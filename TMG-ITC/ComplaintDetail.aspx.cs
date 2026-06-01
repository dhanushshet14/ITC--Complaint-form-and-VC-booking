using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using TMG_ITC.Helpers;

namespace TMG_ITC
{
    public partial class ComplaintDetail : System.Web.UI.Page
    {
        public string CurrentPriority { get; private set; }
        public string CurrentStatus { get; private set; }
        public string SlaClass { get; private set; }
        private bool _hasAccepted;

        private string ComplaintId { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireAuth();

            ComplaintId = Request.QueryString["id"];
            if (string.IsNullOrEmpty(ComplaintId))
            {
                ShowError("Complaint ID is required.");
                return;
            }

            if (!IsPostBack)
            {
                LoadComplaintDetail();
            }
        }

        private void LoadComplaintDetail()
        {
            var user = AuthHelper.GetCurrentUser();

            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            using (var cmd = new SqlCommand("usp_GetComplaintDetail", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@ComplaintId", ComplaintId);
                cmd.Parameters.AddWithValue("@EmpCode", user.EmpCode);

                conn.Open();

                using (var reader = cmd.ExecuteReader())
                {
                    // Result set 1: Complaint header
                    if (!reader.Read())
                    {
                        ShowError("Complaint not found.");
                        return;
                    }

                    panelDetail.Visible = true;

                    string title = reader["Title"]?.ToString();
                    string description = reader["Description"]?.ToString();
                    CurrentPriority = reader["Priority"]?.ToString();
                    CurrentStatus = reader["Status"]?.ToString();
                    string requestType = reader["RequestType"]?.ToString();
                    string complaintTypeName = reader["ComplaintTypeName"]?.ToString();
                    string unitName = reader["UnitName"]?.ToString();
                    string categoryName = reader["CategoryName"]?.ToString();
                    string subCategoryName = reader["SubCategoryName"]?.ToString();
                    string createdByName = reader["CreatedByName"]?.ToString();
                    string createdByRole = reader["CreatedByRole"]?.ToString();
                    string assignedToName = reader["AssignedToName"]?.ToString();
                    string customerName = reader["CustomerName"]?.ToString();
                    int customerImpactFlag = Convert.ToInt32(reader["CustomerImpactFlag"]);
                    DateTime createdDate = Convert.ToDateTime(reader["CreatedDate"]);
                    DateTime lastUpdate = Convert.ToDateTime(reader["LastUpdate"]);

                    lblComplaintId.InnerText = ComplaintId;
                    lblTitle.InnerText = title;
                    litPriority.Text = CurrentPriority;
                    litStatus.Text = CurrentStatus;
                    lblRequestType.InnerText = requestType;
                    lblComplaintType.InnerText = complaintTypeName;
                    lblUnit.InnerText = unitName;
                    lblCategory.InnerText = categoryName;
                    lblCreatedBy.InnerText = $"{createdByName} ({createdByRole})";
                    lblAssignedTo.InnerText = string.IsNullOrEmpty(assignedToName) ? "—" : assignedToName;
                    lblCreatedDate.InnerText = createdDate.ToString("dd MMM yyyy hh:mm tt");
                    lblLastUpdate.InnerText = lastUpdate.ToString("dd MMM yyyy hh:mm tt");
                    lblDescription.InnerText = description;

                    if (!string.IsNullOrEmpty(subCategoryName))
                    {
                        rowSubCategory.Visible = true;
                        lblSubCategory.InnerText = subCategoryName;
                    }

                    if (customerImpactFlag == 1)
                    {
                        panelCustomerImpact.Visible = true;
                        lblCustomerName.InnerText = string.IsNullOrEmpty(customerName) ? "" : "— " + customerName;
                    }

                    // SLA
                    ComputeSla(CurrentPriority, createdDate);

                    // Result set 2: Timeline (read before stepper to detect acceptance)
                    reader.NextResult();
                    _hasAccepted = false;
                    BuildTimeline(reader);

                    // Stepper (after timeline to know if accepted)
                    BuildStepper(CurrentStatus, _hasAccepted);

                    // Result set 3: Attachments
                    reader.NextResult();
                    BuildAttachments(reader);

                    // Hold banner
                    if (CurrentStatus == "Hold")
                    {
                        panelHoldBanner.Visible = true;
                        lblHoldReason.InnerText = reader["HoldReason"]?.ToString() ?? "";
                    }

                    // Action buttons
                    SetupActionButtons(CurrentStatus, assignedToName, user);
                }
            }
        }

        private void ComputeSla(string priority, DateTime createdDate)
        {
            int slaHours = priority switch
            {
                "Critical" => 4,
                "High" => 8,
                "Medium" => 24,
                "Low" => 48,
                _ => 24
            };

            double elapsedHours = (DateTime.Now - createdDate).TotalHours;
            double percentage = Math.Min(elapsedHours / slaHours * 100, 100);
            bool breached = elapsedHours >= slaHours;

            if (breached)
            {
                SlaClass = "text-danger";
                lblSlaText.InnerText = "SLA Breached";
            }
            else if (percentage >= 75)
            {
                SlaClass = "text-warning";
                lblSlaText.InnerText = $"{(slaHours - elapsedHours):F1}h remaining";
            }
            else
            {
                SlaClass = "text-success";
                lblSlaText.InnerText = $"{(slaHours - elapsedHours):F1}h remaining";
            }

            lblSlaCreated.InnerText = $"Created {createdDate:dd MMM yyyy hh:mm tt} • SLA {slaHours}h";

            string barClass = breached ? "bg-danger" : percentage >= 75 ? "bg-warning" : "bg-success";
            slaProgress.Attributes["class"] = $"progress-bar {barClass}";
            slaProgress.Style["width"] = $"{Math.Min(percentage, 100):F0}%";
            slaProgress.Attributes["aria-valuenow"] = $"{(int)Math.Min(percentage, 100)}";
        }

        private void BuildStepper(string status, bool hasAccepted = false)
        {
            int currentStep = status switch
            {
                "New" => 0,
                "Assigned" => hasAccepted ? 2 : 1,
                "Accepted" => 2,
                "In Progress" => 3,
                "Resolved" => 4,
                "Closed" => 5,
                "Reopened" => 0,
                "Hold" => 3,
                _ => 0
            };

            var steps = new[] { stepNew, stepAssigned, stepAccepted, stepInProgress, stepResolved, stepClosed };
            var conns = new[] { conn1, conn2, conn2b, conn3, conn4 };

            for (int i = 0; i < steps.Length; i++)
            {
                if (i < currentStep)
                    steps[i].Attributes["class"] = "step completed";
                else if (i == currentStep)
                    steps[i].Attributes["class"] = "step active";
                else
                    steps[i].Attributes["class"] = "step";
            }

            for (int i = 0; i < conns.Length; i++)
            {
                if (i < currentStep)
                    conns[i].Attributes["class"] = "step-connector completed";
                else if (i == currentStep)
                    conns[i].Attributes["class"] = "step-connector active";
                else
                    conns[i].Attributes["class"] = "step-connector";
            }
        }

        private void BuildTimeline(SqlDataReader reader)
        {
            bool hasRows = false;

            while (reader.Read())
            {
                hasRows = true;
                string updateType = reader["UpdateType"]?.ToString();
                string updateByName = reader["UpdateByName"]?.ToString();
                string updateByRole = reader["UpdateByRole"]?.ToString();
                DateTime updateDate = Convert.ToDateTime(reader["UpdateDate"]);
                string description = reader["Description"]?.ToString();
                string assignType = reader["AssignType"]?.ToString();
                string assignedTo = reader["AssignedTo"]?.ToString();

                // Override updateType for Hold/Resume/Accept updates for distinct styling
                if (updateType == "Update")
                {
                    if (description == "Accepted") { updateType = "Accept"; _hasAccepted = true; }
                    else if (description?.StartsWith("Hold:") == true) updateType = "Hold";
                    else if (description?.StartsWith("Resumed") == true) updateType = "Resume";
                }

                string icon = updateType switch
                {
                    "New" => "bi-plus-circle",
                    "Assign" => "bi-person-check",
                    "Accept" => "bi-hand-thumbs-up",
                    "Resolve" => "bi-check-circle",
                    "Close" => "bi-x-circle",
                    "Reopen" => "bi-arrow-counterclockwise",
                    "Hold" => "bi-pause-circle",
                    "Resume" => "bi-play-circle",
                    "Update" => "bi-chat-dots",
                    _ => "bi-record-circle"
                };

                string descriptionHtml = HttpUtility.HtmlEncode(description).Replace("\n", "<br/>");
                string assignInfo = "";
                if (!string.IsNullOrEmpty(assignType))
                    assignInfo = $" <span class=\"badge bg-light text-dark\">{assignType}</span>";
                if (!string.IsNullOrEmpty(assignedTo))
                    assignInfo += $" → <strong>{HttpUtility.HtmlEncode(assignedTo)}</strong>";

                var div = new Literal();
                div.Text = $@"
                    <div class=""timeline-item"">
                        <div class=""timeline-icon {updateType}""><i class=""bi {icon}""></i></div>
                        <div class=""ms-3"">
                            <div class=""d-flex justify-content-between align-items-start"">
                                <strong>{HttpUtility.HtmlEncode(updateByName)}</strong>
                                <small class=""text-muted"">{updateDate:dd MMM yyyy hh:mm tt}</small>
                            </div>
                            <small class=""text-muted"">{HttpUtility.HtmlEncode(updateByRole)}{assignInfo}</small>
                            <p class=""mb-0 mt-1"">{descriptionHtml}</p>
                        </div>
                    </div>";

                timeline.Controls.Add(div);
            }

            if (!hasRows)
                panelNoUpdates.Visible = true;
        }

        private void BuildAttachments(SqlDataReader reader)
        {
            bool hasRows = false;

            while (reader.Read())
            {
                hasRows = true;
                string fileName = reader["FileName"]?.ToString();
                string filePath = reader["FilePath"]?.ToString();
                long fileSize = reader["FileSize"] != DBNull.Value ? Convert.ToInt64(reader["FileSize"]) : 0;
                string uploadedByName = reader["UploadedByName"]?.ToString();
                DateTime uploadedDate = Convert.ToDateTime(reader["UploadedDate"]);

                string icon = "bi-file-earmark";
                string ext = (System.IO.Path.GetExtension(fileName) ?? "").ToLower();
                if (new[] { ".jpg", ".jpeg", ".png", ".gif" }.Contains(ext))
                    icon = "bi-file-earmark-image";
                else if (ext == ".pdf")
                    icon = "bi-file-earmark-pdf";
                else if (new[] { ".doc", ".docx" }.Contains(ext))
                    icon = "bi-file-earmark-word";
                else if (new[] { ".xls", ".xlsx" }.Contains(ext))
                    icon = "bi-file-earmark-excel";

                string sizeStr = fileSize > 1024 * 1024
                    ? $"{fileSize / (1024.0 * 1024.0):F1} MB"
                    : $"{fileSize / 1024.0:F0} KB";

                bool isImage = new[] { ".jpg", ".jpeg", ".png", ".gif" }.Contains(ext);
                string fileUrl = ResolveUrl(filePath ?? "~/Uploads/" + ComplaintId + "/" + fileName);

                var div = new Literal();
                div.Text = $@"
                    <div class=""col-md-4 col-lg-3"">
                        <div class=""card border"">
                            {(isImage ? $"<img src=\"{fileUrl}\" class=\"card-img-top\" style=\"height:120px;object-fit:cover;\" alt=\"{HttpUtility.HtmlEncode(fileName)}\" />" : "")}
                            <div class=""card-body p-2"">
                                <div class=""d-flex align-items-center gap-2"">
                                    <i class=""bi {icon} fs-4 text-muted""></i>
                                    <div class=""text-truncate"">
                                        <a href=""{fileUrl}"" target=""_blank"" class=""text-decoration-none small fw-semibold"" download>
                                            {HttpUtility.HtmlEncode(fileName)}
                                        </a>
                                        <small class=""text-muted d-block"">{sizeStr}</small>
                                    </div>
                                </div>
                                <small class=""text-muted d-block mt-1"">{HttpUtility.HtmlEncode(uploadedByName)} • {uploadedDate:dd MMM yyyy}</small>
                            </div>
                        </div>
                    </div>";

                attachmentsContainer.Controls.Add(div);
            }

            if (!hasRows)
                panelNoAttachments.Visible = true;
        }

        private void SetupActionButtons(string status, string assignedToName, UserSessionData user)
        {
            btnAssign.Visible = AuthHelper.CanPerformAction("Assign", status);
            btnAccept.Visible = AuthHelper.CanPerformAction("Accept", status)
                && string.Equals(user.EmpCode, GetAssignedTo(), StringComparison.OrdinalIgnoreCase);
            btnMarkInProgress.Visible = AuthHelper.CanPerformAction("MarkInProgress", status)
                && string.Equals(user.EmpCode, GetAssignedTo(), StringComparison.OrdinalIgnoreCase);
            btnTransfer.Visible = AuthHelper.CanPerformAction("Transfer", status);
            btnResolve.Visible = AuthHelper.CanPerformAction("Resolve", status)
                && string.Equals(user.EmpCode, GetAssignedTo(), StringComparison.OrdinalIgnoreCase);
            btnClose.Visible = AuthHelper.CanPerformAction("Close", status);
            btnReopen.Visible = AuthHelper.CanPerformAction("Reopen", status);
            btnHold.Visible = AuthHelper.CanPerformAction("Hold", status);
            btnResume.Visible = AuthHelper.CanPerformAction("Resume", status);
            btnAddNote.Visible = true;
        }

        private string GetAssignedTo()
        {
            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            using (var cmd = new SqlCommand(
                "SELECT AssignedTo FROM Complaint_Header WHERE ComplaintId = @Id", conn))
            {
                cmd.Parameters.AddWithValue("@Id", ComplaintId);
                conn.Open();
                return cmd.ExecuteScalar()?.ToString();
            }
        }

        private void ShowModal(string modalId)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showModal",
                $"$(document).ready(function() {{ $('#{modalId}').modal('show'); }});", true);
        }

