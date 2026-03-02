using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebFormDemo
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lblWelcome.Text = "Welcome," + Session["username"];
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
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}