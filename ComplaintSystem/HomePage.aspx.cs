using ComplaintSystem.Auth;
using ComplaintSystem.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ComplaintSystem
{
    public partial class HomePage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                // Check if user is authenticated
                AuthorizationHelper.RequireAuthentication();

                if (!IsPostBack)
                {
                    LoadDashboardData();
                }
            }
            catch (Exception ex)
            {
                Response.Redirect("Login.aspx");
            }
        }

        private void LoadDashboardData()
        {
            try
            {
                // Get user info from session
                string empCode = AuthorizationHelper.GetUserEmpCode();
                int roleId = AuthorizationHelper.GetUserRoleId();
                string userRole = AuthorizationHelper.GetUserRole();

                // Inject user info into page
                string scriptUserData = $@"
                    <script type='text/javascript'>
                        var userRole = '{userRole}';
                        var empCode = '{empCode}';
                        var roleId = {roleId};
                        console.log('Dashboard loaded for ' + userRole);
                    </script>";

                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "userData", scriptUserData);

                // Update page based on role
                if (roleId == 1) // Admin
                {
                    // Admin sees all complaints
                }
                else if (roleId == 2) // SOC
                {
                    // SOC sees all complaints
                }
                else if (roleId == 3) // Engineer
                {
                    // Engineer sees assigned and unit complaints
                }
                else if (roleId == 4 || roleId == 5) // Employee/Guest
                {
                    // Employee/Guest sees only their own complaints
                }

                // Load complaint statistics
                LoadStatistics();

                // Load complaint pipeline data
                LoadPipelineData();

                // Load recent complaints
                LoadRecentComplaints();
            }
            catch (Exception ex)
            {
                // Log error
                System.Diagnostics.Debug.WriteLine($"Dashboard load error: {ex.Message}");
            }
        }

        private void LoadStatistics()
        {
            try
            {
                string empCode = AuthorizationHelper.GetUserEmpCode();
                int roleId = AuthorizationHelper.GetUserRoleId();

                ComplaintDataService dataService = new ComplaintDataService();

                // Get statistics based on role
                int totalComplaints = 0;
                int ongoingComplaints = 0;
                int resolvedComplaints = 0;
                int closedComplaints = 0;
                int transferredComplaints = 0;

                if (roleId == 1 || roleId == 2) // Admin or SOC - see all
                {
                    totalComplaints = GetTotalComplaintsCount();
                    ongoingComplaints = GetStatusCount("InProgress");
                    resolvedComplaints = GetStatusCount("Resolved");
                    closedComplaints = GetStatusCount("Closed");
                    transferredComplaints = GetTransferredCount();
                }
                else // Engineer, Employee, Guest - see own complaints
                {
                    totalComplaints = GetUserComplaintsCount(empCode, roleId);
                    ongoingComplaints = GetUserStatusCount(empCode, roleId, "InProgress");
                    resolvedComplaints = GetUserStatusCount(empCode, roleId, "Resolved");
                    closedComplaints = GetUserStatusCount(empCode, roleId, "Closed");
                    transferredComplaints = GetUserTransferredCount(empCode, roleId);
                }

                // Inject stats into page
                string scriptStats = $@"
                    <script type='text/javascript'>
                        window.addEventListener('load', function() {{
                            updateStats({totalComplaints}, {ongoingComplaints}, {resolvedComplaints}, {closedComplaints}, {transferredComplaints});
                        }});

                        function updateStats(total, ongoing, resolved, closed, transferred) {{
                            var values = document.querySelectorAll('.stat-value');
                            if (values.length >= 5) {{
                                values[0].textContent = total;
                                values[1].textContent = ongoing;
                                values[2].textContent = resolved;
                                values[3].textContent = closed;
                                values[4].textContent = transferred;
                            }}
                        }}
                    </script>";

                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "statsScript", scriptStats);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Load statistics error: {ex.Message}");
            }
        }

        private int GetTotalComplaintsCount()
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ComplaintsFormConnectionString"].ConnectionString))
            {
                try
                {
                    string query = "SELECT COUNT(*) FROM [ComplaintSystem].[dbo].[Complaint_Header]";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        conn.Open();
                        return (int)cmd.ExecuteScalar();
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error getting total complaints count: {ex.Message}");
                    return 0;
                }
            }
        }

        private int GetUserComplaintsCount(string empCode, int roleId)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ComplaintsFormConnectionString"].ConnectionString))
            {
                try
                {
                    string query = string.Empty;

                    if (roleId == 1 || roleId == 2) // Admin or SOC - see all
                    {
                        query = "SELECT COUNT(*) FROM [ComplaintSystem].[dbo].[Complaint_Header] WHERE 1=1";
                    }
                    else if (roleId == 3) // Engineer - assigned or in their units
                    {
                        query = @"SELECT COUNT(*) FROM [ComplaintSystem].[dbo].[Complaint_Header] ch 
                                 WHERE ch.AssignedTo = @EmpCode 
                                 OR ch.UnitId IN (SELECT UnitId FROM dbo.EngineerUnitPermissions WHERE EmpCode = @EmpCode)";
                    }
                    else // Employee/Guest - only their complaints (CreatedBy = empCode)
                    {
                        query = "SELECT COUNT(*) FROM [ComplaintSystem].[dbo].[Complaint_Header] WHERE CreatedBy = @EmpCode";
                    }

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@EmpCode", empCode ?? string.Empty);
                        conn.Open();
                        return (int)cmd.ExecuteScalar();
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error getting user complaints count: {ex.Message}");
                    return 0;
                }
            }
        }

        private int GetStatusCount(string status)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ComplaintsFormConnectionString"].ConnectionString))
            {
                try
                {
                    string query = "SELECT COUNT(*) FROM [ComplaintSystem].[dbo].[Complaint_Header] WHERE Status = @Status";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Status", status);
                        conn.Open();
                        return (int)cmd.ExecuteScalar();
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error getting status count: {ex.Message}");
                    return 0;
                }
            }
        }

        private int GetUserStatusCount(string empCode, int roleId, string status)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ComplaintsFormConnectionString"].ConnectionString))
            {
                try
                {
                    string query = string.Empty;

                    if (roleId == 1 || roleId == 2) // Admin or SOC - see all
                    {
                        query = "SELECT COUNT(*) FROM [ComplaintSystem].[dbo].[Complaint_Header] WHERE Status = @Status";
                    }
                    else if (roleId == 3) // Engineer - assigned or in their units
                    {
                        query = @"SELECT COUNT(*) FROM [ComplaintSystem].[dbo].[Complaint_Header] ch 
                                 WHERE (ch.AssignedTo = @EmpCode 
                                 OR ch.UnitId IN (SELECT UnitId FROM dbo.EngineerUnitPermissions WHERE EmpCode = @EmpCode))
                                 AND ch.Status = @Status";
                    }
                    else // Employee/Guest - only their complaints (CreatedBy = empCode)
                    {
                        query = "SELECT COUNT(*) FROM [ComplaintSystem].[dbo].[Complaint_Header] WHERE CreatedBy = @EmpCode AND Status = @Status";
                    }

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@EmpCode", empCode ?? string.Empty);
                        cmd.Parameters.AddWithValue("@Status", status);
                        conn.Open();
                        return (int)cmd.ExecuteScalar();
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error getting user status count: {ex.Message}");
                    return 0;
                }
            }
        }

        private int GetTransferredCount()
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ComplaintsFormConnectionString"].ConnectionString))
            {
                string query = "SELECT COUNT(*) FROM Complaints WHERE Status = 'Transferred' OR TransferredFromEmpCode IS NOT NULL";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    return (int)cmd.ExecuteScalar();
                }
            }
        }

        private int GetUserTransferredCount(string empCode, int roleId)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ComplaintsFormConnectionString"].ConnectionString))
            {
                try
                {
                    string query = string.Empty;

                    if (roleId == 1 || roleId == 2) // Admin or SOC - see all transferred
                    {
                        query = "SELECT COUNT(*) FROM [ComplaintSystem].[dbo].[Complaint_Header] WHERE Status = 'Transferred'";
                    }
                    else if (roleId == 3) // Engineer - transferred that they're involved with
                    {
                        query = @"SELECT COUNT(*) FROM [ComplaintSystem].[dbo].[Complaint_Header] ch 
                                 WHERE (ch.AssignedTo = @EmpCode OR ch.UnitId IN (SELECT UnitId FROM dbo.EngineerUnitPermissions WHERE EmpCode = @EmpCode))
                                 AND Status = 'Transferred'";
                    }
                    else // Employee/Guest - transferred complaints they created
                    {
                        query = "SELECT COUNT(*) FROM [ComplaintSystem].[dbo].[Complaint_Header] WHERE CreatedBy = @EmpCode AND Status = 'Transferred'";
                    }

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@EmpCode", empCode ?? string.Empty);
                        conn.Open();
                        return (int)cmd.ExecuteScalar();
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error getting transferred count: {ex.Message}");
                    return 0;
                }
            }
        }

        private void LoadPipelineData()
        {
            try
            {
                string empCode = AuthorizationHelper.GetUserEmpCode();
                int roleId = AuthorizationHelper.GetUserRoleId();

                int assigned = 0, accepted = 0, progress = 0, resolved = 0, closed = 0;

                if (roleId == 1 || roleId == 2) // Admin or SOC
                {
                    assigned = GetStatusCount("Assigned");
                    accepted = GetStatusCount("Accepted");
                    progress = GetStatusCount("InProgress");
                    resolved = GetStatusCount("Resolved");
                    closed = GetStatusCount("Closed");
                }
                else // Employee/Engineer/Guest
                {
                    assigned = GetUserStatusCount(empCode, roleId, "Assigned");
                    accepted = GetUserStatusCount(empCode, roleId, "Accepted");
                    progress = GetUserStatusCount(empCode, roleId, "InProgress");
                    resolved = GetUserStatusCount(empCode, roleId, "Resolved");
                    closed = GetUserStatusCount(empCode, roleId, "Closed");
                }

                string scriptPipeline = $@"
                    <script type='text/javascript'>
                        window.addEventListener('load', function() {{
                            updatePipeline({assigned}, {accepted}, {progress}, {resolved}, {closed});
                        }});

                        function updatePipeline(assigned, accepted, progress, resolved, closed) {{
                            document.getElementById('pipelineAssigned').textContent = assigned;
                            document.getElementById('pipelineAccepted').textContent = accepted;
                            document.getElementById('pipelineProgress').textContent = progress;
                            document.getElementById('pipelineResolved').textContent = resolved;
                            document.getElementById('pipelineClosed').textContent = closed;
                        }}
                    </script>";

                Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "pipelineScript", scriptPipeline);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Load pipeline error: {ex.Message}");
            }
        }

        private void LoadRecentComplaints()
        {
            try
            {
                string empCode = AuthorizationHelper.GetUserEmpCode();
                int roleId = AuthorizationHelper.GetUserRoleId();

                ComplaintDataService dataService = new ComplaintDataService();

                // Get complaints based on role
                DataSet ds;
                if (roleId == 1 || roleId == 2) // Admin or SOC - see all
                {
                    ds = dataService.GetUserComplaints("", roleId); // Empty empCode means all
                }
                else // Employee/Engineer/Guest - see own
                {
                    ds = dataService.GetUserComplaints(empCode, roleId);
                }

                if (ds != null && ds.Tables.Count > 0)
                {
                    DataTable dt = ds.Tables[0];

                    // Generate table rows dynamically
                    System.Text.StringBuilder sb = new System.Text.StringBuilder();

                    int rowCount = 0;
                    foreach (DataRow row in dt.Rows)
                    {
                        if (rowCount >= 10) break; // Limit to 10 recent

                        string complaintId = row["ComplaintId"].ToString();
                        string complaintType = row["Type"].ToString();
                        string status = row["Status"].ToString();
                        string priority = row["Priority"].ToString();
                        string assignedTo = row["AssignedTo"].ToString() ?? "Unassigned";
                        string createdDate = Convert.ToDateTime(row["CreatedDate"]).ToString("MMM dd, yyyy");

                        string statusBadgeClass = GetStatusBadgeClass(status);
                        string priorityBadgeClass = GetPriorityBadgeClass(priority);

                        sb.AppendFormat(@"
                        <tr>
                            <td>{0}</td>
                            <td>{1}</td>
                            <td><span class='badge {2}'>{3}</span></td>
                            <td><span class='priority-badge {4}'>{5}</span></td>
                            <td>{6}</td>
                            <td>{7}</td>
                        </tr>", complaintId, complaintType, statusBadgeClass, status, priorityBadgeClass, priority, assignedTo, createdDate);

                        rowCount++;
                    }

                    // Update the results count
                    string countScript = $@"
                        <script type='text/javascript'>
                            window.addEventListener('load', function() {{
                                var tableBody = document.getElementById('complaintsList');
                                var resultsSpan = document.querySelector('.results-count');
                                if (resultsSpan) {{
                                    resultsSpan.textContent = '{rowCount} results';
                                }}
                            }});
                        </script>";

                    Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "resultsCount", countScript);

                    // Insert the rows via script
                    if (sb.Length > 0)
                    {
                        string rowsScript = $@"
                            <script type='text/javascript'>
                                window.addEventListener('load', function() {{
                                    var tableBody = document.getElementById('complaintsList');
                                    if (tableBody) {{
                                        tableBody.innerHTML = `{sb.ToString().Replace("`", @"\`")}`;
                                    }}
                                }});
                            </script>";

                        Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "complaintRows", rowsScript);
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Load complaints error: {ex.Message}");
            }
        }

        private string GetStatusBadgeClass(string status)
        {
            if (string.IsNullOrEmpty(status)) return "assigned";

            switch (status.ToLower())
            {
                case "assigned":
                    return "assigned";
                case "accepted":
                    return "accepted";
                case "inprogress":
                    return "in-progress";
                case "resolved":
                    return "resolved";
                case "closed":
                    return "closed";
                default:
                    return "assigned";
            }
        }

        private string GetPriorityBadgeClass(string priority)
        {
            if (string.IsNullOrEmpty(priority)) return "medium";

            switch (priority.ToLower())
            {
                case "critical":
                    return "critical";
                case "high":
                    return "high";
                case "medium":
                    return "medium";
                case "low":
                    return "low";
                default:
                    return "medium";
            }
        }
    }
}
