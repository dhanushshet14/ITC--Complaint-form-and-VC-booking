using ComplaintSystem.Auth;
using ComplaintSystem.Data;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;

namespace ComplaintSystem
{
    public partial class AllComplaints : System.Web.UI.Page
    {
        protected string complaintType = "Technical";

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                // Check if user is authenticated
                AuthorizationHelper.RequireAuthentication();

                // Get complaint type from query string
                string type = Request.QueryString["type"];
                if (!string.IsNullOrEmpty(type))
                {
                    complaintType = type;
                }

                // Handle AJAX requests for getting complaints
                if (Request.QueryString["handler"] == "GetComplaints")
                {
                    HandleGetComplaints();
                    return;
                }
            }
            catch (Exception ex)
            {
                Response.Redirect("Login.aspx");
            }
        }

        private void HandleGetComplaints()
        {
            try
            {
                string empCode = AuthorizationHelper.GetUserEmpCode();
                int roleId = AuthorizationHelper.GetUserRoleId();
                string type = Request.QueryString["type"] ?? "Technical";

                List<ComplaintDto> complaints = GetComplaintsForUser(empCode, roleId, type);

                // Convert to JSON and return
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                string json = serializer.Serialize(complaints);

                Response.ContentType = "application/json";
                Response.Write(json);
                Response.End();
            }
            catch (Exception ex)
            {
                Response.ContentType = "application/json";
                Response.Write("{\"error\":\"" + ex.Message.Replace("\"", "\\\"") + "\"}");
                Response.End();
            }
        }

        private List<ComplaintDto> GetComplaintsForUser(string empCode, int roleId, string complaintType)
        {
            List<ComplaintDto> complaints = new List<ComplaintDto>();

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["ComplaintsFormConnectionString"].ConnectionString))
            {
                try
                {
                    string query = GetComplaintsQueryByType(roleId, complaintType);

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@EmpCode", empCode ?? string.Empty);
                        cmd.Parameters.AddWithValue("@RoleId", roleId);
                        cmd.Parameters.AddWithValue("@Type", complaintType);

                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                complaints.Add(new ComplaintDto
                                {
                                    ComplaintId = reader["ComplaintId"].ToString(),
                                    Title = reader["Title"].ToString(),
                                    Description = reader["Description"].ToString(),
                                    Type = reader["Type"].ToString(),
                                    Status = reader["Status"].ToString(),
                                    Priority = reader["Priority"].ToString(),
                                    AssignedTo = reader["AssignedTo"].ToString(),
                                    CreatedBy = reader["CreatedBy"].ToString(),
                                    CreatedDate = reader["CreatedDate"] != DBNull.Value ? ((DateTime)reader["CreatedDate"]).ToString("yyyy-MM-ddTHH:mm:ss") : "",
                                    Category = reader["Category"] != DBNull.Value ? reader["Category"].ToString() : ""
                                });
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Error getting complaints: {ex.Message}");
                    throw;
                }
            }

            return complaints.OrderByDescending(c => c.CreatedDate).ToList();
        }

        private string GetComplaintsQueryByType(int roleId, string complaintType)
        {
            // Role IDs: 1=Admin, 2=SOC, 3=Engineer, 4=Employee, 5=Guest
            string baseQuery = @"
                SELECT ch.ComplaintId, ch.Title, ch.Description, ch.Type, ch.Status, 
                       ch.Priority, ch.AssignedTo, ch.CreatedBy, ch.CreatedDate, ch.Category
                FROM [ComplaintSystem].[dbo].[Complaint_Header] ch
                WHERE ch.Type = @Type";

            switch (roleId)
            {
                case 1: // Admin - all complaints of this type
                    return baseQuery + " ORDER BY ch.CreatedDate DESC";

                case 2: // SOC - all complaints of this type
                    return baseQuery + " ORDER BY ch.CreatedDate DESC";

                case 3: // Engineer - assigned to them or in their units
                    return baseQuery + @"
                        AND (ch.AssignedTo = @EmpCode 
                        OR ch.UnitId IN (SELECT UnitId FROM dbo.EngineerUnitPermissions WHERE EmpCode = @EmpCode))
                        ORDER BY ch.CreatedDate DESC";

                case 4: // Employee - their own complaints of this type
                case 5: // Guest - their own complaints of this type
                    return baseQuery + @"
                        AND ch.CreatedBy = @EmpCode
                        ORDER BY ch.CreatedDate DESC";

                default:
                    return "SELECT TOP 0 * FROM [ComplaintSystem].[dbo].[Complaint_Header] WHERE 1=0";
            }
        }
    }

    /// <summary>
    /// DTO for complaint data to be serialized to JSON
    /// </summary>
    public class ComplaintDto
    {
        public string ComplaintId { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Type { get; set; }
        public string Status { get; set; }
        public string Priority { get; set; }
        public string AssignedTo { get; set; }
        public string CreatedBy { get; set; }
        public string CreatedDate { get; set; }
        public string Category { get; set; }
    }
}
