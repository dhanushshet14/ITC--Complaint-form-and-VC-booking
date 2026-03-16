using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace HomePage
{ 
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Page_Load();

            }
        }

        private void Page_Load()
        {
            //((Label)this.Master.FindControl("lblUsername")).Text = "Raghavendra";
        }
    }
}