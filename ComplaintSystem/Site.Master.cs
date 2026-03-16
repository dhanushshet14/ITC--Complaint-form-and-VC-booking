using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using ComplaintSystem.Auth;

namespace ComplaintSystem
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            //Session Checking
            //--------------------------------
            //Login Session Checking - Start
            int nUserId = 0;
            if (Session["UserId"] != null && Session["UserId"].ToString().Trim() != "")
            {
                try
                {
                    nUserId = Convert.ToInt32(Session["UserId"].ToString());
                }
                catch (Exception ex)
                {
                    nUserId = 0;
                }
            }

            if (nUserId == 0)
            {
                Logout();
            }
            //else
            //{
            //    //hidUserId.Value = nUserId.ToString();
            //    //Get User Profile
            //    Complaints_UserProfile objLogin = new Complaints_UserProfile();
            //    DataSet dsUser = objLogin.getUserProfile(nUserId);

            //    if (dsUser != null && dsUser.Tables[0].Rows.Count > 0)
            //    {
            //        lblUsername.Text = dsUser.Tables[0].Rows[0]["FullName"].ToString();

            //        if (dsUser.Tables[0].Rows[0]["AdminFlag"].ToString() == "Y")
            //        {
            //            hidAdminFlag.Value = "Y";
            //            divMenuAdmin.Visible = true;
            //            divMenuUser.Visible = true;
            //        }
            //        else
            //        {
            //            hidAdminFlag.Value = "N";
            //            divMenuAdmin.Visible = false;
            //            divMenuUser.Visible = true;
            //        }
            //    }
            //}
            //Login Session Checking - End
            //--------------------------------
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

            }
        }

        protected void lnlLogout_Click(object sender, EventArgs e)
        {
            Logout();
        }

        protected void lnlUserProfile_Click(object sender, EventArgs e)
        {
            return;
        }

        private void Logout()
        {
            Session.RemoveAll();
            Response.Redirect("Login.aspx");
        }
    }
}