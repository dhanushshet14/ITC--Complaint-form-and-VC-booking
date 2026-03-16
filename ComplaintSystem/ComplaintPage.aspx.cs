using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace ComplaintPage
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

        protected void SubmitComplaint_Click(object sender, EventArgs e)
        {
            // Gather values from controls
            string complaintId = Guid.NewGuid().ToString().ToUpper().Replace("-", "").Substring(0, 12);
            string createdBy = Session["UserName"] != null ? Session["UserName"].ToString() : "";
            string title = txtSubject != null ? txtSubject.Text.Trim() : string.Empty;
            string priority = ddlPriority != null ? ddlPriority.SelectedValue : string.Empty;
            int complaintTypeId = 0; // not available in UI
            int unitId = 0;
            int categoryId = 0;
            int subCategoryId = 0;
            string requestType = txtRequestTypeDesc != null ? txtRequestTypeDesc.Text.Trim() : string.Empty;
            string description = txtDescription != null ? txtDescription.Text.Trim() : string.Empty;
            int customerImpactFlag = 0;
            if (ddlCustomerImpact != null && ddlCustomerImpact.SelectedValue == "Yes") customerImpactFlag = 1;
            string customerName = string.Empty;
            string assignedTo = string.Empty;
            string assignmentType = string.Empty;

            // Try parse category/unit ids from dropdown values
            if (ddlCategory != null) int.TryParse(ddlCategory.SelectedValue, out categoryId);
            if (ddlUnit != null) int.TryParse(ddlUnit.SelectedValue, out unitId);

            var csSetting = ConfigurationManager.ConnectionStrings["HRMContractConnectionString"];
            if (csSetting == null || string.IsNullOrWhiteSpace(csSetting.ConnectionString))
            {
                throw new ConfigurationErrorsException("Missing connection string 'HRMContractConnectionString' in configuration.");
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

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    // TODO: handle attachments saving separately
                    ClientScript.RegisterStartupScript(this.GetType(), "msg", "alert('Complaint submitted successfully');", true);
                }
                catch (Exception ex)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "err", "alert('Error submitting complaint: " + ex.Message.Replace("'", "\\'") + "');", true);
                }
            }
        }
    }
}
