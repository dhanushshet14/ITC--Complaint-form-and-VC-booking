<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeFile="StatusTimeline.aspx.cs" Inherits="ComplaintSystem.StatusTimeline" %>

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

        .timeline-wrapper {
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
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .page-subtitle {
            text-align: center;
            font-size: 14px;
            color: #7a7a7a;
            margin-bottom: 40px;
            font-weight: 500;
        }

        /* Horizontal Timeline */
        .timeline-container {
            background: white;
            border-radius: 16px;
            padding: 40px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
            max-width: 1400px;
            margin: 0 auto;
            overflow-x: auto;
        }

        .horizontal-timeline {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            position: relative;
            min-width: 100%;
            padding: 20px 0;
        }

        /* Timeline connecting line */
        .timeline-line {
            position: absolute;
            top: 25px;
            left: 40px;
            right: 40px;
            height: 4px;
            background: linear-gradient(to right, #4A90E2 0%, #4A90E2 50%, #D4E9DA 50%, #D4E9DA 100%);
            z-index: 1;
        }

        .timeline-step {
            display: flex;
            flex-direction: column;
            align-items: center;
            flex: 1;
            position: relative;
            z-index: 2;
            min-width: 120px;
        }

        .timeline-step.completed .timeline-dot {
            background: linear-gradient(135deg, #28A745 0%, #20C997 100%);
            box-shadow: 0 0 0 4px rgba(40, 167, 69, 0.2);
        }

        .timeline-step.pending .timeline-dot {
            background: #E0E0E0;
            box-shadow: 0 0 0 4px rgba(224, 224, 224, 0.3);
        }

        .timeline-dot {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: white;
            border: 4px solid #D4E9DA;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            font-weight: bold;
            color: #4A90E2;
            margin-bottom: 20px;
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .timeline-step.completed .timeline-dot {
            background: linear-gradient(135deg, #28A745 0%, #20C997 100%);
            border-color: #28A745;
            color: white;
        }

        .timeline-step.pending .timeline-dot {
            background: #F5F5F5;
            border-color: #D4D4D4;
            color: #999;
        }

        .timeline-dot:hover {
            transform: scale(1.15);
            box-shadow: 0 4px 12px rgba(74, 144, 226, 0.3);
        }

        .timeline-content {
            text-align: center;
            width: 100%;
            margin-top: 10px;
        }

        .timeline-title {
            font-size: 14px;
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
            line-height: 1.4;
        }

        .timeline-time {
            font-size: 12px;
            color: #999;
            margin-bottom: 10px;
        }

        .timeline-icon {
            font-size: 18px;
            margin-bottom: 5px;
            display: block;
        }

        /* Status Badge for Timeline */
        .timeline-status {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            white-space: nowrap;
            margin-top: 5px;
        }

        .timeline-status.completed {
            background-color: #D4EDDA;
            color: #155724;
        }

        .timeline-status.pending {
            background-color: #F8F9FA;
            color: #7a7a7a;
            border: 1px solid #E0E0E0;
        }

        /* Ticket Info Card */
        .ticket-info-card {
            background: linear-gradient(135deg, #F0F8FF 0%, #E6F2FF 100%);
            border-left: 4px solid #4A90E2;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .ticket-info {
            flex: 1;
        }

        .ticket-id {
            font-size: 12px;
            color: #7a7a7a;
            margin-bottom: 5px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .ticket-title {
            font-size: 18px;
            font-weight: 700;
            color: #333;
            margin-bottom: 8px;
        }

        .ticket-assignee {
            font-size: 13px;
            color: #7a7a7a;
        }

        .ticket-progress {
            text-align: right;
            font-size: 28px;
            font-weight: 700;
            color: #4A90E2;
        }

        .ticket-progress-label {
            font-size: 11px;
            color: #7a7a7a;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .page-title {
                font-size: 24px;
            }

            .timeline-container {
                padding: 20px;
                overflow-x: auto;
            }

            .horizontal-timeline {
                min-width: 800px;
            }

            .timeline-step {
                min-width: 100px;
            }

            .timeline-dot {
                width: 40px;
                height: 40px;
                font-size: 18px;
                margin-bottom: 15px;
            }

            .timeline-title {
                font-size: 12px;
            }

            .timeline-time {
                font-size: 10px;
            }

            .ticket-info-card {
                flex-direction: column;
                text-align: center;
                gap: 15px;
            }

            .ticket-progress {
                text-align: center;
            }
        }

        @media (max-width: 480px) {
            .main-content {
                padding: 20px 10px;
            }

            .page-title {
                font-size: 20px;
            }

            .timeline-container {
                padding: 15px;
            }

            .horizontal-timeline {
                min-width: 600px;
            }

            .timeline-step {
                min-width: 80px;
            }

            .timeline-dot {
                width: 36px;
                height: 36px;
                font-size: 14px;
                margin-bottom: 10px;
            }

            .timeline-title {
                font-size: 11px;
            }
        }
    </style>

    <div class="timeline-wrapper">
        <!-- Hamburger Menu -->
        <div class="hamburger-menu" id="hamburgerMenu">
            <button type="button" class="close-menu" onclick="toggleMenu()">&#x2715;</button>
            <a href="ComplaintPage.aspx" class="menu-item">
                <span class="menu-icon">&#x1F4DD;</span>
                New Complaint
            </a>
            <a href="ViewComplaints.aspx" class="menu-item">
                <span class="menu-icon">&#x1F4CB;</span>
                View Complaints
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
        <button type="button" class="hamburger-toggle" onclick="toggleMenu()">&#x2630;</button>

        <!-- Profile Icon (Fixed Top Right) -->
        <div class="profile-section">
            <button type="button" class="profile-icon" onclick="toggleProfile()">&#x2699;&#xFE0F;</button>
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
            <h1 class="page-title">Ticket Status Timeline</h1>
            <p class="page-subtitle">Track the progress of your complaint/ticket through each stage</p>

            <!-- Ticket Info Card -->
            <div class="ticket-info-card">
                <div class="ticket-info">
                    <div class="ticket-id">Ticket #: ITC-2025-001245</div>
                    <div class="ticket-title">Software license expired for Adobe Creative Suite</div>
                    <div class="ticket-assignee">Assigned to: Michael Roberts - IT Admin</div>
                </div>
                <div class="ticket-progress">
                    <div class="ticket-progress-label">Progress</div>
                    5 of 7
                </div>
            </div>

            <!-- Timeline Container -->
            <div class="timeline-container">
                <div class="horizontal-timeline">
                    <!-- Timeline Line Background -->
                    <div class="timeline-line"></div>

                    <!-- Step 1 -->
                    <div class="timeline-step completed">
                        <div class="timeline-dot">
                            <span class="timeline-icon">📋</span>
                        </div>
                        <div class="timeline-content">
                            <div class="timeline-title">Complaint Submitted</div>
                            <div class="timeline-time">09 Aug 2025, 10:00am</div>
                            <div class="timeline-status completed">✓ Completed</div>
                        </div>
                    </div>

                    <!-- Step 2 -->
                    <div class="timeline-step completed">
                        <div class="timeline-dot">
                            <span class="timeline-icon">✓</span>
                        </div>
                        <div class="timeline-content">
                            <div class="timeline-title">Ticket Confirmed</div>
                            <div class="timeline-time">09 Aug 2025, 10:30am</div>
                            <div class="timeline-status completed">✓ Completed</div>
                        </div>
                    </div>

                    <!-- Step 3 -->
                    <div class="timeline-step completed">
                        <div class="timeline-dot">
                            <span class="timeline-icon">⚙️</span>
                        </div>
                        <div class="timeline-content">
                            <div class="timeline-title">In Progress</div>
                            <div class="timeline-time">09 Aug 2025, 12:00pm</div>
                            <div class="timeline-status completed">✓ Completed</div>
                        </div>
                    </div>

                    <!-- Step 4 -->
                    <div class="timeline-step completed">
                        <div class="timeline-dot">
                            <span class="timeline-icon">📦</span>
                        </div>
                        <div class="timeline-content">
                            <div class="timeline-title">Ready for Delivery</div>
                            <div class="timeline-time">10 Aug 2025, 02:00pm</div>
                            <div class="timeline-status completed">✓ Completed</div>
                        </div>
                    </div>

                    <!-- Step 5 -->
                    <div class="timeline-step completed">
                        <div class="timeline-dot">
                            <span class="timeline-icon">🚚</span>
                        </div>
                        <div class="timeline-content">
                            <div class="timeline-title">In Transit</div>
                            <div class="timeline-time">10 Aug 2025, 03:00pm</div>
                            <div class="timeline-status completed">✓ Completed</div>
                        </div>
                    </div>

                    <!-- Step 6 -->
                    <div class="timeline-step pending">
                        <div class="timeline-dot">
                            <span class="timeline-icon">📍</span>
                        </div>
                        <div class="timeline-content">
                            <div class="timeline-title">Out for Delivery</div>
                            <div class="timeline-time">12 Aug 2025, 05:00pm</div>
                            <div class="timeline-status pending">Pending</div>
                        </div>
                    </div>

                    <!-- Step 7 -->
                    <div class="timeline-step pending">
                        <div class="timeline-dot">
                            <span class="timeline-icon">✉️</span>
                        </div>
                        <div class="timeline-content">
                            <div class="timeline-title">Delivered</div>
                            <div class="timeline-time">TBD</div>
                            <div class="timeline-status pending">Pending</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Defensive: ensure interactive buttons are non-submit
        document.addEventListener('DOMContentLoaded', function () {
            document.querySelectorAll('.hamburger-toggle, .close-menu, .profile-icon').forEach(function (btn) {
                if (btn && !btn.hasAttribute('type')) btn.setAttribute('type', 'button');
            });
        });

        function toggleMenu() {
            const menu = document.getElementById('hamburgerMenu');
            if (menu) menu.classList.toggle('active');
        }

        function toggleProfile() {
            const dropdown = document.getElementById('profileDropdown');
            if (dropdown) dropdown.classList.toggle('active');
        }

        // Close profile dropdown when clicking outside
        document.addEventListener('click', function (event) {
            const profileSection = document.querySelector('.profile-section');
            const dropdown = document.getElementById('profileDropdown');
            const profileIcon = document.querySelector('.profile-icon');

            if (profileSection && !profileSection.contains(event.target) && event.target !== profileIcon) {
                if (dropdown) dropdown.classList.remove('active');
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
