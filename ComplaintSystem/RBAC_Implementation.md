# Role-Based Access Control (RBAC) Implementation

## Overview
This implementation provides comprehensive role-based access control for the Complaint Management System with five user roles: Admin, SOC, Engineer, Employee, and Guest.

## Roles and Permissions

### 1. **Admin**
- **Can Create Tickets:** Yes
- **Can View Own Tickets:** Yes
- **Can View All Tickets:** Yes
- **Can Assign Tickets:** Yes
- **Can Transfer Tickets:** Yes
- **Can Modify Tickets:** Yes
- **Can Resolve Tickets:** Yes
- **Can Manage Users:** Yes
- **Can Manage Permissions:** Yes
- **Can Manage Units:** Yes
- **Can Manage Categories:** Yes

### 2. **SOC (Service Operations Center)**
- **Can Create Tickets:** No
- **Can View Own Tickets:** No
- **Can View All Tickets:** Yes
- **Can Assign Tickets:** Yes
- **Can Transfer Tickets:** Yes
- **Can Modify Tickets:** Yes (unit, priority, category)
- **Can Resolve Tickets:** No
- **Can Manage Users:** No
- **Can Manage Permissions:** No

### 3. **Engineer**
- **Can Create Tickets:** No
- **Can View Own Tickets:** No
- **Can View All Tickets:** No (only assigned + unit-specific)
- **Can Assign Tickets:** No (can self-assign)
- **Can Transfer Tickets:** Yes (tickets assigned to them)
- **Can Modify Tickets:** No
- **Can Resolve Tickets:** Yes (tickets assigned to them)
- **Permission-Based:** Only see complaints for their assigned units

### 4. **Employee**
- **Can Create Tickets:** Yes
- **Can View Own Tickets:** Yes (only their created tickets)
- **Can View All Tickets:** No
- **Can Assign Tickets:** No
- **Can Transfer Tickets:** No
- **Can Modify Tickets:** No
- **Can Resolve Tickets:** No (after engineer resolves, they can close)

### 5. **Guest**
- Same permissions as Employee
- Temporary access for external stakeholders

---

## Architecture

### Core Classes

#### 1. **AuthenticationService.cs**
Handles login validation and role determination using stored procedures.

```csharp
// Usage in Login page
AuthenticationService authService = new AuthenticationService();
LoginResult result = authService.ValidateLogin(empCode, password);

if (result.IsValid) {
    Session["UserId"] = result.UserId;
    Session["EmpCode"] = result.EmpCode;
    Session["UserRole"] = result.Role;
    Session["RoleId"] = result.RoleId;
    
    UserPermissions perms = authService.GetUserPermissions(result.EmpCode, result.RoleId);
    Session["UserPermissions"] = perms;
}
```

#### 2. **AuthorizationHelper.cs**
Static helper class for permission checks throughout the application.

```csharp
// Check if user is authenticated
if (!AuthorizationHelper.IsAuthenticated()) {
    Response.Redirect("Login.aspx");
}

// Check specific role
if (AuthorizationHelper.IsEngineer()) {
    // Engineer-specific logic
}

// Check specific permission
if (AuthorizationHelper.HasPermission("create_ticket")) {
    // Show create button
}

// Require permission with automatic redirect
AuthorizationHelper.RequirePermission("view_all_tickets");

// Get current user info
string empCode = AuthorizationHelper.GetUserEmpCode();
int roleId = AuthorizationHelper.GetUserRoleId();
UserPermissions perms = AuthorizationHelper.GetUserPermissions();
```

#### 3. **ComplaintDataService.cs**
Retrieves complaints with role-based filtering using `sp_GetTickets` stored procedure.

```csharp
// Get complaints based on user role
ComplaintDataService service = new ComplaintDataService();
DataSet complaints = service.GetUserComplaints(empCode, roleId);

// Get specific status
DataSet pending = service.GetPendingComplaints(empCode, roleId);
DataSet completed = service.GetCompletedComplaints(empCode, roleId);

// Check if user can perform action
bool canResolve = service.CanModifyComplaint(complaintId, empCode, roleId, "resolve");
```

---

## Implementation in Pages

### Login.aspx.cs
```csharp
protected void btnLogin_Click(object sender, EventArgs e) {
    AuthenticationService authService = new AuthenticationService();
    LoginResult result = authService.ValidateLogin(txtUsername.Text.Trim(), txtPassword.Text);

    if (result.IsValid) {
        // Store in session (see implementation above)
        Response.Redirect("HomePage.aspx");
    } else {
        lblErrorMsg.Text = "Invalid username / password.";
    }
}
```

### ComplaintPage.aspx.cs (Create Complaint)
```csharp
protected void Page_Load(object sender, EventArgs e) {
    // Require authentication + permission
    AuthorizationHelper.RequireAuthentication();
    AuthorizationHelper.RequirePermission("create_ticket");
    
    // Only Employee/Guest allowed on this page
}

protected void SubmitComplaint_Click(object sender, EventArgs e) {
    if (!AuthorizationHelper.HasPermission("create_ticket")) {
        // Show error
        return;
    }
    
    string empCode = AuthorizationHelper.GetUserEmpCode();
    // Save complaint with empCode as CreatedBy
}
```

