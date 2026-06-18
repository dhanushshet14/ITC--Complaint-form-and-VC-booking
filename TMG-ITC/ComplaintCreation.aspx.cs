using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;
using TMG_ITC.Helpers;

namespace TMG_ITC
{
    public partial class ComplaintCreation : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireAuth();

            if (!IsPostBack)
            {
                LoadComplaintTypes();
                LoadUnits();
                subCategoryRow.Visible = false;
                ShowPriorityOverrideIfAuthorized();
            }
        }

        private void ShowPriorityOverrideIfAuthorized()
        {
            panelPriorityOverride.Visible = AuthHelper.HasAnyRole("Admin", "SOC");
        }

        private void LoadComplaintTypes()
        {
            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            using (var cmd = new SqlCommand("usp_GetComplaintTypes", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                conn.Open();
                ddlType.DataSource = cmd.ExecuteReader();
                ddlType.DataBind();
            }
        }

        private void LoadUnits()
        {
            var user = AuthHelper.GetCurrentUser();

            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            using (var cmd = new SqlCommand("usp_GetUnits", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@EmpCode", user.EmpCode);
                cmd.Parameters.AddWithValue("@Role", user.Role);
                conn.Open();
                ddlUnit.DataSource = cmd.ExecuteReader();
                ddlUnit.DataBind();
            }
        }

        protected void ddlType_SelectedIndexChanged(object sender, EventArgs e)
        {
            var typeId = ddlType.SelectedValue;
            ddlCategory.Items.Clear();
            ddlCategory.Items.Add(new ListItem("-- Select Category --", ""));
            ddlSubCategory.Items.Clear();
            ddlSubCategory.Items.Add(new ListItem("-- Select Category first --", ""));
            txtPriority.Text = "";

            if (string.IsNullOrEmpty(typeId)) return;

            int complaintTypeId = int.Parse(typeId);
            var user = AuthHelper.GetCurrentUser();

            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            using (var cmd = new SqlCommand("usp_GetCategoriesByType", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;

                // Determine RequestType alias from the selected ComplaintType
                cmd.Parameters.AddWithValue("@RequestType",
                    GetRequestTypeAlias(complaintTypeId));

                conn.Open();
                ddlCategory.DataSource = cmd.ExecuteReader();
                ddlCategory.DataBind();
            }

            // Hide subcategory for Service requests
            subCategoryRow.Visible = (GetRequestTypeAlias(complaintTypeId) == "INC");
        }

        protected void ddlCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            ddlSubCategory.Items.Clear();
            ddlSubCategory.Items.Add(new ListItem("-- Select Sub Category --", ""));
            txtPriority.Text = "";

            if (string.IsNullOrEmpty(ddlCategory.SelectedValue)) return;

            int categoryId = int.Parse(ddlCategory.SelectedValue);

            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            using (var cmd = new SqlCommand("usp_GetSubCategoriesByCategory", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@CategoryId", categoryId);
                conn.Open();
                ddlSubCategory.DataSource = cmd.ExecuteReader();
                ddlSubCategory.DataBind();
            }

            SuggestPriority(categoryId, null);
        }

        protected void ddlSubCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlCategory.SelectedValue)) return;

            int categoryId = int.Parse(ddlCategory.SelectedValue);
            int? subCategoryId = null;

            if (!string.IsNullOrEmpty(ddlSubCategory.SelectedValue))
                subCategoryId = int.Parse(ddlSubCategory.SelectedValue);

            SuggestPriority(categoryId, subCategoryId);
        }

        private void SuggestPriority(int categoryId, int? subCategoryId)
        {
            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            using (var cmd = new SqlCommand("usp_GetPriorityByCategory", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@CategoryId", categoryId);
                if (subCategoryId.HasValue)
                    cmd.Parameters.AddWithValue("@SubCategoryId", subCategoryId.Value);
                else
                    cmd.Parameters.AddWithValue("@SubCategoryId", DBNull.Value);

                conn.Open();
                var result = cmd.ExecuteScalar();
                if (result != null)
                    txtPriority.Text = result.ToString();
            }
        }

        private string GetRequestTypeAlias(int complaintTypeId)
        {
            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            using (var cmd = new SqlCommand(
                "SELECT ComplaintTypeAlias FROM ComplaintType_Master WHERE ComplaintTypeId = @Id", conn))
            {
                cmd.Parameters.AddWithValue("@Id", complaintTypeId);
                conn.Open();
                return cmd.ExecuteScalar()?.ToString();
            }
        }

        protected void rdoImpact_CheckedChanged(object sender, EventArgs e)
        {
            customerNameRow.Visible = rdoImpactYes.Checked;
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            var user = AuthHelper.GetCurrentUser();

            string title = txtTitle.Text.Trim();
            string description = txtDescription.Text.Trim();

            if (title.Length < 10)
            {
                ShowError("Subject must be at least 10 characters.");
                return;
            }

            if (description.Length < 20)
            {
                ShowError("Description must be at least 20 characters.");
                return;
            }

            int complaintTypeId = int.Parse(ddlType.SelectedValue);
            int unitId = int.Parse(ddlUnit.SelectedValue);
            int categoryId = int.Parse(ddlCategory.SelectedValue);
            int? subCategoryId = null;
            if (!string.IsNullOrEmpty(ddlSubCategory.SelectedValue))
                subCategoryId = int.Parse(ddlSubCategory.SelectedValue);

            string priority = txtPriority.Text.Trim();
            if (string.IsNullOrEmpty(priority))
            {
                ShowError("Priority could not be determined. Please ensure Category is selected.");
                return;
            }

            // Allow Admin/SOC to override priority
            if (AuthHelper.HasAnyRole("Admin", "SOC"))
            {
                priority = ddlPriorityOverride.SelectedValue;
            }

            int customerImpactFlag = rdoImpactYes.Checked ? 1 : 0;
            string customerName = txtCustomerName.Text.Trim();

            try
            {
                string complaintId;
                DateTime createdDate;

                using (var conn = new SqlConnection(
                    ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
                using (var cmd = new SqlCommand("usp_CreateComplaint", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@CreatedBy", user.EmpCode);
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@Priority", priority);
                    cmd.Parameters.AddWithValue("@ComplaintTypeId", complaintTypeId);
                    cmd.Parameters.AddWithValue("@UnitId", unitId);
                    cmd.Parameters.AddWithValue("@CategoryId", categoryId);
                    cmd.Parameters.AddWithValue("@SubCategoryId", (object)subCategoryId ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Description", description);
                    cmd.Parameters.AddWithValue("@CustomerImpactFlag", customerImpactFlag);
                    cmd.Parameters.AddWithValue("@CustomerName",
                        string.IsNullOrEmpty(customerName) ? DBNull.Value : (object)customerName);

                    conn.Open();

                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            complaintId = reader["ComplaintId"].ToString();
                            createdDate = Convert.ToDateTime(reader["CreatedDate"]);
                        }
                        else
                        {
                            ShowError("Failed to create complaint. Please try again.");
                            return;
                        }
                    }
                }

                // Save attachments
                if (fileUpload.HasFiles)
                {
                    SaveAttachments(complaintId, user.EmpCode);
                }

                // Show success
                panelForm.Visible = false;
                panelSuccess.Visible = true;
                lblComplaintId.InnerText = complaintId;
                lnkViewComplaint.HRef = "~/ComplaintDetail.aspx?id=" + complaintId;
            }
            catch (SqlException ex)
            {
                ShowError(ex.Message.Replace("\n", "<br/>"));
            }
            catch (Exception ex)
            {
                ShowError("An unexpected error occurred. Please try again.");
            }
        }

        private void SaveAttachments(string complaintId, string empCode)
        {
            string uploadDir = Server.MapPath("~/Uploads/" + complaintId);
            Directory.CreateDirectory(uploadDir);

            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            {
                conn.Open();

                foreach (HttpPostedFile file in fileUpload.PostedFiles)
                {
                    if (file == null || file.ContentLength == 0) continue;

                    string originalName = Path.GetFileName(file.FileName);
                    string ext = Path.GetExtension(originalName);
                    string storedName = Guid.NewGuid().ToString("N") + ext;
                    string storedPath = Path.Combine(uploadDir, storedName);

                    file.SaveAs(storedPath);

                    using (var cmd = new SqlCommand(@"
                        INSERT INTO [dbo].[Complaint_Attachments]
                            (ComplaintId, FileName, FilePath, FileSize, MimeType, UserId, UploadedDate)
                        VALUES
                            (@ComplaintId, @FileName, @FilePath, @FileSize, @MimeType, @UserId, GETDATE())", conn))
                    {
                        cmd.Parameters.AddWithValue("@ComplaintId", complaintId);
                        cmd.Parameters.AddWithValue("@FileName", originalName);
                        cmd.Parameters.AddWithValue("@FilePath", "~/Uploads/" + complaintId + "/" + storedName);
                        cmd.Parameters.AddWithValue("@FileSize", file.ContentLength);
                        cmd.Parameters.AddWithValue("@MimeType", file.ContentType);
                        cmd.Parameters.AddWithValue("@UserId", empCode);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
        }

        private void ShowError(string message)
        {
            panelError.Visible = true;
            litError.Text = message;
        }
    }
}
