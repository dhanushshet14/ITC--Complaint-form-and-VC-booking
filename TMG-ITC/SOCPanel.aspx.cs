using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TMG_ITC.Helpers;

namespace TMG_ITC
{
    public partial class SOCPanel : System.Web.UI.Page
    {
        private string activeTab = "Queue";
        private int allPageIndex = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireAuth("SOC");

            if (!IsPostBack)
            {
                LoadSummaryCards();
                LoadQueue();
                LoadResolved();

                BindDDLStatus();
                BindDDLPriority();
                LoadAll();

                BindEngineerDropdown();
                UpdateBadges();
            }
        }

        private string CS => AuthHelper.ConnectionString;

        #region Summary
        private void LoadSummaryCards()
        {
            var user = AuthHelper.GetCurrentUser();
            using (var con = new SqlConnection(CS))
            using (var cmd = new SqlCommand("usp_GetDashboardSummary", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", user.EmpCode);
                cmd.Parameters.AddWithValue("@Role", user.Role);
                con.Open();
                using (var rdr = cmd.ExecuteReader())
                {
                    if (rdr.Read())
                    {
                        int total = Convert.ToInt32(rdr["TotalComplaints"]);
                        int open = Convert.ToInt32(rdr["OpenComplaints"]);
                        int resolved = Convert.ToInt32(rdr["ResolvedComplaints"]);
                        int closed = Convert.ToInt32(rdr["ClosedComplaints"]);
                        lblTotal.InnerText = total.ToString();
                        lblOpen.InnerText = open.ToString();
                        lblResolved.InnerText = resolved.ToString();
                        lblClosed.InnerText = closed.ToString();
                    }
                }
            }
        }
        #endregion

        #region Tab Switching
        protected void SwitchTab(object sender, CommandEventArgs e)
        {
            activeTab = e.CommandArgument.ToString();
            pnlQueue.Visible = (activeTab == "Queue");
            pnlResolved.Visible = (activeTab == "Resolved");
            pnlAll.Visible = (activeTab == "All");

            tabQueue.CssClass = (activeTab == "Queue") ? "nav-link active" : "nav-link";
            tabResolved.CssClass = (activeTab == "Resolved") ? "nav-link active" : "nav-link";
            tabAll.CssClass = (activeTab == "All") ? "nav-link active" : "nav-link";
        }
        #endregion

        #region Queue Tab
        private void LoadQueue()
        {
            DataTable dt = GetComplaints("Queue", "", "", "");
            gvQueue.DataSource = dt;
            gvQueue.DataBind();
            panelQueueEmpty.Visible = (dt.Rows.Count == 0);
            badgeQueue.InnerText = dt.Rows.Count.ToString();
        }

        protected void gvQueue_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Assign")
            {
                hfActionComplaintId.Value = e.CommandArgument.ToString();
                assignComplaintId.InnerText = "Assigning: " + hfActionComplaintId.Value;
                BindEngineerDropdown();
                txtAssignNote.Text = "";
                ScriptManager.RegisterStartupScript(this, GetType(), "showAssign",
                    "$('#assignModal').modal('show');", true);
            }
        }
        #endregion

        #region Resolved Tab
        private void LoadResolved()
        {
            DataTable dt = GetComplaints("Resolved", "", "", "");
            gvResolved.DataSource = dt;
            gvResolved.DataBind();
            panelResolvedEmpty.Visible = (dt.Rows.Count == 0);
            badgeResolved.InnerText = dt.Rows.Count.ToString();
        }

