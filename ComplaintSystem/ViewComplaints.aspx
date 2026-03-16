<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeFile="ViewComplaints.aspx.cs" Inherits="ViewComplaints.WebForm1" %>

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
        }

        .complaints-wrapper {
            display: flex;
            min-height: 100vh;
            background: linear-gradient(135deg, #E8F4F8 0%, #B8E1FF 50%, #87CEEB 100%);
            position: relative;
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

        .hamburger-toggle {
            position: fixed;
            left: 20px;
            top: 20px;
            width: 50px;
            height: 50px;
            background: white;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            z-index: 999;
            transition: all 0.3s ease;
        }

        .hamburger-toggle:hover {
            background: linear-gradient(135deg, #4A90E2 0%, #357ABD 100%);
            color: white;
            transform: scale(1.05);
        }

        /* Profile Dropdown */
        .profile-section {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 999;
        }

        .profile-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #4A90E2 0%, #357ABD 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(74, 144, 226, 0.3);
            transition: all 0.3s ease;
            border: none;
        }

        .profile-icon:hover {
            transform: scale(1.1);
            box-shadow: 0 6px 20px rgba(74, 144, 226, 0.4);
        }

        .profile-dropdown {
            position: absolute;
            top: 70px;
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

        /* Main Content */
        .main-content {
            flex: 1;
            padding: 40px 20px;
            margin-left: 0;
        }

        .page-title {
            text-align: center;
            font-size: 32px;
            font-weight: 700;
            color: #4A90E2;
            margin-bottom: 40px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* Tab Navigation */
        .tab-container {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .tab-button {
            padding: 12px 30px;
            border: 2px solid #E0E0E0;
            background: white;
            border-radius: 25px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            color: #7a7a7a;
            transition: all 0.3s ease;
        }

        .tab-button.active {
            background: linear-gradient(135deg, #4A90E2 0%, #357ABD 100%);
            color: white;
            border-color: #4A90E2;
            box-shadow: 0 4px 15px rgba(74, 144, 226, 0.3);
        }

        .tab-button:hover {
            border-color: #4A90E2;
        }

        /* Complaints Table Container */
        .complaints-container {
            background: white;
            border-radius: 16px;
            padding: 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
            max-width: 1200px;
            margin: 0 auto;
        }

        .complaints-table {
            width: 100%;
            border-collapse: collapse;
            table-layout: auto;
        }

        .complaints-table thead {
            background: linear-gradient(135deg, #4A90E2 0%, #357ABD 100%);
            color: white;
        }

        .complaints-table th {
            padding: 20px 15px;
            text-align: left;
            font-weight: 600;
            font-size: 14px;
        }

        .complaints-table tbody tr {
            border-bottom: 1px solid #E0E0E0;
            transition: all 0.3s ease;
            height: auto;
        }

        .complaints-table tbody tr:hover {
            background-color: #F5F5F5;
        }

        .complaints-table td {
            padding: 25px 15px;
            font-size: 14px;
            color: #333;
            line-height: 1.8;
            vertical-align: middle;
        }

        .complaint-detail-cell {
            color: #333;
            font-weight: 500;
            word-wrap: break-word;
            overflow-wrap: break-word;
            white-space: normal;
        }

        .task-assigned-cell {
            color: #7a7a7a;
            white-space: normal;
        }

        .status-badge {
            display: inline-block;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            white-space: nowrap;
        }

        .status-completed {
            background-color: #D4EDDA;
            color: #155724;
        }

        .status-pending {
            background-color: #FFF3CD;
            color: #856404;
        }

        .table-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #E0E0E0;
            color: #7a7a7a;
            font-size: 14px;
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        @media (max-width: 768px) {
            .page-title {
                font-size: 24px;
            }

            .complaints-container {
                padding: 20px;
            }

            .complaints-table {
                font-size: 12px;
            }

            .complaints-table th,
            .complaints-table td {
                padding: 10px;
            }

            .main-content {
                padding: 20px 10px;
            }

            .tab-container {
                gap: 10px;
            }

            .tab-button {
                padding: 10px 20px;
                font-size: 12px;
            }
        }
    </style>

    <div class="complaints-wrapper">
        <!-- Hamburger Menu -->
        <div class="hamburger-menu" id="hamburgerMenu">
            <button class="close-menu" onclick="toggleMenu()">&#x2715;</button>
            <a href="ComplaintPage.aspx" class="menu-item">
                <span class="menu-icon">&#x1F4DD;</span>
                New Complaint
            </a>
            <a href="HomePage.aspx" class="menu-item">
                <span class="menu-icon">&#x1F3E0;</span>
                Home
            </a>
            <a href="Login.aspx" class="menu-item logout">
                <span class="menu-icon">&#x1F6AA;</span>
                Logout
            </a>
        </div>

        <!-- Hamburger Toggle Button -->
        <button class="hamburger-toggle" onclick="toggleMenu()">&#x2630;</button>

        <!-- Profile Icon (Fixed Top Right) -->
        <div class="profile-section">
            <button class="profile-icon" onclick="toggleProfile()">&#x2699;&#xFE0F;</button>
            <div class="profile-dropdown" id="profileDropdown">
                <div class="dropdown-item">
                    <span>&#x1F464;</span>
                    Profile
                </div>
                <a href="Login.aspx" class="dropdown-item logout">
                    <span>&#x1F6AA;</span>
                    Logout
                </a>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <h1 class="page-title">View Complaints</h1>

            <!-- Tab Navigation -->
            <div class="tab-container">
                <button class="tab-button active" onclick="switchTab('completed')">
                    Completed Requests (3)
                </button>
                <button class="tab-button" onclick="switchTab('pending')">
                    Pending Requests (4)
                </button>
            </div>

            <!-- Completed Complaints Tab -->
            <div id="completed" class="tab-content active">
                <div class="complaints-container">
                    <table class="complaints-table">
                        <thead>
                            <tr>
                                <th style="width: 60%;">Complaint Detail / Remarks</th>
                                <th style="width: 30%;">Task Assigned To</th>
                                <th style="width: 10%;">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="complaint-detail-cell">Software license expired for Adobe Creative Suite - Affecting design team productivity</td>
                                <td class="task-assigned-cell">Michael Roberts - IT Admin</td>
                                <td><span class="status-badge status-completed">✓ Completed</span></td>
                            </tr>
                            <tr>
                                <td class="complaint-detail-cell">Office supplies shortage - Need immediate restock of stationery and printer paper</td>
                                <td class="task-assigned-cell">David Lee - Operations</td>
                                <td><span class="status-badge status-completed">✓ Completed</span></td>
                            </tr>
                            <tr>
                                <td class="complaint-detail-cell">Projector in Training Room B not displaying correctly - Screen flickers intermittently</td>
                                <td class="task-assigned-cell">James Wilson - AV Support</td>
                                <td><span class="status-badge status-completed">✓ Completed</span></td>
                            </tr>
                        </tbody>
                    </table>
                    <div class="table-footer">
                        <span>Showing 3 completed complaints</span>
                        <span>Total Complaints: 7</span>
                    </div>
                </div>
            </div>

            <!-- Pending Complaints Tab -->
            <div id="pending" class="tab-content">
                <div class="complaints-container">
                    <table class="complaints-table">
                        <thead>
                            <tr>
                                <th style="width: 60%;">Complaint Detail / Remarks</th>
                                <th style="width: 30%;">Task Assigned To</th>
                                <th style="width: 10%;">Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="complaint-detail-cell">Network connectivity issues in Building A - Unable to access internal servers and shared drives</td>
                                <td class="task-assigned-cell">John Mitchell - IT Support</td>
                                <td><span class="status-badge status-pending">⏳ Pending</span></td>
                            </tr>
                            <tr>
                                <td class="complaint-detail-cell">Air conditioning malfunction in Conference Room 3 - Temperature control not responding</td>
                                <td class="task-assigned-cell">Sarah Chen - Facilities</td>
                                <td><span class="status-badge status-pending">⏳ Pending</span></td>
                            </tr>
                            <tr>
                                <td class="complaint-detail-cell">Printer in Marketing department printing blank pages - Urgent replacement needed</td>
                                <td class="task-assigned-cell">Emma Thompson - Tech Support</td>
                                <td><span class="status-badge status-pending">⏳ Pending</span></td>
                            </tr>
                            <tr>
                                <td class="complaint-detail-cell">Parking access card not working - Employee unable to enter parking garage</td>
                                <td class="task-assigned-cell">Lisa Anderson - Security</td>
                                <td><span class="status-badge status-pending">⏳ Pending</span></td>
                            </tr>
                        </tbody>
                    </table>
                    <div class="table-footer">
                        <span>Showing 4 pending complaints</span>
                        <span>Total Complaints: 7</span>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function toggleMenu() {
            const menu = document.getElementById('hamburgerMenu');
            if (menu) {
                menu.classList.toggle('active');
            }
        }

        function toggleProfile() {
            const dropdown = document.getElementById('profileDropdown');
            if (dropdown) {
                dropdown.classList.toggle('active');
            }
        }

        function switchTab(tabName) {
            // Hide all tabs
            const tabs = document.querySelectorAll('.tab-content');
            tabs.forEach(tab => {
                tab.classList.remove('active');
            });

            // Remove active class from all buttons
            const buttons = document.querySelectorAll('.tab-button');
            buttons.forEach(btn => {
                btn.classList.remove('active');
            });

            // Show selected tab
            const selectedTab = document.getElementById(tabName);
            if (selectedTab) {
                selectedTab.classList.add('active');
            }

            // Add active class to clicked button
            if (event && event.target) {
                event.target.classList.add('active');
            }
        }

        // Initialize tabs on page load
        document.addEventListener('DOMContentLoaded', function() {
            // Set completed tab as active by default
            const completedTab = document.getElementById('completed');
            const completedButton = document.querySelector('.tab-button');
            if (completedTab) {
                completedTab.classList.add('active');
            }
            if (completedButton) {
                completedButton.classList.add('active');
            }
        });

        // Close profile dropdown when clicking outside
        document.addEventListener('click', function (event) {
            const profileSection = document.querySelector('.profile-section');
            const dropdown = document.getElementById('profileDropdown');
            const profileIcon = document.querySelector('.profile-icon');

            if (profileSection && !profileSection.contains(event.target) && event.target !== profileIcon) {
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
