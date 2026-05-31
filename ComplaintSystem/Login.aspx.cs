using ComplaintSystem.Auth;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ComplaintSystem
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadPage();
            }
        }

        private void LoadPage()
        {
            txtUsername.Text = "";
            txtPassword.Text = "";
            divErrorMsg.Attributes["class"] = "alert-danger";
            lblErrorMsg.Text = "";
            txtUsername.Focus();
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            try
            {
                // Use new authentication service with role-based access control
                AuthenticationService authService = new AuthenticationService();
                LoginResult loginResult = authService.ValidateLogin(txtUsername.Text.Trim(), txtPassword.Text);

                if (loginResult.IsValid)
                {
                    // Clear existing session
                    Session.RemoveAll();

                    // Store user information in session
                    Session["UserId"] = loginResult.UserId;
                    Session["EmpCode"] = loginResult.EmpCode;
                    Session["UserRole"] = loginResult.Role;
                    Session["RoleId"] = loginResult.RoleId;
                    Session["UserName"] = txtUsername.Text.Trim();

                    // Get and store user permissions
                    UserPermissions permissions = authService.GetUserPermissions(loginResult.EmpCode, loginResult.RoleId);
                    Session["UserPermissions"] = permissions;

                    divErrorMsg.Attributes["class"] = "alert-danger";
                    lblErrorMsg.Text = "";

                    Response.Redirect("HomePage.aspx");
                }
                else
                {
                    divErrorMsg.Attributes["class"] = "alert-danger show";
                    lblErrorMsg.Text = "Invalid username / password.";
                    txtPassword.Focus();
                }
            }
            catch (Exception ex)
            {
                divErrorMsg.Attributes["class"] = "alert-danger show";
                lblErrorMsg.Text = $"Login error: {ex.Message}";
                txtPassword.Focus();
            }
        }
    }
}