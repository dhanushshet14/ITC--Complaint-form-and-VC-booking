using System;
using System.Collections.Generic;

namespace ComplaintSystem.Auth
{
    /// <summary>
    /// Quick reference examples for using RBAC in your pages
    /// </summary>
    public class RBACQuickReference
    {
        /*
        ========================================
        QUICK START - Add to your pages
        ========================================
        */

        // EXAMPLE 1: Secure page with authentication
        public void ExampleSecurePage()
        {
            /*
            In Page_Load of your aspx.cs:
            
            protected void Page_Load(object sender, EventArgs e) {
                // Require authentication
                AuthorizationHelper.RequireAuthentication();
                
                if (!IsPostBack) {
                    LoadData();
                }
            }
            */
        }

        // EXAMPLE 2: Require specific role
        public void ExampleRoleRequirement()
        {
            /*
            protected void Page_Load(object sender, EventArgs e) {
                // Only Admin and SOC allowed
                AuthorizationHelper.RequireRole("admin", "soc");
                
                if (!IsPostBack) {
                    LoadTickets();
                }
            }
            */
        }

        // EXAMPLE 3: Require specific permission
        public void ExamplePermissionRequirement()
        {
            /*
            protected void Page_Load(object sender, EventArgs e) {
                // Only users who can create tickets
                AuthorizationHelper.RequirePermission("create_ticket");
                
                if (!IsPostBack) {
                    InitializeForm();
                }
            }
            */
        }

        // EXAMPLE 4: Conditional UI based on role
        public void ExampleConditionalUI()
        {
            /*
            protected void Page_Load(object sender, EventArgs e) {
                AuthorizationHelper.RequireAuthentication();
                
                if (AuthorizationHelper.IsEngineer()) {
                    pnlEngineerTools.Visible = true;
                } else if (AuthorizationHelper.IsSOC()) {
                    pnlSOCTools.Visible = true;
                } else if (AuthorizationHelper.IsEmployeeOrGuest()) {
                    pnlEmployeeTools.Visible = true;
                }
            }
            */
        }

        // EXAMPLE 5: Permission-based button visibility
        public void ExampleButtonVisibility()
        {
            /*
            protected void Page_Load(object sender, EventArgs e) {
                AuthorizationHelper.RequireAuthentication();
                
                // Show buttons based on permission
                btnCreateTicket.Visible = AuthorizationHelper.HasPermission("create_ticket");
                btnAssignTicket.Visible = AuthorizationHelper.HasPermission("assign_tickets");
                btnResolveTicket.Visible = AuthorizationHelper.HasPermission("resolve_ticket");
                btnManageUsers.Visible = AuthorizationHelper.HasPermission("manage_users");
            }
            */
        }

        // EXAMPLE 6: Get current user info
        public void ExampleGetUserInfo()
        {
            /*
            string empCode = AuthorizationHelper.GetUserEmpCode();
            string role = AuthorizationHelper.GetUserRole();
            int roleId = AuthorizationHelper.GetUserRoleId();
            UserPermissions perms = AuthorizationHelper.GetUserPermissions();
            
            // Use empCode and roleId to fetch role-based data
            ComplaintDataService service = new ComplaintDataService();
            DataSet tickets = service.GetUserComplaints(empCode, roleId);
            */
        }

        // EXAMPLE 7: Check before action
        public void ExampleActionCheck()
        {
            /*
            protected void btnResolve_Click(object sender, EventArgs e) {
                if (!AuthorizationHelper.HasPermission("resolve_ticket")) {
                    lblError.Text = "You don't have permission to resolve tickets";
                    return;
                }
                
                // Proceed with action
                ResolveTicket();
            }
            */
        }

