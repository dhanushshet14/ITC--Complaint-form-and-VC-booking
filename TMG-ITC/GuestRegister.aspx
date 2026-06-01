<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="GuestRegister.aspx.cs" Inherits="TMG_ITC.GuestRegister" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>IT Helpdesk - Guest Registration</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body { background: linear-gradient(135deg, #1a237e 0%, #283593 50%, #3949ab 100%); min-height: 100vh; }
        .register-card { border: none; border-radius: 12px; overflow: hidden; max-width: 520px; }
        .register-header { background: #1a237e; color: white; padding: 20px 24px; text-align: center; }
        .register-body { padding: 28px 32px; }
        .form-control:focus { border-color: #3949ab; box-shadow: 0 0 0 0.2rem rgba(57, 73, 171, 0.25); }
        .brand-text { font-size: 13px; color: #6c757d; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container d-flex justify-content-center align-items-center min-vh-100 py-4">
            <div class="card shadow-lg register-card">
                <div class="register-header">
                    <h5 class="mb-1">Guest Registration</h5>
                    <p class="mb-0" style="font-size: 13px; opacity: 0.8;">Create an account to submit complaints</p>
                </div>
                <div class="register-body">
                    <asp:Panel ID="pnlForm" runat="server" Visible="true">
                        <div class="mb-3">
                            <label class="form-label fw-semibold small">Full Name <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Enter your full name" />
                            <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" CssClass="text-danger small" Display="Dynamic" Text="Name is required" />
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold small">Email <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Enter your email" TextMode="Email" />
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" CssClass="text-danger small" Display="Dynamic" Text="Email is required" />
                            <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" CssClass="text-danger small" Display="Dynamic"
                                ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Text="Invalid email format" />
                        </div>

                        <div class="row g-2 mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold small">Mobile</label>
                                <asp:TextBox ID="txtMobile" runat="server" CssClass="form-control" placeholder="Phone number" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold small">Department</label>
                                <asp:TextBox ID="txtDepartment" runat="server" CssClass="form-control" placeholder="Department name" />
                            </div>
                        </div>

                        <div class="row g-2 mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold small">Designation</label>
                                <asp:TextBox ID="txtDesignation" runat="server" CssClass="form-control" placeholder="Job title" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold small">Location</label>
                                <asp:TextBox ID="txtLocation" runat="server" CssClass="form-control" placeholder="Office location" />
                            </div>
                        </div>

                        <div class="row g-2 mb-3">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold small">Password <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Min 6 characters" />
                                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" CssClass="text-danger small" Display="Dynamic" Text="Password is required" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold small">Confirm Password <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Re-enter password" />
                                <asp:RequiredFieldValidator ID="rfvConfirm" runat="server" ControlToValidate="txtConfirmPassword" CssClass="text-danger small" Display="Dynamic" Text="Confirm password" />
                                <asp:CompareValidator ID="cvPasswords" runat="server" ControlToCompare="txtPassword" ControlToValidate="txtConfirmPassword" CssClass="text-danger small" Display="Dynamic" Text="Passwords do not match" />
                            </div>
                        </div>

                        <asp:Label ID="lblMessage" runat="server" CssClass="d-block mb-3" Visible="false" />

                        <asp:Button ID="btnRegister" runat="server" Text="Create Account" CssClass="btn btn-primary w-100 py-2 fw-semibold" OnClick="btnRegister_Click" />

                        <div class="text-center mt-3">
                            <small>Already have an account? <a href="Login.aspx" class="text-decoration-none fw-semibold">Sign in</a></small>
                        </div>
                        <div class="text-center mt-2">
                            <small class="brand-text">&copy; Manipal Group - Information Technology Division</small>
                        </div>
                    </asp:Panel>

                    <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="text-center py-4">
                        <i class="bi bi-check-circle text-success" style="font-size: 48px;"></i>
                        <h5 class="mt-3 mb-2">Registration Successful!</h5>
                        <p class="text-muted small mb-3" id="successMessage" runat="server">Your account has been created.</p>
                        <a href="Login.aspx" class="btn btn-primary">Sign In</a>
                    </asp:Panel>
                </div>
            </div>
        </div>
    </form>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet" />
</body>
</html>
