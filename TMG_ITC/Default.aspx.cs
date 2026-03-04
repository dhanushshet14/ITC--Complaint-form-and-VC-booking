using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // If user is already logged in, redirect to Dashboard
        if (Session["EmpCode"] != null)
        {
            Response.Redirect("~/Dashboard.aspx");
        }
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        string empCode = txtEmpCode.Text.Trim();

        if (ValidateEmployee(empCode))
        {
            // Store employee code in session
            Session["EmpCode"] = empCode;

            // Set Forms Authentication ticket
            FormsAuthentication.SetAuthCookie(empCode, false);

            // Redirect to Dashboard
            Response.Redirect("~/Dashboard.aspx");
        }
        else
        {
            lblMessage.Text = "Invalid Employee Code. Please try again.";
        }
    }

    private bool ValidateEmployee(string empCode)
    {
        bool isValid = false;
        string connectionString = ConfigurationManager.ConnectionStrings["TMG_EMPLOYEEData"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connectionString))
        {   
            string query = "SELECT COUNT(*) FROM dbo.TBL_EmployeeDetails WHERE EMP_Empcode = @EmpCode";
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@EmpCode", empCode);
                conn.Open();
                int count = (int)cmd.ExecuteScalar();
                isValid = count > 0;
            }
        }

        return isValid;
    }
}