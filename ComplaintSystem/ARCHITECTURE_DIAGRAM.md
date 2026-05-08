# Dashboard User Filtering - Visual Architecture

## Before vs After

### BEFORE (Problem):
```
┌─────────────────────────────────────────────────────────┐
│          Dashboard for Employee "EMP12345"              │
├─────────────────────────────────────────────────────────┤
│                                                           │
│  Total Complaints: 248  (ALL complaints - WRONG!)        │
│  Ongoing: 64           (ALL complaints)                   │
│  Resolved: 142         (ALL complaints)                   │
│  Closed: 35            (ALL complaints)                   │
│                                                           │
│  Recent Complaints:                                       │
│  ├─ TC-1024 (Technical) - Created by EMP67890 ❌ VISIBLE │
│  ├─ TC-1023 (Telephone) - Created by EMP11111 ❌ VISIBLE │
│  ├─ SC-0981 (SOC)       - Created by EMP99999 ❌ VISIBLE │
│  ├─ TC-1022 (Technical) - Created by EMP12345 ✅ VISIBLE │
│  └─ TP-0890 (Telephone) - Created by EMP44444 ❌ VISIBLE │
│                                                           │
└─────────────────────────────────────────────────────────┘
```

### AFTER (Solution):
```
┌─────────────────────────────────────────────────────────┐
│          Dashboard for Employee "EMP12345"              │
├─────────────────────────────────────────────────────────┤
│                                                           │
│  Total Complaints: 3    (ONLY their complaints ✅)        │
│  Ongoing: 1             (ONLY their complaints)           │
│  Resolved: 2            (ONLY their complaints)           │
│  Closed: 0              (ONLY their complaints)           │
│                                                           │
│  Recent Complaints:                                       │
│  ├─ TC-1022 (Technical) - Created by EMP12345 ✅ VISIBLE │
│  ├─ TC-1021 (Technical) - Created by EMP12345 ✅ VISIBLE │
│  └─ TP-1020 (Telephone) - Created by EMP12345 ✅ VISIBLE │
│                                                           │
│  Other complaints are HIDDEN ✅                           │
│                                                           │
└─────────────────────────────────────────────────────────┘
```

## Data Flow Diagram

```
┌────────────────────────────────────────────────────────────┐
│                     User Login                             │
│              (EmpCode = "EMP12345")                         │
└────────────────────────────────────────────────────────────┘
                           ↓
┌────────────────────────────────────────────────────────────┐
│              Session is Established                        │
│         AuthorizationHelper.GetUserEmpCode()               │
│         AuthorizationHelper.GetUserRoleId()                │
└────────────────────────────────────────────────────────────┘
                           ↓
┌────────────────────────────────────────────────────────────┐
│              HomePage.aspx.cs                              │
│           LoadDashboardData() is called                    │
└────────────────────────────────────────────────────────────┘
                           ↓
        ┌──────────────────┬──────────────────┐
        ↓                  ↓                  ↓
    LoadStatistics   LoadPipelineData  LoadRecentComplaints
        ↓                  ↓                  ↓
┌──────────────────────────────────────────────────────────┐
│         Role Check: Is RoleId 4 or 5? (Employee/Guest)  │
└──────────────────────────────────────────────────────────┘
                           ↓
          [YES] Employee/Guest   [NO] Admin/SOC/Engineer
            ↓                              ↓
    ┌─────────────────────┐      ┌──────────────────┐
    │ Filter by CreatedBy │      │ Show All/Assigned│
    │   = EmpCode         │      │  / Unit-based    │
    └─────────────────────┘      └──────────────────┘
            ↓                              ↓
    ┌─────────────────────────────────────────────────────┐
    │        ComplaintDataService.GetUserComplaints()     │
    └─────────────────────────────────────────────────────┘
            ↓
    ┌─────────────────────────────────────────────────────┐
    │      Generate SQL Query Based on RoleId             │
    │                                                      │
    │  IF RoleId = 4 or 5 (Employee/Guest):              │
    │  SELECT * FROM Complaint_Header                     │
    │  WHERE CreatedBy = @EmpCode                         │
    │  ORDER BY CreatedDate DESC                          │
    └─────────────────────────────────────────────────────┘
            ↓
    ┌─────────────────────────────────────────────────────┐
    │         Execute Query Against Database              │
    │                                                      │
    │   [ComplaintSystem].[dbo].[Complaint_Header]       │
    └─────────────────────────────────────────────────────┘
            ↓
    ┌─────────────────────────────────────────────────────┐
    │        Return Only Filtered Results                 │
    │     (User's own complaints only)                    │
    └─────────────────────────────────────────────────────┘
            ↓
    ┌─────────────────────────────────────────────────────┐
    │    Populate Dashboard with Filtered Data            │
    │      - Stats cards                                  │
    │      - Status pipeline                              │
    │      - Recent complaints table                      │
    └─────────────────────────────────────────────────────┘
```

