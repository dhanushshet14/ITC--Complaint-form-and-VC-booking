using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using ComplaintSystem.Auth;

namespace ComplaintPage
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Use new authorization helper
                AuthorizationHelper.RequireAuthentication();

                // Only Employee and Guest can create tickets
                if (!AuthorizationHelper.HasPermission("create_ticket"))
                {
                    Response.Redirect("AccessDenied.aspx");
                }

                LoadFormDefaults();
            }
        }

        private void LoadFormDefaults()
        {
            // Load any default form data if needed
        }

        protected void SubmitComplaint_Click(object sender, EventArgs e)
        {
            try
            {
                // Verify user has permission to create ticket
                if (!AuthorizationHelper.HasPermission("create_ticket"))
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "err", "alert('You do not have permission to create complaints');", true);
                    return;
                }

                // Gather values from controls
                string complaintId = Guid.NewGuid().ToString().ToUpper().Replace("-", "").Substring(0, 12);
                string createdBy = AuthorizationHelper.GetUserEmpCode();
                string title = txtSubject != null ? txtSubject.Text.Trim() : string.Empty;
                string priority = ddlPriority != null ? ddlPriority.SelectedValue : string.Empty;
                int complaintTypeId = 0;
                int unitId = 0;
                int categoryId = 0;
                int subCategoryId = 0;
                string requestType = ddlRequestTypeDesc != null ? ddlRequestTypeDesc.SelectedValue : string.Empty;
                string description = txtDescription != null ? txtDescription.Text.Trim() : string.Empty;
                int customerImpactFlag = 0;
                if (ddlCustomerImpact != null && ddlCustomerImpact.SelectedValue == "Yes") customerImpactFlag = 1;
                string customerName = string.Empty;
                string assignedTo = string.Empty;
                string assignmentType = string.Empty;

                // Try parse category/unit ids from dropdown values
                if (ddlCategory != null) int.TryParse(ddlCategory.SelectedValue, out categoryId);
                if (ddlUnit != null) int.TryParse(ddlUnit.SelectedValue, out unitId);

                var csSetting = ConfigurationManager.ConnectionStrings["ComplaintsFormConnectionString"];
                if (csSetting == null || string.IsNullOrWhiteSpace(csSetting.ConnectionString))
                {
                    throw new ConfigurationErrorsException("Missing connection string 'ComplaintsFormConnectionString' in configuration.");
                }
                string cs = csSetting.ConnectionString;

                using (SqlConnection conn = new SqlConnection(cs))
                using (SqlCommand cmd = new SqlCommand("dbo.sp_InsertComplaintHeader", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ComplaintId", complaintId);
                    cmd.Parameters.AddWithValue("@CreatedBy", string.IsNullOrEmpty(createdBy) ? (object)DBNull.Value : createdBy);
                    cmd.Parameters.AddWithValue("@Title", string.IsNullOrEmpty(title) ? (object)DBNull.Value : title);
                    cmd.Parameters.AddWithValue("@Priority", string.IsNullOrEmpty(priority) ? (object)DBNull.Value : priority);
                    cmd.Parameters.AddWithValue("@ComplaintTypeId", complaintTypeId);
                    cmd.Parameters.AddWithValue("@UnitId", unitId);
                    cmd.Parameters.AddWithValue("@RequestType", string.IsNullOrEmpty(requestType) ? (object)DBNull.Value : requestType);
                    cmd.Parameters.AddWithValue("@CategoryId", categoryId);
                    cmd.Parameters.AddWithValue("@SubCategoryId", subCategoryId);
                    cmd.Parameters.AddWithValue("@Description", string.IsNullOrEmpty(description) ? (object)DBNull.Value : description);
                    cmd.Parameters.AddWithValue("@CustomerImpactFlag", customerImpactFlag);
                    cmd.Parameters.AddWithValue("@CustomerName", string.IsNullOrEmpty(customerName) ? (object)DBNull.Value : customerName);
                    cmd.Parameters.AddWithValue("@AssignedTo", string.IsNullOrEmpty(assignedTo) ? (object)DBNull.Value : assignedTo);
                    cmd.Parameters.AddWithValue("@AssignmentType", string.IsNullOrEmpty(assignmentType) ? (object)DBNull.Value : assignmentType);
                    cmd.Parameters.AddWithValue("@Status", "New");
                    cmd.Parameters.AddWithValue("@LastUpdateBy", string.IsNullOrEmpty(createdBy) ? (object)DBNull.Value : createdBy);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                    ClientScript.RegisterStartupScript(this.GetType(), "msg", "alert('Complaint submitted successfully'); window.location='ViewComplaints.aspx';", true);
                }
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "err", "alert('Error submitting complaint: " + ex.Message.Replace("'", "\\'") + "');", true);
            }
        }
    }
}
