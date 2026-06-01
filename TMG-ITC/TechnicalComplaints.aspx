<%@ Page Title="Technical Complaints" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="TechnicalComplaints.aspx.cs" Inherits="TMG_ITC.TechnicalComplaints" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-body">
            <div class="row g-2 align-items-end">
                <div class="col-md-3">
                    <label class="form-label small">Status</label>
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged">
                        <asp:ListItem Text="All Statuses" Value="" />
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
                    <asp:DropDownList ID="ddlPriority" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged">
                        <asp:ListItem Text="All Priorities" Value="" />
                        <asp:ListItem Text="Low" Value="Low" />
                        <asp:ListItem Text="Medium" Value="Medium" />
                        <asp:ListItem Text="High" Value="High" />
                        <asp:ListItem Text="Critical" Value="Critical" />
                    </asp:DropDownList>
                </div>
                <div class="col-md-4">
                    <label class="form-label small">Search</label>
                    <div class="input-group">
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control"
                            placeholder="Complaint ID or title..." />
                        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-outline-primary"
                            OnClick="btnSearch_Click" />
                    </div>
                </div>
                <div class="col-md-2">
                    <asp:Button ID="btnClear" runat="server" Text="Clear Filters" CssClass="btn btn-outline-secondary w-100"
                        OnClick="btnClear_Click" />
                </div>
                <div class="col-md-1 text-end">
                    <asp:LinkButton ID="btnRefresh" runat="server" CssClass="btn btn-outline-primary"
                        OnClick="FilterChanged" title="Refresh">
                        <i class="bi bi-arrow-clockwise"></i>
                    </asp:LinkButton>
                </div>
            </div>
        </div>
    </div>

    <div class="card border-0 shadow-sm">
        <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
            <h5 class="mb-0"><i class="bi bi-laptop me-2"></i>Technical Complaints</h5>
            <a href="ComplaintCreation.aspx" class="btn btn-sm btn-primary">
                <i class="bi bi-plus-circle"></i> New Complaint
            </a>
        </div>
        <div class="card-body p-0">
            <asp:Panel ID="panelEmpty" runat="server" Visible="false" CssClass="text-center py-5">
                <i class="bi bi-inbox text-muted" style="font-size: 48px;"></i>
                <p class="text-muted mt-2 mb-0">No complaints found matching your criteria.</p>
            </asp:Panel>

            <asp:GridView ID="gvComplaints" runat="server" AutoGenerateColumns="false"
                CssClass="table table-hover mb-0" GridLines="None"
                AllowPaging="true" AllowCustomPaging="true"
                PageSize="15" PagerSettings-Position="Bottom"
                OnPageIndexChanging="gvComplaints_PageIndexChanging"
                OnRowDataBound="gvComplaints_RowDataBound"
                PagerStyle-CssClass="table-pager">
                <Columns>
                    <asp:TemplateField HeaderText="ID" ItemStyle-Width="180">
                        <ItemTemplate>
                            <a href='<%# "ComplaintDetail.aspx?id=" + Eval("ComplaintId") %>'
                                class="fw-semibold text-decoration-none">
                                <%# Eval("ComplaintId") %>
                            </a>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Title" HeaderText="Title" />
                    <asp:TemplateField HeaderText="Priority" ItemStyle-Width="90">
                        <ItemTemplate>
                            <span class="badge priority-<%# Eval("Priority") %> w-100">
                                <%# Eval("Priority") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Status" ItemStyle-Width="110">
                        <ItemTemplate>
                            <span class="badge status-<%# Eval("Status").ToString().Replace(" ", "") %> w-100">
                                <%# Eval("Status") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="UnitName" HeaderText="Unit" ItemStyle-Width="140" />
                    <asp:BoundField DataField="CategoryName" HeaderText="Category" ItemStyle-Width="140" />
                    <asp:BoundField DataField="AssignedToName" HeaderText="Assigned To" ItemStyle-Width="140" />
                    <asp:BoundField DataField="CreatedDate" HeaderText="Created" ItemStyle-Width="140"
                        DataFormatString="{0:dd MMM yyyy}" />
                    <asp:BoundField DataField="LastUpdate" HeaderText="Updated" ItemStyle-Width="140"
                        DataFormatString="{0:dd MMM yyyy}" />
                </Columns>
                <PagerSettings Mode="NumericFirstLast" PageButtonCount="5"
                    FirstPageText="&laquo;" LastPageText="&raquo;"
                    NextPageText="&gt;" PreviousPageText="&lt;" />
                <PagerStyle CssClass="table-pager" HorizontalAlign="Center" />
            </asp:GridView>
        </div>
    </div>

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

        .table-pager { padding: 12px; background: #f8f9fa; border-top: 1px solid #dee2e6; }
        .table-pager a { padding: 4px 10px; margin: 0 2px; border: 1px solid #dee2e6; border-radius: 4px; text-decoration: none; color: #0d6efd; }
        .table-pager span { padding: 4px 10px; margin: 0 2px; border: 1px solid #0d6efd; border-radius: 4px; background: #0d6efd; color: #fff; font-weight: 600; }
        .table-pager td { padding: 0; }
    </style>
</asp:Content>