        // Assign
        protected void btnAssign_Click(object sender, EventArgs e)
        {
            LoadEngineers(ddlAssignEngineer);
            ShowModal("assignModal");
        }

        protected void btnConfirmAssign_Click(object sender, EventArgs e)
        {
            string engineer = ddlAssignEngineer.SelectedValue;
            if (string.IsNullOrEmpty(engineer))
            {
                ShowModal("assignModal");
                return;
            }

            ExecuteAction("usp_AssignComplaint", cmd =>
            {
                cmd.Parameters.AddWithValue("@AssignedTo", engineer);
                cmd.Parameters.AddWithValue("@AssignType", "ASSIGN");
                cmd.Parameters.AddWithValue("@Note", (object)txtAssignNote.Text.Trim() ?? DBNull.Value);
            });
            txtAssignNote.Text = "";
        }

        // Accept
        protected void btnAccept_Click(object sender, EventArgs e)
        {
            ExecuteAction("usp_AcceptComplaint", cmd => { });
        }

        // Mark In Progress
        protected void btnMarkInProgress_Click(object sender, EventArgs e)
        {
            ExecuteAction("usp_MarkInProgress", cmd => { });
        }

        // Transfer
        protected void btnTransfer_Click(object sender, EventArgs e)
        {
            LoadEngineers(ddlTransferEngineer);
            ShowModal("transferModal");
        }

