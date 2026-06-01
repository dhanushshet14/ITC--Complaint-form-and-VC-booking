using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;

namespace TMG_ITC.Helpers
{
    public static class NotificationHelper
    {
        private static string CS => AuthHelper.ConnectionString;

        public static void QueueNotification(string complaintId, string recipientEmpCode,
            string subject, string body)
        {
            string email = ResolveEmail(recipientEmpCode);
            long notificationId;

            using (var con = new SqlConnection(CS))
            using (var cmd = new SqlCommand(@"
                INSERT INTO Notification_Queue (ComplaintId, RecipientEmpCode, RecipientEmail, Subject, Body)
                VALUES (@ComplaintId, @EmpCode, @Email, @Subject, @Body);
                SELECT SCOPE_IDENTITY();", con))
            {
                cmd.Parameters.AddWithValue("@ComplaintId", (object)complaintId ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@EmpCode", recipientEmpCode);
                cmd.Parameters.AddWithValue("@Email", (object)email ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@Subject", subject);
                cmd.Parameters.AddWithValue("@Body", body);
                con.Open();
                notificationId = Convert.ToInt64(cmd.ExecuteScalar());
            }

            if (!string.IsNullOrEmpty(email))
                SendEmail(email, subject, body, notificationId);
        }

        private static string ResolveEmail(string empCode)
        {
            using (var con = new SqlConnection(CS))
            {
                con.Open();

                // Check GuestUser_Master first
                using (var cmd = new SqlCommand(
                    "SELECT Email FROM GuestUser_Master WHERE GuestEmpCode = @EmpCode", con))
                {
                    cmd.Parameters.AddWithValue("@EmpCode", empCode);
                    string email = cmd.ExecuteScalar()?.ToString();
                    if (!string.IsNullOrEmpty(email))
                        return email;
                }

                // Fallback: Username might be an email
                using (var cmd = new SqlCommand(
                    "SELECT Username FROM User_Master WHERE EmpCode = @EmpCode", con))
                {
                    cmd.Parameters.AddWithValue("@EmpCode", empCode);
                    string username = cmd.ExecuteScalar()?.ToString();
                    if (!string.IsNullOrEmpty(username) && username.Contains('@'))
                        return username;
                }
            }
            return null;
        }

        private static void SendEmail(string to, string subject, string body, long notificationId)
        {
            try
            {
                string smtpHost = ConfigurationManager.AppSettings["SmtpHost"];
                if (string.IsNullOrEmpty(smtpHost))
                    return; // SMTP not configured — queue only

                int port = int.Parse(ConfigurationManager.AppSettings["SmtpPort"] ?? "25");
                bool ssl = bool.Parse(ConfigurationManager.AppSettings["SmtpSsl"] ?? "false");
                string user = ConfigurationManager.AppSettings["SmtpUser"] ?? "";
                string pass = ConfigurationManager.AppSettings["SmtpPass"] ?? "";
                string from = ConfigurationManager.AppSettings["SmtpFrom"] ?? "noreply@manipalgroup.com";

                using (var client = new SmtpClient(smtpHost, port))
                {
                    client.EnableSsl = ssl;
                    if (!string.IsNullOrEmpty(user))
                        client.Credentials = new NetworkCredential(user, pass);
                    else
                        client.UseDefaultCredentials = true;

                    using (var msg = new MailMessage(from, to, subject, body))
                    {
                        msg.IsBodyHtml = true;
                        client.Send(msg);
                    }
                }

                MarkSent(notificationId);
            }
            catch (Exception ex)
            {
                MarkFailed(notificationId, ex.Message);
            }
        }

        private static void MarkSent(long notificationId)
        {
            using (var con = new SqlConnection(CS))
            using (var cmd = new SqlCommand(
                "UPDATE Notification_Queue SET Status='Sent', SentDate=GETDATE() WHERE NotificationId=@Id", con))
            {
                cmd.Parameters.AddWithValue("@Id", notificationId);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private static void MarkFailed(long notificationId, string error)
        {
            using (var con = new SqlConnection(CS))
            using (var cmd = new SqlCommand(
                "UPDATE Notification_Queue SET Status='Failed', ErrorMessage=@Err WHERE NotificationId=@Id", con))
            {
                cmd.Parameters.AddWithValue("@Id", notificationId);
                cmd.Parameters.AddWithValue("@Err", error);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public static int CheckSlaBreaches()
        {
            using (var con = new SqlConnection(CS))
            using (var cmd = new SqlCommand("usp_CheckSlaBreaches", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                con.Open();
                return (int)cmd.ExecuteScalar();
            }
        }

        public static int GetUnreadCount(string empCode)
        {
            using (var con = new SqlConnection(CS))
            using (var cmd = new SqlCommand(
                "SELECT COUNT(*) FROM Notification_Queue WHERE RecipientEmpCode=@EmpCode AND ReadFlag=0", con))
            {
                cmd.Parameters.AddWithValue("@EmpCode", empCode);
                con.Open();
                return (int)cmd.ExecuteScalar();
            }
        }

        public static DataTable GetUnreadNotifications(string empCode, int top = 10)
        {
            var dt = new DataTable();
            using (var con = new SqlConnection(CS))
            using (var cmd = new SqlCommand(@"
                SELECT TOP (@Top) NotificationId, ComplaintId, Subject,
                    LEFT(Body, 120) AS BodyShort, CreatedDate
                FROM Notification_Queue
                WHERE RecipientEmpCode=@EmpCode AND ReadFlag=0
                ORDER BY CreatedDate DESC", con))
            {
                cmd.Parameters.AddWithValue("@EmpCode", empCode);
                cmd.Parameters.AddWithValue("@Top", top);
                con.Open();
                using (var adapter = new SqlDataAdapter(cmd))
                    adapter.Fill(dt);
            }
            return dt;
        }

        public static void MarkAsRead(long notificationId)
        {
            using (var con = new SqlConnection(CS))
            using (var cmd = new SqlCommand(
                "UPDATE Notification_Queue SET ReadFlag=1 WHERE NotificationId=@Id", con))
            {
                cmd.Parameters.AddWithValue("@Id", notificationId);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public static void MarkAllAsRead(string empCode)
        {
            using (var con = new SqlConnection(CS))
            using (var cmd = new SqlCommand(
                "UPDATE Notification_Queue SET ReadFlag=1 WHERE RecipientEmpCode=@EmpCode AND ReadFlag=0", con))
            {
                cmd.Parameters.AddWithValue("@EmpCode", empCode);
                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public static void ProcessPendingNotifications()
        {
            DataTable pending = new DataTable();
            using (var con = new SqlConnection(CS))
            using (var cmd = new SqlCommand(
                "SELECT TOP 50 NotificationId, RecipientEmail, Subject, Body FROM Notification_Queue WHERE Status='Pending' AND RecipientEmail IS NOT NULL", con))
            {
                con.Open();
                using (var adapter = new SqlDataAdapter(cmd))
                    adapter.Fill(pending);
            }

            foreach (DataRow row in pending.Rows)
            {
                int id = Convert.ToInt32(row["NotificationId"]);
                string email = row["RecipientEmail"].ToString();
                string subject = row["Subject"].ToString();
                string body = row["Body"].ToString();

                try
                {
                    string smtpHost = ConfigurationManager.AppSettings["SmtpHost"];
                    if (string.IsNullOrEmpty(smtpHost))
                        return;

                    int port = int.Parse(ConfigurationManager.AppSettings["SmtpPort"] ?? "25");
                    bool ssl = bool.Parse(ConfigurationManager.AppSettings["SmtpSsl"] ?? "false");
                    string user = ConfigurationManager.AppSettings["SmtpUser"] ?? "";
                    string pass = ConfigurationManager.AppSettings["SmtpPass"] ?? "";
                    string from = ConfigurationManager.AppSettings["SmtpFrom"] ?? "noreply@manipalgroup.com";

                    using (var client = new SmtpClient(smtpHost, port))
                    {
                        client.EnableSsl = ssl;
                        if (!string.IsNullOrEmpty(user))
                            client.Credentials = new NetworkCredential(user, pass);
                        else
                            client.UseDefaultCredentials = true;

                        using (var msg = new MailMessage(from, email, subject, body))
                        {
                            msg.IsBodyHtml = true;
                            client.Send(msg);
                        }
                    }

                    using (var con = new SqlConnection(CS))
                    using (var cmd = new SqlCommand(
                        "UPDATE Notification_Queue SET Status='Sent', SentDate=GETDATE() WHERE NotificationId=@Id", con))
                    {
                        cmd.Parameters.AddWithValue("@Id", id);
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                catch (Exception ex)
                {
                    using (var con = new SqlConnection(CS))
                    using (var cmd = new SqlCommand(
                        "UPDATE Notification_Queue SET Status='Failed', ErrorMessage=@Err WHERE NotificationId=@Id", con))
                    {
                        cmd.Parameters.AddWithValue("@Id", id);
                        cmd.Parameters.AddWithValue("@Err", ex.Message);
                        con.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
        }
    }
}
