# Dashboard Data Integration - Quick Start

## Objective
Connect the ServiceCore dashboard to your database for dynamic data display.

## Current State
✓ UI is complete and styled
✓ Role-based authentication working
✓ Mock data showing in dashboard
⚠️ Database queries need to be implemented

## What Needs to Be Done

### 1. Database Queries for Statistics

Add these methods to `ComplaintDataService.cs`:

```csharp
public class DashboardStatistics
{
    public int TotalComplaints { get; set; }
    public int OngoingComplaints { get; set; }
    public int ResolvedComplaints { get; set; }
    public int ClosedComplaints { get; set; }
    public int TransferredComplaints { get; set; }
}

public DashboardStatistics GetDashboardStatistics(string empCode, int roleId)
{
    using (SqlConnection conn = new SqlConnection(_connectionString))
    {
        conn.Open();
        
        string query = "";
        if (roleId == 1 || roleId == 2) // Admin or SOC
        {
            // Query: SELECT COUNT(*) FROM Complaint_Header GROUP BY Status
            query = @"
                SELECT 
                    COUNT(*) AS Total,
                    SUM(CASE WHEN Status = 'Ongoing' THEN 1 ELSE 0 END) AS Ongoing,
                    SUM(CASE WHEN Status = 'Resolved' THEN 1 ELSE 0 END) AS Resolved,
                    SUM(CASE WHEN Status = 'Closed' THEN 1 ELSE 0 END) AS Closed,
                    SUM(CASE WHEN Status = 'Transferred' THEN 1 ELSE 0 END) AS Transferred
                FROM dbo.Complaint_Header";
        }
        else if (roleId == 3) // Engineer
        {
            // Query: Own assigned complaints + unit complaints
            query = @"
                SELECT 
                    COUNT(*) AS Total,
                    SUM(CASE WHEN Status = 'Ongoing' THEN 1 ELSE 0 END) AS Ongoing,
                    -- ... similar logic
                FROM dbo.Complaint_Header ch
                LEFT JOIN dbo.EngineerUnitPermissions eup ON ch.UnitId = eup.UnitId
                WHERE ch.AssignedTo = @EmpCode OR eup.EmpCode = @EmpCode";
        }
        else // Employee/Guest
        {
            // Query: Only own complaints
            query = @"
                SELECT 
                    COUNT(*) AS Total,
                    SUM(CASE WHEN Status = 'Ongoing' THEN 1 ELSE 0 END) AS Ongoing,
                    -- ... similar logic
                FROM dbo.Complaint_Header
                WHERE CreatedBy = @EmpCode";
        }

        using (SqlCommand cmd = new SqlCommand(query, conn))
        {
            cmd.Parameters.AddWithValue("@EmpCode", empCode);
            
            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                if (reader.Read())
                {
                    return new DashboardStatistics
                    {
                        TotalComplaints = reader.GetInt32(reader.GetOrdinal("Total")),
                        OngoingComplaints = reader.GetInt32(reader.GetOrdinal("Ongoing")),
                        ResolvedComplaints = reader.GetInt32(reader.GetOrdinal("Resolved")),
                        ClosedComplaints = reader.GetInt32(reader.GetOrdinal("Closed")),
                        TransferredComplaints = reader.GetInt32(reader.GetOrdinal("Transferred"))
                    };
                }
            }
        }

        return new DashboardStatistics();
    }
}
```

### 2. Pipeline Data Query

Add this method to `ComplaintDataService.cs`:

```csharp
public class PipelineData
{
    public int AssignedCount { get; set; }
    public int AcceptedCount { get; set; }
    public int InProgressCount { get; set; }
    public int ResolvedCount { get; set; }
    public int ClosedCount { get; set; }
}

public PipelineData GetPipelineData(string empCode, int roleId)
{
    // Similar pattern to GetDashboardStatistics
    // Query Complaint_Header by status
    // Apply role-based filtering
    
    string query = @"
        SELECT 
            SUM(CASE WHEN Status = 'Assigned' THEN 1 ELSE 0 END) AS Assigned,
            SUM(CASE WHEN Status = 'Accepted' THEN 1 ELSE 0 END) AS Accepted,
            SUM(CASE WHEN Status = 'In Progress' THEN 1 ELSE 0 END) AS InProgress,
            SUM(CASE WHEN Status = 'Resolved' THEN 1 ELSE 0 END) AS Resolved,
            SUM(CASE WHEN Status = 'Closed' THEN 1 ELSE 0 END) AS Closed
        FROM dbo.Complaint_Header";
    
    // Return populated PipelineData object
}
```

### 3. Update HomePage.aspx.cs to Use Real Data

Replace TODO sections in `LoadStatistics()`:

```csharp
private void LoadStatistics()
{
    try
    {
        string empCode = AuthorizationHelper.GetUserEmpCode();
        int roleId = AuthorizationHelper.GetUserRoleId();

        // Query database
        ComplaintDataService dataService = new ComplaintDataService();
        var stats = dataService.GetDashboardStatistics(empCode, roleId);

        // Update UI with real data
        string scriptStats = $@"
            <script type='text/javascript'>
                function updateStats() {{
                    var values = document.querySelectorAll('.stat-value');
                    values[0].textContent = '{stats.TotalComplaints}';
                    values[1].textContent = '{stats.OngoingComplaints}';
                    values[2].textContent = '{stats.ResolvedComplaints}';
                    values[3].textContent = '{stats.ClosedComplaints}';
                    values[4].textContent = '{stats.TransferredComplaints}';
                }}
                window.addEventListener('load', updateStats);
            </script>";

        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "statsScript", scriptStats);
    }
    catch (Exception ex)
    {
        System.Diagnostics.Debug.WriteLine($"Load statistics error: {ex.Message}");
    }
}
```

