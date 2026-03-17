using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;
using System.Web.UI.WebControls;

namespace VCBooking
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["EmployeeCode"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }
            if (Session["IsAdmin"] == null || (bool)Session["IsAdmin"] == false)
            {
                Response.Redirect("~/Dashboard.aspx");
            }
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

                string cancelledBy = Session["Username"] != null
                                     ? Session["Username"].ToString()
                                     : "Admin";

                cmd.Parameters.AddWithValue("@CancelledBy", cancelledBy);
                cmd.Parameters.AddWithValue("@CancelReason", reason);

                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        protected async void gvMeetings_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string vcId = e.CommandArgument.ToString();

            if (e.CommandName == "RescheduleMeeting")
            {
                hfRescheduleVCId.Value = vcId;
                pnlReschedule.Visible = true;
                pnlCancel.Visible = false;
                LoadMeetingDetailsForReschedule(vcId);
            }
            else if (e.CommandName == "CancelMeeting")
            {
                hfCancelVCId.Value = vcId;
                pnlCancel.Visible = true;
                pnlReschedule.Visible = false;
            }
            else if (e.CommandName == "DeleteMeeting")
            {
                await DeleteMeetingPermanently(vcId);
                LoadMeetings();
            }
        }

        private void LoadMeetingDetailsForReschedule(string vcId)
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            {
                string query = "SELECT VCDate, FromTime, ToTime FROM VCRequestHeader WHERE VCId = @VCId";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@VCId", vcId);
                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        txtNewDate.Text = Convert.ToDateTime(reader["VCDate"]).ToString("yyyy-MM-dd");
                        txtNewFromTime.Text = Convert.ToDateTime(reader["FromTime"]).ToString("HH:mm");
                        txtNewToTime.Text = Convert.ToDateTime(reader["ToTime"]).ToString("HH:mm");
                    }
                }
            }
        }

        protected async void btnConfirmCancel_Click(object sender, EventArgs e)
        {
            try
            {
                string vcId = hfCancelVCId.Value;
                string reason = txtCancelReason.Text;

                // 1. Get Meeting Details
                var details = GetBaseMeetingDetails(vcId);
                if (details == null) return;

                // 2. Delete Zoom Meeting
                var zoom = new Services.ZoomService();
                if (!string.IsNullOrEmpty(details.MeetingId))
                {
                    await zoom.DeleteMeetingAsync(details.MeetingId);
                }

                // 3. Update DB
                UpdateStatusInDB(vcId, "Cancelled", reason);

                // 4. Notify participants
                var email = new Services.EmailService();
                await email.SendCancellationNotificationAsync(
                    details.Topic, details.Date, details.FromTime, details.ToTime,
                    details.MeetingId, reason, details.Participants);

                pnlCancel.Visible = false;
                txtCancelReason.Text = "";
                LoadMeetings();
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message.Replace("'", "") + "');</script>");
            }
        }

        protected async void btnConfirmReschedule_Click(object sender, EventArgs e)
        {
            try
            {
                string vcId = hfRescheduleVCId.Value;
                string reason = txtRescheduleReason.Text;
                DateTime newDate = DateTime.Parse(txtNewDate.Text);
                TimeSpan newFrom = TimeSpan.Parse(txtNewFromTime.Text);
                TimeSpan newTo = TimeSpan.Parse(txtNewToTime.Text);

                // 1. Get Details
                var details = GetBaseMeetingDetails(vcId);
                if (details == null) return;

                // 1.5. Overlap Check
                if (details.VCAccountId != null) // We need AccountId for check
                {
                    bool isOverlapping = IsAccountBusy(details.VCAccountId.ToString(), newDate, newFrom, newTo, vcId);
                    if (isOverlapping)
                    {
                        Response.Write("<script>alert('Error: The selected account is already booked for this time slot.');</script>");
                        return;
                    }
                }

                // 2. Update Zoom
                var zoom = new Services.ZoomService();
                if (!string.IsNullOrEmpty(details.MeetingId))
                {
                    DateTime start = newDate.Add(newFrom);
                    int duration = (int)(newTo - newFrom).TotalMinutes;
                    await zoom.UpdateMeetingAsync(details.MeetingId, details.Topic, start, duration);
                }

                // 3. Update DB
                UpdateScheduleInDB(vcId, newDate, newFrom, newTo);

                // 4. Notify
                var email = new Services.EmailService();
                await email.SendRescheduleNotificationAsync(
                    details.Topic,
                    details.Date, details.FromTime, details.ToTime,
                    newDate, newFrom, newTo,
                    details.JoinUrl, details.MeetingId, details.Password,
                    reason, details.Participants);

                pnlReschedule.Visible = false;
                LoadMeetings();
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message.Replace("'", "") + "');</script>");
            }
        }

        private void UpdateStatusInDB(string vcId, string status, string reason)
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            {
                string query = "UPDATE VCRequestHeader SET VCStatus = @Status, CancelReason = @Reason, CancelledDate = GETDATE(), CancelledBy = @By WHERE VCId = @VCId";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Status", status);
                cmd.Parameters.AddWithValue("@Reason", reason);
                cmd.Parameters.AddWithValue("@By", Session["UserName"] != null ? Session["UserName"].ToString() : "Admin");
                cmd.Parameters.AddWithValue("@VCId", vcId);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private void UpdateScheduleInDB(string vcId, DateTime date, TimeSpan from, TimeSpan to)
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            {
                string query = "UPDATE VCRequestHeader SET VCDate = @Date, FromTime = @From, ToTime = @To WHERE VCId = @VCId";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Date", date);
                cmd.Parameters.AddWithValue("@From", from);
                cmd.Parameters.AddWithValue("@To", to);
                cmd.Parameters.AddWithValue("@VCId", vcId);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private async Task DeleteMeetingPermanently(string vcId)
        {
            try
            {
                var details = GetBaseMeetingDetails(vcId);
                if (details != null && !string.IsNullOrEmpty(details.MeetingId))
                {
                    await new Services.ZoomService().DeleteMeetingAsync(details.MeetingId);
                }

                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
                {
                    con.Open();
                    using (SqlTransaction trans = con.BeginTransaction())
                    {
                        try
                        {
                            SqlCommand cmdP = new SqlCommand("DELETE FROM VCParticipants WHERE VCId = @Id", con, trans);
                            cmdP.Parameters.AddWithValue("@Id", vcId);
                            cmdP.ExecuteNonQuery();

                            SqlCommand cmdH = new SqlCommand("DELETE FROM VCRequestHeader WHERE VCId = @Id", con, trans);
                            cmdH.Parameters.AddWithValue("@Id", vcId);
                            cmdH.ExecuteNonQuery();

                            trans.Commit();
                        }
                        catch { trans.Rollback(); throw; }
                    }
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Delete failed: " + ex.Message.Replace("'", "") + "');</script>");
            }
        }

        private bool IsAccountBusy(string accountId, DateTime date, TimeSpan from, TimeSpan to, string excludeVcId)
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            {
                string query = @"SELECT COUNT(*) FROM VCRequestHeader 
                                 WHERE VCAccountId = @AccountId 
                                 AND VCStatus NOT IN ('Cancelled', 'Completed')
                                 AND VCId <> @ExcludeId
                                 AND (@Start < ToTime AND @End > FromTime)";
                
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@AccountId", accountId);
                cmd.Parameters.AddWithValue("@ExcludeId", excludeVcId);
                
                DateTime start = date.Add(from);
                DateTime end = date.Add(to);
                cmd.Parameters.Add("@Start", SqlDbType.DateTime).Value = start;
                cmd.Parameters.Add("@End", SqlDbType.DateTime).Value = end;

                con.Open();
                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }

        private MeetingDetails GetBaseMeetingDetails(string vcId)
        {
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            {
                string query = "SELECT Topic, VCDate, FromTime, ToTime, MeetingId, JoinUrl, MeetingPassword AS Password, VCAccountId FROM VCRequestHeader WHERE VCId = @Id";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Id", vcId);
                con.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        var d = new MeetingDetails();
                        d.Topic = reader["Topic"].ToString();
                        d.Date = Convert.ToDateTime(reader["VCDate"]);
                        d.FromTime = Convert.ToDateTime(reader["FromTime"]).TimeOfDay;
                        d.ToTime = Convert.ToDateTime(reader["ToTime"]).TimeOfDay;
                        d.MeetingId = reader["MeetingId"].ToString();
                        d.JoinUrl = reader["JoinUrl"].ToString();
                        d.Password = reader["Password"].ToString();
                        d.VCAccountId = reader["VCAccountId"];
                        d.Participants = GetParticipants(vcId);
                        return d;
                    }
                }
            }
            return null;
        }

        private List<string> GetParticipants(string vcId)
        {
            var list = new List<string>();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand("SELECT ParticipantEmail FROM VCParticipants WHERE VCId = @Id", con);
                cmd.Parameters.AddWithValue("@Id", vcId);
                con.Open();
                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    while (r.Read()) list.Add(r["ParticipantEmail"].ToString());
                }
            }
            return list;
        }

        protected void btnCancelPopup_Click(object sender, EventArgs e)
        {
            pnlCancel.Visible = false;
            pnlReschedule.Visible = false;
        }

        private class MeetingDetails
        {
            public string Topic;
            public DateTime Date;
            public TimeSpan FromTime;
            public TimeSpan ToTime;
            public string MeetingId;
            public string JoinUrl;
            public string Password;
            public string Platform;
            public object VCAccountId;
            public List<string> Participants;
        }
    }
}