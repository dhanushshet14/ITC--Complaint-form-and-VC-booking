using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebFormDemo
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string empCode = txtEmployeecode.Text.Trim();
            string empEmail = txtEmployeeEmail.Text.Trim();
            string empPassword = txtEmployeePassword.Text.Trim();

            if (string.IsNullOrEmpty(empCode) || string.IsNullOrEmpty(empEmail) || string.IsNullOrEmpty(empPassword))
            {
                lblMessage.Text = "All credentials must be filled";
                return;
            }
            string cs = ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = @"SELECT EMP_PasswordHash,
                        EMP_Name,
                        EMP_EmailId
                 FROM dbo.TBL_EmployeeDetails
                 WHERE EMP_Empcode = @EmpCode
                 AND EMP_EmailId = @EmpEmail";

                SqlCommand cmd = new SqlCommand(query, con);

                cmd.Parameters.AddWithValue("@EmpCode", empCode);
                cmd.Parameters.AddWithValue("@EmpEmail", empEmail);
                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    string storedHash = reader["EMP_PasswordHash"].ToString();
                    string enteredHash = HashPassword(empPassword);

                    if (storedHash == enteredHash)
                    {
                        Session["EmpCode"] = empCode;
                        Session["UserName"] = reader["EMP_Name"].ToString();
                        Session["UserEmail"] = reader["EMP_EmailId"].ToString();

                        Response.Redirect("EmployeeDashboard.aspx");
                    }
                    else
                    {
                        lblMessage.Text = "Invalid Credentials";
                    }
                }
                else
                {
                    lblMessage.Text = "Invalid Credentials";
                }
            }
        }

        private string HashPassword(string password)
        {
            using (var sha256 = System.Security.Cryptography.SHA256.Create())
            {
                byte[] bytes = System.Text.Encoding.UTF8.GetBytes(password);
                byte[] hash = sha256.ComputeHash(bytes);

                System.Text.StringBuilder builder = new System.Text.StringBuilder();
                foreach (byte b in hash)
                {
                    builder.Append(b.ToString("x2"));
                }

                return builder.ToString();
            }
        }
    }
}