# Role-Based Dashboard Statistics Implementation

## Overview
The dashboard now displays employee-specific complaint statistics based on the logged-in user's role and permissions.

## Changes Made

### 1. HomePage.aspx.cs Updates

#### New Methods Implemented:

**GetTotalComplaintsCount()** / **GetUserComplaintsCount()**
- Admin/SOC sees total complaints across entire system
- Employee/Engineer/Guest sees only their own complaints (created or assigned)

**GetStatusCount()** / **GetUserStatusCount()**
- Filters complaints by status (Assigned, Accepted, InProgress, Resolved, Closed)
- Role-based filtering applied

**GetTransferredCount()** / **GetUserTransferredCount()**
- Tracks transferred complaints
- Admin sees all transfers, employees see their transfers only

**GetStatusBadgeClass()** / **GetPriorityBadgeClass()**
- Maps status/priority values to CSS classes for proper styling
- Compatible with .NET Framework 4.8.1

#### Enhanced Methods:

**LoadStatistics()**
- Checks user role
- Loads role-specific complaint statistics
- Injects real data via JavaScript on page load

**LoadPipelineData()**
- Displays pipeline stages with role-filtered counts
- Updates: Assigned, Accepted, In Progress, Resolved, Closed

**LoadRecentComplaints()**
- Dynamically generates table rows from database
- Filters based on user role and permissions
- Displays up to 10 most recent complaints
- Updates results count

### 2. HomePage_New.aspx Updates

#### UI Changes:
- Stat cards now show "-" as placeholder while loading
- Table initially displays "Loading complaints..." message
- Values are populated via server-side JavaScript injection
- All emojis properly encoded in UTF-8

### 3. Web.config Updates

**Encoding Configuration:**
```xml
<globalization culture="en-US" uiCulture="en-US" 
               fileEncoding="utf-8" requestEncoding="utf-8" 
               responseEncoding="utf-8" />
```

**HTTP Headers:**
```xml
<httpProtocol>
    <customHeaders>
        <add name="Content-Type" value="text/html; charset=utf-8" />
    </customHeaders>
</httpProtocol>
```

## Role-Based Filtering Rules

| Role | Can See |
|------|---------|
| Admin (1) | All complaints in system |
| SOC (2) | All complaints in system |
| Engineer (3) | Own complaints + unit complaints |
| Employee (4) | Own complaints only |
| Guest (5) | Own complaints only |

## Data Flow

1. **Page Load** → `Page_Load()` checks authentication
2. **LoadDashboardData()** → Retrieves user role and empCode
3. **LoadStatistics()** → Queries database with role-based filtering
4. **Server-side injection** → JavaScript inserted with actual numbers
5. **Client-side rendering** → Page displays role-specific data

## SQL Queries Used

### Get Total (Admin/SOC):
```sql
SELECT COUNT(*) FROM Complaints
```

### Get User-Specific:
```sql
SELECT COUNT(*) FROM Complaints 
WHERE (CreatedByEmpCode = @EmpCode OR AssignedToEmpCode = @EmpCode) 
AND Status = @Status
```

## Benefits

✅ **Security**: Users see only their authorized complaints
✅ **Accuracy**: Real-time data from database
✅ **Performance**: Efficient SQL queries with parameters
✅ **Maintainability**: Clean separation of concerns
✅ **Compatibility**: Works with .NET Framework 4.8.1

## Testing Checklist

- [ ] Admin login shows all complaints stats
- [ ] SOC login shows all complaints stats
- [ ] Employee login shows only their complaints
- [ ] Stats update correctly based on database
- [ ] Pipeline stages show correct numbers
- [ ] Recent complaints table filters properly
- [ ] No SQL injection vulnerabilities
- [ ] Emojis display correctly (no garbled text)
- [ ] Page loads without JavaScript errors

## Future Enhancements

1. Add refresh button to reload statistics
2. Implement real-time updates via SignalR
3. Add more detailed filtering options
4. Export statistics to CSV/PDF
5. Add trends/analytics charts

## Notes

- All SQL queries use parameterized statements to prevent injection
- UTF-8 encoding ensures emoji and special characters display correctly
- Server-side data injection prevents client-side data tampering
- Compatible with .NET Framework 4.8.1 (no C# 8.0 features)
