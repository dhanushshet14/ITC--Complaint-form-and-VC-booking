<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AllComplaints.aspx.cs" Inherits="ComplaintSystem.AllComplaints" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>All Complaints - ServiceCore</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
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

        .dropdown-arrow {
            font-size: 12px;
            transition: transform 0.3s;
            margin-left: auto;
        }

        .sidebar-dropdown.active .dropdown-arrow {
            transform: rotate(180deg);
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

        .sidebar-nav-icon {
            width: 20px;
            text-align: center;
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
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .page-title {
            font-size: 28px;
            font-weight: 700;
        }

        .page-controls {
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
        }

        .new-complaint-btn:hover {
            background: #4a90e2;
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

        /* Tab Navigation */
        .tab-navigation {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            border-bottom: 2px solid #e0e0e0;
        }

        .tab-btn {
            padding: 12px 20px;
            background: none;
            border: none;
            border-bottom: 3px solid transparent;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            color: #666;
            transition: all 0.3s;
        }

        .tab-btn.active {
            color: #1a1a2e;
            border-bottom-color: #4a90e2;
        }

        .tab-btn:hover {
            color: #4a90e2;
        }

        /* Complaints Section */
        .complaints-section {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            overflow: hidden;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 25px;
            border-bottom: 1px solid #e0e0e0;
        }

        .section-title {
            font-size: 16px;
            font-weight: 600;
        }

        .results-count {
            color: #999;
            font-size: 13px;
        }

        .content-area {
            display: flex;
            gap: 20px;
            padding: 0;
        }

        .sidebar-section {
            width: 30%;
            border-right: 1px solid #e0e0e0;
            min-height: 600px;
            overflow-y: auto;
            max-height: 600px;
        }

        .details-section {
            width: 70%;
            padding: 25px;
        }

        .complaint-list {
            list-style: none;
        }

        .complaint-item {
            padding: 15px 15px;
            border-bottom: 1px solid #f0f0f0;
            cursor: pointer;
            transition: all 0.3s;
        }

        .complaint-item:hover {
            background: #f8f9fa;
        }

        .complaint-item.active {
            background: #e3f2fd;
            border-left: 4px solid #4a90e2;
            padding-left: 11px;
        }

        .complaint-id {
            font-size: 13px;
            font-weight: 600;
            color: #4a90e2;
            margin-bottom: 5px;
        }

        .complaint-title {
            font-size: 14px;
            font-weight: 500;
            color: #333;
            margin-bottom: 8px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .complaint-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 12px;
        }

        .complaint-type {
            color: #666;
        }

        .complaint-priority {
            padding: 3px 8px;
            border-radius: 3px;
            font-weight: 600;
        }

        .priority-critical {
            background: #ffebee;
            color: #d32f2f;
        }

        .priority-high {
            background: #fff3e0;
            color: #f57c00;
        }

        .priority-medium {
            background: #fce4ec;
            color: #c2185b;
        }

        .priority-low {
            background: #e0f2f1;
            color: #00897b;
        }

        /* Detail View */
        .no-selection {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 500px;
            color: #999;
        }

        .no-selection-icon {
            font-size: 60px;
            margin-bottom: 15px;
        }

        .no-selection-text {
            font-size: 16px;
            font-weight: 500;
            margin-bottom: 5px;
        }

        .no-selection-hint {
            font-size: 13px;
            color: #bbb;
        }

        .detail-header {
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 2px solid #e0e0e0;
        }

        .detail-title {
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .detail-meta {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }

        .meta-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
        }

        .meta-label {
            color: #999;
            font-weight: 500;
        }

        .meta-value {
            color: #333;
            font-weight: 600;
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

        .detail-section-title {
            font-size: 14px;
            font-weight: 600;
            margin-top: 20px;
            margin-bottom: 12px;
            color: #333;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #f0f0f0;
            font-size: 13px;
        }

        .detail-row-label {
            color: #666;
            font-weight: 500;
        }

        .detail-row-value {
            color: #333;
            font-weight: 500;
        }

        .description-box {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            font-size: 13px;
            line-height: 1.6;
            margin: 15px 0;
            color: #555;
        }

        /* Responsive */
        @media (max-width: 1200px) {
            .sidebar {
                width: 160px;
            }

            .main-content {
                margin-left: 160px;
            }

            .sidebar-section {
                width: 35%;
            }

            .details-section {
                width: 65%;
            }
        }

        @media (max-width: 768px) {
            .sidebar {
                display: none;
            }

            .main-content {
                margin-left: 0;
                padding: 15px;
            }

            .content-area {
                flex-direction: column;
            }

            .sidebar-section {
                width: 100%;
                max-height: 400px;
                border-right: none;
                border-bottom: 1px solid #e0e0e0;
            }

            .details-section {
                width: 100%;
                padding: 15px;
            }

            .page-controls {
                flex-direction: column;
                width: 100%;
            }

            .search-box {
                width: 100%;
            }

            .tab-navigation {
                overflow-x: auto;
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
                    <a href="HomePage.aspx">
                        <span class="sidebar-nav-icon">📊</span>
                        Dashboard
                    </a>
                </li>
                <li class="sidebar-dropdown">
                    <button type="button" onclick="toggleSidebarDropdown(event, 'technicalDropdown')" class="sidebar-dropdown-toggle">
                        <span class="sidebar-nav-icon">🔧</span>
                        <span>Technical</span>
                        <span class="dropdown-arrow">▼</span>
                    </button>
                    <div class="sidebar-dropdown-menu" id="technicalDropdown">
                        <a href="AllComplaints.aspx?type=Technical">All Complaints</a>
                        <a href="NewComplaint.aspx?type=Technical">New Complaint</a>
                    </div>
                </li>
                <li>
                    <a href="#">
                        <span class="sidebar-nav-icon">🎯</span>
                        SOC
                    </a>
                </li>
                <li class="sidebar-dropdown">
                    <button type="button" onclick="toggleSidebarDropdown(event, 'telephoneDropdown')" class="sidebar-dropdown-toggle">
                        <span class="sidebar-nav-icon">☎️</span>
                        <span>Telephone</span>
                        <span class="dropdown-arrow">▼</span>
                    </button>
                    <div class="sidebar-dropdown-menu" id="telephoneDropdown">
                        <a href="AllComplaints.aspx?type=Telephone">All Complaints</a>
                        <a href="NewComplaint.aspx?type=Telephone">New Complaint</a>
                    </div>
                </li>
                <li>
                    <a href="#">
                        <span class="sidebar-nav-icon">📹</span>
                        VC Booking
                    </a>
                </li>
            </ul>

            <div class="sidebar-bottom">
                <a href="#">
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
            <div class="page-header">
                <h1 class="page-title" id="pageTitle">Technical Complaints</h1>
                <div class="page-controls">
                    <div class="search-box">
                        <span>🔍</span>
                        <input type="text" placeholder="Search complaints..." id="searchBox" onkeyup="filterComplaints()">
                    </div>

                    <div class="dropdown-filter" id="statusDropdown">
                        <button class="dropdown-btn" onclick="toggleDropdown('statusDropdown', event)" type="button">
                            <span id="statusLabel">All Status</span>
                            <span>▼</span>
                        </button>
                        <div class="dropdown-content">
                            <a href="#" onclick="selectStatus(event, 'All Status')">All Status</a>
                            <a href="#" onclick="selectStatus(event, 'Assigned')">Assigned</a>
                            <a href="#" onclick="selectStatus(event, 'Accepted')">Accepted</a>
                            <a href="#" onclick="selectStatus(event, 'InProgress')">In Progress</a>
                            <a href="#" onclick="selectStatus(event, 'Resolved')">Resolved</a>
                            <a href="#" onclick="selectStatus(event, 'Closed')">Closed</a>
                        </div>
                    </div>

                    <div class="dropdown-filter" id="priorityDropdown">
                        <button class="dropdown-btn" onclick="toggleDropdown('priorityDropdown', event)" type="button">
                            <span id="priorityLabel">All Priority</span>
                            <span>▼</span>
                        </button>
                        <div class="dropdown-content">
                            <a href="#" onclick="selectPriority(event, 'All Priority')">All Priority</a>
                            <a href="#" onclick="selectPriority(event, 'Critical')">Critical</a>
                            <a href="#" onclick="selectPriority(event, 'High')">High</a>
                            <a href="#" onclick="selectPriority(event, 'Medium')">Medium</a>
                            <a href="#" onclick="selectPriority(event, 'Low')">Low</a>
                        </div>
                    </div>

                    <button type="button" class="new-complaint-btn" onclick="goToNewComplaint()">
                        <span>+</span>
                        New Complaint
                    </button>

                    <div class="notification-bell">
                        🔔
                        <span class="notification-badge">1</span>
                    </div>
                    <div class="profile-icon">JD</div>
                </div>
            </div>

            <!-- Tab Navigation -->
            <div class="tab-navigation">
                <button class="tab-btn active" onclick="selectTab(event, 'all')">All</button>
                <button class="tab-btn" onclick="selectTab(event, 'my-complaints')">My Complaints</button>
                <button class="tab-btn" onclick="selectTab(event, 'high-priority')">High Priority</button>
            </div>

            <!-- Complaints View -->
            <div class="complaints-section">
                <div class="section-header">
                    <h2 class="section-title" id="sectionTitle">All Complaints</h2>
                    <span class="results-count"><span id="complaintCount">0</span> complaints</span>
                </div>

                <div class="content-area">
                    <!-- Complaints List -->
                    <div class="sidebar-section">
                        <ul class="complaint-list" id="complaintsList">
                                <li style="padding: 20px; text-align: center; color: #999;">Loading complaints...</li>
                            </ul>
                        </div>

                        <!-- Detail View -->
                        <div class="details-section" id="detailsSection">
                            <div class="no-selection">
                                <div class="no-selection-icon">📋</div>
                                <div class="no-selection-text">No complaint selected</div>
                                <div class="no-selection-hint">Click a row on the left to view full complaint details here.</div>
                            </div>
                        </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        let allComplaints = [];
        let filteredComplaints = [];
        let currentComplaintType = '<%= complaintType %>';
        let currentStatusFilter = 'All Status';
        let currentPriorityFilter = 'All Priority';

        window.addEventListener('load', function () {
            loadComplaints();
            setPageTitle();
        });

        function goToNewComplaint() {
            window.location.href = 'NewComplaint.aspx?type=' + encodeURIComponent(currentComplaintType);
        }

        function setPageTitle() {
            const type = currentComplaintType;
            document.getElementById('pageTitle').textContent = type + ' Complaints';
            document.getElementById('sectionTitle').textContent = 'All ' + type + ' Complaints';
        }

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

        function selectStatus(event, status) {
            event.preventDefault();
            currentStatusFilter = status;
            document.getElementById('statusLabel').textContent = status;
            document.getElementById('statusDropdown').classList.remove('active');
            filterComplaints();
        }

        function selectPriority(event, priority) {
            event.preventDefault();
            currentPriorityFilter = priority;
            document.getElementById('priorityLabel').textContent = priority;
            document.getElementById('priorityDropdown').classList.remove('active');
            filterComplaints();
        }

        function selectTab(event, tab) {
            event.preventDefault();
            document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
            event.target.classList.add('active');
            // TODO: Implement tab filtering
            filterComplaints();
        }

        function loadComplaints() {
            fetch('AllComplaints.aspx?handler=GetComplaints&type=' + encodeURIComponent(currentComplaintType))
                .then(response => response.json())
                .then(data => {
                    allComplaints = data || [];
                    filterComplaints();
                })
                .catch(error => {
                    console.error('Error loading complaints:', error);
                    document.getElementById('complaintsList').innerHTML = '<li style="padding: 20px; text-align: center; color: #999;">Error loading complaints</li>';
                });
        }

        function filterComplaints() {
            const searchTerm = document.getElementById('searchBox').value.toLowerCase();

            filteredComplaints = allComplaints.filter(complaint => {
                let matches = true;

                // Search filter
                if (searchTerm) {
                    matches = complaint.ComplaintId.toLowerCase().includes(searchTerm) ||
                        complaint.Title.toLowerCase().includes(searchTerm) ||
                        complaint.Description.toLowerCase().includes(searchTerm);
                }

                // Status filter
                if (currentStatusFilter !== 'All Status') {
                    matches = matches && complaint.Status === currentStatusFilter;
                }

                // Priority filter
                if (currentPriorityFilter !== 'All Priority') {
                    matches = matches && complaint.Priority === currentPriorityFilter;
                }

                return matches;
            });

            renderComplaints();
        }

        function renderComplaints() {
            const complaintsList = document.getElementById('complaintsList');
            document.getElementById('complaintCount').textContent = filteredComplaints.length;

            if (filteredComplaints.length === 0) {
                complaintsList.innerHTML = '<li style="padding: 20px; text-align: center; color: #999;">No complaints found</li>';
                return;
            }

            complaintsList.innerHTML = filteredComplaints.map(complaint => `
                <li class="complaint-item" onclick="selectComplaint(event, ${complaint.ComplaintId})">
                    <div class="complaint-id">${complaint.ComplaintId}</div>
                    <div class="complaint-title">${complaint.Title}</div>
                    <div class="complaint-meta">
                        <span class="complaint-type">${complaint.Type}</span>
                        <span class="complaint-priority priority-${complaint.Priority.toLowerCase()}">${complaint.Priority}</span>
                    </div>
                </li>
            `).join('');
        }

        function selectComplaint(event, complaintId) {
            const complaint = filteredComplaints.find(c => c.ComplaintId == complaintId);
            if (!complaint) return;

            // Update active state
            document.querySelectorAll('.complaint-item').forEach(item => item.classList.remove('active'));
            const complaintItem = event.currentTarget;
            if (complaintItem && complaintItem.classList) {
                complaintItem.classList.add('active');
            }

            // Show detail view
            displayComplaintDetail(complaint);
        }

        function displayComplaintDetail(complaint) {
            const detailsSection = document.getElementById('detailsSection');
            const statusBadgeClass = getStatusBadgeClass(complaint.Status);
            const createdDate = new Date(complaint.CreatedDate).toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });
            const assignedTo = complaint.AssignedTo || 'Unassigned';

            detailsSection.innerHTML = `
                <div class="detail-header">
                    <div class="detail-title">${complaint.Title}</div>
                    <div class="detail-meta">
                        <div class="meta-item">
                            <span class="meta-label">ID:</span>
                            <span class="meta-value">${complaint.ComplaintId}</span>
                        </div>
                        <div class="meta-item">
                            <span class="meta-label">Status:</span>
                            <span class="badge ${statusBadgeClass}">${complaint.Status}</span>
                        </div>
                        <div class="meta-item">
                            <span class="meta-label">Priority:</span>
                            <span class="complaint-priority priority-${complaint.Priority.toLowerCase()}">${complaint.Priority}</span>
                        </div>
                        <div class="meta-item">
                            <span class="meta-label">Created:</span>
                            <span class="meta-value">${createdDate}</span>
                        </div>
                    </div>
                </div>

                <div class="detail-section-title">Details</div>
                <div class="detail-row">
                    <span class="detail-row-label">Type:</span>
                    <span class="detail-row-value">${complaint.Type}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-row-label">Assigned To:</span>
                    <span class="detail-row-value">${assignedTo}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-row-label">Category:</span>
                    <span class="detail-row-value">${complaint.Category || 'N/A'}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-row-label">Created By:</span>
                    <span class="detail-row-value">${complaint.CreatedBy || 'N/A'}</span>
                </div>

                <div class="detail-section-title">Description</div>
                <div class="description-box">${complaint.Description}</div>
            `;
        }

        function getStatusBadgeClass(status) {
            const statusMap = {
                'Assigned': 'assigned',
                'Accepted': 'accepted',
                'InProgress': 'in-progress',
                'Resolved': 'resolved',
                'Closed': 'closed'
            };
            return statusMap[status] || 'assigned';
        }

        // Close dropdowns when clicking outside
        document.addEventListener('click', function (event) {
            if (!event.target.closest('.dropdown-filter')) {
                document.querySelectorAll('.dropdown-filter').forEach(dropdown => {
                    dropdown.classList.remove('active');
                });
            }

            if (!event.target.closest('.sidebar-dropdown')) {
                document.querySelectorAll('.sidebar-dropdown').forEach(dropdown => {
                    dropdown.classList.remove('active');
                });
            }
        });
    </script>
</body>
</html>
