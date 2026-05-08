# Dashboard User Filtering Implementation

## Objective
Display only complaints raised by the logged-in user (filtered by CreatedBy field from Complaint_Header table) on the dashboard for Employee and Guest roles.

## Changes Made

### 1. **ComplaintDataService.cs** - Updated `GetUserComplaints()` method

**What Changed:**
- Modified the `GetUserComplaints()` method to use direct SQL queries based on user role instead of relying solely on the stored procedure `sp_GetTickets`
- Now properly filters complaints using the role-based logic:

**Filtering Logic by Role:**
- **Admin (RoleId=1)**: Sees ALL complaints
- **SOC (RoleId=2)**: Sees ALL complaints  
- **Engineer (RoleId=3)**: Sees complaints assigned to them OR in their assigned units
- **Employee (RoleId=4) & Guest (RoleId=5)**: Sees ONLY complaints where `CreatedBy = @EmpCode` ✅ KEY CHANGE

**Code Logic:**
```csharp
// For Employee/Guest (RoleId 4 & 5):
"SELECT * FROM dbo.Complaint_Header ch WHERE ch.CreatedBy = @EmpCode ORDER BY ch.CreatedDate DESC"
```

### 2. **HomePage.aspx.cs** - Updated Data Retrieval Methods

Updated the following methods to ensure consistent role-based filtering using the `Complaint_Header` table:

#### a. `GetUserComplaintsCount()` 
- Now filters by `CreatedBy` for Employees/Guests
- Properly counts only complaints raised by the logged-in user

#### b. `GetUserStatusCount()`
- Added role-based status filtering
- Employees/Guests see only their complaints with specific status

#### c. `GetUserTransferredCount()`
- Updated to filter transferred complaints by role
- Employees/Guests see only transferred complaints they created

#### d. `GetTotalComplaintsCount()` & `GetStatusCount()`
- Updated to use correct table schema: `[ComplaintSystem].[dbo].[Complaint_Header]`

**Key Change in All Methods:**
```csharp
// For Employee/Guest filtering:
"SELECT COUNT(*) FROM [ComplaintSystem].[dbo].[Complaint_Header] 
 WHERE CreatedBy = @EmpCode AND Status = @Status"
```

### 3. **Database Schema Used**
All queries now reference the correct table with proper field names:
- Table: `[ComplaintSystem].[dbo].[Complaint_Header]`
- Key Fields:
  - `ComplaintId` - Unique identifier
  - `CreatedBy` - Employee code of the user who raised the complaint ✅
  - `CreatedDate` - Date complaint was created
  - `Title` - Complaint title
  - `Priority` - Priority level
  - `Status` - Current status (New, InProgress, Resolved, Closed, Transferred)
  - `AssignedTo` - Employee code of assigned person
  - `UnitId` - Unit ID for unit-based access

## Benefits

1. **Security**: Users can only see complaints they created
2. **Privacy**: Complaint data is properly isolated per user
3. **Compliance**: Aligns with role-based access control
4. **Consistency**: All dashboard statistics and counts properly reflect user permissions

## Dashboard Display After Changes

### For Employee/Guest Users:
- ✅ **Total Complaints**: Shows only complaints created by the user
- ✅ **Ongoing**: Shows only their ongoing complaints
- ✅ **Resolved**: Shows only their resolved complaints
- ✅ **Closed**: Shows only their closed complaints
- ✅ **Transferred**: Shows only complaints they created that were transferred
- ✅ **Status Pipeline**: Shows only their complaints in each status
- ✅ **Recent Complaints**: Shows only recent complaints created by them

### For Admin/SOC Users:
- Shows ALL complaints (no filtering)

### For Engineer Users:
- Shows complaints assigned to them
- Shows complaints in their assigned units

## Testing Recommendations

1. Login as Employee with EmpCode = "EMP001"
2. Create 2-3 complaints
3. Verify dashboard shows only those complaints
4. Login as different Employee with EmpCode = "EMP002"
5. Verify dashboard shows only EMP002's complaints
6. Login as Admin
7. Verify Admin sees all complaints from all employees

## Files Modified

1. `ComplaintSystem/Data/ComplaintDataService.cs`
2. `ComplaintSystem/HomePage.aspx.cs`

## Fallback Logic

The `GetUserComplaints()` method has a fallback mechanism:
- Primary: Uses direct SQL query with role-based filtering
- Secondary: Falls back to `sp_GetTickets` stored procedure if primary fails
- This ensures backward compatibility if the stored procedure is properly implemented

## Notes

- All queries use parameterized queries for SQL injection prevention
- Error handling with debug logging for troubleshooting
- Proper null handling for empCode with empty string default
- Connection strings use the configured `ComplaintsFormConnectionString`
