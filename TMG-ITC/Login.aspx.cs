using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace TMG_ITC
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string empCode = txtEmployeecode.Text.Trim();

            string connStr = ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "SELECT COUNT(*) FROM TBL_EmployeeDetails WHERE EMP_Empcode = @EmpCode AND EMP_DomainUsername = @EmpCode";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@EmpCode", empCode);

                con.Open();
                int count = (int)cmd.ExecuteScalar();

                if (count > 0)
                {
                    Session["EmployeeCode"]= empCode;
                    Response.Redirect("~/Dashboard.aspx");
                }
                else
                {
                    Response.Write("<script>alert('Invalid Credentials');</script>");
                }
            }
        }
    }
}