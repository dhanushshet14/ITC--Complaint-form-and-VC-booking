using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VCBooking
{
    public partial class CreateVCRequest : System.Web.UI.Page
    {
        protected async void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                await CleanupExpiredMeetings();
                DataTable dt = new DataTable();
                dt.Columns.Add("ParticipantEmail");
                ViewState["Participants"] = dt;

                LoadDropdown("SELECT CompanyName,CompanyId from dbo.Company_Master WHERE Status='Active'",
                    ddlCompany, "CompanyName", "CompanyId", "-- Select Your Company --");

                LoadDropdown("SELECT VCTypeName,VCTypeId from dbo.VC_Type_Master WHERE Status='Active'",
                    ddlVCType, "VCTypeName", "VCTypeId", "-- Select Vedio Conference Type --");

                LoadDropdown("SELECT LocationName,LocationId from dbo.Location_Master WHERE Status='Active'",
                    ddlLocation, "LocationName", "LocationId", "-- Select Location --");
            }
        }

        protected void btnAddParticipant_Click(object sender, EventArgs e)
        {
            lblParticipantMessage.Text = "";

            if (!string.IsNullOrWhiteSpace(txtParticipant.Text))
            {
                bool exists = false;

                DataTable dt = ViewState["Participants"] as DataTable;

                if (dt == null)
                {
                    dt = new DataTable();
                    dt.Columns.Add("ParticipantEmail");
                    ViewState["Participants"] = dt;
                }

                foreach (DataRow row in dt.Rows)
                {
                    if (row["ParticipantEmail"].ToString().ToLower() ==
                        txtParticipant.Text.Trim().ToLower())
                    {
                        exists = true;
                        break;
                    }
                }

                if (exists)
                {
                    lblParticipantMessage.Text = "Email already added!";
                }
                else
                {
                    DataRow dr = dt.NewRow();
                    dr["ParticipantEmail"] = txtParticipant.Text.Trim();
                    dt.Rows.Add(dr);

                    ViewState["Participants"] = dt;

                    gvParticipants.DataSource = dt;
                    gvParticipants.DataBind();

                    txtParticipant.Text = "";
                }
            }
        }


        private void LoadDropdown(string query, DropDownList ddl, string textField, string valueField, string placeholderText)
        {
            string connStr = ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {

                SqlCommand cmd = new SqlCommand(query, conn);

                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();

                ddl.DataSource = reader;
                ddl.DataTextField = textField;
                ddl.DataValueField = valueField;
                ddl.DataBind();
                ddl.Items.Insert(0, new ListItem(placeholderText, ""));
            }
        }

        protected void ddlVCType_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadAvailableAccounts();
        }


        protected async void btnFormSubmit_Click(object sender, EventArgs e)
        {
            if (ddlCompany.SelectedValue == "" ||
                ddlVCType.SelectedValue == "" ||
                ddlVCAccount.SelectedValue == "" ||
                ddlLocation.SelectedValue == "" ||
                string.IsNullOrEmpty(txtTopic.Text) ||
                string.IsNullOrEmpty(txtDate.Text) ||
                string.IsNullOrEmpty(txtFrom.Text) ||
                string.IsNullOrEmpty(txtTo.Text))
            {
                Response.Write("<script>alert('Please fill all required fields');</script>");
                return;
            }

            DataTable dt = ViewState["Participants"] as DataTable;

            if (dt == null || dt.Rows.Count == 0)
            {
                Response.Write("<script>alert('Add at least one participant');</script>");
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString;

            List<string> participantEmails = new List<string>();
            foreach (DataRow row in dt.Rows)
                participantEmails.Add(row["ParticipantEmail"].ToString());

            string createdByName = Session["UserName"]?.ToString();
            string createdByEmail = Session["UserEmail"]?.ToString();

            if (string.IsNullOrEmpty(createdByName) || string.IsNullOrEmpty(createdByEmail))
            {
                Response.Redirect("Login.aspx");
                return;
            }

            string meetingId = "";
            string joinUrl = "";
            string startUrl = "";
            string password = "";
            DateTime fullFromDateTime;
            DateTime fullToDateTime;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                await conn.OpenAsync();
                SqlTransaction transaction = conn.BeginTransaction();

                try
                {
                    // 🔹 Generate VCId
                    string newVCId = "";
                    string getLastIdQuery = "SELECT TOP 1 VCId FROM VCRequestHeader ORDER BY VCId DESC";

                    SqlCommand cmdGetId = new SqlCommand(getLastIdQuery, conn, transaction);
                    object result = cmdGetId.ExecuteScalar();

                    if (result == null)
                        newVCId = "VC001";
                    else
                    {
                        string lastId = result.ToString();
                        int number = int.Parse(lastId.Substring(2)) + 1;
                        newVCId = "VC" + number.ToString("D3");
                    }

                    fullFromDateTime = DateTime.Parse(txtDate.Text + " " + txtFrom.Text);
                    fullToDateTime = DateTime.Parse(txtDate.Text + " " + txtTo.Text);

                    // 🔹 Overlap check
                    string overlapCheckQuery = @"
                SELECT COUNT(*)
                FROM VCRequestHeader
                WHERE VCAccountId = @VCAccountId
                AND (@NewFromTime < ToTime AND @NewToTime > FromTime)";

                    SqlCommand cmdCheck = new SqlCommand(overlapCheckQuery, conn, transaction);
                    cmdCheck.Parameters.AddWithValue("@VCAccountId", ddlVCAccount.SelectedValue);
                    cmdCheck.Parameters.Add("@NewFromTime", SqlDbType.DateTime).Value = fullFromDateTime;
                    cmdCheck.Parameters.Add("@NewToTime", SqlDbType.DateTime).Value = fullToDateTime;

                    int overlapCount = (int)cmdCheck.ExecuteScalar();

                    if (overlapCount > 0)
                    {
                        transaction.Rollback();
                        Response.Write("<script>alert('Selected VC Account is already booked!');</script>");
                        return;
                    }

                    // 🔹 Insert Header
                    string insertHeaderQuery = @"
                INSERT INTO VCRequestHeader
                (VCId, CompanyId, VCTypeId, VCAccountId, Topic, VCDate, FromTime, ToTime, LocationId, VCStatus, CreatedBy, CreatedDate)
                VALUES
                (@VCId, @CompanyId, @VCTypeId, @VCAccountId, @Topic, @VCDate, @FromTime, @ToTime, @LocationId, 'New', @CreatedBy, GETDATE())";

                    SqlCommand cmdHeader = new SqlCommand(insertHeaderQuery, conn, transaction);

                    cmdHeader.Parameters.AddWithValue("@VCId", newVCId);
                    cmdHeader.Parameters.AddWithValue("@CompanyId", ddlCompany.SelectedValue);
                    cmdHeader.Parameters.AddWithValue("@VCTypeId", ddlVCType.SelectedValue);
                    cmdHeader.Parameters.AddWithValue("@VCAccountId", ddlVCAccount.SelectedValue);
                    cmdHeader.Parameters.AddWithValue("@Topic", txtTopic.Text.Trim());
                    cmdHeader.Parameters.Add("@VCDate", SqlDbType.DateTime).Value = DateTime.Parse(txtDate.Text);
                    cmdHeader.Parameters.Add("@FromTime", SqlDbType.DateTime).Value = fullFromDateTime;
                    cmdHeader.Parameters.Add("@ToTime", SqlDbType.DateTime).Value = fullToDateTime;
                    cmdHeader.Parameters.AddWithValue("@LocationId", ddlLocation.SelectedValue);
                    cmdHeader.Parameters.AddWithValue("@CreatedBy", createdByName);

                    cmdHeader.ExecuteNonQuery();

                    // 🔹 Insert Participants
                    foreach (string email in participantEmails)
                    {
                        SqlCommand cmdParticipant = new SqlCommand(@"
                    INSERT INTO VCParticipants
                    (VCId, ParticipantEmail, CreatedBy, CreatedDate)
                    VALUES
                    (@VCId, @ParticipantEmail, @CreatedBy, GETDATE())",
                            conn, transaction);

                        cmdParticipant.Parameters.AddWithValue("@VCId", newVCId);
                        cmdParticipant.Parameters.AddWithValue("@ParticipantEmail", email);
                        cmdParticipant.Parameters.AddWithValue("@CreatedBy", createdByName);
                        cmdParticipant.ExecuteNonQuery();
                    }

                    // 🔹 Call Zoom
                    var zoomService = new VCBooking.Services.ZoomService();

                    var zoomResponse = await zoomService.CreateMeetingAsync(
                        txtTopic.Text.Trim(),
                        fullFromDateTime,
                        (int)(fullToDateTime - fullFromDateTime).TotalMinutes,
                        createdByName,
                        createdByEmail
                    );

                    meetingId = zoomResponse["id"].ToString();
                    joinUrl = zoomResponse["join_url"].ToString();
                    startUrl = zoomResponse["start_url"].ToString();
                    password = zoomResponse["password"].ToString();

                    // 🔹 Update Header with Zoom details
                    SqlCommand cmdUpdateZoom = new SqlCommand(@"
                UPDATE VCRequestHeader
                SET MeetingId=@MeetingId,
                    JoinUrl=@JoinUrl,
                    HostUrl=@HostUrl,
                    MeetingPassword=@MeetingPassword,
                    Platform='Zoom',
                    APIStatus='Success',
                    VCStatus='Booked'
                WHERE VCId=@VCId",
                        conn, transaction);

                    cmdUpdateZoom.Parameters.AddWithValue("@MeetingId", meetingId);
                    cmdUpdateZoom.Parameters.AddWithValue("@JoinUrl", joinUrl);
                    cmdUpdateZoom.Parameters.AddWithValue("@HostUrl", startUrl);
                    cmdUpdateZoom.Parameters.AddWithValue("@MeetingPassword", password);
                    cmdUpdateZoom.Parameters.AddWithValue("@VCId", newVCId);

                    cmdUpdateZoom.ExecuteNonQuery();

                    transaction.Commit();
                }
                catch
                {
                    if (transaction != null && transaction.Connection != null)
                    {
                        try { transaction.Rollback(); } catch { }
                    }
                    throw;
                }
            }

            // 🔹 SEND EMAILS OUTSIDE TRANSACTION
            var emailService = new VCBooking.Services.EmailService();
            int duration = (int)(fullToDateTime - fullFromDateTime).TotalMinutes;

            foreach (string email in participantEmails)
            {
                try
                {
                    await emailService.SendMeetingInvitationAsync(
                        email,
                        txtTopic.Text.Trim(),
                        fullFromDateTime,
                        duration,
                        joinUrl,
                        meetingId,
                        password,
                        createdByName,
                        createdByEmail
                    );
                }
                catch
                {
                    // Optional: log email error
                }
            }

            Response.Write("<script>alert('VC Request Created Successfully!');</script>");
        }



        private void LoadAvailableAccounts()
        {
            if (ddlVCType.SelectedValue == "" ||
                string.IsNullOrEmpty(txtDate.Text) ||
                string.IsNullOrEmpty(txtFrom.Text) ||
                string.IsNullOrEmpty(txtTo.Text))
            {
                ddlVCAccount.Items.Clear();
                ddlVCAccount.Items.Insert(0, new ListItem("-- Select Account --", ""));
                return;
            }

            string connStr = ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
        SELECT a.VCAccountId, a.VCAccountName
        FROM VC_Account_Master a
        WHERE a.VCTypeId = @VCTypeId
        AND a.Status = 'Active'
        AND NOT EXISTS
        (
            SELECT 1
            FROM VCRequestHeader h
            WHERE h.VCAccountId = a.VCAccountId
            AND (@NewFromTime < h.ToTime AND @NewToTime > h.FromTime)
        )";

                SqlCommand cmd = new SqlCommand(query, conn);

                cmd.Parameters.AddWithValue("@VCTypeId", ddlVCType.SelectedValue);

                DateTime newFrom = DateTime.Parse(txtDate.Text + " " + txtFrom.Text);
                DateTime newTo = DateTime.Parse(txtDate.Text + " " + txtTo.Text);

                cmd.Parameters.Add("@NewFromTime", SqlDbType.DateTime).Value = newFrom;
                cmd.Parameters.Add("@NewToTime", SqlDbType.DateTime).Value = newTo;

                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();

                ddlVCAccount.DataSource = reader;
                ddlVCAccount.DataTextField = "VCAccountName";
                ddlVCAccount.DataValueField = "VCAccountId";
                ddlVCAccount.DataBind();

                ddlVCAccount.Items.Insert(0, new ListItem("-- Select Account --", ""));
            }
        }


        protected void DateOrTimeChanged(object sender, EventArgs e)
        {
            LoadAvailableAccounts();
        }


        private async Task CleanupExpiredMeetings()
        {
            string connStr = ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                await conn.OpenAsync();

                string query = @"
            SELECT VCId, MeetingId
            FROM VCRequestHeader
            WHERE DATEADD(MINUTE, 5, ToTime) < GETDATE()
            AND VCStatus = 'Booked'
            AND MeetingId IS NOT NULL";

                SqlCommand cmd = new SqlCommand(query, conn);
                SqlDataReader reader = await cmd.ExecuteReaderAsync();

                var expiredMeetings = new List<(string VCId, string MeetingId)>();

                while (await reader.ReadAsync())
                {
                    expiredMeetings.Add((
                        reader["VCId"].ToString(),
                        reader["MeetingId"].ToString()
                    ));
                }

                reader.Close();

                var zoomService = new VCBooking.Services.ZoomService();

                foreach (var meeting in expiredMeetings)
                {
                    try
                    {
                        // 🔥 Delete from Zoom
                        await zoomService.DeleteMeetingAsync(meeting.MeetingId);

                        // 🔥 Update DB
                        string updateQuery = @"
                    UPDATE VCRequestHeader
                    SET VCStatus = 'Completed',
                        APIStatus = 'Deleted'
                    WHERE VCId = @VCId";

                        SqlCommand updateCmd = new SqlCommand(updateQuery, conn);
                        updateCmd.Parameters.AddWithValue("@VCId", meeting.VCId);

                        await updateCmd.ExecuteNonQueryAsync();
                    }
                    catch
                    {
                        // You can log error later if needed
                    }
                }
            }
        }


    }
}