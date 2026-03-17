<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="VCBooking.AdminDashboard" Async="true" %>

    <!DOCTYPE html>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <html xmlns="http://www.w3.org/1999/xhtml">

    <head runat="server">
        <title></title>
    </head>

    <body>
        <form id="form1" runat="server">
            <div>
                <asp:GridView ID="gvMeetings" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered"
                    OnRowCommand="gvMeetings_RowCommand">

                    <Columns>
                        <asp:BoundField DataField="VCId" HeaderText="VC ID" />
                        <asp:BoundField DataField="Topic" HeaderText="Topic" />
                        <asp:BoundField DataField="CreatedBy" HeaderText="Created By" />
                        <asp:BoundField DataField="VCDate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:BoundField DataField="VCStatus" HeaderText="Status" />

                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:Button ID="btnReschedule" runat="server" Text="Reschedule"
                                    CommandName="RescheduleMeeting" CommandArgument='<%# Eval("VCId") %>'
                                    CssClass="btn btn-primary btn-sm" />
                                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CommandName="CancelMeeting"
                                    CommandArgument='<%# Eval("VCId") %>' CssClass="btn btn-warning btn-sm" />
                                <asp:Button ID="btnDelete" runat="server" Text="Delete" CommandName="DeleteMeeting"
                                    CommandArgument='<%# Eval("VCId") %>' CssClass="btn btn-danger btn-sm"
                                    OnClientClick="return confirm('Are you sure you want to permanently delete this record?');" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

                <!-- Cancellation Panel -->
                <asp:Panel ID="pnlCancel" runat="server" Visible="false"
                    CssClass="card p-3 mt-3 shadow-sm border-warning">
                    <asp:HiddenField ID="hfCancelVCId" runat="server" />
                    <h5 class="card-title text-warning">Cancel Meeting</h5>
                    <div class="mb-3">
                        <label class="form-label">Reason for Cancellation:</label>
                        <asp:TextBox ID="txtCancelReason" runat="server" TextMode="MultiLine" CssClass="form-control"
                            Rows="3" placeholder="Enter reason..."></asp:TextBox>
                    </div>
                    <div class="d-flex gap-2">
                        <asp:Button ID="btnConfirmCancel" runat="server" Text="Confirm Cancellation"
                            CssClass="btn btn-warning" OnClick="btnConfirmCancel_Click" />
                        <asp:Button ID="btnCancelPopup" runat="server" Text="Back" CssClass="btn btn-outline-secondary"
                            OnClick="btnCancelPopup_Click" />
                    </div>
                </asp:Panel>

                <!-- Reschedule Panel -->
                <asp:Panel ID="pnlReschedule" runat="server" Visible="false"
                    CssClass="card p-3 mt-3 shadow-sm border-primary">
                    <asp:HiddenField ID="hfRescheduleVCId" runat="server" />
                    <h5 class="card-title text-primary">Reschedule Meeting</h5>
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label">New Date:</label>
                            <asp:TextBox ID="txtNewDate" runat="server" TextMode="Date" CssClass="form-control">
                            </asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">New Start Time:</label>
                            <asp:TextBox ID="txtNewFromTime" runat="server" TextMode="Time" CssClass="form-control">
                            </asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">New End Time:</label>
                            <asp:TextBox ID="txtNewToTime" runat="server" TextMode="Time" CssClass="form-control">
                            </asp:TextBox>
                        </div>
                        <div class="col-12">
                            <label class="form-label">Reason for Reschedule:</label>
                            <asp:TextBox ID="txtRescheduleReason" runat="server" TextMode="MultiLine"
                                CssClass="form-control" Rows="2" placeholder="Optional..."></asp:TextBox>
                        </div>
                    </div>
                    <div class="mt-3 d-flex gap-2">
                        <asp:Button ID="btnConfirmReschedule" runat="server" Text="Confirm Reschedule"
                            CssClass="btn btn-primary" OnClick="btnConfirmReschedule_Click" />
                        <asp:Button ID="btnRescheduleCancel" runat="server" Text="Back"
                            CssClass="btn btn-outline-secondary" OnClick="btnCancelPopup_Click" />
                    </div>
                </asp:Panel>
            </div>
        </form>
    </body>

    </html>