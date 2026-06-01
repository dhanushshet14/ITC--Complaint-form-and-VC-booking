using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using TMG_ITC.Helpers;

namespace VCBooking
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireAuth();
            if (!IsPostBack)
            {
                LoadMeetings();
            }
        }

        private void LoadMeetings()
        {
            using (SqlConnection con = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            {
                string query = @"SELECT VCId, Topic, VCDate, VCStatus, CreatedBy
                 FROM VCRequestHeader
                 WHERE VCStatus <> 'Cancelled'
                 ORDER BY CreatedDate DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvMeetings.DataSource = dt;
                gvMeetings.DataBind();
            }
        }

        private void SoftDeleteMeeting(string vcId, string reason)
        {
            using (SqlConnection con = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            {
                string query = @"UPDATE VCRequestHeader
                                  SET VCStatus = 'Cancelled',
                                      CancelledBy = @CancelledBy,
                                      CancelledDate = GETDATE(),
                                      CancelReason = @CancelReason
                                  WHERE VCId = @VCId";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@VCId", vcId);
                var user = AuthHelper.GetCurrentUser();
                cmd.Parameters.AddWithValue("@CancelledBy", user.FullName);
                cmd.Parameters.AddWithValue("@CancelReason", reason);

                con.Open();
                cmd.ExecuteNonQuery();
                con.Close();
            }
        }

        protected void gvMeetings_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteMeeting")
            {
                hfVCId.Value = e.CommandArgument.ToString();
                pnlDelete.Visible = true;
            }
        }

        protected void btnConfirmDelete_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtReason.Text))
            {
                return;
            }

            SoftDeleteMeeting(hfVCId.Value, txtReason.Text);
            pnlDelete.Visible = false;
            txtReason.Text = "";
            LoadMeetings();
        }

        protected void btnCancelPopup_Click(object sender, EventArgs e)
        {
            pnlDelete.Visible = false;
            txtReason.Text = "";
        }
    }
}