        protected void btnConfirmTransfer_Click(object sender, EventArgs e)
        {
            string engineer = ddlTransferEngineer.SelectedValue;
            string reason = txtTransferReason.Text.Trim();

            if (string.IsNullOrEmpty(engineer) || string.IsNullOrEmpty(reason))
            {
                ShowModal("transferModal");
                return;
            }

            ExecuteAction("usp_TransferComplaint", cmd =>
            {
                cmd.Parameters.AddWithValue("@TransferTo", engineer);
                cmd.Parameters.AddWithValue("@Reason", reason);
            });
            txtTransferReason.Text = "";
        }

        // Resolve
        protected void btnResolve_Click(object sender, EventArgs e)
        {
            ShowModal("resolveModal");
        }

        protected void btnConfirmResolve_Click(object sender, EventArgs e)
        {
            string summary = txtResolveSummary.Text.Trim();
            if (summary.Length < 20)
            {
                ShowModal("resolveModal");
                return;
            }

            ExecuteAction("usp_ResolveComplaint", cmd =>
            {
                cmd.Parameters.AddWithValue("@ResolutionSummary", summary);
            });
            txtResolveSummary.Text = "";
        }

        // Close
        protected void btnClose_Click(object sender, EventArgs e)
        {
            ShowModal("closeModal");
        }

