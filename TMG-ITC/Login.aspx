<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="TMG_ITC.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>IT Helpdesk - Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { background: linear-gradient(135deg, #1a237e 0%, #283593 50%, #3949ab 100%); min-height: 100vh; }
        .login-card { border: none; border-radius: 12px; overflow: hidden; }
        .login-header { background: #1a237e; color: white; padding: 24px; text-align: center; }
        .login-body { padding: 32px; }
        .form-control:focus { border-color: #3949ab; box-shadow: 0 0 0 0.2rem rgba(57, 73, 171, 0.25); }
        .brand-text { font-size: 14px; color: #6c757d; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container d-flex justify-content-center align-items-center min-vh-100">
            <div class="card shadow-lg login-card" style="width: 420px;">
                <div class="login-header">
                    <h4 class="mb-1">IT Helpdesk</h4>
                    <p class="mb-0" style="font-size: 13px; opacity: 0.8;">Complaint Management System</p>
                </div>
                <div class="login-body">
                    <div class="mb-3">
                        <asp:Label ID="lblUsername" runat="server" Text="Username / Employee Code" CssClass="form-label fw-semibold small" />
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Enter your username" />
                    </div>

                    <div class="mb-4">
                        <asp:Label ID="lblPassword" runat="server" Text="Password" CssClass="form-label fw-semibold small" />
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" placeholder="Enter your password" />
                    </div>

                    <asp:Label ID="lblMessage" runat="server" CssClass="text-danger small d-block mb-3" Visible="false" />

                    <asp:Button ID="btnLogin" runat="server" Text="Sign In" CssClass="btn btn-primary w-100 py-2 fw-semibold" OnClick="btnLogin_Click" />

                    <div class="text-center mt-3">
                        <small>New user? <a href="GuestRegister.aspx" class="text-decoration-none fw-semibold">Register as Guest</a></small>
                    </div>
                    <div class="text-center mt-2">
                        <small class="brand-text">&copy; Manipal Group - Information Technology Division</small>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
