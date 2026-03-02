using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Security.Cryptography;
using System.Text;

namespace WebFormDemo
{
    public partial class CreateEmployee : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void btnCreateEmployee_Click(object sender, EventArgs e)
        {
            lblMessage.Text = "";
            lblMessage.ForeColor = System.Drawing.Color.Green;

            string emp_code = txtEmployeeCode.Text.Trim();
            string emp_name = txtEmployeeName.Text.Trim();
            string emp_level = txtEmployeeLevel.Text.Trim();
            string emp_company = txtEmployeeCompany.Text.Trim();
            string emp_department = txtEmployeeDepartment.Text.Trim();
            string emp_designation = txtEmployeeDesignation.Text.Trim();
            string emp_unit = txtEmployeeUnit.Text.Trim();
            string emp_location = txtEmployeeLocation.Text.Trim();
            string emp_email = txtEmployeeEmail.Text.Trim();
            string emp_password = txtEmployeePassword.Text.Trim();
            string emp_phoneNo = txtEmployeePhoneNo.Text.Trim();
            string emp_reportingTo = txtReportingTo.Text.Trim();
            string emp_reportingEmp_id = txtReportingEmpCode.Text.Trim();

            // 🔹 Validation
            if (string.IsNullOrEmpty(emp_code))
            {
                lblMessage.Text = "Employee code is required";
                return;
            }

            if (string.IsNullOrEmpty(emp_name))
            {
                lblMessage.Text = "Employee Name is required";
                return;
            }

            if (string.IsNullOrEmpty(emp_email) || !emp_email.Contains("@"))
            {
                lblMessage.Text = "Enter valid Email address";
                return;
            }

            if (string.IsNullOrEmpty(emp_password))
            {
                lblMessage.Text = "Employee Password is required";
                return;
            }

            if (string.IsNullOrEmpty(emp_phoneNo))
            {
                lblMessage.Text = "Employee Phone number is required";
                return;
            }

            if (string.IsNullOrEmpty(emp_reportingTo))
            {
                lblMessage.Text = "Reporting To is required";
                return;
            }

            // 🔹 Upload Image FIRST
            string imagePath = "";

            if (fuEmployeeImage.HasFile)
            {
                string extension = System.IO.Path.GetExtension(fuEmployeeImage.FileName).ToLower();

                if (extension == ".jpg" || extension == ".jpeg" || extension == ".png")
                {
                    string fileName = Guid.NewGuid().ToString() + extension;
                    string folderPath = Server.MapPath("~/EmployeeImages/");
                    string fullPath = System.IO.Path.Combine(folderPath, fileName);

                    fuEmployeeImage.SaveAs(fullPath);

                    imagePath = "~/EmployeeImages/" + fileName;
                }
                else
                {
                    lblMessage.Text = "Only JPG, JPEG, PNG images allowed.";
                    return;
                }
            }
            else
            {
                lblMessage.Text = "Please upload employee image.";
                return;
            }

            // 🔹 Hash Password
            string hashedPassword = HashPassword(emp_password);

            string cs = ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // 🔹 Duplicate Email Check
                SqlCommand checkCmd = new SqlCommand(
                    "SELECT COUNT(*) FROM TBL_EmployeeDetails WHERE EMP_EmailId=@Email",
                    con);

                checkCmd.Parameters.AddWithValue("@Email", emp_email);

                int emailExists = Convert.ToInt32(checkCmd.ExecuteScalar());

                if (emailExists > 0)
                {
                    lblMessage.Text = "Email already exists!";
                    return;
                }

                // 🔹 Insert Employee
                SqlCommand cmd = new SqlCommand(
                      "INSERT INTO TBL_EmployeeDetails " +
                      "(EMP_Empcode, EMP_Name, EMP_Level, EMP_Department, EMP_Designation, " +
                      "EMP_Location, EMP_CompanyName, EMP_EmailId, EMP_Mobile, " +
                      "EMP_ReportingTo, EMP_ReportingEmpCode, EMP_Unit, EMP_ImageName, EMP_PasswordHash) " +
                      "VALUES (@Empcode, @Name, @Level, @Department, @Designation, " +
                      "@Location, @Company, @Email, @Mobile, " +
                      "@ReportingTo, @ReportingEmpCode, @Unit, @ImageName, @PasswordHash)",con);

                cmd.Parameters.AddWithValue("@Empcode", emp_code);
                cmd.Parameters.AddWithValue("@Name", emp_name);
                cmd.Parameters.AddWithValue("@Level", emp_level);
                cmd.Parameters.AddWithValue("@Department", emp_department);
                cmd.Parameters.AddWithValue("@Designation", emp_designation);
                cmd.Parameters.AddWithValue("@Location", emp_location);
                cmd.Parameters.AddWithValue("@Company", emp_company);
                cmd.Parameters.AddWithValue("@Email", emp_email);
                cmd.Parameters.AddWithValue("@Mobile", emp_phoneNo);
                cmd.Parameters.AddWithValue("@ReportingTo", emp_reportingTo);
                cmd.Parameters.AddWithValue("@ReportingEmpCode", emp_reportingEmp_id);
                cmd.Parameters.AddWithValue("@Unit", emp_unit);
                cmd.Parameters.AddWithValue("@ImageName", imagePath);
                cmd.Parameters.AddWithValue("@PasswordHash", hashedPassword);

                cmd.ExecuteNonQuery();
            }

            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = "Employee Created Successfully!";

            Response.Redirect("Login.aspx");

            ClearFields();
        }

        private void ClearFields()
        {
            txtEmployeeCode.Text = "";
            txtEmployeeName.Text = "";
            txtEmployeeLevel.Text = "";
            txtEmployeeCompany.Text = "";
            txtEmployeeDepartment.Text = "";
            txtEmployeeDesignation.Text = "";
            txtEmployeeUnit.Text = "";
            txtEmployeeLocation.Text = "";
            txtEmployeeEmail.Text = "";
            txtEmployeePassword.Text = "";
            txtEmployeePhoneNo.Text = "";
        }


        private string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = Encoding.UTF8.GetBytes(password);
                byte[] hash = sha256.ComputeHash(bytes);

                StringBuilder builder = new StringBuilder();
                foreach (byte b in hash)
                {
                    builder.Append(b.ToString("x2"));
                }

                return builder.ToString();
            }
        }
    }
}