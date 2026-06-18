using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using TMG_ITC.Helpers;

namespace TMG_ITC
{
    public partial class TechnicalComplaints : System.Web.UI.Page
    {
        private const string RequestType = "INC";

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireAuth();

            if (!IsPostBack)
            {
                BindComplaints(1);
            }
        }

        private void BindComplaints(int pageNumber)
        {
            var user = AuthHelper.GetCurrentUser();
            string statusFilter = ddlStatus.SelectedValue;
            string priorityFilter = ddlPriority.SelectedValue;
            string searchQuery = txtSearch.Text.Trim();

            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            using (var cmd = new SqlCommand("usp_GetComplaints", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", user.EmpCode);
                cmd.Parameters.AddWithValue("@Role", user.Role);
                cmd.Parameters.AddWithValue("@StatusFilter", (object)statusFilter ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@PriorityFilter", (object)priorityFilter ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@RequestType", RequestType);
                cmd.Parameters.AddWithValue("@SearchQuery", (object)searchQuery ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@PageNumber", pageNumber);
                cmd.Parameters.AddWithValue("@PageSize", 15);

                conn.Open();

                using (var reader = cmd.ExecuteReader())
                {
                    var dt = new DataTable();
                    dt.Load(reader);

                    if (dt.Rows.Count > 0)
                    {
                        int totalCount = Convert.ToInt32(dt.Rows[0]["TotalCount"]);
                        gvComplaints.VirtualItemCount = totalCount;
                        gvComplaints.PageIndex = pageNumber - 1;
                        gvComplaints.DataSource = dt;
                        gvComplaints.DataBind();
                        panelEmpty.Visible = false;
                        gvComplaints.Visible = true;
                    }
                    else
                    {
                        gvComplaints.Visible = false;
                        panelEmpty.Visible = true;
                    }
                }
            }
        }

        protected void FilterChanged(object sender, EventArgs e)
        {
            BindComplaints(1);
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            BindComplaints(1);
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ddlStatus.SelectedIndex = 0;
            ddlPriority.SelectedIndex = 0;
            txtSearch.Text = "";
            BindComplaints(1);
        }

        protected void gvComplaints_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            BindComplaints(e.NewPageIndex + 1);
        }

        protected void gvComplaints_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Attributes["style"] = "cursor: pointer;";
                e.Row.Attributes["onclick"] = "location.href='ComplaintDetail.aspx?id=" +
                    DataBinder.Eval(e.Row.DataItem, "ComplaintId") + "'";
            }
        }
    }
}
