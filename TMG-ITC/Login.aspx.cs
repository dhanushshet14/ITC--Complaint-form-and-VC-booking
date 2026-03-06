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
                string query = "SELECT EMP_Empcode, EMP_Name, EMP_EmailId FROM TBL_EmployeeDetails WHERE EMP_Empcode = @EmpCode AND EMP_DomainUsername = @EmpCode";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@EmpCode", empCode);

                con.Open();

                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    Session["EmployeeCode"] = reader["EMP_Empcode"].ToString();
                    Session["UserName"] = reader["EMP_Name"].ToString();
                    Session["UserEmail"] = reader["EMP_EmailId"].ToString();

                    Response.Redirect("~/Dashboard.aspx");
                }
                else
                {
                    Response.Write("<script>alert('Invalid Credentials');</script>");
                }

                reader.Close();
            }
        }
    }
}