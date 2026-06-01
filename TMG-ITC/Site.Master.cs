using System;
using System.Data;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using TMG_ITC.Helpers;

namespace TMG_ITC
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!AuthHelper.IsAuthenticated())
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            var user = AuthHelper.GetCurrentUser();

            litUserName.Text = user.FullName;
            litRoleBadge.Text = $"<span class=\"role-badge {user.Role.ToLower()}\">{user.Role}</span>";

            string initials = string.Concat(
                user.FullName.Split(' ').Where(w => w.Length > 0).Take(2).Select(w => w[0])
            ).ToUpper();
            litAvatar.Text = initials.Length > 0 ? initials.Substring(0, 1) : "?";

            navSOCItem.Visible = AuthHelper.CanAccessModule("soc");
            navAdminItem.Visible = AuthHelper.CanAccessModule("adminpanel");

            string currentPage = Request.Url.AbsolutePath.ToLower();
            SetActiveNav(currentPage);

            if (!IsPostBack)
                BindNotifications();
        }

        private void BindNotifications()
        {
            var user = AuthHelper.GetCurrentUser();
            int count = NotificationHelper.GetUnreadCount(user.EmpCode);

            if (count > 0)
                litNotifBadge.Text = $"<span class=\"notif-badge\">{count}</span>";
            else
                litNotifBadge.Text = "";

            DataTable notifs = NotificationHelper.GetUnreadNotifications(user.EmpCode);
            rptNotifications.DataSource = notifs;
            rptNotifications.DataBind();

            if (notifs.Rows.Count == 0)
                litNoNotif.Text = "<div class=\"notif-empty\"><i class=\"bi bi-bell-slash\"></i><br/>No new notifications</div>";
            else
                litNoNotif.Text = "";
        }

        protected void timerNotifications_Tick(object sender, EventArgs e)
        {
            BindNotifications();
        }

        protected void rptNotifications_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Open")
            {
                string[] args = e.CommandArgument.ToString().Split('|');
                long notificationId = long.Parse(args[0]);
                string complaintId = args.Length > 1 ? args[1] : "";

                NotificationHelper.MarkAsRead(notificationId);

                if (!string.IsNullOrEmpty(complaintId))
                    Response.Redirect("~/ComplaintDetail.aspx?Id=" + complaintId);
                else
                    BindNotifications();
            }
        }

        protected void btnMarkAllRead_Click(object sender, EventArgs e)
        {
            var user = AuthHelper.GetCurrentUser();
            NotificationHelper.MarkAllAsRead(user.EmpCode);
            BindNotifications();
        }

        protected string GetTimeAgo(object dateObj)
        {
            if (dateObj == null || dateObj == DBNull.Value) return "";
            DateTime date = Convert.ToDateTime(dateObj);
            TimeSpan span = DateTime.Now - date;

            if (span.TotalMinutes < 1) return "Just now";
            if (span.TotalMinutes < 60) return $"{(int)span.TotalMinutes}m ago";
            if (span.TotalHours < 24) return $"{(int)span.TotalHours}h ago";
            if (span.TotalDays < 7) return $"{(int)span.TotalDays}d ago";
            return date.ToString("dd MMM");
        }

        private void SetActiveNav(string currentPage)
        {
            var navLinks = new[]
            {
                (navDashboard, "dashboard"),
                (navNewComplaint, "complaintcreation"),
                (navTechnical, "technical"),
                (navTelephone, "telephone"),
                (navVCBooking, "vcbooking"),
                (navSOC, "socpanel"),
                (navAdmin, "adminpanel")
            };

            foreach (var (link, keyword) in navLinks)
            {
                if (link != null && currentPage.Contains(keyword.ToLower()))
                {
                    link.Attributes["class"] = "nav-link active";
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            AuthHelper.Logout();
            Response.Redirect("~/Login.aspx");
        }
    }
}