        protected void btnConfirmClose_Click(object sender, EventArgs e)
        {
            string reason = txtCloseReason.Text.Trim();
            if (string.IsNullOrEmpty(reason))
            {
                ShowModal("closeModal");
                return;
            }

            ExecuteAction("usp_CloseComplaint", cmd =>
            {
                cmd.Parameters.AddWithValue("@Reason", reason);
            });
            txtCloseReason.Text = "";
        }

        // Reopen
        protected void btnReopen_Click(object sender, EventArgs e)
        {
            ShowModal("reopenModal");
        }

        protected void btnConfirmReopen_Click(object sender, EventArgs e)
        {
            string reason = txtReopenReason.Text.Trim();
            if (string.IsNullOrEmpty(reason))
            {
                ShowModal("reopenModal");
                return;
            }

            ExecuteAction("usp_ReopenComplaint", cmd =>
            {
                cmd.Parameters.AddWithValue("@Reason", reason);
            });
            txtReopenReason.Text = "";
        }

        // Hold
        protected void btnHold_Click(object sender, EventArgs e)
        {
            ShowModal("holdModal");
        }

        protected void btnConfirmHold_Click(object sender, EventArgs e)
        {
            string reason = txtHoldReason.Text.Trim();
            if (string.IsNullOrEmpty(reason))
            {
                ShowModal("holdModal");
                return;
            }

            ExecuteAction("usp_HoldComplaint", cmd =>
            {
                cmd.Parameters.AddWithValue("@HoldReason", reason);
            });
            txtHoldReason.Text = "";
        }

