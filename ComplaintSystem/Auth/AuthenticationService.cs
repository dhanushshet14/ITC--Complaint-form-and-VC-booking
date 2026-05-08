using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace ComplaintSystem.Auth
{
    /// <summary>
    /// Handles authentication and role-based access control
    /// </summary>
    public class AuthenticationService
    {
        private string _connectionString;

        public AuthenticationService()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["ComplaintsFormConnectionString"].ConnectionString;
        }

        /// <summary>
        /// Validates user login and retrieves role/employee code
        /// Uses SP_verifyLogin for credential verification and sp_ValidateLoginUser for role determination
        /// CRITICAL: If SP_verifyLogin doesn't exist, login fails immediately
        /// </summary>
        /// 


        //public LoginResult ValidateLogin(string empCode, string password)
        //{
        //    var result = new LoginResult { IsValid = false };

        //    // SECURITY: Validate input parameters
        //    if (string.IsNullOrWhiteSpace(empCode) || string.IsNullOrWhiteSpace(password))
        //    {
        //        result.ErrorMessage = "Username and password are required";
        //        return result;
        //    }

        //    using (SqlConnection conn = new SqlConnection(_connectionString))
        //    {
        //        try
        //        {
        //            conn.Open();

        //            // CRITICAL SECURITY: Verify credentials using SP_verifyLogin
        //            // This SP MUST exist and return valid data for login to proceed
        //            using (SqlCommand cmd = new SqlCommand("SP_verifyLogin", conn))
        //            {
        //                cmd.CommandType = CommandType.StoredProcedure;
        //                cmd.CommandTimeout = 10;
        //                cmd.Parameters.AddWithValue("@Username", empCode);
        //                cmd.Parameters.AddWithValue("@Password", password);

        //                DataSet ds = new DataSet();
        //                SqlDataAdapter da = new SqlDataAdapter(cmd);

        //                try
        //                {
        //                    da.Fill(ds);
        //                }
        //                catch (SqlException spEx)
        //                {
        //                    // SP_verifyLogin doesn't exist - CRITICAL SECURITY ISSUE
        //                    result.ErrorMessage = "CRITICAL: Authentication system not configured. Please contact administrator.";
        //                    System.Diagnostics.EventLog.WriteEntry("Application",
        //                        $"SECURITY ALERT: SP_verifyLogin missing or failed for user '{empCode}': {spEx.Message}",
        //                        System.Diagnostics.EventLogEntryType.Error);
        //                    return result;
        //                }

        //                // SECURITY: Verify we got data back
        //                if (ds == null || ds.Tables.Count == 0 || ds.Tables[0].Rows.Count == 0)
        //                {
        //                    // Invalid credentials - no data returned
        //                    result.ErrorMessage = "Invalid username or password";
        //                    return result;
        //                }

        //                // SECURITY: Extract and validate user data
        //                try
        //                {
        //                    int userId = Convert.ToInt32(ds.Tables[0].Rows[0]["ID"]);
        //                    string status = ds.Tables[0].Rows[0]["Status"].ToString();

        //                    if (userId <= 0)
        //                    {
        //                        // Invalid user ID
        //                        result.ErrorMessage = "Invalid username or password";
        //                        return result;
        //                    }

        //                    if (status != "Active")
        //                    {
        //                        // User is not active
        //                        result.ErrorMessage = $"User account is {status}. Please contact administrator.";
        //                        return result;
        //                    }

        //                    // Credentials valid, set result
        //                    result.UserId = userId;
        //                    result.EmpCode = empCode;
        //                    result.IsValid = true;
        //                }
        //                catch (Exception dataEx)
        //                {
        //                    result.ErrorMessage = "Error validating credentials";
        //                    System.Diagnostics.EventLog.WriteEntry("Application",
        //                        $"SECURITY ERROR: Failed to parse SP_verifyLogin response for user '{empCode}': {dataEx.Message}",
        //                        System.Diagnostics.EventLogEntryType.Error);
        //                    return result;
        //                }
        //            }

        //            // SECURITY: Only get role details if credentials validated successfully
        //            if (result.IsValid)
        //            {
        //                GetUserRoleAndDetails(empCode, result);
        //            }
        //        }
        //        catch (Exception ex)
        //        {
        //            result.IsValid = false;
        //            result.ErrorMessage = "Login validation failed: " + ex.Message;
        //            System.Diagnostics.EventLog.WriteEntry("Application",
        //                $"SECURITY ERROR: Login validation failed for user '{empCode}': {ex.Message}",
        //                System.Diagnostics.EventLogEntryType.Error);
        //        }
        //    }

        //    return result;
        //}

        public LoginResult ValidateLogin(string empCode, string password)
        {
            var result = new LoginResult { IsValid = false };

            if (string.IsNullOrWhiteSpace(empCode) || string.IsNullOrWhiteSpace(password))
            {
                result.ErrorMessage = "Username and password are required";
                return result;
            }

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                try
                {
                    conn.Open();

                    using (SqlCommand cmd = new SqlCommand("SP_verifyLogin", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandTimeout = 10;
                        cmd.Parameters.AddWithValue("@EmpCode", empCode);
                        cmd.Parameters.AddWithValue("@Password", password);

                        // Since SP returns 1 if valid, null otherwise
                        object scalar = cmd.ExecuteScalar();

                        if (scalar == null)
                        {
                            result.ErrorMessage = "Invalid username or password";
                            return result;
                        }

                        // Credentials valid
                        result.IsValid = true;
                        result.EmpCode = empCode;

                        // Optionally fetch user role/details
                        GetUserRoleAndDetails(empCode, result);
                    }
                }
                catch (Exception ex)
                {
                    result.IsValid = false;
                    result.ErrorMessage = "Login validation failed: " + ex.Message;
                    System.Diagnostics.EventLog.WriteEntry("Application",
                        $"SECURITY ERROR: Login validation failed for user '{empCode}': {ex.Message}",
                        System.Diagnostics.EventLogEntryType.Error);
                }
            }

            return result;
        }


        /// <summary>
        /// Retrieves user role and role ID directly from sp_ValidateLoginUser
        /// The SP validates user existence and category (admin/employee/guest)
        /// SECURITY: If sp_ValidateLoginUser fails, login is rejected
        /// </summary>
        private void GetUserRoleAndDetails(string empCode, LoginResult result)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                try
                {
                    if (conn.State != ConnectionState.Open)
                    {
                        conn.Open();
                    }

                    // Call sp_ValidateLoginUser to determine user type and role ID
                    using (SqlCommand cmd = new SqlCommand("sp_ValidateLoginUser", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandTimeout = 10;
                        cmd.Parameters.AddWithValue("@EmpCode", empCode ?? string.Empty);

                        // Output parameters
                        SqlParameter loginUserTypeParam = new SqlParameter("@LoginUserType", SqlDbType.VarChar, 50);
                        loginUserTypeParam.Direction = ParameterDirection.Output;
                        cmd.Parameters.Add(loginUserTypeParam);

                        SqlParameter roleIdParam = new SqlParameter("@RoleId", SqlDbType.Int);
                        roleIdParam.Direction = ParameterDirection.Output;
                        cmd.Parameters.Add(roleIdParam);

                        try
                        {
                            cmd.ExecuteNonQuery();
                        }
                        catch (SqlException spEx)
                        {
                            // CRITICAL: sp_ValidateLoginUser doesn't exist
                            result.IsValid = false;
                            result.ErrorMessage = "CRITICAL: Role validation system not configured.";
                            System.Diagnostics.EventLog.WriteEntry("Application", 
                                $"SECURITY ALERT: sp_ValidateLoginUser missing for user '{empCode}': {spEx.Message}", 
                                System.Diagnostics.EventLogEntryType.Error);
                            return;
                        }

                        // Process output parameters
                        string loginUserType = loginUserTypeParam.Value != DBNull.Value 
                            ? loginUserTypeParam.Value.ToString() 
                            : null;

                        // SECURITY: Validate that we got a role back
                        if (string.IsNullOrEmpty(loginUserType))
                        {
                            // User not found in role validation system
                            result.IsValid = false;
                            result.ErrorMessage = "User not found or does not have assigned role";
                            System.Diagnostics.EventLog.WriteEntry("Application", 
                                $"SECURITY WARNING: User '{empCode}' passed credential check but failed role validation", 
                                System.Diagnostics.EventLogEntryType.Warning);
                            return;
                        }

                        // Map login user type to friendly role name
                        result.Role = ConvertLoginUserTypeToRoleName(loginUserType);

                        // Get RoleId from output parameter or lookup by role name
                        if (roleIdParam.Value != DBNull.Value && (int)roleIdParam.Value > 0)
                        {
                            result.RoleId = Convert.ToInt32(roleIdParam.Value);
                        }
                        else
                        {
                            result.RoleId = MapRoleNameToId(result.Role);
                        }

                        // SECURITY: Validate role ID is valid
                        if (result.RoleId <= 0)
                        {
                            result.IsValid = false;
                            result.ErrorMessage = "Invalid role assignment";
                            System.Diagnostics.EventLog.WriteEntry("Application", 
                                $"SECURITY ERROR: Invalid RoleId for user '{empCode}': {result.RoleId}", 
                                System.Diagnostics.EventLogEntryType.Error);
                            return;
                        }

                        // Login successful
                        result.IsValid = true;
                    }
                }
                catch (Exception ex)
                {
                    // CRITICAL: Fail login on ANY error
                    result.IsValid = false;
                    result.ErrorMessage = "Role validation failed: " + ex.Message;
                    System.Diagnostics.EventLog.WriteEntry("Application", 
                        $"SECURITY ERROR: Role validation exception for user '{empCode}': {ex.Message}", 
                        System.Diagnostics.EventLogEntryType.Error);
                }
            }
        }

        /// <summary>
        /// Attempts to get role from sp_ValidateLoginUser stored procedure
        /// </summary>
        private bool TryGetRoleFromStoredProcedure(SqlConnection conn, string empCode, LoginResult result)
        {
            try
            {
                using (SqlCommand cmd = new SqlCommand("sp_ValidateLoginUser", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandTimeout = 5;
                    cmd.Parameters.AddWithValue("@EmpCode", empCode);

                    SqlParameter roleParam = new SqlParameter("@LoginUserType", SqlDbType.VarChar, 50);
                    roleParam.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(roleParam);

                    SqlParameter roleIdParam = new SqlParameter("@RoleId", SqlDbType.Int);
                    roleIdParam.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(roleIdParam);

                    cmd.ExecuteNonQuery();

                    if (roleParam.Value != DBNull.Value && !string.IsNullOrEmpty(roleParam.Value.ToString()))
                    {
                        result.Role = roleParam.Value.ToString();
                        if (roleIdParam.Value != DBNull.Value)
                        {
                            result.RoleId = Convert.ToInt32(roleIdParam.Value);
                        }
                        else
                        {
                            result.RoleId = GetRoleIdByName(conn, result.Role);
                        }
                        return result.RoleId > 0;
                    }
                    return false;
                }
            }
            catch
            {
                // SP doesn't exist or failed, will try other strategies
                return false;
            }
        }

        /// <summary>
        /// Converts login user type from SP (admin/employee/guest) to role name
        /// </summary>
        private string ConvertLoginUserTypeToRoleName(string loginUserType)
        {
            if (string.IsNullOrEmpty(loginUserType))
                return "Employee";

            string normalized = loginUserType.ToLower().Trim();

            if (normalized == "admin")
                return "Admin";
            else if (normalized == "employee")
                return "Employee";
            else if (normalized == "guest")
                return "Guest";
            else
                return "Employee";
        }

        /// <summary>
        /// Gets Role ID from role name by looking up Roles table
        /// </summary>
        private int GetRoleIdByName(SqlConnection conn, string roleName)
        {
            try
            {
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT TOP 1 RoleId FROM dbo.Roles WHERE RoleName=@RoleName OR RoleName=@NormalizedName", conn))
                {
                    string normalized = NormalizeRoleName(roleName);
                    cmd.Parameters.AddWithValue("@RoleName", roleName);
                    cmd.Parameters.AddWithValue("@NormalizedName", normalized);
                    object result = cmd.ExecuteScalar();
                    return result != null ? Convert.ToInt32(result) : 0;
                }
            }
            catch
            {
                // Map by name if Roles table doesn't exist
                return MapRoleNameToId(roleName);
            }
        }

        /// <summary>
        /// Maps role name to ID (fallback if Roles table doesn't exist)
        /// </summary>
        private int MapRoleNameToId(string roleName)
        {
            string normalized = NormalizeRoleName(roleName);
            if (normalized == "admin") return 1;
            else if (normalized == "soc") return 2;
            else if (normalized == "engineer") return 3;
            else if (normalized == "employee") return 4;
            else if (normalized == "guest") return 5;
            else return 4; // Default to Employee
        }

        /// <summary>
        /// Normalizes role name to lowercase
        /// </summary>
        private string NormalizeRoleName(string roleName)
        {
            return roleName?.ToLower().Trim() ?? "employee";
        }

        /// <summary>
        /// Gets Role ID from role name
        /// </summary>
        private int GetRoleId(string roleName)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                try
                {
                    using (SqlCommand cmd = new SqlCommand("SELECT RoleId FROM dbo.Roles WHERE RoleName = @RoleName", conn))
                    {
                        cmd.Parameters.AddWithValue("@RoleName", roleName);
                        conn.Open();
                        object result = cmd.ExecuteScalar();
                        return result != null ? Convert.ToInt32(result) : 0;
                    }
                }
                catch
                {
                    return 0;
                }
            }
        }

        /// <summary>
        /// Gets user permissions based on role
        /// </summary>
        public UserPermissions GetUserPermissions(string empCode, int roleId)
        {
            var permissions = new UserPermissions { RoleId = roleId };

            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                try
                {
                    conn.Open();

                    switch (roleId)
                    {
                        case 1: // Admin
                            permissions.CanCreateTicket = true;
                            permissions.CanViewOwnTickets = true;
                            permissions.CanViewAllTickets = true;
                            permissions.CanAssignTickets = true;
                            permissions.CanTransferTickets = true;
                            permissions.CanModifyTicket = true;
                            permissions.CanResolveTicket = true;
                            permissions.CanManageUsers = true;
                            permissions.CanManagePermissions = true;
                            permissions.CanManageUnits = true;
                            permissions.CanManageCategories = true;
                            break;

                        case 2: // SOC
                            permissions.CanCreateTicket = false;
                            permissions.CanViewOwnTickets = false;
                            permissions.CanViewAllTickets = true;
                            permissions.CanAssignTickets = true;
                            permissions.CanTransferTickets = true;
                            permissions.CanModifyTicket = true;
                            permissions.CanResolveTicket = false;
                            break;

                        case 3: // Engineer
                            permissions.CanCreateTicket = false;
                            permissions.CanViewOwnTickets = false;
                            permissions.CanViewAllTickets = false;
                            permissions.CanAssignTickets = false;
                            permissions.CanTransferTickets = true;
                            permissions.CanModifyTicket = false;
                            permissions.CanResolveTicket = true;
                            
                            // Get assigned units for engineer
                            GetEngineerUnits(empCode, permissions);
                            break;

                        case 4: // Employee
                        case 5: // Guest
                            permissions.CanCreateTicket = true;
                            permissions.CanViewOwnTickets = true;
                            permissions.CanViewAllTickets = false;
                            permissions.CanAssignTickets = false;
                            permissions.CanTransferTickets = false;
                            permissions.CanModifyTicket = false;
                            permissions.CanResolveTicket = false;
                            break;
                    }
                }
                catch (Exception ex)
                {
                    throw new Exception($"Failed to retrieve user permissions: {ex.Message}");
                }
            }

            return permissions;
        }

        /// <summary>
        /// Gets units assigned to engineer
        /// </summary>
        private void GetEngineerUnits(string empCode, UserPermissions permissions)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                try
                {
                    using (SqlCommand cmd = new SqlCommand(
                        "SELECT DISTINCT UnitId FROM dbo.EngineerUnitPermissions WHERE EmpCode = @EmpCode", conn))
                    {
                        cmd.Parameters.AddWithValue("@EmpCode", empCode);
                        conn.Open();
                        
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                permissions.AssignedUnits.Add(reader.GetInt32(0));
                            }
                        }
                    }
                }
                catch
                {
                    // Log error but don't fail
                }
            }
        }
    }

    /// <summary>
    /// Login result class
    /// </summary>
    public class LoginResult
    {
        public bool IsValid { get; set; }
        public int UserId { get; set; }
        public string EmpCode { get; set; }
        public string Role { get; set; }
        public int RoleId { get; set; }
        public string ErrorMessage { get; set; }
    }

    /// <summary>
    /// User permissions class
    /// </summary>
    public class UserPermissions
    {
        public int RoleId { get; set; }
        public bool CanCreateTicket { get; set; }
        public bool CanViewOwnTickets { get; set; }
        public bool CanViewAllTickets { get; set; }
        public bool CanAssignTickets { get; set; }
        public bool CanTransferTickets { get; set; }
        public bool CanModifyTicket { get; set; }
        public bool CanResolveTicket { get; set; }
        public bool CanManageUsers { get; set; }
        public bool CanManagePermissions { get; set; }
        public bool CanManageUnits { get; set; }
        public bool CanManageCategories { get; set; }
        public List<int> AssignedUnits { get; set; } = new List<int>();
    }
}
