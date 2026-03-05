<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EmployeeDashboard.aspx.cs" Inherits="VCBooking.Dashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Employee Dashboard</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>

    <style>
        body {
            background-color: #f5f7fa;
        }

        .dashboard-card {
            width: 450px;
            margin: 120px auto;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            background: white;
            text-align: center;
        }

        .dashboard-title {
            font-size: 26px;
            font-weight: 600;
            margin-bottom: 20px;
        }

        .dashboard-buttons .btn {
            width: 100%;
            margin-top: 10px;
        }
    </style>

</head>

<body>

<form id="form1" runat="server">

    <div class="dashboard-card">

        <div class="dashboard-title">
            Welcome,
            <asp:Label runat="server" ID="lblWelcome"></asp:Label>
        </div>

        <div class="dashboard-buttons">

            <asp:Button runat="server"
                ID="btnCreateVCRequest"
                CssClass="btn btn-primary"
                Text="Create VC Request"
                OnClick="btnClick_createVCRequest" />

            <asp:Button runat="server"
                ID="btnViewRequests"
                CssClass="btn btn-success"
                Text="View My Requests"
                OnClick="btnClick_viewRequests" />

            <asp:Button runat="server"
                ID="btnLogOut"
                CssClass="btn btn-danger"
                Text="Logout"
                OnClick="btnClick_LogOut" />

        </div>

    </div>

</form>

</body>
</html>