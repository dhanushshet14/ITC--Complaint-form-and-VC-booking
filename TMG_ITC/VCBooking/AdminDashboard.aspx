<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AdminDashboard.aspx.cs" Inherits="VCBooking.AdminDashboard" %>

<!DOCTYPE html>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:GridView ID="gvMeetings" runat="server" AutoGenerateColumns="False"
                CssClass="table table-bordered"
                OnRowCommand="gvMeetings_RowCommand">

                <Columns>
                    <asp:BoundField DataField="VCId" HeaderText="VC ID" />
                    <asp:BoundField DataField="Topic" HeaderText="Topic" />
                    <asp:BoundField DataField="CreatedBy" HeaderText="Created By" />
                    <asp:BoundField DataField="VCDate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" />
                    <asp:BoundField DataField="VCStatus" HeaderText="Status" />

                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:Button ID="btnDelete" runat="server"
                                Text="Delete"
                                CommandName="DeleteMeeting"
                                CommandArgument='<%# Eval("VCId") %>'
                                CssClass="btn btn-danger btn-sm" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>



            <asp:Panel ID="pnlDelete" runat="server" Visible="false" CssClass="card p-3 mt-3">
                <asp:HiddenField ID="hfVCId" runat="server" />
                <div class="form-group">
                    <label>Reason for Cancellation:</label>
                    <asp:TextBox ID="txtReason" runat="server" TextMode="MultiLine"
                        CssClass="form-control" Rows="3"></asp:TextBox>
                </div>

                <asp:Button ID="btnConfirmDelete" runat="server"
                    Text="Confirm Delete"
                    CssClass="btn btn-danger"
                    OnClick="btnConfirmDelete_Click" />
                <asp:Button ID="btnCancelPopup" runat="server"
                    Text="Cancel"
                    CssClass="btn btn-secondary"
                    OnClick="btnCancelPopup_Click" />
            </asp:Panel>
        </div>
    </form>
</body>
</html>
