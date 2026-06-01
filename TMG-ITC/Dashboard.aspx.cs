using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using TMG_ITC.Helpers;

namespace TMG_ITC
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected double openPercent;
        protected double inProgressPercent;
        protected double resolvedPercent;
        protected double closedPercent;

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireAuth();

            if (!IsPostBack)
            {
                LoadDashboardSummary();
                LoadRecentComplaints();
            }
        }

        private void LoadDashboardSummary()
        {
            var user = AuthHelper.GetCurrentUser();

            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            using (var cmd = new SqlCommand("usp_GetDashboardSummary", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", user.EmpCode);
                cmd.Parameters.AddWithValue("@Role", user.Role);

                conn.Open();

                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        int total = Convert.ToInt32(reader["TotalComplaints"]);
                        int open = Convert.ToInt32(reader["OpenComplaints"]);
                        int inProgress = Convert.ToInt32(reader["InProgressComplaints"]);
                        int resolved = Convert.ToInt32(reader["ResolvedComplaints"]);
                        int closed = Convert.ToInt32(reader["ClosedComplaints"]);
                        int slaBreach = Convert.ToInt32(reader["SlaBreachCount"]);

                        lblTotal.InnerText = total.ToString();
                        lblOpen.InnerText = open.ToString();
                        lblInProgress.InnerText = inProgress.ToString();
                        lblResolved.InnerText = resolved.ToString();
                        lblClosed.InnerText = closed.ToString();
                        lblSlaBreach.InnerText = slaBreach.ToString();

                        double divisor = total > 0 ? total : 1;
                        openPercent = Math.Round(open / divisor * 100, 1);
                        inProgressPercent = Math.Round(inProgress / divisor * 100, 1);
                        resolvedPercent = Math.Round(resolved / divisor * 100, 1);
                        closedPercent = Math.Round(closed / divisor * 100, 1);
                    }
                }
            }
        }

        private void LoadRecentComplaints()
        {
            var user = AuthHelper.GetCurrentUser();
            var dt = new DataTable();

            using (var con = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            using (var cmd = new SqlCommand("usp_GetComplaints", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", user.EmpCode);
                cmd.Parameters.AddWithValue("@Role", user.Role);
                cmd.Parameters.AddWithValue("@StatusFilter", "");
                cmd.Parameters.AddWithValue("@PriorityFilter", "");
                cmd.Parameters.AddWithValue("@RequestType", "");
                cmd.Parameters.AddWithValue("@SearchQuery", "");
                cmd.Parameters.AddWithValue("@PageNumber", 1);
                cmd.Parameters.AddWithValue("@PageSize", 5);

                con.Open();
                using (var adapter = new SqlDataAdapter(cmd))
                    adapter.Fill(dt);
            }

            gvRecent.DataSource = dt;
            gvRecent.DataBind();
            panelNoComplaints.Visible = (dt.Rows.Count == 0);
        }

        protected void gvRecent_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            // styling handled via CSS classes
        }

        protected void btnComplaints_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/ComplaintCreation.aspx");
        }

        protected void btnVCBooking_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/VCBooking/EmployeeDashboard.aspx");
        }

        protected void btnMyComplaints_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/TechnicalComplaints.aspx");
        }
    }
}