### ViewComplaints.aspx
```csharp
protected void Page_Load(object sender, EventArgs e) {
    AuthorizationHelper.RequireAuthentication();
    
    string empCode = AuthorizationHelper.GetUserEmpCode();
    int roleId = AuthorizationHelper.GetUserRoleId();
    
    ComplaintDataService service = new ComplaintDataService();
    DataSet complaints = service.GetUserComplaints(empCode, roleId);
    // Bind to GridView based on role
}
```

---

## Stored Procedures

### sp_ValidateLoginUser
Validates user login and determines role.

**Parameters:**
- `@EmpCode` (VARCHAR): Employee code
- `@LoginUserType` (VARCHAR OUTPUT): User role (admin, employee, guest, engineer, soc)
- `@RoleId` (INT OUTPUT): Role ID from Roles table

**Logic:**
1. Checks if user exists in User_Master, TBL_EmployeeDetails, or guestUser_master
2. Determines role based on hierarchical rules
3. Returns role and role ID

### sp_GetTickets
Retrieves complaints filtered by role.

**Parameters:**
- `@EmpCode` (VARCHAR): Employee code
- `@RoleId` (INT): Role ID

**Filters by Role:**
- **Admin/SOC:** All complaints
- **Engineer:** Assigned tickets + unit-specific complaints
- **Employee/Guest:** Own complaints only

---

## Database Schema Requirements

### Tables Needed:
1. **dbo.Roles**
   - RoleId (INT, PK)
   - RoleName (VARCHAR)
   - Description (VARCHAR)

2. **dbo.EngineerUnitPermissions**
   - EmpCode (VARCHAR)
   - UnitId (INT)
   - (FK to User_Master and Units table)

3. **dbo.Complaint_Header**
   - ComplaintId (VARCHAR, PK)
   - CreatedBy (VARCHAR, FK)
   - AssignedTo (VARCHAR, FK)
   - UnitId (INT, FK)
   - Status (VARCHAR)
   - Priority (VARCHAR)
   - CreatedDate (DATETIME)
   - etc.

---

## Usage Examples

### Example 1: Check if User Can Create Ticket
```csharp
if (AuthorizationHelper.HasPermission("create_ticket")) {
    // Show create button
    btnCreateTicket.Visible = true;
} else {
    btnCreateTicket.Visible = false;
}
```

### Example 2: Role-Specific Page Logic
```csharp
string role = AuthorizationHelper.GetUserRole();

if (AuthorizationHelper.IsEngineer()) {
    // Show only assigned tickets + self-assign button
    LoadEngineerDashboard();
} else if (AuthorizationHelper.IsSOC()) {
    // Show all tickets + assignment controls
    LoadSOCDashboard();
} else if (AuthorizationHelper.IsEmployeeOrGuest()) {
    // Show only their tickets + create button
    LoadEmployeeDashboard();
}
```

### Example 3: Permission Check with Automatic Redirect
```csharp
// If user doesn't have permission, redirects to AccessDenied.aspx automatically
AuthorizationHelper.RequirePermission("manage_users");

// Page only reaches here if user has "manage_users" permission
LoadUserManagement();
```

### Example 4: Get User Info
```csharp
string empCode = AuthorizationHelper.GetUserEmpCode();
int roleId = AuthorizationHelper.GetUserRoleId();
string role = AuthorizationHelper.GetUserRole();
UserPermissions perms = AuthorizationHelper.GetUserPermissions();

// Use for data retrieval
ComplaintDataService service = new ComplaintDataService();
DataSet data = service.GetUserComplaints(empCode, roleId);
```

---

## Security Considerations

1. **Always verify authentication** - Use `AuthorizationHelper.RequireAuthentication()` at page load
2. **Always check permissions** - Don't rely on UI hiding, verify on backend
3. **Store data per role** - Use role-based queries (sp_GetTickets)
4. **Session validation** - Check session before accessing user properties
5. **SQL injection prevention** - All queries use parameterized SP calls
6. **Access Denied page** - Never expose sensitive information on error pages

---

## Files Modified/Created

### Created Files:
- `ComplaintSystem\Auth\AuthenticationService.cs`
- `ComplaintSystem\Auth\AuthorizationHelper.cs`
- `ComplaintSystem\Data\ComplaintDataService.cs`
- `ComplaintSystem\AccessDenied.aspx`
- `RBAC_Implementation.md` (this file)

### Modified Files:
- `ComplaintSystem\Login.aspx.cs` - Updated to use AuthenticationService
- `ComplaintSystem\ComplaintPage.aspx.cs` - Added role-based access checks

---

## Testing Checklist

- [ ] Admin can login and access all features
- [ ] SOC can view all tickets and assign
- [ ] Engineer sees only assigned + unit tickets
- [ ] Employee can create and view own tickets
- [ ] Guest has same permissions as Employee
- [ ] Unauthorized access redirects to AccessDenied.aspx
- [ ] Session expires properly
- [ ] Permission checks work correctly
- [ ] Stored procedures return correct data by role

---

## Future Enhancements

1. Add audit logging for all actions
2. Implement ticket history tracking
3. Add notification system for role-specific events
4. Create dashboard views per role
5. Add bulk operations for SOC/Admin
6. Implement ticket escalation workflows
7. Add SLA tracking for engineers
8. Create performance metrics per unit/engineer
