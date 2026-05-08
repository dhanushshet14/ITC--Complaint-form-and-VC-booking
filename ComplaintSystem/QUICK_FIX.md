# Quick Fix Guide - Admin Access Denied

## The Issue
✗ Admin login successful, but then → Access Denied (role = "Unknown")

## The Cause
The system can't find the user's role in the database

## The Fix (Do These Steps NOW)

### 1. Run SQL Setup (2 minutes)
```
1. Open SQL Server Management Studio
2. Connect to: DESKTOP-PJ2GO33\SQLEXPRESS → ComplaintSystem
3. File → Open → ComplaintSystem\RBAC_Setup.sql
4. Click Execute (F5)
5. Check output - should say "SETUP COMPLETE"
```

### 2. Verify Admin User (2 minutes)
```sql
-- Copy this and run in SSMS
SELECT * FROM TBL_EmployeeDetails WHERE EmpCode = 'your_admin_empcode';
SELECT * FROM User_Master WHERE UserCode = 'your_admin_empcode';
```

If admin user not found in either table, ask: **What is the admin user's employee code?**

### 3. Restart Application (1 minute)
```
1. Rebuild solution (Ctrl+Shift+B)
2. Run application (F5)
3. Login as admin
```

## What Changed in Code

**AuthenticationService.cs** - Now has 3 ways to find user role:
1. Try `sp_ValidateLoginUser` SP (NEW)
2. Check if user in `TBL_EmployeeDetails` → Role = Employee
3. Default to Employee role (safe fallback)

**This is backward compatible** - won't break existing functionality

## If Still Getting "Unknown Role"

Run this to see what's happening:

```sql
-- Test the role lookup
DECLARE @LoginUserType NVARCHAR(50);
DECLARE @RoleId INT;

-- Replace 'admin_empcode' with actual admin employee code
EXEC sp_ValidateLoginUser 'admin_empcode', @LoginUserType OUTPUT, @RoleId OUTPUT;

-- See what it returns
SELECT @LoginUserType AS Role, @RoleId AS RoleId;
```

## Expected Result After Fix

1. Admin logs in → redirects to HomePage.aspx ✓
2. Session shows: Role = "admin" or "employee" (not "Unknown") ✓
3. Can access complaints dashboard ✓

## Questions to Answer

1. **What is your admin user's employee code?** (e.g., 'EMP001', 'A001', etc.)
2. **Does TBL_EmployeeDetails have a UserType or Role column?**
   - Check by running: `EXEC sp_columns @table_name = 'TBL_EmployeeDetails'`

---

**Next Step:** Run the SQL_Setup.sql script, then test login again. If it still doesn't work, share:
- Admin employee code
- Output from the diagnostic SQL queries
