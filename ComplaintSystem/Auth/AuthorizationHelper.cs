using System;
using System.Web;

namespace ComplaintSystem.Auth
{
    /// <summary>
    /// Helper class for authorization and permission checks
    /// </summary>
    public static class AuthorizationHelper
    {
        /// <summary>
        /// Gets current user's role from session
        /// </summary>
        public static string GetUserRole()
        {
            return HttpContext.Current?.Session?["UserRole"]?.ToString() ?? null;
        }

        /// <summary>
        /// Gets current user's role ID from session
        /// </summary>
        public static int GetUserRoleId()
        {
            if (HttpContext.Current?.Session?["RoleId"] != null && 
                int.TryParse(HttpContext.Current.Session["RoleId"].ToString(), out int roleId))
            {
                return roleId;
            }
            return 0;
        }

        /// <summary>
        /// Gets current user's employee code from session
        /// </summary>
        public static string GetUserEmpCode()
        {
            return HttpContext.Current?.Session?["EmpCode"]?.ToString() ?? null;
        }

        /// <summary>
        /// Gets current user's permissions from session
        /// </summary>
        public static UserPermissions GetUserPermissions()
        {
            return HttpContext.Current?.Session?["UserPermissions"] as UserPermissions;
        }

        /// <summary>
        /// Checks if user is authenticated
        /// </summary>
        public static bool IsAuthenticated()
        {
            return HttpContext.Current?.Session?["UserId"] != null;
        }

        /// <summary>
        /// Checks if user has specific role
        /// </summary>
        public static bool HasRole(string roleName)
        {
            string userRole = GetUserRole();
            return !string.IsNullOrEmpty(userRole) && userRole.Equals(roleName, StringComparison.OrdinalIgnoreCase);
        }

        /// <summary>
        /// Checks if user is admin
        /// </summary>
        public static bool IsAdmin()
        {
            return HasRole("admin");
        }

        /// <summary>
        /// Checks if user is SOC
        /// </summary>
        public static bool IsSOC()
        {
            return HasRole("soc");
        }

        /// <summary>
        /// Checks if user is engineer
        /// </summary>
        public static bool IsEngineer()
        {
            return HasRole("engineer");
        }

        /// <summary>
        /// Checks if user is employee or guest
        /// </summary>
        public static bool IsEmployeeOrGuest()
        {
            string role = GetUserRole();
            return !string.IsNullOrEmpty(role) && 
                   (role.Equals("employee", StringComparison.OrdinalIgnoreCase) || 
                    role.Equals("guest", StringComparison.OrdinalIgnoreCase));
        }

        /// <summary>
        /// Checks if user can perform specific action
        /// </summary>
        public static bool HasPermission(string permission)
        {
            UserPermissions perms = GetUserPermissions();
            if (perms == null) return false;

            string perm = permission.ToLower();

            if (perm == "create_ticket") return perms.CanCreateTicket;
            else if (perm == "view_own_tickets") return perms.CanViewOwnTickets;
            else if (perm == "view_all_tickets") return perms.CanViewAllTickets;
            else if (perm == "assign_tickets") return perms.CanAssignTickets;
            else if (perm == "transfer_tickets") return perms.CanTransferTickets;
            else if (perm == "modify_ticket") return perms.CanModifyTicket;
            else if (perm == "resolve_ticket") return perms.CanResolveTicket;
            else if (perm == "manage_users") return perms.CanManageUsers;
            else if (perm == "manage_permissions") return perms.CanManagePermissions;
            else if (perm == "manage_units") return perms.CanManageUnits;
            else if (perm == "manage_categories") return perms.CanManageCategories;
            else return false;
        }

        /// <summary>
        /// Requires authentication, redirects to login if not authenticated
        /// </summary>
        public static void RequireAuthentication()
        {
            if (!IsAuthenticated())
            {
                HttpContext.Current?.Response.Redirect("~/Login.aspx");
            }
        }

        /// <summary>
        /// Requires specific role, redirects to access denied if user doesn't have role
        /// </summary>
        public static void RequireRole(params string[] roles)
        {
            RequireAuthentication();

            string userRole = GetUserRole();
            bool hasRole = false;

            foreach (string role in roles)
            {
                if (!string.IsNullOrEmpty(userRole) && userRole.Equals(role, StringComparison.OrdinalIgnoreCase))
                {
                    hasRole = true;
                    break;
                }
            }

            if (!hasRole)
            {
                HttpContext.Current?.Response.Redirect("~/AccessDenied.aspx");
            }
        }

        /// <summary>
        /// Requires specific permission
        /// </summary>
        public static void RequirePermission(string permission)
        {
            RequireAuthentication();

            if (!HasPermission(permission))
            {
                HttpContext.Current?.Response.Redirect("~/AccessDenied.aspx");
            }
        }
    }
}
