# Quick Reference: User Filtering by CreatedBy

## Problem Statement
Dashboard was displaying ALL complaints instead of only those raised by the logged-in employee (using their empcode).

## Solution Implemented
Modified the complaint retrieval logic to filter by `CreatedBy` field from `Complaint_Header` table for Employee/Guest users.

## Key Filtering Logic

### Database Table: `Complaint_Header`
```
ComplaintId (PK)
CreatedBy ← **FILTER BY THIS FOR EMPLOYEES**
CreatedDate
Title
Priority
Status
AssignedTo
UnitId
... other fields
```

### Role-Based Filtering Applied

| Role | Filter Criteria | Query |
|------|-----------------|-------|
| Admin (1) | None - See All | `WHERE 1=1` |
| SOC (2) | None - See All | `WHERE 1=1` |
| Engineer (3) | Assigned OR Unit Access | `WHERE AssignedTo=@EmpCode OR UnitId IN (...)` |
| **Employee (4)** | **Only Their Complaints** | **`WHERE CreatedBy=@EmpCode`** ✅ |
| **Guest (5)** | **Only Their Complaints** | **`WHERE CreatedBy=@EmpCode`** ✅ |

## Example Query Generated

### For Employee/Guest User with EmpCode = "EMP12345":
```sql
SELECT * FROM dbo.Complaint_Header ch 
WHERE ch.CreatedBy = 'EMP12345'
ORDER BY ch.CreatedDate DESC
```

This ensures the employee sees ONLY the 3 complaints they raised:
- TC-1001 - Technical Issue (Created by EMP12345)
- TC-1002 - System Error (Created by EMP12345)
- TC-1003 - Access Issue (Created by EMP12345)

NOT other employees' complaints like:
- TC-2001 - Created by EMP67890 ❌ Hidden
- TC-2002 - Created by EMP11111 ❌ Hidden

## Updated Methods

### In `HomePage.aspx.cs`:
1. `GetUserComplaintsCount()` - Total count filtering
2. `GetUserStatusCount()` - Status-wise count filtering
3. `GetUserTransferredCount()` - Transferred complaints filtering
4. `LoadRecentComplaints()` - Uses ComplaintDataService

### In `ComplaintDataService.cs`:
1. `GetUserComplaints()` - Main data retrieval with role-based SQL queries

## Implementation Details

### Connection String
```
Name: ComplaintsFormConnectionString
Server: [configured in Web.config]
Database: ComplaintSystem
Table: dbo.Complaint_Header
```

### Parameters Used
- `@EmpCode` - Employee code from `AuthorizationHelper.GetUserEmpCode()`
- `@RoleId` - Role ID from `AuthorizationHelper.GetUserRoleId()`
- `@Status` - Status filter (when applicable)

## Security Features

✅ **SQL Injection Prevention**: All queries use parameterized statements  
✅ **Authorization**: Role-based access control enforced at data layer  
✅ **Privacy**: Users cannot access other users' complaints  
✅ **Audit Trail**: CreatedBy tracking maintains data integrity  

## Testing Checklist

- [ ] Login as Employee (RoleId=4)
- [ ] Verify dashboard shows only their complaints in stats
- [ ] Verify Recent Complaints table shows only their complaints
- [ ] Verify Status Pipeline counts match their complaints
- [ ] Login as different Employee
- [ ] Verify they see only THEIR complaints
- [ ] Login as Admin
- [ ] Verify Admin sees all complaints
- [ ] Check browser console for any JavaScript errors
- [ ] Verify SQL queries in Application Insights/Logs

## Future Enhancements

1. Add complaint filtering by type (Technical, Telephone, etc.)
2. Add date range filtering
3. Add search functionality with user isolation
4. Add export functionality (respecting user permissions)
5. Consider caching for performance optimization
