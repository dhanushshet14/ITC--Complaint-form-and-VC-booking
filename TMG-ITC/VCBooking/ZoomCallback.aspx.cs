using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VCBooking
{
    public partial class ZoomCallback : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["EmployeeCode"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }
            string code = Request.QueryString["code"];

            if (!string.IsNullOrEmpty(code))
            {
                Response.Write("Authorization Code: " + code);
            }
            else
            {
                Response.Write("No authorization code received.");
            }
        }
    }
}