### 4. Update Pipeline Loading

Similar pattern in `LoadPipelineData()`:

```csharp
private void LoadPipelineData()
{
    try
    {
        string empCode = AuthorizationHelper.GetUserEmpCode();
        int roleId = AuthorizationHelper.GetUserRoleId();

        ComplaintDataService dataService = new ComplaintDataService();
        var pipeline = dataService.GetPipelineData(empCode, roleId);

        string scriptPipeline = $@"
            <script type='text/javascript'>
                document.getElementById('pipelineAssigned').textContent = '{pipeline.AssignedCount}';
                document.getElementById('pipelineAccepted').textContent = '{pipeline.AcceptedCount}';
                document.getElementById('pipelineProgress').textContent = '{pipeline.InProgressCount}';
                document.getElementById('pipelineResolved').textContent = '{pipeline.ResolvedCount}';
                document.getElementById('pipelineClosed').textContent = '{pipeline.ClosedCount}';
            </script>";

        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "pipelineScript", scriptPipeline);
    }
    catch (Exception ex)
    {
        System.Diagnostics.Debug.WriteLine($"Load pipeline error: {ex.Message}");
    }
}
```

### 5. Update Recent Complaints Table

In `LoadRecentComplaints()`:

```csharp
private void LoadRecentComplaints()
{
    try
    {
        string empCode = AuthorizationHelper.GetUserEmpCode();
        int roleId = AuthorizationHelper.GetUserRoleId();

        ComplaintDataService dataService = new ComplaintDataService();
        DataTable complaints = dataService.GetUserComplaints(empCode, roleId);

        // Generate table rows
        StringBuilder tableRows = new StringBuilder();
        if (complaints != null && complaints.Rows.Count > 0)
        {
            foreach (DataRow row in complaints.Rows.Take(10))
            {
                string status = row["Status"].ToString().ToLower().Replace(" ", "-");
                string priority = row["Priority"].ToString().ToLower();

                tableRows.AppendLine($@"
                    <tr>
                        <td>{row["ID"]}</td>
                        <td>{row["Type"]}</td>
                        <td><span class='badge {status}'>{row["Status"]}</span></td>
                        <td><span class='priority-badge {priority}'>{row["Priority"]}</span></td>
                        <td>{row["AssignedTo"]}</td>
                        <td>{Convert.ToDateTime(row["CreatedDate"]):MMM dd, yyyy}</td>
                    </tr>");
            }
        }

        // Inject rows via script
        string scriptComplaints = $@"
            <script type='text/javascript'>
                var tableBody = document.getElementById('complaintsList');
                if (tableBody) {{
                    tableBody.innerHTML = '{tableRows.ToString().Replace("'", "\\'")}';
                }}
            </script>";

        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "complaintsScript", scriptComplaints);
    }
    catch (Exception ex)
    {
        System.Diagnostics.Debug.WriteLine($"Load complaints error: {ex.Message}");
    }
}
```

## SQL Queries Needed

### Count Complaints by Status
```sql
SELECT 
    COUNT(*) AS Total,
    SUM(CASE WHEN Status = 'Ongoing' THEN 1 ELSE 0 END) AS Ongoing,
    SUM(CASE WHEN Status = 'Resolved' THEN 1 ELSE 0 END) AS Resolved,
    SUM(CASE WHEN Status = 'Closed' THEN 1 ELSE 0 END) AS Closed,
    SUM(CASE WHEN Status = 'Transferred' THEN 1 ELSE 0 END) AS Transferred
FROM dbo.Complaint_Header
WHERE Status IS NOT NULL;
```

### Get Recent Complaints (Top 10)
```sql
SELECT TOP 10 
    ID,
    Type,
    Status,
    Priority,
    AssignedTo,
    CreatedDate
FROM dbo.Complaint_Header
ORDER BY CreatedDate DESC;
```

## Testing Checklist

- [ ] Dashboard loads without errors
- [ ] Statistics cards show real data
- [ ] Pipeline stages show correct counts
- [ ] Table displays recent complaints
- [ ] Role-based filtering works (Admin sees all, Employee sees own)
- [ ] Dropdown filters update table
- [ ] Search box filters results
- [ ] Mobile view is responsive
- [ ] No console errors

## Performance Notes

- Cache statistics for 1 hour to reduce queries
- Use indexed queries on Status, CreatedBy, AssignedTo
- Limit table to 10-20 rows (pagination)
- Use AJAX for filter operations to avoid page reload

## Files to Modify

1. ✓ `HomePage.aspx` - Already created
2. ✓ `HomePage.aspx.cs` - Already created with TODO comments
3. ⚠️ `ComplaintDataService.cs` - Add DashboardStatistics and PipelineData methods
4. ⚠️ Database - Verify table/column names match

## Next Steps

1. Review your actual database schema
2. Update SQL queries with correct table/column names
3. Implement the methods in ComplaintDataService.cs
4. Update HomePage.aspx.cs data loading methods
5. Test with different user roles
6. Add pagination to table if needed

## Example Column Names to Verify

Common variations in your database:
- `ComplaintID` vs `ID` vs `TicketID`
- `ComplaintStatus` vs `Status`
- `ComplaintPriority` vs `Priority`
- `EmployeeCode` vs `EmpCode`
- `CreatedDate` vs `CreatedOn`
- `AssignedEmployee` vs `AssignedTo`
- `ComplaintType` vs `Type`
- `Unit` vs `UnitID` vs `Department`

Modify SQL queries accordingly.
