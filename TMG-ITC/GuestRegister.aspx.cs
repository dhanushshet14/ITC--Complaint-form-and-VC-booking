using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using BCrypt.Net;
using TMG_ITC.Helpers;

namespace TMG_ITC
{
    public partial class GuestRegister : System.Web.UI.Page
    {
        private string CS => AuthHelper.ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (AuthHelper.IsAuthenticated())
                Response.Redirect("~/Dashboard.aspx");
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            lblMessage.Visible = false;

            string name = txtName.Text.Trim();
            string email = txtEmail.Text.Trim().ToLower();
            string mobile = txtMobile.Text.Trim();
            string department = txtDepartment.Text.Trim();
            string designation = txtDesignation.Text.Trim();
            string location = txtLocation.Text.Trim();
            string password = txtPassword.Text;

            if (password.Length < 6)
            {
                ShowError("Password must be at least 6 characters", "danger");
                return;
            }

            string passwordHash = BCrypt.Net.BCrypt.HashPassword(password, BCrypt.Net.BCrypt.GenerateSalt(12));

            using (var con = new SqlConnection(CS))
            using (var cmd = new SqlCommand("usp_RegisterGuest", con))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@FullName", name);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@PasswordHash", passwordHash);
                cmd.Parameters.AddWithValue("@Mobile", string.IsNullOrEmpty(mobile) ? (object)DBNull.Value : mobile);
                cmd.Parameters.AddWithValue("@Department", string.IsNullOrEmpty(department) ? (object)DBNull.Value : department);
                cmd.Parameters.AddWithValue("@Designation", string.IsNullOrEmpty(designation) ? (object)DBNull.Value : designation);
                cmd.Parameters.AddWithValue("@Location", string.IsNullOrEmpty(location) ? (object)DBNull.Value : location);

                con.Open();
                using (var rdr = cmd.ExecuteReader())
                {
                    if (rdr.Read())
                    {
                        bool success = Convert.ToBoolean(rdr["Success"]);
                        string message = rdr["Message"].ToString();

                        if (success)
                        {
                            pnlForm.Visible = false;
                            pnlSuccess.Visible = true;
                            successMessage.InnerText = "Welcome, " + name + "! Your account (" + rdr["EmpCode"].ToString() + ") is ready. Please sign in.";
                        }
                        else
                        {
                            ShowError(message, "danger");
                        }
                    }
                }
            }
        }

        private void ShowError(string message, string type = "danger")
        {
            lblMessage.CssClass = "alert alert-" + type + " d-block mb-3 small py-2";
            lblMessage.Text = message;
            lblMessage.Visible = true;
        }
    }
}
