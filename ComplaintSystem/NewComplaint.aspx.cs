using ComplaintSystem.Auth;
using System;
using System.Web.UI;

namespace ComplaintSystem
{
    public partial class NewComplaint : Page
    {
        protected string complaintType = "Technical";

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                // Check if user is authenticated
                AuthorizationHelper.RequireAuthentication();

                // Get complaint type from query string
                string type = Request.QueryString["type"];
                if (!string.IsNullOrEmpty(type) && (type == "Technical" || type == "Telephone"))
                {
                    complaintType = type;
                }
            }
            catch (Exception ex)
            {
                Response.Redirect("Login.aspx");
            }
        }
    }
}
