using System;
using System.Web.UI;

namespace TMG_ITC
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["EmployeeCode"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }
        }

        protected void btnComplaints_Click(object sender, EventArgs e)
        {
            Response.Redirect("");
        }

        protected void btnVCBooking_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/VCBooking/EmployeeDashboard.aspx");
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Login.aspx");
        }
    }
}