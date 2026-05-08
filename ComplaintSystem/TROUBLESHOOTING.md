# Admin Login Access Denied - Troubleshooting Guide

## Problem
Admin user logs in successfully but gets redirected to `AccessDenied.aspx` with "Your Current Role: Unknown"

## Root Cause
The `sp_ValidateLoginUser` stored procedure is either:
1. Not created in the database
2. Not returning role information correctly
3. Or the Roles table doesn't have the required data

## Solution Steps

### Step 1: Run the Diagnostic Script
1. Open **SQL Server Management Studio**
2. Connect to your `ComplaintSystem` database on `DESKTOP-PJ2GO33\SQLEXPRESS`
3. Open and run the file: `ComplaintSystem\Database_Diagnostic.sql`
4. Review the output to identify missing components

### Step 2: Run the Setup Script
1. In SQL Server Management Studio, open: `ComplaintSystem\RBAC_Setup.sql`
2. Run the script (this is safe - it only creates missing components)
3. This will:
   - Create `Roles` table with 5 roles (admin, soc, engineer, employee, guest)
   - Create `EngineerUnitPermissions` table
   - Create `sp_ValidateLoginUser` stored procedure
   - Create `sp_GetTickets` stored procedure

### Step 3: Verify User Role Assignment
The system now uses a **multi-strategy approach** to determine user role:

#### Strategy 1: Stored Procedure (if exists)
- Calls `sp_ValidateLoginUser` with user's employee code
- Returns role name from database

#### Strategy 2: Table-Based (fallback)
- Checks if user exists in `TBL_EmployeeDetails` → Role = Employee
- Checks if user exists in `guestUser_master` → Role = Guest
- Otherwise defaults to Employee

**Important:** For your admin user, you need to ensure:
- The employee code matches what was used at login
- The user exists in one of the recognized user tables
- Preferably in `TBL_EmployeeDetails` with a `UserType` or `Role` column set to "admin"

### Step 4: For Your Admin User Specifically
Run this SQL query to check your admin user (replace `admin_empcode` with actual value):

```sql
-- Check in User_Master
SELECT * FROM User_Master WHERE UserCode = 'admin_empcode' OR EmpCode = 'admin_empcode';

-- Check in TBL_EmployeeDetails
SELECT * FROM TBL_EmployeeDetails WHERE EmpCode = 'admin_empcode' OR EmployeeCode = 'admin_empcode';

-- Check in guestUser_master
SELECT * FROM guestUser_master WHERE UserCode = 'admin_empcode' OR EmpCode = 'admin_empcode';
```

### Step 5: (Optional) Manually Set Admin Role
If your admin user isn't in the expected tables, you can add them:

```sql
-- Option A: If TBL_EmployeeDetails exists and has a UserType/Role column
UPDATE TBL_EmployeeDetails 
SET UserType = 'admin'  -- or SET Role = 'admin' if column name differs
WHERE EmpCode = 'admin_empcode';

-- Option B: If you need to insert a new admin user
INSERT INTO TBL_EmployeeDetails (EmpCode, UserType, /* other required columns */)
VALUES ('admin_empcode', 'admin', /* values for other columns */);
```

### Step 6: Test the Login Again
1. Restart your application
2. Navigate to the login page
3. Enter your admin credentials
4. Click Login
5. You should now be redirected to HomePage.aspx with your role properly set

## New Code Changes

### AuthenticationService.cs - Multi-Strategy Role Determination

The updated `AuthenticationService` now:

1. **Tries sp_ValidateLoginUser first** (if it exists in your database)
   - Executes the stored procedure with user's employee code
   - Retrieves role name and role ID

2. **Falls back to table checking** (if SP doesn't exist or fails)
   - Checks `TBL_EmployeeDetails` → defaults to "Employee"
   - Checks `guestUser_master` → sets to "Guest"
   - Otherwise defaults to "Employee" (safest option)

3. **Safe defaults**
   - If all methods fail, user is assigned "Employee" role (RoleId=4)
   - This ensures login doesn't break, user just has limited permissions

### Session Values After Login

After successful login, these are stored in Session:
- `Session["UserId"]` - User ID from database
- `Session["EmpCode"]` - Employee code
- `Session["UserRole"]` - Role name (admin, soc, engineer, employee, guest)
- `Session["RoleId"]` - Role ID (1-5)
- `Session["UserPermissions"]` - UserPermissions object with all permission flags

### Role-Based Permissions

The system automatically assigns permissions based on role:

| Role | Can Create | Can View All | Can Assign | Can Resolve | Can Manage |
|------|-----------|------------|---------|-----------|-----------|
| Admin (1) | ✓ | ✓ | ✓ | ✓ | ✓ |
| SOC (2) | ✗ | ✓ | ✓ | ✗ | ✗ |
| Engineer (3) | ✗ | Unit Only | ✗ | ✓ | ✗ |
| Employee (4) | ✓ | Own Only | ✗ | ✗ | ✗ |
| Guest (5) | ✓ | Own Only | ✗ | ✗ | ✗ |

## Debugging

If you still get "Access Denied" after setup:

1. **Check AuthenticationService error logging**
   - Add a breakpoint in `ValidateLogin` method
   - Check the `result.ErrorMessage` property

2. **Monitor SQL queries**
   - Use SQL Server Profiler to see which queries are executing
   - Verify `sp_ValidateLoginUser` is being called
   - Check if role determination fallbacks are working

3. **Verify session values**
   - Add this code temporarily in your page to debug:
   ```csharp
   Response.Write($"Role: {Session["UserRole"]}, RoleId: {Session["RoleId"]}");
   ```

## Files Modified

- `ComplaintSystem\Auth\AuthenticationService.cs` - Multi-strategy role determination
- `ComplaintSystem\Database_Diagnostic.sql` - Diagnostic script (run to verify setup)
- `ComplaintSystem\RBAC_Setup.sql` - Setup script (run to create missing components)

## Still Not Working?

1. Verify the connection string in `Web.config` is correct
2. Ensure your SQL Server account has permissions to create tables and SPs
3. Check that `SP_verifyLogin` is working (that's called first)
4. Run the Diagnostic script to identify which components are missing

## Contact

If you need to revert changes:
1. The C# code changes are fully backward compatible
2. Running the SQL scripts again is safe - they check for existing objects
3. You can manually test the SP by running in SSMS:
   ```sql
   DECLARE @LoginUserType NVARCHAR(50);
   DECLARE @RoleId INT;
   EXEC sp_ValidateLoginUser 'your_empcode', @LoginUserType OUTPUT, @RoleId OUTPUT;
   SELECT @LoginUserType AS Role, @RoleId AS RoleId;
   ```
