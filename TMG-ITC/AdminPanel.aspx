<%@ Page Title="Admin Panel" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="AdminPanel.aspx.cs" Inherits="TMG_ITC.AdminPanel" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row g-4">
        <div class="col-md-2">
            <div class="nav flex-column nav-pills" role="tablist">
                <asp:LinkButton ID="tabUsers" runat="server" CssClass="nav-link active" OnClick="SwitchTab"
                    CommandArgument="Users"><i class="bi bi-people me-2"></i>Users</asp:LinkButton>
                <asp:LinkButton ID="tabTypes" runat="server" CssClass="nav-link" OnClick="SwitchTab"
                    CommandArgument="Types"><i class="bi bi-tags me-2"></i>Types</asp:LinkButton>
                <asp:LinkButton ID="tabUnits" runat="server" CssClass="nav-link" OnClick="SwitchTab"
                    CommandArgument="Units"><i class="bi bi-building me-2"></i>Units</asp:LinkButton>
                <asp:LinkButton ID="tabCategories" runat="server" CssClass="nav-link" OnClick="SwitchTab"
                    CommandArgument="Categories"><i class="bi bi-folder me-2"></i>Categories</asp:LinkButton>
                <asp:LinkButton ID="tabPriority" runat="server" CssClass="nav-link" OnClick="SwitchTab"
                    CommandArgument="Priority"><i class="bi bi-signal me-2"></i>Priority</asp:LinkButton>
            </div>
        </div>

        <div class="col-md-10">
            <asp:Panel ID="pnlUsers" runat="server" CssClass="card border-0 shadow-sm">
                <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="bi bi-people me-2"></i>User Management</h5>
                    <asp:Button ID="btnAddUser" runat="server" Text="+ Add User" CssClass="btn btn-primary btn-sm" OnClick="btnAddUser_Click" />
                </div>
                <div class="card-body p-0">
                    <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="false"
                        CssClass="table table-hover mb-0" GridLines="None" DataKeyNames="EmpCode"
                        OnRowCommand="gvUsers_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="EmpCode" HeaderText="Emp Code" ItemStyle-Width="100" />
                            <asp:BoundField DataField="FullName" HeaderText="Full Name" />
                            <asp:BoundField DataField="Username" HeaderText="Username" ItemStyle-Width="140" />
                            <asp:BoundField DataField="Role" HeaderText="Role" ItemStyle-Width="100" />
                            <asp:BoundField DataField="LoginType" HeaderText="Login" ItemStyle-Width="80" />
                            <asp:TemplateField HeaderText="Status" ItemStyle-Width="100">
                                <ItemTemplate><span class="badge <%# Eval("Status").ToString() == "Active" ? "bg-success" : "bg-secondary" %>"><%# Eval("Status") %></span></ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Actions" ItemStyle-Width="180">
                                <ItemTemplate>
                                    <asp:Button ID="btnEditUser" runat="server" Text="Edit" CssClass="btn btn-sm btn-outline-primary"
                                        CommandName="EditUser" CommandArgument='<%# Eval("EmpCode") %>' />
                                    <asp:Button ID="btnToggleUser" runat="server" Text='<%# Eval("Status").ToString() == "Active" ? "Deactivate" : "Activate" %>'
                                        CssClass="btn btn-sm btn-outline-secondary"
                                        CommandName="ToggleUser" CommandArgument='<%# Eval("EmpCode") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlTypes" runat="server" Visible="false" CssClass="card border-0 shadow-sm">
                <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="bi bi-tags me-2"></i>Complaint Types</h5>
                    <asp:Button ID="btnAddType" runat="server" Text="+ Add Type" CssClass="btn btn-primary btn-sm" OnClick="btnAddType_Click" />
                </div>
                <div class="card-body p-0">
                    <asp:GridView ID="gvTypes" runat="server" AutoGenerateColumns="false"
                        CssClass="table table-hover mb-0" GridLines="None" DataKeyNames="ComplaintTypeId"
                        OnRowCommand="gvTypes_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="ComplaintTypeName" HeaderText="Name" />
                            <asp:BoundField DataField="ComplaintTypeAlias" HeaderText="Alias" ItemStyle-Width="100" />
                            <asp:TemplateField HeaderText="Status" ItemStyle-Width="100">
                                <ItemTemplate><span class="badge <%# Eval("Status").ToString() == "Active" ? "bg-success" : "bg-secondary" %>"><%# Eval("Status") %></span></ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Actions" ItemStyle-Width="120">
                                <ItemTemplate>
                                    <asp:Button ID="btnToggleType" runat="server" Text='<%# Eval("Status").ToString() == "Active" ? "Deactivate" : "Activate" %>'
                                        CssClass="btn btn-sm btn-outline-secondary"
                                        CommandName="ToggleType" CommandArgument='<%# Eval("ComplaintTypeId") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlUnits" runat="server" Visible="false" CssClass="card border-0 shadow-sm">
                <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="bi bi-building me-2"></i>Units</h5>
                    <asp:Button ID="btnAddUnit" runat="server" Text="+ Add Unit" CssClass="btn btn-primary btn-sm" OnClick="btnAddUnit_Click" />
                </div>
                <div class="card-body p-0">
                    <asp:GridView ID="gvUnits" runat="server" AutoGenerateColumns="false"
                        CssClass="table table-hover mb-0" GridLines="None" DataKeyNames="UnitId"
                        OnRowCommand="gvUnits_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="UnitName" HeaderText="Unit Name" />
                            <asp:BoundField DataField="UnitAlias" HeaderText="Alias" ItemStyle-Width="100" />
                            <asp:TemplateField HeaderText="Status" ItemStyle-Width="100">
                                <ItemTemplate><span class="badge <%# Eval("Status").ToString() == "Active" ? "bg-success" : "bg-secondary" %>"><%# Eval("Status") %></span></ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Actions" ItemStyle-Width="120">
                                <ItemTemplate>
                                    <asp:Button ID="btnToggleUnit" runat="server" Text='<%# Eval("Status").ToString() == "Active" ? "Deactivate" : "Activate" %>'
                                        CssClass="btn btn-sm btn-outline-secondary"
                                        CommandName="ToggleUnit" CommandArgument='<%# Eval("UnitId") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlCategories" runat="server" Visible="false" CssClass="card border-0 shadow-sm">
                <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="bi bi-folder me-2"></i>Categories</h5>
                    <div class="d-flex gap-2">
                        <asp:DropDownList ID="ddlCatFilter" runat="server" CssClass="form-select form-select-sm" AutoPostBack="true" OnSelectedIndexChanged="ddlCatFilter_Changed">
                            <asp:ListItem Text="All" Value="" />
                            <asp:ListItem Text="Incident (INC)" Value="INC" />
                            <asp:ListItem Text="Service (SRV)" Value="SRV" />
                        </asp:DropDownList>
                        <asp:Button ID="btnAddCategory" runat="server" Text="+ Add" CssClass="btn btn-primary btn-sm" OnClick="btnAddCategory_Click" />
                    </div>
                </div>
                <div class="card-body p-0">
                    <asp:GridView ID="gvCategories" runat="server" AutoGenerateColumns="false"
                        CssClass="table table-hover mb-0" GridLines="None" DataKeyNames="CategoryId"
                        OnRowCommand="gvCategories_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="CategoryName" HeaderText="Name" />
                            <asp:BoundField DataField="CategoryAlias" HeaderText="Alias" ItemStyle-Width="100" />
                            <asp:BoundField DataField="RequestType" HeaderText="Type" ItemStyle-Width="80" />
                            <asp:TemplateField HeaderText="Status" ItemStyle-Width="100">
                                <ItemTemplate><span class="badge <%# Eval("Status").ToString() == "Active" ? "bg-success" : "bg-secondary" %>"><%# Eval("Status") %></span></ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Actions" ItemStyle-Width="120">
                                <ItemTemplate>
                                    <asp:Button ID="btnToggleCat" runat="server" Text='<%# Eval("Status").ToString() == "Active" ? "Deactivate" : "Activate" %>'
                                        CssClass="btn btn-sm btn-outline-secondary"
                                        CommandName="ToggleCat" CommandArgument='<%# Eval("CategoryId") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlPriority" runat="server" Visible="false" CssClass="card border-0 shadow-sm">
                <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="bi bi-signal me-2"></i>Priority Linking</h5>
                    <asp:Button ID="btnAddPriority" runat="server" Text="+ Add Link" CssClass="btn btn-primary btn-sm" OnClick="btnAddPriority_Click" />
                </div>
                <div class="card-body p-0">
                    <asp:GridView ID="gvPriority" runat="server" AutoGenerateColumns="false"
                        CssClass="table table-hover mb-0" GridLines="None" DataKeyNames="LinkingId"
                        OnRowCommand="gvPriority_RowCommand">
                        <Columns>
                            <asp:BoundField DataField="CategoryName" HeaderText="Category" />
                            <asp:BoundField DataField="SubCategoryName" HeaderText="Sub Category" ItemStyle-Width="160" />
                            <asp:TemplateField HeaderText="Priority" ItemStyle-Width="100">
                                <ItemTemplate><span class="badge priority-<%# Eval("Priority") %>"><%# Eval("Priority") %></span></ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Actions" ItemStyle-Width="80">
                                <ItemTemplate>
                                    <asp:Button ID="btnDeletePriority" runat="server" Text="Delete" CssClass="btn btn-sm btn-outline-danger"
                                        CommandName="DeletePriority" CommandArgument='<%# Eval("LinkingId") %>'
                                        OnClientClick="return confirm('Delete this priority link?');" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </asp:Panel>
        </div>
    </div>

    <%-- User Modal --%>
    <div class="modal fade" id="userModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header"><h5 class="modal-title" id="userModalTitle">Add User</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                <div class="modal-body">
                    <div class="mb-2">
                        <label class="form-label small">Emp Code</label>
                        <asp:TextBox ID="txtUserEmpCode" runat="server" CssClass="form-control" MaxLength="20" />
                    </div>
                    <div class="mb-2">
                        <label class="form-label small">Full Name</label>
                        <asp:TextBox ID="txtUserFullName" runat="server" CssClass="form-control" MaxLength="200" />
                    </div>
                    <div class="row g-2 mb-2">
                        <div class="col"><label class="form-label small">Username</label><asp:TextBox ID="txtUserUsername" runat="server" CssClass="form-control" MaxLength="100" /></div>
                        <div class="col"><label class="form-label small">Login Type</label><asp:DropDownList ID="ddlUserLoginType" runat="server" CssClass="form-select"><asp:ListItem Text="CUST" Value="CUST" /></asp:DropDownList></div>
                    </div>
                    <div class="row g-2 mb-2">
                        <div class="col"><label class="form-label small">Role</label><asp:DropDownList ID="ddlUserRole" runat="server" CssClass="form-select" /></div>
                        <div class="col"><label class="form-label small">Password <span class="text-muted">(CUSTOM only)</span></label><asp:TextBox ID="txtUserPassword" runat="server" CssClass="form-control" TextMode="Password" /></div>
                    </div>
                    <div class="mb-2">
                        <label class="form-label small">Unit Access</label>
                        <asp:CheckBoxList ID="cblUnits" runat="server" DataTextField="UnitName" DataValueField="UnitId" CssClass="small" RepeatColumns="2" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnSaveUser" runat="server" Text="Save" CssClass="btn btn-primary" OnClick="btnSaveUser_Click" />
                </div>
            </div>
        </div>
    </div>

    <%-- Type Modal --%>
    <div class="modal fade" id="typeModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header"><h5 class="modal-title">Complaint Type</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                <div class="modal-body">
                    <div class="mb-2"><label class="form-label small">Name</label><asp:TextBox ID="txtTypeName" runat="server" CssClass="form-control" MaxLength="100" /></div>
                    <div class="mb-2"><label class="form-label small">Alias</label><asp:TextBox ID="txtTypeAlias" runat="server" CssClass="form-control" MaxLength="10" /></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnSaveType" runat="server" Text="Save" CssClass="btn btn-primary" OnClick="btnSaveType_Click" />
                </div>
            </div>
        </div>
    </div>

    <%-- Unit Modal --%>
    <div class="modal fade" id="unitModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header"><h5 class="modal-title">Unit</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                <div class="modal-body">
                    <div class="mb-2"><label class="form-label small">Unit Name</label><asp:TextBox ID="txtUnitName" runat="server" CssClass="form-control" MaxLength="200" /></div>
                    <div class="mb-2"><label class="form-label small">Alias</label><asp:TextBox ID="txtUnitAlias" runat="server" CssClass="form-control" MaxLength="20" /></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnSaveUnit" runat="server" Text="Save" CssClass="btn btn-primary" OnClick="btnSaveUnit_Click" />
                </div>
            </div>
        </div>
    </div>

    <%-- Category Modal --%>
    <div class="modal fade" id="categoryModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header"><h5 class="modal-title">Category</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                <div class="modal-body">
                    <div class="mb-2"><label class="form-label small">Name</label><asp:TextBox ID="txtCatName" runat="server" CssClass="form-control" MaxLength="200" /></div>
                    <div class="mb-2"><label class="form-label small">Alias</label><asp:TextBox ID="txtCatAlias" runat="server" CssClass="form-control" MaxLength="20" /></div>
                    <div class="mb-2"><label class="form-label small">Type</label><asp:DropDownList ID="ddlCatType" runat="server" CssClass="form-select"><asp:ListItem Text="Incident" Value="INC" /><asp:ListItem Text="Service" Value="SRV" /></asp:DropDownList></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnSaveCategory" runat="server" Text="Save" CssClass="btn btn-primary" OnClick="btnSaveCategory_Click" />
                </div>
            </div>
        </div>
    </div>

    <%-- Priority Modal --%>
    <div class="modal fade" id="priorityModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header"><h5 class="modal-title">Priority Link</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                <div class="modal-body">
                    <div class="mb-2"><label class="form-label small">Category</label><asp:DropDownList ID="ddlPrioCategory" runat="server" CssClass="form-select" DataTextField="CategoryName" DataValueField="CategoryId" AppendDataBoundItems="true"><asp:ListItem Text="-- Select --" Value="" /></asp:DropDownList></div>
                    <div class="mb-2"><label class="form-label small">Sub Category <span class="text-muted">(optional)</span></label><asp:DropDownList ID="ddlPrioSubCategory" runat="server" CssClass="form-select" DataTextField="SubCategoryName" DataValueField="SubCategoryId" AppendDataBoundItems="true"><asp:ListItem Text="-- All Sub Categories --" Value="" /></asp:DropDownList></div>
                    <div class="mb-2"><label class="form-label small">Priority</label><asp:DropDownList ID="ddlPrioValue" runat="server" CssClass="form-select"><asp:ListItem Text="Low" Value="Low" /><asp:ListItem Text="Medium" Value="Medium" /><asp:ListItem Text="High" Value="High" /><asp:ListItem Text="Critical" Value="Critical" /></asp:DropDownList></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnSavePriority" runat="server" Text="Save" CssClass="btn btn-primary" OnClick="btnSavePriority_Click" />
                </div>
            </div>
        </div>
    </div>

    <style>
        .nav-pills .nav-link { color: #495057; border-radius: 8px; margin-bottom: 4px; font-size: 14px; }
        .nav-pills .nav-link.active { background: #1a237e; }
        .nav-pills .nav-link:hover:not(.active) { background: #e9ecef; }
        .badge.priority-Critical { background: #7c1d0e; color: #fff; }
        .badge.priority-High { background: #dc3545; color: #fff; }
        .badge.priority-Medium { background: #ffc107; color: #000; }
        .badge.priority-Low { background: #198754; color: #fff; }
    </style>
</asp:Content>
