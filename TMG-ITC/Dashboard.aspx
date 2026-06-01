<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="TMG_ITC.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row g-4 mb-4" id="summaryCards" runat="server">
        <div class="col-md-4">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-subtitle text-muted mb-1">Total Complaints</h6>
                            <h2 class="card-text mb-0" id="lblTotal" runat="server">0</h2>
                        </div>
                        <i class="bi bi-ticket-perforated fs-1 text-primary opacity-25"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-subtitle text-muted mb-1">Open</h6>
                            <h2 class="card-text mb-0" id="lblOpen" runat="server">0</h2>
                        </div>
                        <i class="bi bi-exclamation-circle fs-1 text-warning opacity-25"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-subtitle text-muted mb-1">In Progress</h6>
                            <h2 class="card-text mb-0" id="lblInProgress" runat="server">0</h2>
                        </div>
                        <i class="bi bi-arrow-repeat fs-1 text-info opacity-25"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-subtitle text-muted mb-1">Resolved</h6>
                            <h2 class="card-text mb-0" id="lblResolved" runat="server">0</h2>
                        </div>
                        <i class="bi bi-check-circle fs-1 text-success opacity-25"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-subtitle text-muted mb-1">Closed</h6>
                            <h2 class="card-text mb-0" id="lblClosed" runat="server">0</h2>
                        </div>
                        <i class="bi bi-check2-all fs-1 text-secondary opacity-25"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="card-subtitle text-muted mb-1">SLA Breach</h6>
                            <h2 class="card-text mb-0" id="lblSlaBreach" runat="server">0</h2>
                        </div>
                        <i class="bi bi-alarm fs-1 text-danger opacity-25"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-4 mb-4">
        <div class="col-md-6">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-header bg-white py-3">
                    <h6 class="mb-0"><i class="bi bi-lightning me-2"></i>Quick Actions</h6>
                </div>
                <div class="card-body">
                    <div class="d-flex gap-3 flex-wrap">
                        <asp:Button ID="btnComplaints" runat="server" Text="New Complaint" CssClass="btn btn-primary" OnClick="btnComplaints_Click" />
                        <asp:Button ID="btnVCBooking" runat="server" Text="VC Booking" CssClass="btn btn-success" OnClick="btnVCBooking_Click" />
                        <asp:Button ID="btnMyComplaints" runat="server" Text="My Complaints" CssClass="btn btn-outline-primary" OnClick="btnMyComplaints_Click" />
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-header bg-white py-3">
                    <h6 class="mb-0"><i class="bi bi-bar-chart me-2"></i>Status Distribution</h6>
                </div>
                <div class="card-body">
                    <div class="d-flex gap-2 align-items-center">
                        <div class="progress flex-grow-1" style="height: 24px;"
                            title="Open: <%= openPercent %>% | In Progress: <%= inProgressPercent %>% | Resolved: <%= resolvedPercent %>% | Closed: <%= closedPercent %>%">
                            <div class="progress-bar bg-warning" style="width: <%= openPercent %>%"><%= openPercent %>%</div>
                            <div class="progress-bar bg-info" style="width: <%= inProgressPercent %>%"><%= inProgressPercent > 8 ? inProgressPercent.ToString() + "%" : "" %></div>
                            <div class="progress-bar bg-success" style="width: <%= resolvedPercent %>%"><%= resolvedPercent > 8 ? resolvedPercent.ToString() + "%" : "" %></div>
                            <div class="progress-bar bg-secondary" style="width: <%= closedPercent %>%"><%= closedPercent > 8 ? closedPercent.ToString() + "%" : "" %></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="card border-0 shadow-sm">
        <div class="card-header bg-white py-3">
            <div class="d-flex justify-content-between align-items-center">
                <h6 class="mb-0"><i class="bi bi-clock-history me-2"></i>Recent Complaints</h6>
                <a href="TechnicalComplaints.aspx" class="btn btn-sm btn-outline-primary">View All</a>
            </div>
        </div>
        <div class="card-body p-0">
            <asp:Panel ID="panelNoComplaints" runat="server" Visible="false" CssClass="text-center py-4">
                <i class="bi bi-inbox text-muted" style="font-size: 32px;"></i>
                <p class="text-muted mb-0 mt-2">No complaints found.</p>
            </asp:Panel>
            <asp:GridView ID="gvRecent" runat="server" AutoGenerateColumns="false"
                CssClass="table table-hover mb-0" GridLines="None" DataKeyNames="ComplaintId"
                OnRowDataBound="gvRecent_RowDataBound">
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
                    <asp:BoundField DataField="AssignedToName" HeaderText="Engineer" ItemStyle-Width="120" />
                    <asp:BoundField DataField="CreatedDate" HeaderText="Created" ItemStyle-Width="110" DataFormatString="{0:dd MMM yy}" />
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
