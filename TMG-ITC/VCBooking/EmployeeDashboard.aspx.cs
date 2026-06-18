using System;
using TMG_ITC.Helpers;

namespace VCBooking
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireAuth();
            var user = AuthHelper.GetCurrentUser();
            lblWelcome.Text = "Welcome, " + user.FullName;
        }

        protected void btnClick_createVCRequest(object sender, EventArgs e)
        {
            Response.Redirect("CreateVCRequest.aspx");
        }

        protected void btnClick_viewRequests(object sender, EventArgs e)
        {
            Response.Redirect("ViewRequests.aspx");
        }

        protected void btnClick_LogOut(object sender, EventArgs e)
        {
            AuthHelper.Logout();
            Response.Redirect("~/Login.aspx");
        }
    }
}
