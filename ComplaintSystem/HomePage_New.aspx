<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="HomePage.aspx.cs" Inherits="ComplaintSystem.HomePage" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>ServiceCore - Dashboard</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', sans-serif;
            background-color: #f8f9fa;
            color: #333;
        }

        /* Main Layout */
        .dashboard-container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .sidebar {
            width: 200px;
            background: #1a1a2e;
            color: white;
            padding: 30px 20px;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            left: 0;
            top: 0;
            z-index: 999;
        }

        .sidebar-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 40px;
            font-size: 18px;
            font-weight: 600;
        }

        .sidebar-brand-icon {
            width: 35px;
            height: 35px;
            background: #4a90e2;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }

        .sidebar-nav {
            list-style: none;
        }

        .sidebar-nav li {
            margin-bottom: 15px;
        }

        .sidebar-nav a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 15px;
            color: #aaa;
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s;
            font-size: 14px;
        }

        .sidebar-nav a:hover {
            background: rgba(74, 144, 226, 0.1);
            color: #4a90e2;
        }

        .sidebar-nav a.active {
            background: #4a90e2;
            color: white;
            border-radius: 8px;
        }

        .sidebar-nav-icon {
            width: 20px;
            text-align: center;
        }

        .sidebar-dropdown {
            position: relative;
        }

        .sidebar-dropdown-toggle {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            padding: 12px 15px;
            color: #aaa;
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s;
            font-size: 14px;
            background: none;
            border: none;
            cursor: pointer;
            width: 100%;
        }

        .sidebar-dropdown-toggle:hover {
            background: rgba(74, 144, 226, 0.1);
            color: #4a90e2;
        }

        .sidebar-dropdown-menu {
            display: none;
            background: rgba(0, 0, 0, 0.2);
            border-radius: 8px;
            overflow: hidden;
            margin-top: 5px;
            animation: slideDown 0.3s ease-out;
        }

        .sidebar-dropdown.active .sidebar-dropdown-menu {
            display: block;
        }

        .sidebar-dropdown-menu a {
            display: block;
            padding: 10px 20px;
            color: #aaa;
            text-decoration: none;
            font-size: 13px;
            transition: all 0.3s;
            cursor: pointer;
        }

        .sidebar-dropdown-menu a:hover,
        .sidebar-dropdown-menu a.active {
            background: rgba(74, 144, 226, 0.2);
            color: #4a90e2;
            padding-left: 25px;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .sidebar-bottom {
            position: absolute;
            bottom: 30px;
            left: 20px;
            right: 20px;
            border-top: 1px solid #333;
            padding-top: 20px;
        }

        .sidebar-bottom a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 15px;
            color: #aaa;
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s;
            font-size: 14px;
        }

        .sidebar-bottom a.logout {
            color: #ff4757;
        }

        .sidebar-bottom a:hover {
            background: rgba(255, 71, 87, 0.1);
        }

        /* Main Content */
        .main-content {
            margin-left: 200px;
            flex: 1;
            padding: 30px;
        }

        /* Header */
        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .dashboard-title {
            font-size: 32px;
            font-weight: 700;
        }

        .dashboard-controls {
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .search-box {
            display: flex;
            align-items: center;
            background: white;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 10px 15px;
            gap: 10px;
            width: 300px;
        }

        .search-box input {
            border: none;
            outline: none;
            font-size: 14px;
            flex: 1;
        }

        .dropdown-filter {
            position: relative;
            display: inline-block;
        }

        .dropdown-btn {
            background: white;
            border: 1px solid #e0e0e0;
            padding: 10px 15px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            min-width: 130px;
            transition: all 0.3s;
        }

        .dropdown-btn:hover {
            border-color: #4a90e2;
            background: #f8f9fa;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            background-color: white;
            min-width: 180px;
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
            padding: 12px 0;
            z-index: 1001;
            border-radius: 8px;
            top: 100%;
            right: 0;
            margin-top: 5px;
            border: 1px solid #e0e0e0;
        }

        .dropdown-content a {
            color: black;
            padding: 12px 20px;
            text-decoration: none;
            display: block;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 13px;
        }

        .dropdown-content a:hover {
            background-color: #f8f9fa;
            color: #4a90e2;
        }

        .dropdown-filter.active .dropdown-content {
            display: block;
        }

        .new-complaint-btn {
            background: #1a1a2e;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
            font-weight: 500;
        }

        .new-complaint-btn:hover {
            background: #4a90e2;
        }

        .new-complaint-dropdown {
            position: relative;
            display: inline-block;
        }

        .new-complaint-menu {
            display: none;
            position: absolute;
            background-color: white;
            min-width: 180px;
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
            padding: 12px 0;
            z-index: 1001;
            border-radius: 8px;
            top: 100%;
            right: 0;
            margin-top: 5px;
            border: 1px solid #e0e0e0;
        }

        .new-complaint-menu a {
            color: black;
            padding: 12px 20px;
            text-decoration: none;
            display: block;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 13px;
        }

        .new-complaint-menu a:hover {
            background-color: #f8f9fa;
            color: #4a90e2;
        }

        .new-complaint-dropdown.active .new-complaint-menu {
            display: block;
        }

        .notification-bell {
            width: 40px;
            height: 40px;
            background: white;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 18px;
            position: relative;
        }

        .notification-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            background: #ff4757;
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 11px;
            font-weight: 600;
        }

        .profile-icon {
            width: 40px;
            height: 40px;
            background: #4a90e2;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            cursor: pointer;
        }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            border-left: 4px solid #e0e0e0;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            transition: all 0.3s;
        }

        .stat-card:hover {
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
            transform: translateY(-2px);
        }

        .stat-card.total { border-left-color: #4a90e2; }
        .stat-card.ongoing { border-left-color: #f39c12; }
        .stat-card.resolved { border-left-color: #27ae60; }
        .stat-card.closed { border-left-color: #95a5a6; }
        .stat-card.transferred { border-left-color: #9b59b6; }

        .stat-icon {
            font-size: 28px;
            margin-bottom: 12px;
        }

        .stat-value {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .stat-label {
            font-size: 13px;
            color: #999;
        }

        .stat-change {
            font-size: 12px;
            margin-top: 8px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .stat-change.positive {
            color: #27ae60;
        }

        .stat-change.negative {
            color: #ff4757;
        }

        /* Status Pipeline */
        .section {
            background: white;
            padding: 25px;
            border-radius: 12px;
            margin-bottom: 30px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .section-title {
            font-size: 18px;
            font-weight: 600;
        }

        .pipeline-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
        }

        .pipeline-stage {
            flex: 1;
            text-align: center;
            position: relative;
        }

        .pipeline-badge {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 12px;
            font-size: 22px;
            font-weight: 600;
            color: white;
        }

        .pipeline-badge.pending {
            background: #27ae60;
        }

        .pipeline-badge.progress {
            background: #2c3e50;
        }

        .pipeline-stage-label {
            font-size: 13px;
            color: #666;
            font-weight: 500;
        }

        .pipeline-stage-count {
            font-size: 14px;
            color: #999;
            margin-top: 5px;
        }

        .pipeline-line {
            position: absolute;
            top: 30px;
            left: 50%;
            width: calc(100% - 60px);
            height: 2px;
            background: #27ae60;
            z-index: 0;
        }

        /* Table */
        .complaints-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .complaints-table thead {
            background: #f8f9fa;
        }

        .complaints-table th {
            padding: 15px;
            text-align: left;
            font-size: 12px;
            font-weight: 600;
            color: #666;
            border-bottom: 2px solid #e0e0e0;
            cursor: pointer;
        }

        .complaints-table td {
            padding: 15px;
            border-bottom: 1px solid #e0e0e0;
            font-size: 13px;
        }

        .complaints-table tbody tr:hover {
            background: #f8f9fa;
        }

        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
        }

        .badge.assigned {
            background: #e3f2fd;
            color: #1976d2;
        }

        .badge.accepted {
            background: #e3f2fd;
            color: #1976d2;
        }

        .badge.in-progress {
            background: #fff3e0;
            color: #f57c00;
        }

        .badge.resolved {
            background: #e8f5e9;
            color: #388e3c;
        }

        .badge.closed {
            background: #f5f5f5;
            color: #666;
        }

        .priority-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
        }

        .priority-badge.critical {
            background: #ffebee;
            color: #d32f2f;
        }

        .priority-badge.high {
            background: #fff3e0;
            color: #f57c00;
        }

        .priority-badge.medium {
            background: #fce4ec;
            color: #c2185b;
        }

        .priority-badge.low {
            background: #e0f2f1;
            color: #00897b;
        }

        .results-count {
            color: #999;
            font-size: 12px;
        }

        /* Responsive */
        @media (max-width: 1200px) {
            .stats-grid {
                grid-template-columns: repeat(3, 1fr);
            }
        }

        @media (max-width: 768px) {
            .sidebar {
                display: none;
            }

            .main-content {
                margin-left: 0;
            }

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .search-box {
                width: 100%;
            }

            .pipeline-container {
                flex-wrap: wrap;
                gap: 15px;
            }

            .complaints-table {
                font-size: 11px;
            }

            .complaints-table th, .complaints-table td {
                padding: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-brand">
                <div class="sidebar-brand-icon">⚙️</div>
                <span>ServiceCore</span>
            </div>

            <ul class="sidebar-nav">
                <li>
                    <a href="HomePage.aspx" class="active">
                        <span class="sidebar-nav-icon">📊</span>
                        Dashboard
                    </a>
                </li>
                <li class="sidebar-dropdown">
                    <button type="button" onclick="toggleSidebarDropdown(event, 'technicalDropdown')" class="sidebar-dropdown-toggle">
                        <span><span class="sidebar-nav-icon">🔧</span>Technical</span>
                    </button>
                    <div class="sidebar-dropdown-menu" id="technicalDropdown">
                        <a href="AllComplaints.aspx?type=Technical">All Complaints</a>
                        <a href="NewComplaint.aspx?type=Technical">New Complaint</a>
                    </div>
                </li>
                <li>
                    <a href="#SOC">
                        <span class="sidebar-nav-icon">🎯</span>
                        SOC
                    </a>
                </li>
                <li class="sidebar-dropdown">
                    <button type="button" onclick="toggleSidebarDropdown(event, 'telephoneDropdown')" class="sidebar-dropdown-toggle">
                        <span><span class="sidebar-nav-icon">☎️</span>Telephone</span>
                    </button>
                    <div class="sidebar-dropdown-menu" id="telephoneDropdown">
                        <a href="AllComplaints.aspx?type=Telephone">All Complaints</a>
                        <a href="NewComplaint.aspx?type=Telephone">New Complaint</a>
                    </div>
                </li>
                <li>
                    <a href="#VCBooking">
                        <span class="sidebar-nav-icon">📹</span>
                        VC Booking
                    </a>
                </li>
            </ul>

            <div class="sidebar-bottom">
                <a href="#Profile">
                    <span class="sidebar-nav-icon">👤</span>
                    Profile
                </a>
                <a href="Login.aspx" class="logout">
                    <span class="sidebar-nav-icon">🚪</span>
                    Logout
                </a>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Header -->
            <div class="dashboard-header">
                <h1 class="dashboard-title">Dashboard</h1>
                <div class="dashboard-controls">
                    <div class="search-box">
                        <span>🔍</span>
                        <input type="text" placeholder="Search complaints...">
                    </div>

                    <div class="dropdown-filter" id="statusDropdown">
                        <button class="dropdown-btn" onclick="toggleDropdown('statusDropdown', event)" type="button">
                            <span id="statusLabel">All Status</span>
                            <span>▼</span>
                        </button>
                        <div class="dropdown-content">
                            <a href="#" onclick="selectStatus('All Status')">All Status</a>
                            <a href="#" onclick="selectStatus('Assigned')">Assigned</a>
                            <a href="#" onclick="selectStatus('Accepted')">Accepted</a>
                            <a href="#" onclick="selectStatus('In Progress')">In Progress</a>
                            <a href="#" onclick="selectStatus('Resolved')">Resolved</a>
                            <a href="#" onclick="selectStatus('Closed')">Closed</a>
                        </div>
                    </div>

                    <div class="dropdown-filter" id="priorityDropdown">
                        <button class="dropdown-btn" onclick="toggleDropdown('priorityDropdown', event)" type="button">
                            <span id="priorityLabel">All Priority</span>
                            <span>▼</span>
                        </button>
                        <div class="dropdown-content">
                            <a href="#" onclick="selectPriority('All Priority')">All Priority</a>
                            <a href="#" onclick="selectPriority('Critical')">Critical</a>
                            <a href="#" onclick="selectPriority('High')">High</a>
                            <a href="#" onclick="selectPriority('Medium')">Medium</a>
                            <a href="#" onclick="selectPriority('Low')">Low</a>
                        </div>
                    </div>

                    <div class="new-complaint-dropdown" id="newComplaintDropdown">
                        <button type="button" class="new-complaint-btn" onclick="toggleNewComplaintMenu(event)">
                            <span>+</span>
                            New Complaint
                        </button>
                        <div class="new-complaint-menu">
                            <a href="NewComplaint.aspx?type=Technical">Technical</a>
                            <a href="NewComplaint.aspx?type=Telephone">Telephone</a>
                            <a href="NewComplaint.aspx">Generic</a>
                        </div>
                    </div>

                    <div class="notification-bell">
                        🔔
                        <span class="notification-badge">1</span>
                    </div>
                    <div class="profile-icon">JD</div>
                </div>
            </div>

            <!-- Stats Cards -->
            <div class="stats-grid" id="statsGrid">
                <div class="stat-card total">
                    <div class="stat-icon">📋</div>
                    <div class="stat-value">-</div>
                    <div class="stat-label">Total Complaints</div>
                    <div class="stat-change positive">↑ +12%</div>
                </div>

                <div class="stat-card ongoing">
                    <div class="stat-icon">⏳</div>
                    <div class="stat-value">-</div>
                    <div class="stat-label">Ongoing</div>
                    <div class="stat-change positive">↑ +5%</div>
                </div>

                <div class="stat-card resolved">
                    <div class="stat-icon">✅</div>
                    <div class="stat-value">-</div>
                    <div class="stat-label">Resolved</div>
                    <div class="stat-change positive">↑ +8%</div>
                </div>

                <div class="stat-card closed">
                    <div class="stat-icon">🔒</div>
                    <div class="stat-value">-</div>
                    <div class="stat-label">Closed</div>
                    <div class="stat-change negative">↓ -2%</div>
                </div>

                <div class="stat-card transferred">
                    <div class="stat-icon">↔️</div>
                    <div class="stat-value">-</div>
                    <div class="stat-label">Transferred</div>
                    <div class="stat-change positive">↑ +3%</div>
                </div>
            </div>

            <!-- Status Pipeline -->
            <div class="section">
                <div class="section-header">
                    <h2 class="section-title">Status Pipeline</h2>
                    <a href="#" style="color: #4a90e2; font-size: 12px; text-decoration: none;">Click to filter</a>
                </div>

                <div class="pipeline-container">
                    <div class="pipeline-stage">
                        <div class="pipeline-badge pending">✓</div>
                        <div class="pipeline-stage-label">Assigned</div>
                        <div class="pipeline-stage-count" id="pipelineAssigned">-</div>
                    </div>

                    <div class="pipeline-line" style="left: 10%; width: 80%; background: #27ae60;"></div>

                    <div class="pipeline-stage">
                        <div class="pipeline-badge pending">✓</div>
                        <div class="pipeline-stage-label">Accepted</div>
                        <div class="pipeline-stage-count" id="pipelineAccepted">-</div>
                    </div>

                    <div class="pipeline-line" style="left: 10%; width: 80%; background: #27ae60;"></div>

                    <div class="pipeline-stage">
                        <div class="pipeline-badge progress">45</div>
                        <div class="pipeline-stage-label">In Progress</div>
                        <div class="pipeline-stage-count" id="pipelineProgress">45</div>
                    </div>

                    <div class="pipeline-line" style="left: 10%; width: 80%; background: #ddd;"></div>

                    <div class="pipeline-stage">
                        <div class="pipeline-badge" style="background: #f39c12;">142</div>
                        <div class="pipeline-stage-label">Resolved</div>
                        <div class="pipeline-stage-count" id="pipelineResolved">142</div>
                    </div>

                    <div class="pipeline-line" style="left: 10%; width: 80%; background: #ddd;"></div>

                    <div class="pipeline-stage">
                        <div class="pipeline-badge" style="background: #95a5a6;">35</div>
                        <div class="pipeline-stage-label">Closed</div>
                        <div class="pipeline-stage-count" id="pipelineClosed">35</div>
                    </div>
                </div>
            </div>

            <!-- Recent Complaints -->
            <div class="section">
                <div class="section-header">
                    <h2 class="section-title">Recent Complaints</h2>
                    <span class="results-count">10 results</span>
                </div>

                <table class="complaints-table" id="complaintsTable">
                    <thead>
                        <tr>
                            <th>ID ⬇️</th>
                            <th>Type ⬇️</th>
                            <th>Status ⬇️</th>
                            <th>Priority ⬇️</th>
                            <th>Assigned To ⬇️</th>
                            <th>Date ⬇️</th>
                        </tr>
                    </thead>
                    <tbody id="complaintsList">
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 40px;">Loading complaints...</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        function toggleDropdown(dropdownId, event) {
            event.preventDefault();
            const dropdown = document.getElementById(dropdownId);
            dropdown.classList.toggle('active');

            // Close other dropdowns
            document.querySelectorAll('.dropdown-filter').forEach(d => {
                if (d.id !== dropdownId) {
                    d.classList.remove('active');
                }
            });
        }

        function toggleSidebarDropdown(event, dropdownId) {
            event.preventDefault();
            const dropdown = document.getElementById(dropdownId);
            const parentItem = event.target.closest('li');

            if (parentItem) {
                parentItem.classList.toggle('active');

                // Close other sidebar dropdowns
                document.querySelectorAll('.sidebar-dropdown').forEach(item => {
                    if (item !== parentItem) {
                        item.classList.remove('active');
                    }
                });
            }
        }

        function selectStatus(status) {
            event.preventDefault();
            document.getElementById('statusLabel').textContent = status;
            document.getElementById('statusDropdown').classList.remove('active');
            // TODO: Filter table by status
        }

        function selectPriority(priority) {
            event.preventDefault();
            document.getElementById('priorityLabel').textContent = priority;
            document.getElementById('priorityDropdown').classList.remove('active');
            // TODO: Filter table by priority
        }

        function toggleNewComplaintMenu(event) {
            event.preventDefault();
            const dropdown = document.getElementById('newComplaintDropdown');
            dropdown.classList.toggle('active');

            // Close other dropdowns
            document.querySelectorAll('.dropdown-filter').forEach(d => {
                d.classList.remove('active');
            });
        }

        // Close dropdowns when clicking outside
        document.addEventListener('click', function (event) {
            // Check if click is on a link inside dropdown menu - allow it to navigate
            if (event.target.closest('.sidebar-dropdown-menu a')) {
                // Allow the link to work, just close the dropdown
                document.querySelectorAll('.sidebar-dropdown').forEach(dropdown => {
                    dropdown.classList.remove('active');
                });
                return;
            }

            const dropdowns = document.querySelectorAll('.dropdown-filter');
            dropdowns.forEach(dropdown => {
                if (!dropdown.contains(event.target)) {
                    dropdown.classList.remove('active');
                }
            });

            // Close new complaint menu
            const newComplaintDropdown = document.getElementById('newComplaintDropdown');
            if (newComplaintDropdown && !newComplaintDropdown.contains(event.target)) {
                newComplaintDropdown.classList.remove('active');
            }

            // Close sidebar dropdowns when clicking outside sidebar
            if (!event.target.closest('.sidebar-dropdown') && !event.target.closest('.sidebar-dropdown-toggle')) {
                document.querySelectorAll('.sidebar-dropdown').forEach(dropdown => {
                    dropdown.classList.remove('active');
                });
            }
        });

        // Load dashboard data from server
        window.addEventListener('load', function () {
            loadDashboardData();
        });

        function loadDashboardData() {
            // This will be called by the code-behind to populate data
            // Data will be passed from server via hidden fields or AJAX
        }
    </script>
</body>
</html>
