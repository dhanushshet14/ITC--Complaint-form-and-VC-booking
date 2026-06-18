using System;
using System.Web.UI;
using TMG_ITC.Helpers;

namespace TMG_ITC
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (AuthHelper.IsAuthenticated())
                Response.Redirect("~/Dashboard.aspx");
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            lblMessage.Visible = false;

            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;

            if (string.IsNullOrEmpty(username))
            {
                ShowError("Please enter username or employee code");
                return;
            }

            var result = AuthHelper.ValidateCredentials(username, password);

            if (!result.Success)
            {
                ShowError(result.Message);
                return;
            }

            AuthHelper.SetSession(new UserSessionData
            {
                EmpCode = result.EmpCode,
                FullName = result.FullName,
                Username = username,
                Role = result.Role,
                LoginType = result.LoginType,
                UnitIds = result.UnitIds
            });

            Response.Redirect(AuthHelper.GetRedirectUrl(result.Role));
        }

        private void ShowError(string message)
        {
            lblMessage.Text = message;
            lblMessage.Visible = true;
        }
    }
}
