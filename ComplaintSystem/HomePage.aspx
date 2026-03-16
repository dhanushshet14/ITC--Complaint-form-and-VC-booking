<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master"  CodeFile="HomePage.aspx.cs" Inherits="HomePage.WebForm1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            background: linear-gradient(135deg, #E8F4F8 0%, #B8E1FF 50%, #87CEEB 100%);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Navigation Bar */
        .navbar {
            background: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 15px 30px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 998;
        }

        .navbar-left {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .hamburger-toggle {
            width: 45px;
            height: 45px;
            background: linear-gradient(135deg, #4A90E2 0%, #357ABD 100%);
            border: none;
            border-radius: 12px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            color: white;
            transition: all 0.3s ease;
        }

        .hamburger-toggle:hover {
            transform: scale(1.05);
            box-shadow: 0 4px 12px rgba(74, 144, 226, 0.3);
        }

        .company-logo {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #4A90E2 0%, #357ABD 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 18px;
            box-shadow: 0 4px 12px rgba(74, 144, 226, 0.3);
        }

        .navbar-center {
            flex: 1;
            text-align: center;
        }

        .navbar-right {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        /* Hamburger Menu Styles */
        .hamburger-menu {
            position: fixed;
            left: -300px;
            top: 0;
            width: 300px;
            height: 100vh;
            background: white;
            padding: 20px;
            transition: left 0.3s ease;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
            z-index: 1000;
        }

        .hamburger-menu.active {
            left: 0;
        }

        .menu-item {
            display: flex;
            align-items: center;
            padding: 15px;
            margin: 10px 0;
            border-radius: 8px;
            color: #333;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .menu-item:hover {
            background-color: #D4E9F7;
            transform: translateX(10px);
        }

        .menu-icon {
            margin-right: 12px;
            font-size: 18px;
        }

        .menu-item.logout {
            color: #E74C3C;
        }

        .menu-item.logout:hover {
            background-color: #FADBD8;
        }

        .close-menu {
            position: absolute;
            top: 20px;
            right: 20px;
            background: none;
            border: none;
            font-size: 28px;
            cursor: pointer;
            color: #333;
            transition: all 0.3s ease;
        }

        .close-menu:hover {
            transform: rotate(90deg);
            color: #4A90E2;
        }

        /* Profile Section */
        .profile-section {
            position: relative;
        }

        .profile-icon {
            width: 45px;
            height: 45px;
            background: linear-gradient(135deg, #4A90E2 0%, #357ABD 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 22px;
            box-shadow: 0 4px 12px rgba(74, 144, 226, 0.3);
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
        }

        .profile-icon:hover {
            transform: scale(1.1);
            box-shadow: 0 6px 20px rgba(74, 144, 226, 0.4);
        }

        .profile-dropdown {
            position: absolute;
            top: 60px;
            right: 0;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
            padding: 15px;
            min-width: 150px;
            display: none;
            z-index: 100;
        }

        .profile-dropdown.active {
            display: block;
        }

        .dropdown-item {
            padding: 12px 15px;
            color: #333;
            cursor: pointer;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 10px;
            border-radius: 8px;
            transition: all 0.3s ease;
            margin: 5px 0;
        }

        .dropdown-item:hover {
            background-color: #D4E9F7;
            transform: translateX(5px);
        }

        .dropdown-item.logout {
            color: #E74C3C;
        }

        .dropdown-item.logout:hover {
            background-color: #FADBD8;
        }

        .home-wrapper {
            padding: 40px 20px;
            background: linear-gradient(135deg, #E8F4F8 0%, #B8E1FF 50%, #87CEEB 100%);
            flex: 1;
        }

        .employee-container {
            display: flex;
            gap: 30px;
            align-items: flex-start;
            margin-bottom: 40px;
            padding: 0 20px;
        }

        .employee-card {
            background: white;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            flex: 1;
            max-width: 100%;
            transition: all 0.3s ease;
            display: flex;
            gap: 30px;
            align-items: flex-start;
        }

        .employee-card:hover {
            box-shadow: 0 8px 32px rgba(74, 144, 226, 0.2);
            transform: translateY(-4px);
        }

        .employee-card-title {
            font-size: 24px;
            font-weight: 600;
            color: #333;
            margin-bottom: 25px;
        }

        .employee-details-section {
            flex: 1;
            min-width: 0;
        }

        .detail-row {
            margin-bottom: 20px;
        }

        .detail-label {
            font-size: 12px;
            color: #7a7a7a;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 5px;
        }

        .detail-value {
            font-size: 15px;
            color: #333;
            font-weight: 500;
        }

        .employee-image-container {
            display: flex;
            justify-content: center;
            margin-top: 0;
        }

        .employee-image-box {
            width: 200px;
            height: 200px;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .employee-image-box:hover {
            transform: scale(1.08) translateY(-5px);
            box-shadow: 0 8px 24px rgba(74, 144, 226, 0.3);
        }

        .employee-image-placeholder {
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #E8F4F8 0%, #B8E1FF 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #7a7a7a;
            font-size: 14px;
            text-align: center;
            padding: 20px;
        }

        .employee-image-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .navigation-section {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-bottom: 40px;
            flex-wrap: wrap;
            padding: 0 20px;
        }

        .nav-button {
            background: linear-gradient(135deg, #4A90E2 0%, #357ABD 100%);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 25px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 4px 15px rgba(74, 144, 226, 0.3);
            transition: all 0.3s ease;
        }

        .nav-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(74, 144, 226, 0.4);
            text-decoration: none;
            color: white;
        }

        .icon {
            font-size: 18px;
        }

        @media (max-width: 768px) {
            .employee-container {
                flex-direction: column;
                align-items: center;
            }

            .employee-card {
                max-width: 100%;
                width: 100%;
                flex-direction: column;
            }

            .employee-image-container {
                justify-content: center;
                width: 100%;
            }

            .employee-image-box {
                width: 200px;
                height: 200px;
            }

            .navigation-section {
                justify-content: center;
                gap: 15px;
            }

            .nav-button {
                padding: 10px 20px;
                font-size: 13px;
            }

            .home-wrapper {
                padding: 20px 10px;
            }

            .navbar {
                padding: 10px 15px;
            }

            .employee-container,
            .navigation-section {
                padding: 0 10px;
            }
        }
    </style>

    <div class="navbar">
        <!-- Left Side: Hamburger and Logo -->
        <div class="navbar-left">
            <%--<button class="hamburger-toggle" onclick="toggleMenu()">☰</button>--%>
            <div class="company-logo">CO</div>
        </div>

        <!-- Center: (Empty for now) -->
        <div class="navbar-center"></div>

        <!-- Right Side: Profile Section -->
        <div class="navbar-right">
            <div class="profile-section">
                <button class="profile-icon" onclick="toggleProfile()">⚙️</button>
                <div class="profile-dropdown" id="profileDropdown">
                    <div class="dropdown-item">
                        <span>👤</span>
                        Profile
                    </div>
                    <a href="Login.aspx" class="dropdown-item logout">
                        <span>🚪</span>
                        Logout
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Hamburger Menu -->
    <div class="hamburger-menu" id="hamburgerMenu">
        <button class="close-menu" onclick="toggleMenu()">✕</button>
        <a href="ComplaintPage.aspx" class="menu-item">
            <span class="menu-icon">&#x1F4DD;</span>
            New Complaint
        </a>
        <a href="ViewComplaints.aspx" class="menu-item">
            <span class="menu-icon">&#x1F4CB;</span>
            View Complaints
        </a>
        <a href="Login.aspx" class="menu-item logout">
            <span class="menu-icon">&#x1F6AA;</span>
            Logout
        </a>
    </div>

    <div class="home-wrapper">
        <!-- Employee Details and Image Section -->
        <div class="employee-container">
            <!-- Employee Details Card with Image on Right -->
            <div class="employee-card">
                <!-- Employee Details Left Side -->
                <div class="employee-details-section">
                    <div class="employee-card-title">Employee Details</div>

                    <div class="detail-row">
                        <div class="detail-label">Name</div>
                        <div class="detail-value">Sarah Johnson</div>
                    </div>

                    <div class="detail-row">
                        <div class="detail-label">Employee Code</div>
                        <div class="detail-value">EMP-2024-1247</div>
                    </div>

                    <div class="detail-row">
                        <div class="detail-label">Mail ID</div>
                        <div class="detail-value">sarah.johnson@company.com</div>
                    </div>

                    <div class="detail-row">
                        <div class="detail-label">Phone Number</div>
                        <div class="detail-value">+1 (555) 123-4567</div>
                    </div>

                    <div class="detail-row">
                        <div class="detail-label">Role</div>
                        <div class="detail-value">Senior Software Engineer</div>
                    </div>

                    <div class="detail-row">
                        <div class="detail-label">Branch / Unit</div>
                        <div class="detail-value">Technology Division - San Francisco</div>
                    </div>
                </div>

                <!-- Employee Image Right Side -->
                <div class="employee-image-container" style="flex-shrink: 0;">
                    <div class="employee-image-box">
                        <div class="employee-image-placeholder">
                            <asp:Image ID="imgEmployee" runat="server" AlternateText="Employee Photo" />
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Navigation Section -->
        <div class="navigation-section">
            <a href="ComplaintPage.aspx" class="nav-button">
                <span class="icon">&#x1F4DD;</span>
                New Complaints
            </a>
            <a href="ViewComplaints.aspx" class="nav-button">
                <span class="icon">&#x1F4CB;</span>
                View Complaints
            </a>
            <a href="#" class="nav-button">
                <span class="icon">&#x1F4AC;</span>
                VC Booking
            </a>
            <a href="Login.aspx" class="nav-button">
                <span class="icon">&#x1F6AA;</span>
                Logout
            </a>
        </div>
    </div>

    <script>
        function toggleMenu() {
            const menu = document.getElementById('hamburgerMenu');
            menu.classList.toggle('active');
        }

        function toggleProfile() {
            const dropdown = document.getElementById('profileDropdown');
            dropdown.classList.toggle('active');
        }

        // Close profile dropdown when clicking outside
        document.addEventListener('click', function (event) {
            const profileSection = document.querySelector('.profile-section');
            const dropdown = document.getElementById('profileDropdown');

            if (profileSection && !profileSection.contains(event.target)) {
                if (dropdown) {
                    dropdown.classList.remove('active');
                }
            }
        });

        // Close menu when clicking outside
        document.addEventListener('click', function (event) {
            const menu = document.getElementById('hamburgerMenu');
            const toggle = document.querySelector('.hamburger-toggle');

            if (menu && toggle && !menu.contains(event.target) && !toggle.contains(event.target)) {
                menu.classList.remove('active');
            }
        });
    </script>
</asp:Content>
