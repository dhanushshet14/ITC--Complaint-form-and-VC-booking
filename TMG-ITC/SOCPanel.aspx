<%@ Page Title="SOC Panel" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="SOCPanel.aspx.cs" Inherits="TMG_ITC.SOCPanel" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row g-3 mb-4" id="summaryCards" runat="server">
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted mb-1 small">Total Complaints</h6>
                        <h3 class="mb-0" id="lblTotal" runat="server">0</h3>
                    </div>
                    <i class="bi bi-ticket-perforated fs-2 text-primary opacity-25"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted mb-1 small">Open</h6>
                        <h3 class="mb-0" id="lblOpen" runat="server">0</h3>
                    </div>
                    <i class="bi bi-exclamation-circle fs-2 text-warning opacity-25"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted mb-1 small">Resolved</h6>
                        <h3 class="mb-0" id="lblResolved" runat="server">0</h3>
                    </div>
                    <i class="bi bi-check-circle fs-2 text-success opacity-25"></i>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 shadow-sm">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h6 class="text-muted mb-1 small">Closed</h6>
                        <h3 class="mb-0" id="lblClosed" runat="server">0</h3>
                    </div>
                    <i class="bi bi-check2-all fs-2 text-secondary opacity-25"></i>
                </div>
            </div>
        </div>
    </div>

    <ul class="nav nav-tabs mb-3" id="socTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <asp:LinkButton ID="tabQueue" runat="server" CssClass="nav-link active" OnClick="SwitchTab" CommandArgument="Queue">
                <i class="bi bi-inbox me-1"></i>Queue <span class="badge bg-primary ms-1" id="badgeQueue" runat="server">0</span>
            </asp:LinkButton>
        </li>
        <li class="nav-item" role="presentation">
            <asp:LinkButton ID="tabResolved" runat="server" CssClass="nav-link" OnClick="SwitchTab" CommandArgument="Resolved">
                <i class="bi bi-check-circle me-1"></i>Resolved <span class="badge bg-success ms-1" id="badgeResolved" runat="server">0</span>
            </asp:LinkButton>
        </li>
        <li class="nav-item" role="presentation">
            <asp:LinkButton ID="tabAll" runat="server" CssClass="nav-link" OnClick="SwitchTab" CommandArgument="All">
                <i class="bi bi-list-ul me-1"></i>All Complaints
            </asp:LinkButton>
        </li>
    </ul>

    <%-- Queue Tab --%>
    <asp:Panel ID="pnlQueue" runat="server" CssClass="card border-0 shadow-sm">
        <div class="card-body p-0">
            <asp:Panel ID="panelQueueEmpty" runat="server" Visible="false" CssClass="text-center py-4">
                <i class="bi bi-check2-all text-success" style="font-size: 36px;"></i>
                <p class="text-muted mt-2 mb-0">No complaints waiting in queue.</p>
            </asp:Panel>
            <asp:GridView ID="gvQueue" runat="server" AutoGenerateColumns="false"
                CssClass="table table-hover mb-0" GridLines="None" DataKeyNames="ComplaintId"
                OnRowCommand="gvQueue_RowCommand">
                <Columns>
                    <asp:TemplateField HeaderText="ID" ItemStyle-Width="160">
                        <ItemTemplate><a href='<%# "ComplaintDetail.aspx?id=" + Eval("ComplaintId") %>' class="fw-semibold text-decoration-none"><%# Eval("ComplaintId") %></a></ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Title" HeaderText="Title" />
                    <asp:TemplateField HeaderText="Priority" ItemStyle-Width="80">
                        <ItemTemplate><span class="badge w-100 priority-<%# Eval("Priority") %>"><%# Eval("Priority") %></span></ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="UnitName" HeaderText="Unit" ItemStyle-Width="130" />
                    <asp:BoundField DataField="CategoryName" HeaderText="Category" ItemStyle-Width="120" />
                    <asp:BoundField DataField="CreatedByName" HeaderText="Created By" ItemStyle-Width="130" />
                    <asp:BoundField DataField="CreatedDate" HeaderText="Created" ItemStyle-Width="120" DataFormatString="{0:dd MMM yyyy}" />
                    <asp:TemplateField HeaderText="Action" ItemStyle-Width="100">
                        <ItemTemplate>
                            <asp:Button ID="btnQueueAssign" runat="server" Text="Assign" CssClass="btn btn-sm btn-primary"
                                CommandName="Assign" CommandArgument='<%# Eval("ComplaintId") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </asp:Panel>

    <%-- Resolved Tab --%>
    <asp:Panel ID="pnlResolved" runat="server" Visible="false" CssClass="card border-0 shadow-sm">
        <div class="card-body p-0">
            <asp:Panel ID="panelResolvedEmpty" runat="server" Visible="false" CssClass="text-center py-4">
                <i class="bi bi-check2-all text-success" style="font-size: 36px;"></i>
                <p class="text-muted mt-2 mb-0">No resolved complaints awaiting closure.</p>
            </asp:Panel>
            <asp:GridView ID="gvResolved" runat="server" AutoGenerateColumns="false"
                CssClass="table table-hover mb-0" GridLines="None" DataKeyNames="ComplaintId"
                OnRowCommand="gvResolved_RowCommand">
                <Columns>
                    <asp:TemplateField HeaderText="ID" ItemStyle-Width="160">
                        <ItemTemplate><a href='<%# "ComplaintDetail.aspx?id=" + Eval("ComplaintId") %>' class="fw-semibold text-decoration-none"><%# Eval("ComplaintId") %></a></ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Title" HeaderText="Title" />
                    <asp:TemplateField HeaderText="Priority" ItemStyle-Width="80">
                        <ItemTemplate><span class="badge w-100 priority-<%# Eval("Priority") %>"><%# Eval("Priority") %></span></ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="UnitName" HeaderText="Unit" ItemStyle-Width="130" />
                    <asp:BoundField DataField="AssignedToName" HeaderText="Engineer" ItemStyle-Width="130" />
                    <asp:BoundField DataField="LastUpdate" HeaderText="Resolved" ItemStyle-Width="120" DataFormatString="{0:dd MMM yyyy}" />
                    <asp:TemplateField HeaderText="Action" ItemStyle-Width="100">
                        <ItemTemplate>
                            <asp:Button ID="btnResolvedClose" runat="server" Text="Close" CssClass="btn btn-sm btn-success"
                                CommandName="Close" CommandArgument='<%# Eval("ComplaintId") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </asp:Panel>

    <%-- All Tab --%>
    <asp:Panel ID="pnlAll" runat="server" Visible="false" CssClass="card border-0 shadow-sm">
        <div class="card-body">
            <div class="row g-2 mb-3">
                <div class="col-md-3">
                    <label class="form-label small">Status</label>
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="FilterAllChanged">
                        <asp:ListItem Text="All" Value="" />
                        <asp:ListItem Text="New" Value="New" />
                        <asp:ListItem Text="Assigned" Value="Assigned" />
                        <asp:ListItem Text="In Progress" Value="In Progress" />
                        <asp:ListItem Text="Resolved" Value="Resolved" />
                        <asp:ListItem Text="Closed" Value="Closed" />
                        <asp:ListItem Text="Reopened" Value="Reopened" />
                    </asp:DropDownList>
                </div>
                <div class="col-md-2">
                    <label class="form-label small">Priority</label>
                    <asp:DropDownList ID="ddlPriority" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="FilterAllChanged">
                        <asp:ListItem Text="All" Value="" />
                        <asp:ListItem Text="Low" Value="Low" />
                        <asp:ListItem Text="Medium" Value="Medium" />
                        <asp:ListItem Text="High" Value="High" />
                        <asp:ListItem Text="Critical" Value="Critical" />
                    </asp:DropDownList>
                </div>
                <div class="col-md-4">
                    <label class="form-label small">Search</label>
                    <div class="input-group">
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="ID or title..." />
                        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-outline-primary" OnClick="btnSearch_Click" />
                    </div>
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-outline-secondary w-100" OnClick="btnClear_Click" />
                </div>
                <div class="col-md-1 d-flex align-items-end">
                    <asp:LinkButton ID="btnRefresh" runat="server" CssClass="btn btn-outline-primary" OnClick="FilterAllChanged"><i class="bi bi-arrow-clockwise"></i></asp:LinkButton>
                </div>
            </div>
            <asp:GridView ID="gvAll" runat="server" AutoGenerateColumns="false"
                CssClass="table table-hover mb-0" GridLines="None" AllowPaging="true" AllowCustomPaging="true"
                PageSize="15" OnPageIndexChanging="gvAll_PageIndexChanging" OnRowDataBound="gvAll_RowDataBound"
                PagerStyle-CssClass="table-pager" PagerSettings-Position="Bottom">
                <Columns>
                    <asp:TemplateField HeaderText="ID" ItemStyle-Width="160">
                        <ItemTemplate><a href='<%# "ComplaintDetail.aspx?id=" + Eval("ComplaintId") %>' class="fw-semibold text-decoration-none"><%# Eval("ComplaintId") %></a></ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Title" HeaderText="Title" />
                    <asp:TemplateField HeaderText="Priority" ItemStyle-Width="70">
                        <ItemTemplate><span class="badge w-100 priority-<%# Eval("Priority") %>"><%# Eval("Priority") %></span></ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Status" ItemStyle-Width="90">
                        <ItemTemplate><span class="badge w-100 status-<%# Eval("Status").ToString().Replace(" ", "") %>"><%# Eval("Status") %></span></ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="UnitName" HeaderText="Unit" ItemStyle-Width="120" />
                    <asp:BoundField DataField="AssignedToName" HeaderText="Engineer" ItemStyle-Width="120" />
                    <asp:BoundField DataField="CreatedDate" HeaderText="Created" ItemStyle-Width="110" DataFormatString="{0:dd MMM yy}" />
                </Columns>
                <PagerSettings Mode="NumericFirstLast" PageButtonCount="5" FirstPageText="&laquo;" LastPageText="&raquo;" />
                <PagerStyle CssClass="table-pager" HorizontalAlign="Center" />
            </asp:GridView>
        </div>
    </asp:Panel>

    <%-- Assign Modal --%>
    <div class="modal fade" id="assignModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Assign Complaint</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p class="small text-muted" id="assignComplaintId" runat="server"></p>
                    <div class="mb-3">
                        <label class="form-label">Engineer</label>
                        <asp:DropDownList ID="ddlEngineer" runat="server" CssClass="form-select"
                            DataTextField="FullName" DataValueField="EmpCode" AppendDataBoundItems="true">
                            <asp:ListItem Text="-- Select --" Value="" />
                        </asp:DropDownList>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Note <span class="text-muted">(optional)</span></label>
                        <asp:TextBox ID="txtAssignNote" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnConfirmAssign" runat="server" Text="Assign" CssClass="btn btn-primary" OnClick="btnConfirmAssign_Click" />
                </div>
            </div>
        </div>
    </div>

    <%-- Close Modal --%>
    <div class="modal fade" id="closeModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Close Complaint</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p class="small text-muted" id="closeComplaintId" runat="server"></p>
                    <div class="mb-3">
                        <label class="form-label">Closure Reason <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtCloseReason" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnConfirmClose" runat="server" Text="Close" CssClass="btn btn-success" OnClick="btnConfirmClose_Click" />
                </div>
            </div>
        </div>
    </div>

    <asp:HiddenField ID="hfActionComplaintId" runat="server" />

    <style>
        .badge.priority-Critical { background: #7c1d0e; color: #fff; }
        .badge.priority-High { background: #dc3545; color: #fff; }
        .badge.priority-Medium { background: #ffc107; color: #000; }
        .badge.priority-Low { background: #198754; color: #fff; }
        .badge.status-New { background: #0d6efd; color: #fff; }
        .badge.status-Assigned { background: #6f42c1; color: #fff; }
        .badge.status-InProgress { background: #ffc107; color: #000; }
        .badge.status-Resolved { background: #198754; color: #fff; }
        .badge.status-Closed { background: #6c757d; color: #fff; }
        .badge.status-Reopened { background: #dc3545; color: #fff; }
        .badge.status-Hold { background: #212529; color: #fff; }
        .table-pager { padding: 12px; background: #f8f9fa; border-top: 1px solid #dee2e6; }
        .table-pager a { padding: 4px 10px; margin: 0 2px; border: 1px solid #dee2e6; border-radius: 4px; text-decoration: none; color: #0d6efd; }
        .table-pager span { padding: 4px 10px; margin: 0 2px; border: 1px solid #0d6efd; border-radius: 4px; background: #0d6efd; color: #fff; font-weight: 600; }
        .table-pager td { padding: 0; }
    </style>
</asp:Content>
