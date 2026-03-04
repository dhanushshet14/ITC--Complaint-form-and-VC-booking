using System;
using System.Web;
using System.Web.Security;
using System.Web.UI;

public partial class Dashboard : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Check if user is logged in
        if (Session["EmpCode"] == null)
        {
            Response.Redirect("~/Default.aspx");
            return;
        }

        if (!IsPostBack)
        {
            lblWelcome.Text = "Employee Code: " + Session["EmpCode"].ToString();
        }
    }

    protected void btnLogout_Click(object sender, EventArgs e)
    {
        // Clear session
        Session.Clear();
        Session.Abandon();

        // Sign out from Forms Authentication
        FormsAuthentication.SignOut();

        // Redirect to login page
        Response.Redirect("~/Default.aspx");
    }
}