        // EXAMPLE 8: Role-specific data loading
        public void ExampleRoleSpecificData()
        {
            /*
            protected void Page_Load(object sender, EventArgs e) {
                AuthorizationHelper.RequireAuthentication();
                
                string empCode = AuthorizationHelper.GetUserEmpCode();
                int roleId = AuthorizationHelper.GetUserRoleId();
                
                ComplaintDataService service = new ComplaintDataService();
                
                switch (roleId) {
                    case 1: // Admin
                        LoadAdminDashboard(service);
                        break;
                    case 2: // SOC
                        LoadSOCDashboard(service);
                        break;
                    case 3: // Engineer
                        LoadEngineerDashboard(service, empCode);
                        break;
                    case 4:
                    case 5: // Employee/Guest
                        LoadEmployeeDashboard(service, empCode);
                        break;
                }
            }
            */
        }

        // EXAMPLE 9: Complete complaint submission with auth check
        public void ExampleComplaintSubmission()
        {
            /*
            protected void btnSubmit_Click(object sender, EventArgs e) {
                try {
                    // Check permission first
                    if (!AuthorizationHelper.HasPermission("create_ticket")) {
                        lblError.Text = "You don't have permission to create complaints";
                        return;
                    }
                    
                    // Get authenticated user
                    string createdBy = AuthorizationHelper.GetUserEmpCode();
                    
                    // Submit complaint
                    string complaintId = Guid.NewGuid().ToString();
                    using (SqlConnection conn = new SqlConnection(connectionString)) {
                        using (SqlCommand cmd = new SqlCommand("sp_InsertComplaint", conn)) {
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.Parameters.AddWithValue("@ComplaintId", complaintId);
                            cmd.Parameters.AddWithValue("@CreatedBy", createdBy);
                            cmd.Parameters.AddWithValue("@Title", txtTitle.Text);
                            cmd.Parameters.AddWithValue("@Description", txtDescription.Text);
                            // ... other parameters
                            
                            conn.Open();
                            cmd.ExecuteNonQuery();
                        }
                    }
                    
                    ClientScript.RegisterStartupScript(GetType(), "msg", 
                        "alert('Complaint created successfully'); location.href='ViewComplaints.aspx';", true);
                }
                catch (Exception ex) {
                    lblError.Text = $"Error: {ex.Message}";
                }
            }
            */
        }

        // EXAMPLE 10: Secure API/Service call
        public void ExampleSecureServiceCall()
        {
            /*
            public static DataSet GetComplaintsSecure() {
                // Verify authentication
                if (!AuthorizationHelper.IsAuthenticated()) {
                    throw new UnauthorizedAccessException("Not authenticated");
                }
                
                // Get user info
                string empCode = AuthorizationHelper.GetUserEmpCode();
                int roleId = AuthorizationHelper.GetUserRoleId();
                
                // Fetch role-filtered data
                ComplaintDataService service = new ComplaintDataService();
                return service.GetUserComplaints(empCode, roleId);
            }
            */
        }
    }

    // ========================================
    // PERMISSION STRINGS - Use exactly as shown
    // ========================================
    public static class Permissions
    {
        public const string CREATE_TICKET = "create_ticket";
        public const string VIEW_OWN_TICKETS = "view_own_tickets";
        public const string VIEW_ALL_TICKETS = "view_all_tickets";
        public const string ASSIGN_TICKETS = "assign_tickets";
        public const string TRANSFER_TICKETS = "transfer_tickets";
        public const string MODIFY_TICKET = "modify_ticket";
        public const string RESOLVE_TICKET = "resolve_ticket";
        public const string MANAGE_USERS = "manage_users";
        public const string MANAGE_PERMISSIONS = "manage_permissions";
        public const string MANAGE_UNITS = "manage_units";
        public const string MANAGE_CATEGORIES = "manage_categories";
    }

    // ========================================
    // ROLE IDS - Use for comparison
    // ========================================
    public static class RoleIds
    {
        public const int ADMIN = 1;
        public const int SOC = 2;
        public const int ENGINEER = 3;
        public const int EMPLOYEE = 4;
        public const int GUEST = 5;
    }

    // ========================================
    // ROLE NAMES - Use for string comparison
    // ========================================
    public static class RoleNames
    {
        public const string ADMIN = "admin";
        public const string SOC = "soc";
        public const string ENGINEER = "engineer";
        public const string EMPLOYEE = "employee";
        public const string GUEST = "guest";
    }
}
