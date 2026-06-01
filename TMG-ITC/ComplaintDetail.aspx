<%@ Page Title="Complaint Detail" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="ComplaintDetail.aspx.cs" Inherits="TMG_ITC.ComplaintDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Panel ID="panelError" runat="server" Visible="false">
        <div class="alert alert-danger">
            <asp:Literal ID="litError" runat="server" />
        </div>
        <a href="Dashboard.aspx" class="btn btn-outline-secondary">Back to Dashboard</a>
    </asp:Panel>

    <asp:Panel ID="panelDetail" runat="server" Visible="false">

        <div class="d-flex justify-content-between align-items-start mb-4">
            <div>
                <a href="javascript:history.back()" class="text-decoration-none text-muted small mb-2 d-inline-block">
                    <i class="bi bi-arrow-left"></i> Back
                </a>
                <h3 class="mb-1" id="lblComplaintId" runat="server"></h3>
                <h5 class="text-muted fw-normal" id="lblTitle" runat="server"></h5>
            </div>
            <div class="d-flex gap-2">
                <span class="badge fs-6 priority-<%= CurrentPriority %>" id="badgePriority" runat="server">
                    <asp:Literal ID="litPriority" runat="server" />
                </span>
                <span class="badge fs-6 status-<%= CurrentStatus %>" id="badgeStatus" runat="server">
                    <asp:Literal ID="litStatus" runat="server" />
                </span>
            </div>
        </div>

        <div class="row g-4 mb-4">
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-sm-6">
                                <small class="text-muted d-block">Request Type</small>
                                <strong id="lblRequestType" runat="server"></strong>
                            </div>
                            <div class="col-sm-6">
                                <small class="text-muted d-block">Complaint Type</small>
                                <strong id="lblComplaintType" runat="server"></strong>
                            </div>
                            <div class="col-sm-6">
                                <small class="text-muted d-block">Unit</small>
                                <strong id="lblUnit" runat="server"></strong>
                            </div>
                            <div class="col-sm-6">
                                <small class="text-muted d-block">Category</small>
                                <strong id="lblCategory" runat="server"></strong>
                            </div>
                            <div class="col-sm-6" id="rowSubCategory" runat="server" visible="false">
                                <small class="text-muted d-block">Sub Category</small>
                                <strong id="lblSubCategory" runat="server"></strong>
                            </div>
                            <div class="col-sm-6">
                                <small class="text-muted d-block">Created By</small>
                                <strong id="lblCreatedBy" runat="server"></strong>
                            </div>
                            <div class="col-sm-6">
                                <small class="text-muted d-block">Assigned To</small>
                                <strong id="lblAssignedTo" runat="server">—</strong>
                            </div>
                            <div class="col-sm-6">
                                <small class="text-muted d-block">Created</small>
                                <strong id="lblCreatedDate" runat="server"></strong>
                            </div>
                            <div class="col-sm-6">
                                <small class="text-muted d-block">Last Updated</small>
                                <strong id="lblLastUpdate" runat="server"></strong>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="card border-0 shadow-sm h-100">
                    <div class="card-body d-flex flex-column justify-content-between">
                        <div>
                            <small class="text-muted d-block mb-1">SLA Status</small>
                            <div class="d-flex align-items-center gap-2 mb-1">
                                <i class="bi bi-clock-history fs-4 <%= SlaClass %>"></i>
                                <span class="fw-bold <%= SlaClass %>" id="lblSlaText" runat="server"></span>
                            </div>
                            <small class="text-muted" id="lblSlaCreated" runat="server"></small>
                        </div>
                        <div class="mt-3">
                            <div class="progress" style="height: 6px;">
                                <div id="slaProgress" runat="server" class="progress-bar" role="progressbar"
                                    style="width: 0%;" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%-- Status Stepper --%>
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-body">
                <div class="stepper d-flex justify-content-between" id="stepper" runat="server">
                    <div class="step" id="stepNew" runat="server">
                        <div class="step-circle">1</div>
                        <div class="step-label">New</div>
                    </div>
                    <div class="step-connector" id="conn1" runat="server"></div>
                    <div class="step" id="stepAssigned" runat="server">
                        <div class="step-circle">2</div>
                        <div class="step-label">Assigned</div>
                    </div>
                    <div class="step-connector" id="conn2" runat="server"></div>
                    <div class="step" id="stepAccepted" runat="server">
                        <div class="step-circle">3</div>
                        <div class="step-label">Accepted</div>
                    </div>
                    <div class="step-connector" id="conn2b" runat="server"></div>
                    <div class="step" id="stepInProgress" runat="server">
                        <div class="step-circle">4</div>
                        <div class="step-label">In Progress</div>
                    </div>
                    <div class="step-connector" id="conn3" runat="server"></div>
                    <div class="step" id="stepResolved" runat="server">
                        <div class="step-circle">5</div>
                        <div class="step-label">Resolved</div>
                    </div>
                    <div class="step-connector" id="conn4" runat="server"></div>
                    <div class="step" id="stepClosed" runat="server">
                        <div class="step-circle">6</div>
                        <div class="step-label">Closed</div>
                    </div>
                </div>
            </div>
        </div>

        <%-- Action Buttons --%>
        <div class="d-flex gap-2 flex-wrap mb-4" id="actionBar" runat="server">
            <asp:Button ID="btnAssign" runat="server" Text="Assign" CssClass="btn btn-primary"
                OnClick="btnAssign_Click" Visible="false" />
            <asp:Button ID="btnAccept" runat="server" Text="Accept" CssClass="btn btn-success"
                OnClick="btnAccept_Click" Visible="false" />
            <asp:Button ID="btnMarkInProgress" runat="server" Text="Mark In Progress" CssClass="btn btn-warning"
                OnClick="btnMarkInProgress_Click" Visible="false" />
            <asp:Button ID="btnTransfer" runat="server" Text="Transfer" CssClass="btn btn-info text-white"
                OnClick="btnTransfer_Click" Visible="false" />
            <asp:Button ID="btnResolve" runat="server" Text="Resolve" CssClass="btn btn-success"
                OnClick="btnResolve_Click" Visible="false" />
            <asp:Button ID="btnClose" runat="server" Text="Close" CssClass="btn btn-secondary"
                OnClick="btnClose_Click" Visible="false" />
            <asp:Button ID="btnReopen" runat="server" Text="Reopen" CssClass="btn btn-danger"
                OnClick="btnReopen_Click" Visible="false" />
            <asp:Button ID="btnHold" runat="server" Text="Hold" CssClass="btn btn-dark"
                OnClick="btnHold_Click" Visible="false" />
            <asp:Button ID="btnResume" runat="server" Text="Resume" CssClass="btn btn-outline-dark"
                OnClick="btnResume_Click" Visible="false" />
            <asp:Button ID="btnAddNote" runat="server" Text="Add Note" CssClass="btn btn-outline-primary"
                OnClick="btnAddNote_Click" />
        </div>

        <%-- Hold Banner --%>
        <asp:Panel ID="panelHoldBanner" runat="server" Visible="false" CssClass="card border-0 shadow-sm mb-4 border-start border-dark border-4 bg-light">
            <div class="card-body">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-pause-circle text-dark fs-5"></i>
                    <strong>On Hold</strong>
                    <span class="ms-2 text-muted" id="lblHoldReason" runat="server"></span>
                </div>
            </div>
        </asp:Panel>

        <%-- Customer Impact --%>
        <asp:Panel ID="panelCustomerImpact" runat="server" Visible="false" CssClass="card border-0 shadow-sm mb-4 border-start border-danger border-4">
            <div class="card-body">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-person-fill-exclamation text-danger fs-5"></i>
                    <strong>Customer Impact</strong>
                    <span class="ms-2" id="lblCustomerName" runat="server"></span>
                </div>
            </div>
        </asp:Panel>

        <%-- Description --%>
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-white py-3">
                <h6 class="mb-0">Description</h6>
            </div>
            <div class="card-body">
                <p class="mb-0 text-pre-wrap" id="lblDescription" runat="server"></p>
            </div>
        </div>

        <%-- Timeline --%>
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-white py-3">
                <h6 class="mb-0"><i class="bi bi-chat-dots me-2"></i>Activity Timeline</h6>
            </div>
            <div class="card-body">
                <asp:Panel ID="panelNoUpdates" runat="server" Visible="false" CssClass="text-center py-3">
                    <p class="text-muted mb-0">No activity recorded yet.</p>
                </asp:Panel>
                <div class="timeline" id="timeline" runat="server">
                </div>
            </div>
        </div>

        <%-- Attachments --%>
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-header bg-white py-3">
                <h6 class="mb-0"><i class="bi bi-paperclip me-2"></i>Attachments</h6>
            </div>
            <div class="card-body">
                <asp:Panel ID="panelNoAttachments" runat="server" Visible="false" CssClass="text-center py-3">
                    <p class="text-muted mb-0">No attachments.</p>
                </asp:Panel>
                <div class="row g-2" id="attachmentsContainer" runat="server">
                </div>
            </div>
        </div>

    </asp:Panel>

    <%-- MODALS --%>

    <%-- Assign Modal --%>
    <div class="modal fade" id="assignModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Assign Complaint</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Assign to Engineer</label>
                        <asp:DropDownList ID="ddlAssignEngineer" runat="server" CssClass="form-select"
                            DataTextField="FullName" DataValueField="EmpCode"
                            AppendDataBoundItems="true">
                            <asp:ListItem Text="-- Select Engineer --" Value="" />
                        </asp:DropDownList>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Note <span class="text-muted">(optional)</span></label>
                        <asp:TextBox ID="txtAssignNote" runat="server" CssClass="form-control"
                            TextMode="MultiLine" Rows="3" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnConfirmAssign" runat="server" Text="Assign"
                        CssClass="btn btn-primary" OnClick="btnConfirmAssign_Click" />
                </div>
            </div>
        </div>
    </div>

    <%-- Transfer Modal --%>
    <div class="modal fade" id="transferModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Transfer Complaint</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Transfer to</label>
                        <asp:DropDownList ID="ddlTransferEngineer" runat="server" CssClass="form-select"
                            DataTextField="FullName" DataValueField="EmpCode"
                            AppendDataBoundItems="true">
                            <asp:ListItem Text="-- Select Engineer --" Value="" />
                        </asp:DropDownList>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Reason <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtTransferReason" runat="server" CssClass="form-control"
                            TextMode="MultiLine" Rows="3" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnConfirmTransfer" runat="server" Text="Transfer"
                        CssClass="btn btn-info text-white" OnClick="btnConfirmTransfer_Click" />
                </div>
            </div>
        </div>
    </div>

    <%-- Resolve Modal --%>
    <div class="modal fade" id="resolveModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Resolve Complaint</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Resolution Summary <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtResolveSummary" runat="server" CssClass="form-control"
                            TextMode="MultiLine" Rows="4" placeholder="Describe how the issue was resolved (min 20 chars)" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnConfirmResolve" runat="server" Text="Resolve"
                        CssClass="btn btn-success" OnClick="btnConfirmResolve_Click" />
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
                    <div class="mb-3">
                        <label class="form-label">Closure Reason <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtCloseReason" runat="server" CssClass="form-control"
                            TextMode="MultiLine" Rows="3" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnConfirmClose" runat="server" Text="Close"
                        CssClass="btn btn-secondary" OnClick="btnConfirmClose_Click" />
                </div>
            </div>
        </div>
    </div>

    <%-- Reopen Modal --%>
    <div class="modal fade" id="reopenModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Reopen Complaint</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Reason for Reopening <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtReopenReason" runat="server" CssClass="form-control"
                            TextMode="MultiLine" Rows="3" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnConfirmReopen" runat="server" Text="Reopen"
                        CssClass="btn btn-danger" OnClick="btnConfirmReopen_Click" />
                </div>
            </div>
        </div>
    </div>

    <%-- Hold Modal --%>
    <div class="modal fade" id="holdModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Place Complaint on Hold</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Hold Reason <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtHoldReason" runat="server" CssClass="form-control"
                            TextMode="MultiLine" Rows="3" placeholder="Why is this complaint being put on hold?" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnConfirmHold" runat="server" Text="Put on Hold"
                        CssClass="btn btn-dark" OnClick="btnConfirmHold_Click" />
                </div>
            </div>
        </div>
    </div>

    <%-- Resume Modal --%>
    <div class="modal fade" id="resumeModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Resume Complaint from Hold</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Resume Notes <span class="text-muted">(optional)</span></label>
                        <asp:TextBox ID="txtResumeNotes" runat="server" CssClass="form-control"
                            TextMode="MultiLine" Rows="3" placeholder="Any notes about resuming this complaint..." />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnConfirmResume" runat="server" Text="Resume"
                        CssClass="btn btn-outline-dark" OnClick="btnConfirmResume_Click" />
                </div>
            </div>
        </div>
    </div>

    <%-- Work Note Modal --%>
    <div class="modal fade" id="noteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add Work Note</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Note <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtNote" runat="server" CssClass="form-control"
                            TextMode="MultiLine" Rows="4" placeholder="Enter your work note..." />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnConfirmNote" runat="server" Text="Add Note"
                        CssClass="btn btn-primary" OnClick="btnConfirmNote_Click" />
                </div>
            </div>
        </div>
    </div>

    <style>
        .text-pre-wrap { white-space: pre-wrap; }

        .step { display: flex; flex-direction: column; align-items: center; flex: 1; }
        .step-circle {
            width: 36px; height: 36px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 14px;
            background: #e9ecef; color: #6c757d;
            border: 2px solid #dee2e6; transition: all 0.3s;
        }
        .step.active .step-circle {
            background: #0d6efd; color: #fff; border-color: #0d6efd;
        }
        .step.completed .step-circle {
            background: #198754; color: #fff; border-color: #198754;
        }
        .step-label { font-size: 12px; margin-top: 6px; color: #6c757d; font-weight: 500; }
        .step.active .step-label { color: #0d6efd; font-weight: 600; }
        .step.completed .step-label { color: #198754; font-weight: 600; }
        .step-connector {
            flex: 1; height: 2px; background: #dee2e6;
            align-self: center; margin: 0 4px; margin-bottom: 24px;
        }
        .step-connector.completed { background: #198754; }
        .step-connector.active { background: #0d6efd; }

        .timeline { position: relative; padding-left: 30px; }
        .timeline::before {
            content: ''; position: absolute; left: 10px; top: 0; bottom: 0;
            width: 2px; background: #e9ecef;
        }
        .timeline-item { position: relative; margin-bottom: 20px; }
        .timeline-icon {
            position: absolute; left: -22px; top: 2px;
            width: 24px; height: 24px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            font-size: 12px; color: #fff; z-index: 1;
        }
        .timeline-icon.New, .timeline-icon.Reopen { background: #0d6efd; }
        .timeline-icon.Assign { background: #6f42c1; }
        .timeline-icon.Accept { background: #20c997; }
        .timeline-icon.Update { background: #6c757d; }
        .timeline-icon.Resolve { background: #198754; }
        .timeline-icon.Close { background: #dc3545; }
        .timeline-icon.Hold { background: #212529; }
        .timeline-icon.Resume { background: #0dcaf0; }

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
    </style>
</asp:Content>
