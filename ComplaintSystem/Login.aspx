<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="ComplaintSystem.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>Manipal Group - Complaint Management System</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta content="Complaint and VC booking - The Manipal Group" name="description" />
    <meta content="GroupIT - The Manipal Group" name="author" />

    <link href="assets/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="assets/css/icons.css" rel="stylesheet" type="text/css" />
    <link href="assets/css/metisMenu.min.css" rel="stylesheet" type="text/css" />
    <link href="assets/css/style.css" rel="stylesheet" type="text/css" />

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: #ffffff;
            height: 100vh;
            overflow: hidden;
        }

        .login-container {
            display: flex;
            height: 100vh;
        }

        /* Left Side - Dark Branding Section */
        .login-left {
            flex: 1;
            background: linear-gradient(135deg, #0f1419 0%, #1a1e2e 100%);
            color: white;
            padding: 60px 50px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            overflow-y: auto;
        }

        .brand-section {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 60px;
        }

        .brand-icon {
            width: 45px;
            height: 45px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 2px solid rgba(255, 255, 255, 0.2);
        }

        .brand-icon i {
            font-size: 24px;
            color: #fff;
        }

        .brand-text h3 {
            font-size: 18px;
            font-weight: 600;
            margin: 0;
            letter-spacing: 0.5px;
        }

        .brand-text p {
            font-size: 12px;
            color: rgba(255, 255, 255, 0.6);
            margin: 0;
        }

        .hero-content h1 {
            font-size: 48px;
            font-weight: 700;
            line-height: 1.3;
            margin-bottom: 20px;
        }

        .hero-content h1 .highlight {
            color: #6366f1;
        }

        .hero-content p {
            font-size: 16px;
            color: rgba(255, 255, 255, 0.7);
            line-height: 1.6;
            margin-bottom: 0;
        }

        .live-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-top: 60px;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            padding: 25px;
            border-radius: 12px;
            backdrop-filter: blur(10px);
        }

        .stat-label {
            font-size: 12px;
            color: rgba(255, 255, 255, 0.6);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 12px;
        }

        .stat-value {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .stat-change {
            font-size: 13px;
            color: rgba(255, 255, 255, 0.6);
        }

        .activity-section {
            margin-top: 60px;
        }

        .activity-title {
            font-size: 11px;
            color: rgba(255, 255, 255, 0.5);
            text-transform: uppercase;
            letter-spacing: 1.5px;
            margin-bottom: 20px;
            font-weight: 600;
        }

        .activity-list {
            list-style: none;
        }

        .activity-item {
            display: flex;
            align-items: flex-start;
            gap: 15px;
            padding: 15px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            margin-top: 6px;
            flex-shrink: 0;
        }

        .activity-dot.progress {
            background: #fbbf24;
        }

        .activity-dot.resolved {
            background: #34d399;
        }

        .activity-dot.escalated {
            background: #f87171;
        }

        .activity-content {
            flex: 1;
        }

        .activity-content p {
            margin: 0;
            font-size: 14px;
            color: rgba(255, 255, 255, 0.8);
        }

        .activity-status {
            font-size: 11px;
            color: rgba(255, 255, 255, 0.5);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Right Side - Login Form Section */
        .login-right {
            flex: 1;
            background: white;
            padding: 60px 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            overflow-y: auto;
        }

        .login-form-wrapper {
            max-width: 420px;
            width: 100%;
            margin: 0 auto;
        }

        .login-header {
            margin-bottom: 40px;
        }

        .login-header h2 {
            font-size: 32px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 10px;
        }

        .login-header p {
            font-size: 15px;
            color: #6b7280;
            margin: 0;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #374151;
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .form-control {
            width: 100%;
            padding: 13px 16px;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.3s ease;
            background: #f9fafb;
        }

        .form-control:focus {
            outline: none;
            border-color: #6366f1;
            background: white;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
        }

        .form-control::placeholder {
            color: #9ca3af;
        }

        .form-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            font-size: 13px;
        }

        .remember-check {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .remember-check input[type="checkbox"] {
            width: 18px;
            height: 18px;
            cursor: pointer;
            accent-color: #6366f1;
        }

        .remember-check label {
            cursor: pointer;
            color: #6b7280;
            margin: 0;
            text-transform: none;
            letter-spacing: normal;
        }

        .forgot-link {
            color: #6366f1;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s;
        }

        .forgot-link:hover {
            color: #4f46e5;
        }

        .btn-login {
            width: 100%;
            padding: 14px 24px;
            background: #1a1a1a;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .btn-login:hover {
            background: #0a0a0a;
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
        }

        .btn-login:active {
            transform: translateY(0);
        }

        .credentials-hint {
            margin-top: 25px;
            padding: 15px;
            background: #f3f4f6;
            border-radius: 8px;
            font-size: 12px;
            color: #6b7280;
            text-align: center;
        }

        .credentials-hint strong {
            color: #1a1a1a;
        }

        .alert-danger {
            background: #fee2e2;
            border: 1px solid #fecaca;
            color: #991b1b;
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 13px;
            margin-bottom: 20px;
            display: none;
        }

        .alert-danger.show {
            display: block;
        }

        .login-footer {
            margin-top: 30px;
            text-align: center;
            font-size: 12px;
            color: #9ca3af;
        }

        .login-footer p {
            margin: 0;
        }

        /* Responsive Design */
        @media (max-width: 1024px) {
            .login-left,
            .login-right {
                padding: 40px;
            }

            .hero-content h1 {
                font-size: 36px;
            }

            .live-stats {
                grid-template-columns: repeat(3, 1fr);
                gap: 15px;
            }

            .stat-card {
                padding: 20px;
            }

            .stat-value {
                font-size: 24px;
            }
        }

        @media (max-width: 768px) {
            .login-container {
                flex-direction: column;
            }

            .login-left {
                padding: 30px;
                min-height: 50vh;
            }

            .login-right {
                padding: 30px;
                min-height: 50vh;
            }

            .hero-content h1 {
                font-size: 28px;
            }

            .live-stats {
                grid-template-columns: 1fr;
            }

            .activity-section {
                display: none;
            }

            .login-form-wrapper {
                max-width: 100%;
            }
        }

        @media (max-width: 480px) {
            .login-left {
                padding: 20px;
            }

            .login-right {
                padding: 20px;
            }

            .hero-content h1 {
                font-size: 24px;
            }

            .login-header h2 {
                font-size: 24px;
            }
        }
    </style>
</head>
<body>
    <form id="frmLogin" runat="server">
        <div class="login-container">
            <!-- Left Side - Branding -->
            <div class="login-left">
                <!-- Brand -->
                <div>
                    <div class="brand-section">
                        <div class="brand-icon">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <div class="brand-text">
                            <h3>Manipal Group</h3>
                            <p>Complaint Management</p>
                        </div>
                    </div>

                    <!-- Hero Content -->
                    <div class="hero-content">
                        <h1>Manage every complaint,<br /><span class="highlight">track every resolution.</span></h1>
                        <p>A unified operations hub for technical services, telephone complaints, SOC monitoring, and VC scheduling — all in one dashboard.</p>
                    </div>
                </div>

                <!-- Live Stats -->
                <div>
                    <div class="live-stats">
                        <div class="stat-card">
                            <div class="stat-label">Active Complaints</div>
                            <div class="stat-value">1,284</div>
                            <div class="stat-change">↑ 12 today</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-label">Resolved This Week</div>
                            <div class="stat-value">347</div>
                            <div class="stat-change">↑ 18% vs last</div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-label">Avg. Response Time</div>
                            <div class="stat-value">2.4h</div>
                            <div class="stat-change">↓ 0.3h improved</div>
                        </div>
                    </div>

                    <!-- Recent Activity -->
                    <div class="activity-section">
                        <div class="activity-title">Recent Activity</div>
                        <ul class="activity-list">
                            <li class="activity-item">
                                <div class="activity-dot progress"></div>
                                <div class="activity-content">
                                    <p><strong>TC-8891</strong> Router fault — Block B</p>
                                    <div class="activity-status">In Progress</div>
                                </div>
                            </li>
                            <li class="activity-item">
                                <div class="activity-dot resolved"></div>
                                <div class="activity-content">
                                    <p><strong>PH-0047</strong> Line noise complaint</p>
                                    <div class="activity-status">Resolved</div>
                                </div>
                            </li>
                            <li class="activity-item">
                                <div class="activity-dot escalated"></div>
                                <div class="activity-content">
                                    <p><strong>TC-0008</strong> Fibre cut — Sector 4</p>
                                    <div class="activity-status">Escalated</div>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Right Side - Login Form -->
            <div class="login-right">
                <div class="login-form-wrapper">
                    <!-- Login Header -->
                    <div class="login-header">
                        <h2>Welcome back</h2>
                        <p>Sign in to your account to continue</p>
                    </div>

                    <!-- Error Message -->
                    <div id="divErrorMsg" runat="server" class="alert-danger">
                        <asp:Label ID="lblErrorMsg" runat="server"></asp:Label>
                    </div>

                    <!-- Login Form -->
                    <asp:Panel ID="panLogin" runat="server" DefaultButton="btnLogin">
                        <div class="form-group">
                            <label for="txtUsername">Username</label>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" 
                                TextMode="SingleLine" MaxLength="200" ValidationGroup="Login" 
                                placeholder="e.g. admin"></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label for="txtPassword">Password</label>
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" 
                                TextMode="Password" MaxLength="200" ValidationGroup="Login" 
                                placeholder="••••••••"></asp:TextBox>
                        </div>

                        <!-- Form Footer -->
                        <div class="form-footer">
                            <div class="remember-check">
                                <input type="checkbox" id="chkRemember" name="remember" />
                                <label for="chkRemember">Remember me</label>
                            </div>
                            <a href="#" class="forgot-link">Forgot password?</a>
                        </div>

                        <!-- Login Button -->
                        <asp:LinkButton ID="btnLogin" runat="server" CssClass="btn-login" 
                            CausesValidation="true" ValidationGroup="Login" OnClick="btnLogin_Click">
                            <span>Sign in</span>
                            <i class="fas fa-arrow-right"></i>
                        </asp:LinkButton>

                        <!-- Demo Credentials Hint -->
                       <!----- <div class="credentials-hint">
                            Demo credentials: <strong>admin</strong> / <strong>admin123</strong>
                        </div> ------>
                    </asp:Panel>

                    <!-- Footer -->
                    <div class="login-footer">
                        <p>&copy; 2026 Manipal Group. All rights reserved</p>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <!-- Scripts -->
    <script src="assets/js/jquery.min.js"></script>
    <script src="assets/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/metisMenu.min.js"></script>
    <script src="assets/js/waves.min.js"></script>
    <script src="assets/js/jquery.slimscroll.min.js"></script>
    <script src="assets/js/app.js"></script>
</body>

</html>
