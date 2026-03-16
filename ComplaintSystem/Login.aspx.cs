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
            divErrorMsg.Visible = false;
            lblErrorMsg.Text = "";
            txtUsername.Focus();
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            bool bLogin = false;
            Complaints_UserProfile objLogin = new Complaints_UserProfile();
            int nUserId = objLogin.verifyLogin(txtUsername.Text.Trim(), txtPassword.Text);

            if (nUserId > 0)
            {
                bLogin = true;
                divErrorMsg.Visible = false;
                lblErrorMsg.Text = "";
                Session.RemoveAll();
                Session.Add("UserId", nUserId.ToString());
                Response.Redirect("HomePage.aspx");
            }

            if (bLogin == false)
            {
                divErrorMsg.Visible = true;
                lblErrorMsg.Text = "Invalid username / password.";
                txtPassword.Focus();
            }

            Console.WriteLine("Hello");
        }
    }
}