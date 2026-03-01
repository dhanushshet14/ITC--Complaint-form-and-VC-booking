using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
namespace WebFormDemo
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string cs = ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString;
            SqlConnection con = new SqlConnection(cs);
            if (!IsPostBack)
            {

            con.Open();
            Response.Write("Connected Successfully");
            con.Close();
            }
        }
    }
}