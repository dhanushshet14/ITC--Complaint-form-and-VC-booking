using System;
using System.Configuration;
using System.Net;
using System.Net.Mail;
using System.Threading.Tasks;

namespace WebFormDemo.Services
{
    public class EmailService
    {
        public async Task SendMeetingInvitationAsync(
            string toEmail,
            string topic,
            DateTime startTime,
            int duration,
            string joinUrl,
            string meetingId,
            string password,
            string createdByName,
            string createdByEmail)
        {
            string fromEmail = ConfigurationManager.AppSettings["SmtpEmail"];
            string smtpPassword = ConfigurationManager.AppSettings["SmtpPassword"];

            string subject = $"Meeting Invitation: {topic}";

            string body = $@"
Hello,

You are invited to attend a meeting.

----------------------------------------
Topic: {topic}
Date: {startTime:dd-MM-yyyy}
Time: {startTime:hh:mm tt}
Duration: {duration} minutes
----------------------------------------

Join Link:
{joinUrl}

Meeting ID: {meetingId}
Passcode: {password}

----------------------------------------
Created By: {createdByName}
Email: {createdByEmail}
----------------------------------------

Thank you.
";

            MailMessage message = new MailMessage();
            message.From = new MailAddress(fromEmail);
            message.To.Add(toEmail);
            message.Subject = subject;
            message.Body = body;

            SmtpClient client = new SmtpClient("smtp.gmail.com", 587);
            client.Credentials = new NetworkCredential(fromEmail, smtpPassword);
            client.EnableSsl = true;

            await client.SendMailAsync(message);
        }
    }
}