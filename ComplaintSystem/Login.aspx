<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="ComplaintSystem.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>The Manipal Group</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta content="Complaint and VC booking - The Manipal Group" name="description" />
    <meta content="GroupIT - The Manipal Group" name="author" />

    <link href="assets/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="assets/css/icons.css" rel="stylesheet" type="text/css" />
    <link href="assets/css/metisMenu.min.css" rel="stylesheet" type="text/css" />
    <link href="assets/css/style.css" rel="stylesheet" type="text/css" />
</head>
<body class="account-body accountbg">
    <form id="frmLogin" runat="server">
        <div class="row vh-100 ">
            <div class="col-12 align-self-center">
                <div class="auth-page">
                    <div class="card auth-card shadow-lg">
                        <div class="card-body">
                            <asp:Panel ID="panLogin" runat="server" DefaultButton="btnLogin" class="px-3">
                                <div class="auth-logo-box">
                                    <a href="#" class="logo logo-admin"><img src="assets/images/logo-sm.png" height="55" alt="logo" class="auth-logo"></a>
                                </div>
                                <div class="text-center auth-logo-text">
                                    <h4 class="mt-0 mb-3 mt-5">Attendance Module - Contract Employees</h4>
                                    <p class="text-muted mb-0">Sign in to continue.</p>
                                </div>
                                <div class="form-group">
                                    <label for="username">Username</label>
                                    <div class="input-group mb-3">
                                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" TextMode="SingleLine" MaxLength="200" ValidationGroup="Login" placeholder="Enter username"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="userpassword">Password</label>
                                    <div class="input-group mb-3">
                                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" MaxLength="200" ValidationGroup="Login" placeholder="Enter password"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="form-group mb-0 row">
                                    <div class="col-12 mt-2">
                                        <asp:LinkButton ID="btnLogin" runat="server" CssClass="btn btn-gradient-primary btn-round btn-block waves-effect waves-light" CausesValidation="true" ValidationGroup="Login" OnClick="btnLogin_Click">Log In <i class="fas fa-sign-in-alt ml-1"></i></asp:LinkButton>
                                    </div>
                                </div>
                                <div id="divErrorMsg" runat="server" class="alert alert-danger mt-4 border-0">
                                    <asp:Label ID="lblErrorMsg" runat="server"></asp:Label>
                                </div>
                            </asp:Panel>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- jQuery  -->
        <script src="assets/js/jquery.min.js"></script>
        <script src="assets/js/bootstrap.bundle.min.js"></script>
        <script src="assets/js/metisMenu.min.js"></script>
        <script src="assets/js/waves.min.js"></script>
        <script src="assets/js/jquery.slimscroll.min.js"></script>

        <!-- App js -->
        <script src="assets/js/app.js"></script>
    </form>
</body>

</html>
