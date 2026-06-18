using System;
using TMG_ITC.Helpers;

namespace VCBooking
{
    public partial class ZoomCallback : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireAuth();

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