## Database Query Execution

### For Employee with EmpCode = "EMP12345", RoleId = 4:

```
SQL EXECUTION:
─────────────

Query: SELECT * FROM [ComplaintSystem].[dbo].[Complaint_Header]
       WHERE CreatedBy = 'EMP12345'
       ORDER BY CreatedDate DESC

RESULT SET:
──────────
ComplaintId │ CreatedBy  │ CreatedDate │ Title           │ Status
─────────────┼────────────┼─────────────┼─────────────────┼──────────
TC-1022     │ EMP12345   │ 2026-04-06  │ Technical Issue │ InProgress
TC-1021     │ EMP12345   │ 2026-04-05  │ System Error    │ Resolved
TP-1020     │ EMP12345   │ 2026-04-04  │ Phone Support   │ Resolved

FILTERED OUT (Not shown):
─────────────────────────
TC-1024     │ EMP67890   │ 2026-04-08  │ System Down     │ InProgress ❌
TC-1023     │ EMP11111   │ 2026-04-08  │ Access Issue    │ Assigned   ❌
SC-0981     │ EMP99999   │ 2026-04-07  │ Config Change   │ Resolved   ❌
```

## Role-Based Access Control Matrix

```
┌──────────┬──────────────────┬────────────┬──────────────────────────────────────┐
│  RoleId  │  Role Name       │  Query     │  Filter Criteria                     │
├──────────┼──────────────────┼────────────┼──────────────────────────────────────┤
│    1     │  Admin           │ WHERE 1=1  │  See ALL complaints                  │
│    2     │  SOC             │ WHERE 1=1  │  See ALL complaints                  │
│    3     │  Engineer        │ WHERE ...  │  AssignedTo OR UnitId in (...)       │
│    4     │  Employee   ✅   │ WHERE ...  │  CreatedBy = @EmpCode                │
│    5     │  Guest      ✅   │ WHERE ...  │  CreatedBy = @EmpCode                │
└──────────┴──────────────────┴────────────┴──────────────────────────────────────┘

✅ = Modified for proper filtering
```

## Code Flow in ComplaintDataService.cs

```
Public Method:
┌─────────────────────────────────────────────────┐
│ GetUserComplaints(empCode, roleId)              │
└─────────────────────────────────────────────────┘
           ↓
Private Method:
┌─────────────────────────────────────────────────┐
│ GetComplaintsQuery(roleId)                      │
├─────────────────────────────────────────────────┤
│ SWITCH (roleId) {                               │
│   case 1, 2: return ALL query                   │
│   case 3: return ENGINEER query                 │
│   case 4, 5: return EMPLOYEE query ✅           │
│              WHERE CreatedBy = @EmpCode         │
│   default: return NO_ACCESS query               │
│ }                                               │
└─────────────────────────────────────────────────┘
           ↓
Execute Query with Parameters:
┌─────────────────────────────────────────────────┐
│ @EmpCode = 'EMP12345'  (from session)          │
│ @RoleId = 4             (from session)          │
└─────────────────────────────────────────────────┘
           ↓
Return Results:
┌─────────────────────────────────────────────────┐
│ DataSet with filtered complaints                │
│ (Only those where CreatedBy = EMP12345)         │
└─────────────────────────────────────────────────┘
```

## Statistics Calculation Example

### Employee Dashboard with 3 complaints:

```
Before:
  Total Complaints: 248 (of entire system)
  Ongoing: 64 (of entire system)
  Resolved: 142 (of entire system)

After:
  Total Complaints: 3 (EMP12345's complaints)
    └─ TC-1022 (Ongoing)
    └─ TC-1021 (Resolved)
    └─ TP-1020 (Resolved)

  Ongoing: 1 (TC-1022 only)
  Resolved: 2 (TC-1021 & TP-1020)
```

## Security Features Implemented

```
┌────────────────────────────────────────────────────────┐
│              Security Layers                           │
├────────────────────────────────────────────────────────┤
│                                                        │
│  1. AUTHENTICATION                                     │
│     └─ User must be logged in                          │
│        AuthorizationHelper.RequireAuthentication()     │
│                                                        │
│  2. ROLE-BASED ACCESS CONTROL                          │
│     └─ Different queries for different roles           │
│        RoleId checked before executing query           │
│                                                        │
│  3. DATA ISOLATION                                     │
│     └─ Employee can only access CreatedBy = empcode    │
│        No JOINs to other users' complaints             │
│                                                        │
│  4. SQL INJECTION PREVENTION                           │
│     └─ Parameterized queries (@EmpCode, @RoleId)       │
│        No string concatenation in queries              │
│                                                        │
│  5. ERROR HANDLING                                     │
│     └─ Fallback mechanism if primary query fails       │
│        Debug logging for troubleshooting               │
│                                                        │
└────────────────────────────────────────────────────────┘
```
