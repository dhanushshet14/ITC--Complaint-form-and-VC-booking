using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ViewComplaints
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Session Checking
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
                    Session.RemoveAll();
                    Response.Redirect("Login.aspx");
                }
            }
        }
    }
}
