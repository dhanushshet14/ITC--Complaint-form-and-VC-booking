<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="WebFormDemo.Dashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        <asp:Label runat="server" ID="lblWelcome"></asp:Label>
        <br />
        </div>
        <div>
        <asp:Button  runat="server" Id="btnCreateVCRequest" OnClick="btnClick_createVCRequest" Text="Create VCRequest" />
        <asp:Button runat="server" ID="btnViewRequests" OnClick="btnClick_viewRequests" Text="View Requests" />
        <asp:Button runat="server" ID="btnLogOut" OnClick="btnClick_LogOut" Text="Log Out"/>
        </div>
    </form>
</body>
</html>