        // Resume
        protected void btnResume_Click(object sender, EventArgs e)
        {
            ShowModal("resumeModal");
        }

        protected void btnConfirmResume_Click(object sender, EventArgs e)
        {
            ExecuteAction("usp_ResumeComplaint", cmd =>
            {
                cmd.Parameters.AddWithValue("@ResumeNotes", (object)txtResumeNotes.Text.Trim() ?? DBNull.Value);
            });
            txtResumeNotes.Text = "";
        }

        // Work Note
        protected void btnAddNote_Click(object sender, EventArgs e)
        {
            ShowModal("noteModal");
        }

        protected void btnConfirmNote_Click(object sender, EventArgs e)
        {
            string note = txtNote.Text.Trim();
            if (string.IsNullOrEmpty(note))
            {
                ShowModal("noteModal");
                return;
            }

            ExecuteAction("usp_AddWorkNote", cmd =>
            {
                cmd.Parameters.AddWithValue("@NoteText", note);
            });
            txtNote.Text = "";
        }

        private void LoadEngineers(DropDownList ddl)
        {
            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            using (var cmd = new SqlCommand("usp_GetEngineers", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                conn.Open();
                ddl.Items.Clear();
                ddl.Items.Add(new ListItem("-- Select Engineer --", ""));
                ddl.DataSource = cmd.ExecuteReader();
                ddl.DataBind();
            }
        }

        private void ExecuteAction(string spName, Action<SqlCommand> addParams)
        {
            var user = AuthHelper.GetCurrentUser();

            try
            {
                string assignedEngineer = null;

                using (var conn = new SqlConnection(
                    ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
                using (var cmd = new SqlCommand(spName, conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@ComplaintId", ComplaintId);

                    if (spName == "usp_AcceptComplaint")
                        cmd.Parameters.AddWithValue("@AcceptedBy", user.EmpCode);
                    if (spName == "usp_MarkInProgress")
                        cmd.Parameters.AddWithValue("@UpdatedBy", user.EmpCode);
                    if (spName == "usp_ResolveComplaint")
                        cmd.Parameters.AddWithValue("@ResolvedBy", user.EmpCode);
                    if (spName == "usp_CloseComplaint")
                        cmd.Parameters.AddWithValue("@ClosedBy", user.EmpCode);
                    if (spName == "usp_ReopenComplaint")
                        cmd.Parameters.AddWithValue("@ReopenedBy", user.EmpCode);
                    if (spName == "usp_AddWorkNote")
                        cmd.Parameters.AddWithValue("@AddedBy", user.EmpCode);
                    if (spName == "usp_HoldComplaint")
                        cmd.Parameters.AddWithValue("@HeldBy", user.EmpCode);
                    if (spName == "usp_ResumeComplaint")
                        cmd.Parameters.AddWithValue("@ResumedBy", user.EmpCode);
                    if (spName == "usp_AssignComplaint")
                        cmd.Parameters.AddWithValue("@AssignedBy", user.EmpCode);
                    if (spName == "usp_TransferComplaint")
                        cmd.Parameters.AddWithValue("@TransferBy", user.EmpCode);

                    addParams(cmd);

                    if (spName == "usp_AssignComplaint")
                        assignedEngineer = cmd.Parameters["@AssignedTo"]?.Value?.ToString();

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                // Send notifications
                string title = GetComplaintTitle();
                if (spName == "usp_AssignComplaint" && !string.IsNullOrEmpty(assignedEngineer))
                {
                    NotificationHelper.QueueNotification(ComplaintId, assignedEngineer,
                        "Complaint Assigned: " + ComplaintId,
                        $"Complaint <b>{ComplaintId}</b> has been assigned to you.<br/>Title: {title}<br/><a href='ComplaintDetail.aspx?id={ComplaintId}'>View Details</a>");
                }
                if (spName == "usp_ResolveComplaint")
                {
                    string creator = GetComplaintCreator();
                    if (!string.IsNullOrEmpty(creator))
                        NotificationHelper.QueueNotification(ComplaintId, creator,
                            "Complaint Resolved: " + ComplaintId,
                            $"Complaint <b>{ComplaintId}</b> has been resolved.<br/>Title: {title}<br/><a href='ComplaintDetail.aspx?id={ComplaintId}'>View Details</a>");
                }
                if (spName == "usp_CloseComplaint")
                {
                    string creator = GetComplaintCreator();
                    if (!string.IsNullOrEmpty(creator))
                        NotificationHelper.QueueNotification(ComplaintId, creator,
                            "Complaint Closed: " + ComplaintId,
                            $"Complaint <b>{ComplaintId}</b> has been closed.<br/>Title: {title}<br/><a href='ComplaintDetail.aspx?id={ComplaintId}'>View Details</a>");
                }

                Response.Redirect(Request.RawUrl);
            }
            catch (SqlException ex)
            {
                ShowError(ex.Message.Replace("\n", "<br/>"));
            }
            catch (Exception)
            {
                ShowError("An unexpected error occurred.");
            }
        }

        private string GetComplaintTitle()
        {
            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            using (var cmd = new SqlCommand(
                "SELECT Title FROM Complaint_Header WHERE ComplaintId = @Id", conn))
            {
                cmd.Parameters.AddWithValue("@Id", ComplaintId);
                conn.Open();
                return cmd.ExecuteScalar()?.ToString() ?? "";
            }
        }

        private string GetComplaintCreator()
        {
            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            using (var cmd = new SqlCommand(
                "SELECT CreatedBy FROM Complaint_Header WHERE ComplaintId = @Id", conn))
            {
                cmd.Parameters.AddWithValue("@Id", ComplaintId);
                conn.Open();
                return cmd.ExecuteScalar()?.ToString();
            }
        }

        private void ShowError(string message)
        {
            panelDetail.Visible = false;
            panelError.Visible = true;
            litError.Text = message;
        }
    }
}