        protected void gvResolved_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Close")
            {
                hfActionComplaintId.Value = e.CommandArgument.ToString();
                closeComplaintId.InnerText = "Closing: " + hfActionComplaintId.Value;
                txtCloseReason.Text = "";
                ScriptManager.RegisterStartupScript(this, GetType(), "showClose",
                    "$('#closeModal').modal('show');", true);
            }
        }
        #endregion

        #region All Tab
        private void BindDDLStatus()
        {
            if (ddlStatus.Items.Count == 0)
            {
                ddlStatus.Items.Add(new ListItem("All", ""));
                ddlStatus.Items.Add(new ListItem("New", "New"));
                ddlStatus.Items.Add(new ListItem("Assigned", "Assigned"));
                ddlStatus.Items.Add(new ListItem("In Progress", "In Progress"));
                ddlStatus.Items.Add(new ListItem("Resolved", "Resolved"));
                ddlStatus.Items.Add(new ListItem("Closed", "Closed"));
                ddlStatus.Items.Add(new ListItem("Reopened", "Reopened"));
            }
        }

        private void BindDDLPriority()
        {
            if (ddlPriority.Items.Count == 0)
            {
                ddlPriority.Items.Add(new ListItem("All", ""));
                ddlPriority.Items.Add(new ListItem("Low", "Low"));
                ddlPriority.Items.Add(new ListItem("Medium", "Medium"));
                ddlPriority.Items.Add(new ListItem("High", "High"));
                ddlPriority.Items.Add(new ListItem("Critical", "Critical"));
            }
        }

        protected void FilterAllChanged(object sender, EventArgs e)
        {
            allPageIndex = 0;
            LoadAll();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            allPageIndex = 0;
            LoadAll();
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ddlStatus.SelectedIndex = 0;
            ddlPriority.SelectedIndex = 0;
            txtSearch.Text = "";
            allPageIndex = 0;
            LoadAll();
        }

        protected void gvAll_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            allPageIndex = e.NewPageIndex;
            LoadAll();
        }

        protected void gvAll_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            // action buttons per row if needed
        }

        private int allTotalRows = 0;
        private void LoadAll()
        {
            string status = ddlStatus.SelectedValue;
            string priority = ddlPriority.SelectedValue;
            string search = txtSearch.Text.Trim();
            var allDt = GetComplaints("All", status, priority, search);
            allTotalRows = (allDt.Rows.Count > 0) ? Convert.ToInt32(allDt.Rows[0]["TotalCount"]) : 0;

            DataTable pagedDt = allDt.Clone();
            int start = allPageIndex * 15;
            int end = Math.Min(start + 15, allDt.Rows.Count);
            for (int i = start; i < end; i++)
                pagedDt.ImportRow(allDt.Rows[i]);

            gvAll.DataSource = pagedDt;
            gvAll.VirtualItemCount = allTotalRows;
            gvAll.PageIndex = allPageIndex;
            gvAll.DataBind();
        }
        #endregion

        #region Data Access
        private DataTable GetComplaints(string view, string statusFilter, string priorityFilter, string searchFilter)
        {
            var user = AuthHelper.GetCurrentUser();
            var dt = new DataTable();
            using (var con = new SqlConnection(CS))
            using (var cmd = new SqlCommand("usp_GetComplaints", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@RequestType", "");
                cmd.Parameters.AddWithValue("@StatusFilter", "");
                cmd.Parameters.AddWithValue("@PriorityFilter", "");

                if (view == "Queue")
                    cmd.Parameters["@StatusFilter"].Value = "New,Reopened";
                else if (view == "Resolved")
                    cmd.Parameters["@StatusFilter"].Value = "Resolved";

                if (view == "All")
                {
                    cmd.Parameters["@StatusFilter"].Value = statusFilter;
                    cmd.Parameters["@PriorityFilter"].Value = priorityFilter;
                }

                cmd.Parameters.AddWithValue("@EmpCode", user.EmpCode);
                cmd.Parameters.AddWithValue("@Role", user.Role);
                cmd.Parameters.AddWithValue("@SearchQuery", searchFilter);
                cmd.Parameters.AddWithValue("@PageNumber", 1);
                cmd.Parameters.AddWithValue("@PageSize", 10000);

                con.Open();
                using (var adapter = new SqlDataAdapter(cmd))
                    adapter.Fill(dt);
            }
            return dt;
        }

        private void BindEngineerDropdown()
        {
            DataTable dtEngineers = new DataTable();
            using (var con = new SqlConnection(CS))
            using (var cmd = new SqlCommand("usp_GetEngineers", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                con.Open();
                using (var adapter = new SqlDataAdapter(cmd))
                    adapter.Fill(dtEngineers);
            }
            ddlEngineer.DataSource = dtEngineers;
            ddlEngineer.DataBind();
            ddlEngineer.Items.Insert(0, new ListItem("-- Select --", ""));
        }

        private void UpdateBadges()
        {
            // badges already set during LoadQueue / LoadResolved
        }
        #endregion

        #region Actions
        protected void btnConfirmAssign_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlEngineer.SelectedValue))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alertAssign",
                    "alert('Please select an engineer.');", true);
                return;
            }

            var user = AuthHelper.GetCurrentUser();
            string complaintId = hfActionComplaintId.Value;
            string engineer = ddlEngineer.SelectedValue;
            string note = txtAssignNote.Text.Trim();

            string title = "";
            using (var con = new SqlConnection(CS))
            using (var cmd = new SqlCommand("usp_AssignComplaint", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@ComplaintId", complaintId);
                cmd.Parameters.AddWithValue("@AssignedTo", engineer);
                cmd.Parameters.AddWithValue("@AssignedBy", user.EmpCode);
                cmd.Parameters.AddWithValue("@AssignType", "ASSIGN");
                cmd.Parameters.AddWithValue("@Note", (object)note ?? DBNull.Value);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            // Get title for notification
            using (var con = new SqlConnection(CS))
            using (var cmd = new SqlCommand("SELECT Title FROM Complaint_Header WHERE ComplaintId=@Id", con))
            {
                cmd.Parameters.AddWithValue("@Id", complaintId);
                con.Open();
                title = cmd.ExecuteScalar()?.ToString() ?? "";
            }

            NotificationHelper.QueueNotification(complaintId, engineer,
                "Complaint Assigned: " + complaintId,
                $"Complaint <b>{complaintId}</b> has been assigned to you.<br/>Title: {title}<br/><a href='ComplaintDetail.aspx?id={complaintId}'>View Details</a>");

            ScriptManager.RegisterStartupScript(this, GetType(), "hideAssign",
                "$('#assignModal').modal('hide');", true);

            LoadQueue();
            LoadSummaryCards();
            UpdateBadges();
        }

        protected void btnConfirmClose_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtCloseReason.Text.Trim()))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alertClose",
                    "alert('Please provide a closure reason.');", true);
                return;
            }

            var user = AuthHelper.GetCurrentUser();
            string complaintId = hfActionComplaintId.Value;

            using (var con = new SqlConnection(CS))
            using (var cmd = new SqlCommand("usp_CloseComplaint", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@ComplaintId", complaintId);
                cmd.Parameters.AddWithValue("@ClosedBy", user.EmpCode);
                cmd.Parameters.AddWithValue("@Reason", txtCloseReason.Text.Trim());
                con.Open();
                cmd.ExecuteNonQuery();
            }

            // Notify creator
            string creator = "";
            using (var con = new SqlConnection(CS))
            using (var cmd = new SqlCommand("SELECT CreatedBy FROM Complaint_Header WHERE ComplaintId=@Id", con))
            {
                cmd.Parameters.AddWithValue("@Id", complaintId);
                con.Open();
                creator = cmd.ExecuteScalar()?.ToString() ?? "";
            }
            if (!string.IsNullOrEmpty(creator))
            {
                string title = "";
                using (var con = new SqlConnection(CS))
                using (var cmd = new SqlCommand("SELECT Title FROM Complaint_Header WHERE ComplaintId=@Id", con))
                {
                    cmd.Parameters.AddWithValue("@Id", complaintId);
                    con.Open();
                    title = cmd.ExecuteScalar()?.ToString() ?? "";
                }
                NotificationHelper.QueueNotification(complaintId, creator,
                    "Complaint Closed: " + complaintId,
                    $"Complaint <b>{complaintId}</b> has been closed.<br/>Title: {title}<br/><a href='ComplaintDetail.aspx?id={complaintId}'>View Details</a>");
            }

            ScriptManager.RegisterStartupScript(this, GetType(), "hideClose",
                "$('#closeModal').modal('hide');", true);

            if (activeTab == "Resolved")
                LoadResolved();
            else
            {
                LoadQueue();
                LoadResolved();
            }
            LoadSummaryCards();
        }
        #endregion

    }
}
