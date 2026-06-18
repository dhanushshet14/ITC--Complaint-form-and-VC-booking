using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace TMG_ITC.Helpers
{
    public class AuthHelper
    {
        public static string ConnectionString =>
            ConfigurationManager.ConnectionStrings["HRConnection"]?.ConnectionString;

        public static string[] AllRoles = new[] { "Admin", "SOC", "Engineer", "Employee", "Guest" };
        public static string[] AdminRoles = new[] { "Admin", "SOC" };
        public static string[] EngineerRoles = new[] { "Engineer", "Admin" };

        public static bool IsAuthenticated()
        {
            if (HttpContext.Current.Session["EmpCode"] != null)
                return true;

            string token = JwtHelper.GetCookie();
            if (token == null) return false;

            var user = JwtHelper.ValidateToken(token);
            if (user == null)
            {
                JwtHelper.ClearCookie();
                return false;
            }

            if (JwtHelper.ShouldRefresh(token))
                token = JwtHelper.GenerateToken(user);

            SetSession(user, token);
            return true;
        }

        public static void RequireAuth()
        {
            if (!IsAuthenticated())
                HttpContext.Current.Response.Redirect("~/Login.aspx");
        }

        public static void RequireAuth(params string[] roles)
        {
            if (!IsAuthenticated())
                HttpContext.Current.Response.Redirect("~/Login.aspx");
            if (roles.Length > 0 && !HasAnyRole(roles))
                HttpContext.Current.Response.Redirect("~/Dashboard.aspx");
        }

        public static bool HasRole(string role)
        {
            var userRole = HttpContext.Current.Session["Role"]?.ToString();
            return string.Equals(userRole, role, StringComparison.OrdinalIgnoreCase);
        }

        public static bool HasAnyRole(params string[] roles)
        {
            var userRole = HttpContext.Current.Session["Role"]?.ToString();
            return roles.Any(r => string.Equals(userRole, r, StringComparison.OrdinalIgnoreCase));
        }

        public static bool CanAccessModule(string module)
        {
            var role = HttpContext.Current.Session["Role"]?.ToString();

            return module.ToLower() switch
            {
                "soc" => HasAnyRole("Engineer", "SOC", "Admin"),
                "adminpanel" => HasRole("Admin"),
                _ => true
            };
        }

        public static bool HasUnitAccess(int unitId)
        {
            var role = HttpContext.Current.Session["Role"]?.ToString();
            if (HasAnyRole("Admin", "SOC")) return true;

            var unitIds = HttpContext.Current.Session["UnitIds"] as List<int>;
            return unitIds?.Contains(unitId) == true;
        }

        public static bool CanPerformAction(string action, string complaintStatus)
        {
            var role = HttpContext.Current.Session["Role"]?.ToString();

            return (role, action, complaintStatus) switch
            {
                ("Employee", "Reopen", "Resolved" or "Closed") => true,
                ("Employee", _, _) when action == "AddWorkNote" => true,
                ("Employee", _, _) => false,
                ("Guest", "Reopen", "Resolved" or "Closed") => true,
                ("Guest", _, _) when action == "AddWorkNote" => true,
                ("Guest", _, _) => false,
                ("Engineer", "Resolve" or "Close", _) when complaintStatus != "Closed" => true,
                ("Engineer", "SelfAssign", "New" or "Reopened") => true,
                ("Engineer", "Transfer", _) when complaintStatus != "Closed" => true,
                ("Engineer", "Accept", "Assigned") => true,
                ("Engineer", "MarkInProgress", "Assigned") => true,
                ("Engineer", _, _) when action == "AddWorkNote" => true,
                ("Engineer", "Hold", "Assigned" or "In Progress") => true,
                ("Engineer", "Resume", "Hold") => true,
                ("SOC", "Assign", "New" or "Reopened") => true,
                ("SOC", "Transfer", _) when complaintStatus != "Closed" => true,
                ("SOC", "Close", "Resolved") => true,
                ("SOC", "Hold", _) when complaintStatus != "Closed" => true,
                ("SOC", "Resume", "Hold") => true,
                ("SOC", _, _) when action == "AddWorkNote" => true,
                ("Admin", _, _) => true,
                _ => false
            };
        }

        public static UserSessionData GetCurrentUser()
        {
            if (!IsAuthenticated()) return null;

            return new UserSessionData
            {
                EmpCode = HttpContext.Current.Session["EmpCode"]?.ToString(),
                FullName = HttpContext.Current.Session["FullName"]?.ToString(),
                Username = HttpContext.Current.Session["Username"]?.ToString(),
                Role = HttpContext.Current.Session["Role"]?.ToString(),
                LoginType = HttpContext.Current.Session["LoginType"]?.ToString(),
                UnitIds = HttpContext.Current.Session["UnitIds"] as List<int>
            };
        }

        public static void SetSession(UserSessionData user, string existingToken = null)
        {
            HttpContext.Current.Session["EmpCode"] = user.EmpCode;
            HttpContext.Current.Session["FullName"] = user.FullName;
            HttpContext.Current.Session["Username"] = user.Username;
            HttpContext.Current.Session["Role"] = user.Role;
            HttpContext.Current.Session["LoginType"] = user.LoginType;
            HttpContext.Current.Session["UnitIds"] = user.UnitIds;

            string token = existingToken ?? JwtHelper.GenerateToken(user);
            JwtHelper.SetCookie(token);
        }

        public static void Logout()
        {
            HttpContext.Current.Session.Clear();
            HttpContext.Current.Session.Abandon();
            JwtHelper.ClearCookie();
        }

        public static string GetRedirectUrl(string role)
        {
            return "~/Dashboard.aspx";
        }

        public static LoginResult ValidateCredentials(string username, string password)
        {
            var result = new LoginResult();

            if (string.IsNullOrEmpty(username))
            {
                result.Success = false;
                result.Message = "Please enter username";
                return result;
            }

            // Step 1: Check User_Master for privileged users (Admin/SOC/Engineer)
            using (var conn = new SqlConnection(ConnectionString))
            {
                conn.Open();

                using (var cmd = new SqlCommand(@"
                    SELECT EmpCode, FullName, Role, Username, LoginType, [Status]
                    FROM User_Master
                    WHERE EmpCode = @Username OR Username = @Username", conn))
                {
                    cmd.Parameters.AddWithValue("@Username", username);

                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            string status = reader["Status"]?.ToString();
                            if (status != "Active")
                            {
                                var msg = status == "Locked"
                                    ? "Your account is locked. Contact IT Administrator."
                                    : "Your account is inactive. Contact IT Administrator.";
                                result.Success = false;
                                result.Message = msg;
                                return result;
                            }

                            result.EmpCode = reader["EmpCode"]?.ToString();
                            result.FullName = reader["FullName"]?.ToString();
                            result.Role = reader["Role"]?.ToString();
                            result.LoginType = reader["LoginType"]?.ToString();
                            result.Success = true;

                            // Validate password for privileged users
                            string loginType = reader["LoginType"]?.ToString();
                            if (loginType == "CUST")
                            {
                                bool passwordValid = BCrypt.Net.BCrypt.Verify(password, GetPasswordHash(result.EmpCode));
                                if (!passwordValid)
                                {
                                    IncrementFailedAttempts(result.EmpCode);
                                    result.Success = false;
                                    result.Message = "Invalid username or password";

                                    if (GetFailedAttempts(result.EmpCode) >= 5)
                                    {
                                        LockAccount(result.EmpCode);
                                        result.Message = "Your account is locked. Contact IT Administrator.";
                                    }
                                    return result;
                                }
                            }

                            ResetFailedAttempts(result.EmpCode);
                            RecordSuccessfulLogin(result.EmpCode);

                            // Get unit permissions
                            reader.Close();
                            result.UnitIds = GetUserUnitIds(result.EmpCode, result.Role);
                            return result;
                        }
                    }
                }
            }

            // Step 2: Not in User_Master — check TBL_EmployeeDetails (regular employee)
            using (var conn = new SqlConnection(ConnectionString))
            {
                conn.Open();

                using (var cmd = new SqlCommand(@"
                    SELECT EMP_Empcode, EMP_Name, EMP_DomainUsername, EMP_EmailId, EMP_DOL, EMP_Unit, EMP_Department
                    FROM [TMG_EmployeeData].[dbo].[TBL_EmployeeDetails]
                    WHERE (EMP_Empcode = @Username OR EMP_DomainUsername = @Username)", conn))
                {
                    cmd.Parameters.AddWithValue("@Username", username);

                    using (var reader = cmd.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            result.Success = false;
                            result.Message = "Employee record not found. Please contact IT Administrator.";
                            return result;
                        }

                        // Check DOL (Date of Leaving)
                        if (reader["EMP_DOL"] != DBNull.Value)
                        {
                            DateTime dol = Convert.ToDateTime(reader["EMP_DOL"]);
                            if (dol <= DateTime.Now)
                            {
                                result.Success = false;
                                result.Message = "Your account is inactive. Contact IT Administrator.";
                                return result;
                            }
                        }

                        string empCode = reader["EMP_Empcode"]?.ToString();
                        string empName = reader["EMP_Name"]?.ToString();
                        string domainUser = reader["EMP_DomainUsername"]?.ToString();
                        string empUnit = reader["EMP_Unit"]?.ToString();

                        result.EmpCode = empCode;
                        result.FullName = empName;
                        result.Role = "Employee";
                        result.LoginType = "EMPLOYEE";
                        result.Success = true;

                        reader.Close();

                        // Resolve unit from EMP_Unit name → UnitId
                        result.UnitIds = ResolveEmployeeUnitIds(empUnit);
                        return result;
                    }
                }
            }
        }

        private static List<int> GetUserUnitIds(string empCode, string role)
        {
            if (role == "Admin" || role == "SOC")
                return new List<int>(); // empty = all units

            var ids = new List<int>();
            using (var conn = new SqlConnection(ConnectionString))
            using (var cmd = new SqlCommand(
                "SELECT UnitId FROM User_Unit_Permission WHERE EmpCode = @EmpCode", conn))
            {
                cmd.Parameters.AddWithValue("@EmpCode", empCode);
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                        ids.Add(Convert.ToInt32(reader["UnitId"]));
                }
            }
            return ids;
        }

        private static List<int> ResolveEmployeeUnitIds(string empUnit)
        {
            if (string.IsNullOrEmpty(empUnit)) return new List<int>();

            var ids = new List<int>();
            using (var conn = new SqlConnection(ConnectionString))
            using (var cmd = new SqlCommand(
                "SELECT UnitId FROM Unit_Master WHERE UnitName = @UnitName OR UnitAlias = @UnitName", conn))
            {
                cmd.Parameters.AddWithValue("@UnitName", empUnit);
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                        ids.Add(Convert.ToInt32(reader["UnitId"]));
                }
            }
            return ids;
        }

        private static string GetPasswordHash(string empCode)
        {
            using (var conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                using (var cmd = new SqlCommand(
                    "SELECT [Password] FROM User_Master WHERE EmpCode = @EmpCode", conn))
                {
                    cmd.Parameters.AddWithValue("@EmpCode", empCode);
                    return cmd.ExecuteScalar()?.ToString();
                }
            }
        }

        private static int GetFailedAttempts(string empCode)
        {
            using (var conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                using (var cmd = new SqlCommand(
                    "SELECT FailedAttempts FROM User_Master WHERE EmpCode = @EmpCode", conn))
                {
                    cmd.Parameters.AddWithValue("@EmpCode", empCode);
                    var result = cmd.ExecuteScalar();
                    return result != null ? Convert.ToInt32(result) : 0;
                }
            }
        }

        private static void IncrementFailedAttempts(string empCode)
        {
            using (var conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                using (var cmd = new SqlCommand(@"
                    UPDATE User_Master SET FailedAttempts = ISNULL(FailedAttempts, 0) + 1
                    WHERE EmpCode = @EmpCode", conn))
                {
                    cmd.Parameters.AddWithValue("@EmpCode", empCode);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private static void ResetFailedAttempts(string empCode)
        {
            using (var conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                using (var cmd = new SqlCommand(@"
                    UPDATE User_Master SET FailedAttempts = 0 WHERE EmpCode = @EmpCode", conn))
                {
                    cmd.Parameters.AddWithValue("@EmpCode", empCode);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private static void LockAccount(string empCode)
        {
            using (var conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                using (var cmd = new SqlCommand(@"
                    UPDATE User_Master SET [Status] = 'Locked' WHERE EmpCode = @EmpCode", conn))
                {
                    cmd.Parameters.AddWithValue("@EmpCode", empCode);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private static void RecordSuccessfulLogin(string empCode)
        {
            using (var conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                using (var cmd = new SqlCommand(@"
                    UPDATE User_Master
                    SET LastLoginDate = GETDATE(), FailedAttempts = 0
                    WHERE EmpCode = @EmpCode", conn))
                {
                    cmd.Parameters.AddWithValue("@EmpCode", empCode);
                    cmd.ExecuteNonQuery();
                }
            }
        }
    }

    public class UserSessionData
    {
        public string EmpCode { get; set; }
        public string FullName { get; set; }
        public string Username { get; set; }
        public string Role { get; set; }
        public string LoginType { get; set; }
        public List<int> UnitIds { get; set; }
    }

    public class LoginResult
    {
        public bool Success { get; set; }
        public string Message { get; set; }
        public string EmpCode { get; set; }
        public string FullName { get; set; }
        public string Role { get; set; }
        public string LoginType { get; set; }
        public string Status { get; set; }
        public List<int> UnitIds { get; set; }
    }
}
