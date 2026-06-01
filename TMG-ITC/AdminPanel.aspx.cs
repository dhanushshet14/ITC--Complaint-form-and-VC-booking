using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI.WebControls;
using TMG_ITC.Helpers;

namespace TMG_ITC
{
    public partial class AdminPanel : System.Web.UI.Page
    {
        private string CurrentTab
        {
            get { return ViewState["AdminTab"] as string ?? "Users"; }
            set { ViewState["AdminTab"] = value; }
        }

        private string EditEmpCode
        {
            get { return ViewState["EditEmpCode"] as string; }
            set { ViewState["EditEmpCode"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            AuthHelper.RequireAuth();
            if (!AuthHelper.HasRole("Admin"))
            {
                Response.Redirect("~/Dashboard.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadRoles();
                LoadUnitsChecklist();
                LoadAllTabs();
                ShowTab(CurrentTab);
            }
        }

        private void LoadRoles()
        {
            ddlUserRole.Items.Clear();
            foreach (var role in AuthHelper.AllRoles)
                ddlUserRole.Items.Add(new ListItem(role, role));
        }

        private void LoadUnitsChecklist()
        {
            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            using (var cmd = new SqlCommand("SELECT UnitId, UnitName FROM Unit_Master WHERE Status = 'Active' ORDER BY UnitName", conn))
            {
                conn.Open();
                cblUnits.DataSource = cmd.ExecuteReader();
                cblUnits.DataBind();
            }
        }

        private void LoadAllTabs()
        {
            LoadUsers();
            LoadTypes();
            LoadUnits();
            LoadCategories();
            LoadPriority();
        }

        private void ShowTab(string tab)
        {
            pnlUsers.Visible = tab == "Users";
            pnlTypes.Visible = tab == "Types";
            pnlUnits.Visible = tab == "Units";
            pnlCategories.Visible = tab == "Categories";
            pnlPriority.Visible = tab == "Priority";

            foreach (var ctrl in new[] { tabUsers, tabTypes, tabUnits, tabCategories, tabPriority })
                ctrl.CssClass = "nav-link" + (ctrl.CommandArgument == tab ? " active" : "");
        }

        protected void SwitchTab(object sender, EventArgs e)
        {
            CurrentTab = ((LinkButton)sender).CommandArgument;
            ShowTab(CurrentTab);
        }

        // ── Users ──

        private void LoadUsers()
        {
            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            using (var cmd = new SqlCommand(
                "SELECT EmpCode, FullName, Username, Role, LoginType, Status FROM User_Master ORDER BY FullName", conn))
            {
                conn.Open();
                gvUsers.DataSource = cmd.ExecuteReader();
                gvUsers.DataBind();
            }
        }

        protected void btnAddUser_Click(object sender, EventArgs e)
        {
            EditEmpCode = null;
            txtUserEmpCode.Text = "";
            txtUserFullName.Text = "";
            txtUserUsername.Text = "";
            txtUserPassword.Text = "";
            ddlUserLoginType.SelectedValue = "CUST";
            ddlUserRole.SelectedIndex = -1;
            UncheckAll(cblUnits);
            ShowModal("userModal", "Add User");
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string empCode = e.CommandArgument.ToString();

            if (e.CommandName == "EditUser")
            {
                EditEmpCode = empCode;
                using (var conn = new SqlConnection(
                    ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
                using (var cmd = new SqlCommand(
                    "SELECT EmpCode, FullName, Username, LoginType, Role FROM User_Master WHERE EmpCode = @Code", conn))
                {
                    cmd.Parameters.AddWithValue("@Code", empCode);
                    conn.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            txtUserEmpCode.Text = reader["EmpCode"].ToString();
                            txtUserFullName.Text = reader["FullName"].ToString();
                            txtUserUsername.Text = reader["Username"].ToString();
                            ddlUserLoginType.SelectedValue = reader["LoginType"].ToString();
                            ddlUserRole.SelectedValue = reader["Role"].ToString();
                            txtUserPassword.Text = "";
                            txtUserEmpCode.Enabled = false;
                        }
                    }
                }
                LoadUserUnits(empCode);
                ShowModal("userModal", "Edit User");
            }
            else if (e.CommandName == "ToggleUser")
            {
                ToggleStatus("User_Master", "EmpCode", empCode);
                LoadUsers();
            }
        }

        private void LoadUserUnits(string empCode)
        {
            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            using (var cmd = new SqlCommand(
                "SELECT UnitId FROM User_Unit_Permission WHERE EmpCode = @Code", conn))
            {
                cmd.Parameters.AddWithValue("@Code", empCode);
                conn.Open();
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        int uid = Convert.ToInt32(reader["UnitId"]);
                        var item = cblUnits.Items.FindByValue(uid.ToString());
                        if (item != null) item.Selected = true;
                    }
                }
            }
        }

        protected void btnSaveUser_Click(object sender, EventArgs e)
        {
            string empCode = txtUserEmpCode.Text.Trim();
            string fullName = txtUserFullName.Text.Trim();
            string username = txtUserUsername.Text.Trim();
            string loginType = ddlUserLoginType.SelectedValue;
            string role = ddlUserRole.SelectedValue;
            string password = txtUserPassword.Text.Trim();

            if (string.IsNullOrEmpty(empCode) || string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(username))
            {
                ShowModal("userModal", EditEmpCode == null ? "Add User" : "Edit User");
                return;
            }

            var user = AuthHelper.GetCurrentUser();

            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            {
                conn.Open();

                if (EditEmpCode == null)
                {
                    using (var cmd = new SqlCommand(@"
                        INSERT INTO User_Master (EmpCode, FullName, Username, Password, LoginType, Status, Role, FailedAttempts, CreatedBy, CreatedDate)
                        VALUES (@Code, @Name, @Uname, @Pwd, @LType, 'Active', @Role, 0, @By, GETDATE())", conn))
                    {
                        cmd.Parameters.AddWithValue("@Code", empCode);
                        cmd.Parameters.AddWithValue("@Name", fullName);
                        cmd.Parameters.AddWithValue("@Uname", username);
                        cmd.Parameters.AddWithValue("@Pwd",
                            loginType == "CUST" && !string.IsNullOrEmpty(password)
                                ? BCrypt.Net.BCrypt.HashPassword(password) : (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@LType", loginType);
                        cmd.Parameters.AddWithValue("@Role", role);
                        cmd.Parameters.AddWithValue("@By", user.EmpCode);
                        cmd.ExecuteNonQuery();
                    }
                }
                else
                {
                    using (var cmd = new SqlCommand(@"
                        UPDATE User_Master SET FullName=@Name, Username=@Uname, LoginType=@LType, Role=@Role,
                            UpdatedBy=@By, UpdatedDate=GETDATE()
                        WHERE EmpCode=@Code", conn))
                    {
                        cmd.Parameters.AddWithValue("@Code", empCode);
                        cmd.Parameters.AddWithValue("@Name", fullName);
                        cmd.Parameters.AddWithValue("@Uname", username);
                        cmd.Parameters.AddWithValue("@LType", loginType);
                        cmd.Parameters.AddWithValue("@Role", role);
                        cmd.Parameters.AddWithValue("@By", user.EmpCode);
                        cmd.ExecuteNonQuery();
                    }

                    if (loginType == "CUST" && !string.IsNullOrEmpty(password))
                    {
                        using (var cmd = new SqlCommand(
                            "UPDATE User_Master SET Password=@Pwd WHERE EmpCode=@Code", conn))
                        {
                            cmd.Parameters.AddWithValue("@Code", empCode);
                            cmd.Parameters.AddWithValue("@Pwd", BCrypt.Net.BCrypt.HashPassword(password));
                            cmd.ExecuteNonQuery();
                        }
                    }
                }

                // Unit permissions
                using (var cmd = new SqlCommand("DELETE FROM User_Unit_Permission WHERE EmpCode=@Code", conn))
                {
                    cmd.Parameters.AddWithValue("@Code", empCode);
                    cmd.ExecuteNonQuery();
                }

                foreach (ListItem item in cblUnits)
                {
                    if (item.Selected)
                    {
                        using (var cmd = new SqlCommand(@"
                            INSERT INTO User_Unit_Permission (EmpCode, UnitId, Role, AssignedBy, AssignedDate)
                            VALUES (@Code, @Uid, 'Manage', @By, GETDATE())", conn))
                        {
                            cmd.Parameters.AddWithValue("@Code", empCode);
                            cmd.Parameters.AddWithValue("@Uid", int.Parse(item.Value));
                            cmd.Parameters.AddWithValue("@By", user.EmpCode);
                            cmd.ExecuteNonQuery();
                        }
                    }
                }
            }

            txtUserEmpCode.Enabled = true;
            LoadUsers();
        }

        // ── Complaint Types ──

        private void LoadTypes()
        {
            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            using (var cmd = new SqlCommand(
                "SELECT ComplaintTypeId, ComplaintTypeName, ComplaintTypeAlias, Status FROM ComplaintType_Master ORDER BY ComplaintTypeName", conn))
            {
                conn.Open();
                gvTypes.DataSource = cmd.ExecuteReader();
                gvTypes.DataBind();
            }
        }

        protected void btnAddType_Click(object sender, EventArgs e)
        {
            txtTypeName.Text = "";
            txtTypeAlias.Text = "";
            ShowModal("typeModal", "Add Complaint Type");
        }

        protected void gvTypes_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ToggleType")
            {
                ToggleStatus("ComplaintType_Master", "ComplaintTypeId", e.CommandArgument.ToString());
                LoadTypes();
            }
        }

        protected void btnSaveType_Click(object sender, EventArgs e)
        {
            string name = txtTypeName.Text.Trim();
            string alias = txtTypeAlias.Text.Trim();
            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(alias)) return;

            var user = AuthHelper.GetCurrentUser();
            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            using (var cmd = new SqlCommand(@"
                INSERT INTO ComplaintType_Master (ComplaintTypeName, ComplaintTypeAlias, Status, CreatedBy, CreatedDate)
                VALUES (@Name, @Alias, 'Active', @By, GETDATE())", conn))
            {
                cmd.Parameters.AddWithValue("@Name", name);
                cmd.Parameters.AddWithValue("@Alias", alias.ToUpper());
                cmd.Parameters.AddWithValue("@By", user.EmpCode);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            LoadTypes();
        }

        // ── Units ──

        private void LoadUnits()
        {
            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            using (var cmd = new SqlCommand(
                "SELECT UnitId, UnitName, UnitAlias, Status FROM Unit_Master ORDER BY UnitName", conn))
            {
                conn.Open();
                gvUnits.DataSource = cmd.ExecuteReader();
                gvUnits.DataBind();
            }
        }

        protected void btnAddUnit_Click(object sender, EventArgs e)
        {
            txtUnitName.Text = "";
            txtUnitAlias.Text = "";
            ShowModal("unitModal", "Add Unit");
        }

        protected void gvUnits_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ToggleUnit")
            {
                ToggleStatus("Unit_Master", "UnitId", e.CommandArgument.ToString());
                LoadUnits();
            }
        }

        protected void btnSaveUnit_Click(object sender, EventArgs e)
        {
            string name = txtUnitName.Text.Trim();
            string alias = txtUnitAlias.Text.Trim();
            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(alias)) return;

            var user = AuthHelper.GetCurrentUser();
            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            using (var cmd = new SqlCommand(@"
                INSERT INTO Unit_Master (UnitName, UnitAlias, Status, CreatedBy, CreatedDate)
                VALUES (@Name, @Alias, 'Active', @By, GETDATE())", conn))
            {
                cmd.Parameters.AddWithValue("@Name", name);
                cmd.Parameters.AddWithValue("@Alias", alias.ToUpper());
                cmd.Parameters.AddWithValue("@By", user.EmpCode);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            LoadUnits();
            LoadUnitsChecklist();
        }

        // ── Categories ──

        private void LoadCategories()
        {
            string filter = ddlCatFilter.SelectedValue;

            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            using (var cmd = new SqlCommand(@"
                SELECT CategoryId, CategoryName, CategoryAlias, RequestType, Status
                FROM Category_Master
                WHERE (@Filter = '' OR RequestType = @Filter)
                ORDER BY RequestType, CategoryName", conn))
            {
                cmd.Parameters.AddWithValue("@Filter", (object)filter ?? DBNull.Value);
                conn.Open();
                gvCategories.DataSource = cmd.ExecuteReader();
                gvCategories.DataBind();
            }
        }

        protected void ddlCatFilter_Changed(object sender, EventArgs e) => LoadCategories();

        protected void btnAddCategory_Click(object sender, EventArgs e)
        {
            txtCatName.Text = "";
            txtCatAlias.Text = "";
            ddlCatType.SelectedIndex = 0;
            ShowModal("categoryModal", "Add Category");
        }

        protected void gvCategories_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ToggleCat")
            {
                ToggleStatus("Category_Master", "CategoryId", e.CommandArgument.ToString());
                LoadCategories();
            }
        }

        protected void btnSaveCategory_Click(object sender, EventArgs e)
        {
            string name = txtCatName.Text.Trim();
            string alias = txtCatAlias.Text.Trim();
            string type = ddlCatType.SelectedValue;
            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(alias)) return;

            var user = AuthHelper.GetCurrentUser();
            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            using (var cmd = new SqlCommand(@"
                INSERT INTO Category_Master (CategoryName, CategoryAlias, RequestType, Status, CreatedBy, CreatedDate)
                VALUES (@Name, @Alias, @Type, 'Active', @By, GETDATE())", conn))
            {
                cmd.Parameters.AddWithValue("@Name", name);
                cmd.Parameters.AddWithValue("@Alias", alias.ToUpper());
                cmd.Parameters.AddWithValue("@Type", type);
                cmd.Parameters.AddWithValue("@By", user.EmpCode);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            LoadCategories();
        }

        // ── Priority Linking ──

        private void LoadPriority()
        {
            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            using (var cmd = new SqlCommand(@"
                SELECT p.LinkingId, c.CategoryName, s.SubCategoryName, p.Priority,
                    ISNULL(s.SubCategoryName, '(All Sub Categories)') AS SubCategoryDisplay
                FROM Priority_Category_Linking p
                LEFT JOIN Category_Master c ON p.CategoryId = c.CategoryId
                LEFT JOIN Sub_Category_Master s ON p.SubCategoryId = s.SubCategoryId
                ORDER BY c.CategoryName, p.Priority", conn))
            {
                conn.Open();
                gvPriority.DataSource = cmd.ExecuteReader();
                gvPriority.DataBind();
            }
        }

        protected void btnAddPriority_Click(object sender, EventArgs e)
        {
            ddlPrioCategory.SelectedIndex = 0;
            ddlPrioSubCategory.Items.Clear();
            ddlPrioSubCategory.Items.Add(new ListItem("-- All Sub Categories --", ""));
            ddlPrioValue.SelectedValue = "Medium";

            // Load categories
            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            using (var cmd = new SqlCommand(
                "SELECT CategoryId, CategoryName FROM Category_Master WHERE Status='Active' ORDER BY CategoryName", conn))
            {
                conn.Open();
                ddlPrioCategory.DataSource = cmd.ExecuteReader();
                ddlPrioCategory.DataBind();
            }
            ShowModal("priorityModal", "Add Priority Link");
        }

        protected void gvPriority_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeletePriority")
            {
                using (var conn = new SqlConnection(
                    ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
                using (var cmd = new SqlCommand(
                    "DELETE FROM Priority_Category_Linking WHERE LinkingId=@Id", conn))
                {
                    cmd.Parameters.AddWithValue("@Id", e.CommandArgument);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                LoadPriority();
            }
        }

        protected void btnSavePriority_Click(object sender, EventArgs e)
        {
            string catId = ddlPrioCategory.SelectedValue;
            string priority = ddlPrioValue.SelectedValue;
            if (string.IsNullOrEmpty(catId)) return;

            string subCatId = ddlPrioSubCategory.SelectedValue;

            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            using (var cmd = new SqlCommand(@"
                INSERT INTO Priority_Category_Linking (CategoryId, SubCategoryId, Priority)
                VALUES (@CatId, @SubCatId, @Priority)", conn))
            {
                cmd.Parameters.AddWithValue("@CatId", int.Parse(catId));
                cmd.Parameters.AddWithValue("@SubCatId",
                    string.IsNullOrEmpty(subCatId) ? DBNull.Value : (object)int.Parse(subCatId));
                cmd.Parameters.AddWithValue("@Priority", priority);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            LoadPriority();
        }

        // ── Helpers ──

        private void ToggleStatus(string table, string keyColumn, string keyValue)
        {
            using (var conn = new SqlConnection(
                ConfigurationManager.ConnectionStrings["HRConnection"].ConnectionString))
            using (var cmd = new SqlCommand(
                $"UPDATE {table} SET Status = CASE WHEN Status = 'Active' THEN 'Inactive' ELSE 'Active' END WHERE {keyColumn} = @Id", conn))
            {
                cmd.Parameters.AddWithValue("@Id", keyValue);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        private void UncheckAll(CheckBoxList list)
        {
            foreach (ListItem item in list.Items)
                item.Selected = false;
        }

        private void ShowModal(string modalId, string title)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "showModal",
                $"$('#{modalId}').find('.modal-title').text('{title}'); $('#{modalId}').modal('show');", true);
        }
    }
}
