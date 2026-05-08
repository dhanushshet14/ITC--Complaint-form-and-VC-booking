using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ComplaintSystem.Data
{
    /// <summary>
    /// Handles complaint data retrieval with role-based filtering
    /// </summary>
    public class ComplaintDataService
    {
        private string _connectionString;

        public ComplaintDataService()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["ComplaintsFormConnectionString"].ConnectionString;
        }

        /// <summary>
        /// Gets complaints based on user role and permissions
        /// For Employee/Guest roles: Only shows complaints created by the user (CreatedBy = empCode)
        /// For Admin/SOC: Shows all complaints
        /// For Engineer: Shows assigned complaints and complaints in their units
        /// </summary>
        public DataSet GetUserComplaints(string empCode, int roleId)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                try
                {
                    // Build query based on role to ensure proper filtering
                    string query = GetComplaintsQuery(roleId) + " ORDER BY ch.CreatedDate DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@EmpCode", empCode ?? string.Empty);
                        cmd.Parameters.AddWithValue("@RoleId", roleId);

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        da.Fill(ds);
                    }

                    conn.Open();
                    conn.Close();
                }
                catch (Exception ex)
                {
                    // Fallback to stored procedure if direct query fails
                    try
                    {
                        using (SqlCommand cmd = new SqlCommand("sp_GetTickets", conn))
                        {
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.Parameters.AddWithValue("@EmpCode", empCode ?? string.Empty);
                            cmd.Parameters.AddWithValue("@RoleId", roleId);

                            SqlDataAdapter da = new SqlDataAdapter(cmd);
                            da.Fill(ds);
                        }
                    }
                    catch
                    {
                        throw new Exception($"Failed to retrieve complaints: {ex.Message}");
                    }
                }
            }

            return ds;
        }

        /// <summary>
        /// Gets completed complaints for user
        /// </summary>
        public DataSet GetCompletedComplaints(string empCode, int roleId)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                try
                {
                    string query = GetComplaintsQuery(roleId) + " AND ch.Status = 'Completed' ORDER BY ch.CreatedDate DESC";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@EmpCode", empCode);
                        cmd.Parameters.AddWithValue("@RoleId", roleId);

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        da.Fill(ds);
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception($"Failed to retrieve completed complaints: {ex.Message}");
                }
            }

            return ds;
        }

        /// <summary>
        /// Gets pending complaints for user
        /// </summary>
        public DataSet GetPendingComplaints(string empCode, int roleId)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                try
                {
                    string query = GetComplaintsQuery(roleId) + " AND ch.Status IN ('New', 'InProgress', 'OnHold') ORDER BY ch.CreatedDate DESC";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@EmpCode", empCode);
                        cmd.Parameters.AddWithValue("@RoleId", roleId);

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        da.Fill(ds);
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception($"Failed to retrieve pending complaints: {ex.Message}");
                }
            }

            return ds;
        }

        /// <summary>
        /// Generates query based on role
        /// </summary>
        private string GetComplaintsQuery(int roleId)
        {
            // Role IDs: 1=Admin, 2=SOC, 3=Engineer, 4=Employee, 5=Guest
            switch (roleId)
            {
                case 1: // Admin - all complaints
                    return "SELECT * FROM dbo.Complaint_Header ch WHERE 1=1";

                case 2: // SOC - all complaints
                    return "SELECT * FROM dbo.Complaint_Header ch WHERE 1=1";

                case 3: // Engineer - assigned to them or in their units
                    return @"SELECT * FROM dbo.Complaint_Header ch 
                             WHERE ch.AssignedTo = @EmpCode 
                             OR ch.UnitId IN (SELECT UnitId FROM dbo.EngineerUnitPermissions WHERE EmpCode = @EmpCode)";

                case 4: // Employee - their own complaints
                case 5: // Guest - their own complaints
                    return "SELECT * FROM dbo.Complaint_Header ch WHERE ch.CreatedBy = @EmpCode";

                default:
                    return "SELECT * FROM dbo.Complaint_Header ch WHERE 1=0"; // No access
            }
        }

        /// <summary>
        /// Gets single complaint with authorization check
        /// </summary>
        public DataSet GetComplaintDetail(string complaintId, string empCode, int roleId)
        {
            DataSet ds = new DataSet();

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                try
                {
                    string query = GetComplaintsQuery(roleId) + " AND ch.ComplaintId = @ComplaintId";
                    
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@EmpCode", empCode);
                        cmd.Parameters.AddWithValue("@RoleId", roleId);
                        cmd.Parameters.AddWithValue("@ComplaintId", complaintId);

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        da.Fill(ds);
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception($"Failed to retrieve complaint detail: {ex.Message}");
                }
            }

            return ds;
        }

        /// <summary>
        /// Verifies user has permission to modify complaint
        /// </summary>
        public bool CanModifyComplaint(string complaintId, string empCode, int roleId, string action)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                try
                {
                    conn.Open();
                    
                    // Get complaint details
                    using (SqlCommand cmd = new SqlCommand(
                        "SELECT CreatedBy, AssignedTo, UnitId FROM dbo.Complaint_Header WHERE ComplaintId = @ComplaintId", conn))
                    {
                        cmd.Parameters.AddWithValue("@ComplaintId", complaintId);
                        
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string createdBy = reader.IsDBNull(0) ? null : reader.GetString(0);
                                string assignedTo = reader.IsDBNull(1) ? null : reader.GetString(1);
                                int unitId = reader.IsDBNull(2) ? 0 : reader.GetInt32(2);

                                // Check permissions based on role and action
                                return CheckActionPermission(roleId, empCode, action, createdBy, assignedTo, unitId);
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception($"Failed to verify permission: {ex.Message}");
                }
            }

            return false;
        }

        /// <summary>
        /// Checks if user can perform specific action
        /// </summary>
        private bool CheckActionPermission(int roleId, string empCode, string action, 
            string createdBy, string assignedTo, int unitId)
        {
            switch (action.ToLower())
            {
                case "view":
                    return roleId == 1 || roleId == 2 || // Admin, SOC
                           (roleId == 3 && (assignedTo == empCode || HasUnitAccess(empCode, unitId))) || // Engineer
                           (roleId >= 4 && createdBy == empCode); // Employee, Guest
                
                case "resolve":
                    return roleId == 1 || // Admin
                           (roleId == 3 && assignedTo == empCode); // Engineer who's assigned
                
                case "assign":
                    return roleId == 1 || roleId == 2; // Admin, SOC
                
                case "transfer":
                    return roleId == 1 || roleId == 2 || // Admin, SOC
                           (roleId == 3 && assignedTo == empCode); // Engineer assigned to it
                
                case "close":
                    return roleId >= 4 && createdBy == empCode; // Employee/Guest who created it
                
                default:
                    return false;
            }
        }

        /// <summary>
        /// Checks if engineer has access to unit
        /// </summary>
        private bool HasUnitAccess(string empCode, int unitId)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                try
                {
                    using (SqlCommand cmd = new SqlCommand(
                        "SELECT COUNT(*) FROM dbo.EngineerUnitPermissions WHERE EmpCode = @EmpCode AND UnitId = @UnitId", conn))
                    {
                        cmd.Parameters.AddWithValue("@EmpCode", empCode);
                        cmd.Parameters.AddWithValue("@UnitId", unitId);
                        
                        conn.Open();
                        int count = (int)cmd.ExecuteScalar();
                        return count > 0;
                    }
                }
                catch
                {
                    return false;
                }
            }
        }
    }
}
