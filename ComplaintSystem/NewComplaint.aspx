<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NewComplaint.aspx.cs" Inherits="ComplaintSystem.NewComplaint" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>New Complaint - ServiceCore</title>
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

        /* Breadcrumb and Back Button */
        .breadcrumb-section {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 1px solid #e0e0e0;
        }

        .back-button {
            background: none;
            border: none;
            color: #4a90e2;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            padding: 8px 12px;
            border-radius: 4px;
            transition: all 0.3s;
            white-space: nowrap;
        }

        .back-button:hover {
            background: rgba(74, 144, 226, 0.1);
            color: #2563eb;
        }

        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
        }

        .breadcrumb a {
            color: #4a90e2;
            text-decoration: none;
            transition: all 0.3s;
        }

        .breadcrumb a:hover {
            color: #2563eb;
            text-decoration: underline;
        }

        .breadcrumb-separator {
            color: #ccc;
            margin: 0 4px;
        }

        .breadcrumb-current {
            color: #666;
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

        /* Form Sections */
        .form-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            padding: 40px;
            max-width: 900px;
            margin: 0 auto;
        }

        .form-section {
            margin-bottom: 40px;
        }

        .section-header {
            display: flex;
            align-items: flex-start;
            gap: 15px;
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 2px solid #e0e0e0;
        }

        .section-number {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            background: #e8f0ff;
            color: #4a90e2;
            border-radius: 8px;
            font-weight: 600;
            font-size: 16px;
            flex-shrink: 0;
        }

        .section-content {
            flex: 1;
        }

        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #1a1a2e;
            margin-bottom: 5px;
        }

        .section-description {
            font-size: 13px;
            color: #666;
            line-height: 1.5;
        }

        /* Form Fields */
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 25px;
            margin-bottom: 25px;
        }

        .form-row.single {
            grid-template-columns: 1fr;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-label {
            font-size: 14px;
            font-weight: 500;
            color: #333;
            margin-bottom: 8px;
        }

        .form-label.required::after {
            content: " *";
            color: #ff4757;
        }

        .form-control {
            padding: 12px 15px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.3s;
        }

        .form-control:focus {
            outline: none;
            border-color: #4a90e2;
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
        }

        .form-control:disabled {
            background-color: #f5f5f5;
            color: #999;
            cursor: not-allowed;
        }

        /* Dropdown Styles */
        select.form-control {
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 12px center;
            background-size: 16px;
            padding-right: 40px;
        }

        /* Priority Level Cards */
        .priority-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
        }

        .priority-card {
            padding: 20px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
            position: relative;
        }

        .priority-card:hover {
            border-color: #4a90e2;
            background: rgba(74, 144, 226, 0.05);
        }

        .priority-card input[type="radio"] {
            position: absolute;
            opacity: 0;
        }

        .priority-card input[type="radio"]:checked + .priority-content {
            color: inherit;
        }

        .priority-card input[type="radio"]:checked ~ .priority-check {
            display: block;
        }

        .priority-check {
            display: none;
            position: absolute;
            top: 10px;
            right: 10px;
            width: 20px;
            height: 20px;
            background: #4a90e2;
            border-radius: 50%;
            color: white;
            font-size: 12px;
            font-weight: 600;
            line-height: 20px;
            text-align: center;
        }

        .priority-icon {
            font-size: 24px;
            margin-bottom: 8px;
        }

        .priority-name {
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .priority-desc {
            font-size: 12px;
            color: #666;
            line-height: 1.4;
        }

        .priority-card.low {
            border-color: #00897b;
            color: #00897b;
        }

        .priority-card.low input[type="radio"]:checked {
            background: #00897b;
        }

        .priority-card.low input[type="radio"]:checked ~ * {
            color: #00897b;
        }

        .priority-card.medium {
            border-color: #c2185b;
            color: #c2185b;
        }

        .priority-card.high {
            border-color: #f57c00;
            color: #f57c00;
        }

        .priority-card.critical {
            border-color: #d32f2f;
            color: #d32f2f;
        }

        /* Radio Button Styling */
        .radio-group {
            display: flex;
            gap: 15px;
            margin-top: 12px;
        }

        .radio-option {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 12px 18px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 14px;
        }

        .radio-option input[type="radio"] {
            accent-color: #4a90e2;
            cursor: pointer;
        }

        .radio-option input[type="radio"]:checked {
            accent-color: #4a90e2;
        }

        .radio-option input[type="radio"]:checked + label {
            font-weight: 600;
        }

        .radio-option:has(input[type="radio"]:checked) {
            border-color: #4a90e2;
            background: rgba(74, 144, 226, 0.05);
        }

        .radio-option.yes-checked {
            border-color: #ff6b6b;
            background: #ffe0e0;
        }

        .radio-option.yes-checked input {
            accent-color: #ff6b6b;
        }

        .radio-option.no-checked {
            border-color: #51cf66;
            background: #e7f5ee;
        }

        .radio-option.no-checked input {
            accent-color: #51cf66;
        }

        .radio-option label {
            cursor: pointer;
            margin: 0;
        }

        /* Form Title Section */
        .form-title-section {
            margin-bottom: 30px;
            text-align: center;
        }

        .form-main-title {
            font-size: 24px;
            font-weight: 700;
            color: #1a1a2e;
            margin-bottom: 8px;
        }

        .form-subtitle {
            font-size: 14px;
            color: #666;
            line-height: 1.5;
        }

        .required-mark {
            color: #ff4757;
            font-weight: 600;
        }

        /* Form Steps Indicator */
        .form-steps {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0;
            margin-bottom: 40px;
            padding: 20px 0;
            border-bottom: 1px solid #e0e0e0;
        }

        .step-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
            position: relative;
        }

        .step-circle {
            display: flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            background: #f0f0f0;
            border: 2px solid #e0e0e0;
            border-radius: 50%;
            font-weight: 600;
            color: #999;
            font-size: 14px;
            transition: all 0.3s;
        }

        .step-item.active .step-circle {
            background: #4a90e2;
            color: white;
            border-color: #4a90e2;
        }

        .step-item.completed .step-circle {
            background: #51cf66;
            color: white;
            border-color: #51cf66;
        }

        .step-label {
            font-size: 12px;
            font-weight: 500;
            color: #999;
            white-space: nowrap;
            transition: all 0.3s;
        }

        .step-item.active .step-label {
            color: #4a90e2;
            font-weight: 600;
        }

        .step-item.completed .step-label {
            color: #51cf66;
            font-weight: 600;
        }

        .step-line {
            flex: 1;
            height: 2px;
            background: #e0e0e0;
            margin: 0 10px;
            min-width: 40px;
            max-width: 80px;
        }

        /* Conditional Section */
        .conditional-section {
            display: none;
            margin-top: 20px;
            padding: 15px;
            background: #fff5f5;
            border-left: 4px solid #ff4757;
            border-radius: 4px;
        }

        .conditional-section.show {
            display: block;
        }

        .alert-message {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #ff4757;
            font-size: 13px;
            margin-bottom: 15px;
        }

        .alert-icon {
            font-size: 18px;
        }

        .form-control.impact-reason {
            resize: vertical;
            min-height: 80px;
        }

        .char-count {
            font-size: 12px;
            color: #999;
            text-align: right;
            margin-top: 5px;
        }

        /* Description Section */
        .description-textarea {
            resize: vertical;
            min-height: 150px;
            font-family: inherit;
        }

        /* Title Textarea */
        .title-textarea {
            resize: vertical;
            min-height: 60px;
            font-family: inherit;
            font-size: 14px;
        }

        /* Attachments */
        .upload-area {
            border: 2px dashed #e0e0e0;
            border-radius: 8px;
            padding: 40px 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
            background: #fafafa;
        }

        .upload-area:hover {
            border-color: #4a90e2;
            background: rgba(74, 144, 226, 0.05);
        }

        .upload-area.dragover {
            border-color: #4a90e2;
            background: rgba(74, 144, 226, 0.1);
        }

        .upload-icon {
            font-size: 40px;
            margin-bottom: 15px;
        }

        .upload-text {
            font-size: 14px;
            color: #666;
        }

        .upload-hint {
            font-size: 12px;
            color: #999;
            margin-top: 5px;
        }

        .file-input {
            display: none;
        }

        /* Form Progress */
        .form-progress {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            padding: 0 0 20px 0;
            border-bottom: 1px solid #e0e0e0;
        }

        .progress-text {
            font-size: 13px;
            color: #999;
        }

        .progress-bar {
            width: 150px;
            height: 4px;
            background: #e0e0e0;
            border-radius: 2px;
            overflow: hidden;
            margin: 0 15px;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #4a90e2, #4a90e2);
            border-radius: 2px;
            transition: width 0.3s;
            width: 22%;
        }

        /* Form Actions */
        .form-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
        }

        .cancel-btn {
            padding: 12px 25px;
            background: white;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            color: #333;
            transition: all 0.3s;
        }

        .cancel-btn:hover {
            border-color: #999;
            background: #f5f5f5;
        }

        .actions-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .submit-btn {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 12px 25px;
            background: #1a1a2e;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.3s;
        }

        .submit-btn:hover {
            background: #4a90e2;
        }

        .submit-btn:disabled {
            background: #ccc;
            cursor: not-allowed;
        }

        .submit-arrow {
            font-size: 16px;
        }

        /* Info Icon */
        .info-icon {
            cursor: help;
            color: #999;
            font-size: 16px;
            display: inline-block;
            margin-left: 5px;
        }

        /* Responsive */
        @media (max-width: 1200px) {
            .sidebar {
                width: 160px;
            }

            .main-content {
                margin-left: 160px;
                padding: 20px;
            }

            .priority-grid {
                grid-template-columns: repeat(2, 1fr);
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

            .form-container {
                padding: 20px;
            }

            .form-row {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .priority-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .form-actions {
                flex-direction: column-reverse;
                gap: 15px;
            }

            .cancel-btn,
            .submit-btn {
                width: 100%;
            }

            .actions-right {
                width: 100%;
                gap: 10px;
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
                <li>
                    <a href="AllComplaints.aspx?type=Technical">
                        <span class="sidebar-nav-icon">🔧</span>
                        Technical
                    </a>
                </li>
                <li>
                    <a href="#">
                        <span class="sidebar-nav-icon">🎯</span>
                        SOC
                    </a>
                </li>
                <li>
                    <a href="AllComplaints.aspx?type=Telephone">
                        <span class="sidebar-nav-icon">☎️</span>
                        Telephone
                    </a>
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
            <!-- Back Button and Breadcrumb -->
            <div class="breadcrumb-section">
                <button class="back-button" onclick="goBack()">← Back</button>
                <div class="breadcrumb">
                    <a href="HomePage.aspx">Dashboard</a>
                    <span class="breadcrumb-separator">›</span>
                    <a href="#" id="complaintTypeBread" class="breadcrumb-current">Technical</a>
                    <span class="breadcrumb-separator">›</span>
                    <span class="breadcrumb-current">New Complaint</span>
                </div>
            </div>

            <!-- Header -->
            <div class="page-header">
                <h1 class="page-title" id="pageTitle">New Technical Complaint</h1>
                <div class="page-controls">
                    <div class="notification-bell">
                        🔔
                        <span class="notification-badge">1</span>
                    </div>
                    <div class="profile-icon">JD</div>
                </div>
            </div>

            <!-- Complaint Form -->
            <div class="form-container">
                <form id="complaintForm" onsubmit="handleFormSubmit(event)">
                    <!-- Form Title and Description -->
                    <div class="form-title-section">
                        <h2 class="form-main-title">New Technical Complaint</h2>
                        <p class="form-subtitle">Complete all required fields to submit a complaint. Fields marked <span class="required-mark">*</span> are mandatory.</p>
                    </div>

                    <!-- Form Steps Indicator -->
                    <div class="form-steps">
                        <div class="step-item active" id="step-basic">
                            <div class="step-circle">1</div>
                            <div class="step-label">Basic Info</div>
                        </div>
                        <div class="step-line"></div>
                        <div class="step-item" id="step-classification">
                            <div class="step-circle">2</div>
                            <div class="step-label">Classification</div>
                        </div>
                        <div class="step-line"></div>
                        <div class="step-item" id="step-priority">
                            <div class="step-circle">3</div>
                            <div class="step-label">Priority & Impact</div>
                        </div>
                        <div class="step-line"></div>
                        <div class="step-item" id="step-description">
                            <div class="step-circle">4</div>
                            <div class="step-label">Description</div>
                        </div>
                    </div>

                    <!-- Form Progress -->
                    <div class="form-progress">
                        <span class="progress-text">Form progress</span>
                        <div class="progress-bar">
                            <div class="progress-fill" id="progressFill"></div>
                        </div>
                        <span class="progress-text"><span id="progressPercent">11</span>% complete</span>
                    </div>

                    <!-- Section 1: Basic Information -->
                    <div class="form-section">
                        <div class="section-header">
                            <div class="section-number">01</div>
                            <div class="section-content">
                                <h2 class="section-title">Basic Information</h2>
                                <p class="section-description">Provide a clear title and classify the complaint type.</p>
                            </div>
                        </div>

                        <div class="form-row single">
                            <div class="form-group">
                                <label class="form-label required">Subject / Title</label>
                                <textarea class="form-control title-textarea" id="subjectTitle" placeholder="e.g. Complete network outage in Building 3, Wing B" maxlength="200" onchange="updateProgress()" oninput="updateCharCount(this)"></textarea>
                                <div class="char-count"><span id="titleCharCount">0</span>/200</div>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label required">Complaint Type</label>
                                <select class="form-control" id="complaintTypeSelect" onchange="updateProgress()">
                                    <option value="">Select type...</option>
                                    <option value="Hardware">Hardware</option>
                                    <option value="Software">Software</option>
                                    <option value="Network">Network</option>
                                    <option value="System">System</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label required">Unit / Department</label>
                                <select class="form-control" id="departmentSelect" onchange="updateProgress()">
                                    <option value="">Select department...</option>
                                    <option value="IT">IT Department</option>
                                    <option value="HR">Human Resources</option>
                                    <option value="Finance">Finance</option>
                                    <option value="Operations">Operations</option>
                                    <option value="Sales">Sales</option>
                                    <option value="Support">Support Services</option>
                                    <option value="Other">Other</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Section 2: Classification -->
                    <div class="form-section">
                        <div class="section-header">
                            <div class="section-number">02</div>
                            <div class="section-content">
                                <h2 class="section-title">Classification</h2>
                                <p class="section-description">Choose a category first — the subcategory options will update automatically.</p>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label required">Category</label>
                                <select class="form-control" id="categorySelect" onchange="updateSubcategories()">
                                    <option value="">Select category...</option>
                                    <option value="Hardware">Hardware</option>
                                    <option value="Software">Software</option>
                                    <option value="Network">Network</option>
                                    <option value="Database">Database</option>
                                    <option value="Application">Application</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label required">Subcategory</label>
                                <select class="form-control" id="subcategorySelect" disabled>
                                    <option value="">Select a category first</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Section 3: Priority & Impact -->
                    <div class="form-section">
                        <div class="section-header">
                            <div class="section-number">03</div>
                            <div class="section-content">
                                <h2 class="section-title">Priority & Impact</h2>
                                <p class="section-description">Select the urgency level and indicate whether customers are affected.</p>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label required">Priority Level</label>
                            <div class="priority-grid">
                                <label class="priority-card low">
                                    <input type="radio" name="priority" value="Low" onchange="updateProgress()">
                                    <div class="priority-check">✓</div>
                                    <div class="priority-content">
                                        <div class="priority-icon">🟢</div>
                                        <div class="priority-name">Low</div>
                                        <div class="priority-desc">Minor impact<br>Resolve within 72 hrs</div>
                                    </div>
                                </label>
                                <label class="priority-card medium">
                                    <input type="radio" name="priority" value="Medium" onchange="updateProgress()">
                                    <div class="priority-check">✓</div>
                                    <div class="priority-content">
                                        <div class="priority-icon">🟡</div>
                                        <div class="priority-name">Medium</div>
                                        <div class="priority-desc">Moderate impact<br>Resolve within 24 hrs</div>
                                    </div>
                                </label>
                                <label class="priority-card high">
                                    <input type="radio" name="priority" value="High" onchange="updateProgress()">
                                    <div class="priority-check">✓</div>
                                    <div class="priority-content">
                                        <div class="priority-icon">🟠</div>
                                        <div class="priority-name">High</div>
                                        <div class="priority-desc">Significant impact<br>Resolve within 4 hrs</div>
                                    </div>
                                </label>
                                <label class="priority-card critical">
                                    <input type="radio" name="priority" value="Critical" onchange="updateProgress()">
                                    <div class="priority-check">✓</div>
                                    <div class="priority-content">
                                        <div class="priority-icon">🔴</div>
                                        <div class="priority-name">Critical</div>
                                        <div class="priority-desc">System-wide impact<br>Immediate action required</div>
                                    </div>
                                </label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label required">Customer / End-user Impact
                                <span class="info-icon" title="Select whether customers are affected by this complaint">ⓘ</span>
                            </label>
                            <div class="radio-group">
                                <label class="radio-option" id="yesOption">
                                    <input type="radio" name="customerImpact" value="Yes" onchange="handleImpactChange()">
                                    <span>Yes — customers affected</span>
                                </label>
                                <label class="radio-option" id="noOption">
                                    <input type="radio" name="customerImpact" value="No" checked onchange="handleImpactChange()">
                                    <span>No — internal only</span>
                                </label>
                            </div>
                        </div>

                        <!-- Conditional Impact Section -->
                        <div class="conditional-section" id="impactSection">
                            <div class="alert-message">
                                <span class="alert-icon">⚠️</span>
                                <span>Customer impact detected — please provide additional context.</span>
                            </div>
                            <div class="form-group">
                                <label class="form-label required">Impact Reason</label>
                                <textarea class="form-control impact-reason" id="impactReason" placeholder="Briefly describe how customers are impacted..." maxlength="500" onchange="updateProgress()"></textarea>
                                <div class="char-count"><span id="charCount">0</span>/500</div>
                            </div>
                        </div>
                    </div>

                    <!-- Section 4: Description -->
                    <div class="form-section">
                        <div class="section-header">
                            <div class="section-number">04</div>
                            <div class="section-content">
                                <h2 class="section-title">Description</h2>
                                <p class="section-description">Provide a detailed account of the issue including timeline, scope, and any troubleshooting already attempted.</p>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label required">Detailed Description</label>
                            <textarea class="form-control description-textarea" id="description" placeholder="Describe the issue: what happened, when it started, how many users are affected, any error messages received, steps already taken to resolve..." onchange="updateProgress()"></textarea>
                        </div>
                    </div>

                    <!-- Section 5: Attachments -->
                    <div class="form-section">
                        <div class="section-header">
                            <div class="section-number">05</div>
                            <div class="section-content">
                                <h2 class="section-title">Attachments</h2>
                                <p class="section-description">Upload screenshots, error logs, or supporting documents. Optional but recommended.</p>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="upload-area" id="uploadArea" ondrop="handleDrop(event)" ondragover="handleDragOver(event)" ondragleave="handleDragLeave(event)" onclick="document.getElementById('fileInput').click()">
                                <div class="upload-icon">⬆️</div>
                                <div class="upload-text">Drag & drop files here, or click to browse</div>
                                <div class="upload-hint">PNG, JPG, PDF, TXT, CSV, LOG — up to 10 MB each</div>
                                <input type="file" id="fileInput" class="file-input" multiple onchange="handleFileSelect(event)">
                            </div>
                        </div>
                    </div>

                    <!-- Form Actions -->
                    <div class="form-actions">
                        <button type="button" class="cancel-btn" onclick="handleCancel()">Cancel</button>
                        <div class="actions-right">
                            <span class="progress-text">Form progress: <span id="progressPercent2">22</span>% complete</span>
                            <button type="submit" class="submit-btn" id="submitBtn">
                                <span>Submit Complaint</span>
                                <span class="submit-arrow">→</span>
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Subcategories mapping
        const subcategoriesMap = {
            'Hardware': ['Printer Issues', 'Monitor Issues', 'Keyboard/Mouse', 'Desktop PC', 'Laptop', 'Peripherals'],
            'Software': ['Email Client', 'Office Suite', 'Browser Issues', 'Antivirus', 'VPN', 'Custom Applications'],
            'Network': ['WiFi Connection', 'VPN Access', 'Internet Speed', 'Email Server', 'File Sharing', 'Remote Desktop'],
            'Database': ['Query Performance', 'Data Integrity', 'Backup Issues', 'Access Permissions', 'Connection Issues'],
            'Application': ['Login Issues', 'Performance', 'Features', 'Errors', 'Integration', 'Mobile App']
        };

        let complaintType = '<%= complaintType %>';

        window.addEventListener('load', function () {
            setPageTitle();
            document.getElementById('impactReason').addEventListener('input', function () {
                document.getElementById('charCount').textContent = this.value.length;
            });
        });

        function setPageTitle() {
            const type = complaintType || 'Technical';
            document.getElementById('pageTitle').textContent = 'New ' + type + ' Complaint';
            document.getElementById('complaintTypeBread').textContent = type;
            document.querySelector('.form-main-title').textContent = 'New ' + type + ' Complaint';
        }

        function goBack() {
            if (confirm('Are you sure you want to go back? Any unsaved changes will be lost.')) {
                window.location.href = 'AllComplaints.aspx?type=' + encodeURIComponent(complaintType);
            }
        }

        function updateCharCount(element) {
            const count = element.value.length;
            document.getElementById('titleCharCount').textContent = count;
        }

        function updateSubcategories() {
            const categorySelect = document.getElementById('categorySelect');
            const subcategorySelect = document.getElementById('subcategorySelect');
            const selectedCategory = categorySelect.value;

            if (selectedCategory && subcategoriesMap[selectedCategory]) {
                subcategorySelect.disabled = false;
                subcategorySelect.innerHTML = '<option value="">Select a subcategory</option>';
                subcategoriesMap[selectedCategory].forEach(sub => {
                    const option = document.createElement('option');
                    option.value = sub;
                    option.textContent = sub;
                    subcategorySelect.appendChild(option);
                });
            } else {
                subcategorySelect.disabled = true;
                subcategorySelect.innerHTML = '<option value="">Select a category first</option>';
            }
            updateProgress();
        }

        function handleImpactChange() {
            const yesRadio = document.querySelector('input[value="Yes"]');
            const impactSection = document.getElementById('impactSection');

            if (yesRadio && yesRadio.checked) {
                impactSection.classList.add('show');
            } else {
                impactSection.classList.remove('show');
                document.getElementById('impactReason').value = '';
                document.getElementById('charCount').textContent = '0';
            }
            updateProgress();
        }

        function toggleImpactSection(showSection) {
            const impactSection = document.getElementById('impactSection');
            const yesOption = document.querySelector('input[value="Yes"]');
            const noOption = document.querySelector('input[value="No"]');

            if (yesOption && yesOption.checked) {
                impactSection.classList.add('show');
            } else {
                impactSection.classList.remove('show');
                document.getElementById('impactReason').value = '';
                document.getElementById('charCount').textContent = '0';
            }
        }

        function updateProgress() {
            const fields = {
                subjectTitle: document.getElementById('subjectTitle').value,
                complaintType: document.getElementById('complaintTypeSelect').value,
                department: document.getElementById('departmentSelect').value,
                category: document.getElementById('categorySelect').value,
                subcategory: document.getElementById('subcategorySelect').value,
                priority: document.querySelector('input[name="priority"]:checked'),
                customerImpact: document.querySelector('input[name="customerImpact"]:checked'),
                impactReason: document.getElementById('impactReason').value,
                description: document.getElementById('description').value
            };

            let completed = 0;
            let total = 9;

            // Basic Information (3 fields)
            if (fields.subjectTitle) completed++;
            if (fields.complaintType) completed++;
            if (fields.department) completed++;

            // Classification (2 fields)
            if (fields.category) completed++;
            if (fields.subcategory) completed++;

            // Priority & Impact (2 fields + conditional)
            if (fields.priority) completed++;
            if (fields.customerImpact) completed++;
            if (fields.customerImpact.value === 'No' || fields.impactReason) completed++;

            // Description (1 field)
            if (fields.description) completed++;

            const percentage = Math.round((completed / total) * 100);
            document.getElementById('progressFill').style.width = percentage + '%';
            document.getElementById('progressPercent').textContent = percentage;
            document.getElementById('progressPercent2').textContent = percentage;

            // Update step indicators
            updateStepIndicators(completed, total);
        }

        function updateStepIndicators(completed, total) {
            // Step 1: Basic Info (3 fields)
            if (completed >= 3) {
                document.getElementById('step-basic').classList.add('completed');
                document.getElementById('step-basic').classList.remove('active');
            } else if (completed >= 1) {
                document.getElementById('step-basic').classList.add('active');
                document.getElementById('step-basic').classList.remove('completed');
            }

            // Step 2: Classification (2 fields after Basic Info)
            if (completed >= 5) {
                document.getElementById('step-classification').classList.add('completed');
                document.getElementById('step-classification').classList.remove('active');
            } else if (completed >= 3) {
                document.getElementById('step-classification').classList.add('active');
                document.getElementById('step-classification').classList.remove('completed');
            }

            // Step 3: Priority & Impact (2 fields after Classification)
            if (completed >= 8) {
                document.getElementById('step-priority').classList.add('completed');
                document.getElementById('step-priority').classList.remove('active');
            } else if (completed >= 5) {
                document.getElementById('step-priority').classList.add('active');
                document.getElementById('step-priority').classList.remove('completed');
            }

            // Step 4: Description
            if (completed >= 9) {
                document.getElementById('step-description').classList.add('completed');
                document.getElementById('step-description').classList.remove('active');
            } else if (completed >= 8) {
                document.getElementById('step-description').classList.add('active');
                document.getElementById('step-description').classList.remove('completed');
            }
        }

        function handleDrop(event) {
            event.preventDefault();
            event.stopPropagation();
            document.getElementById('uploadArea').classList.remove('dragover');
            const files = event.dataTransfer.files;
            handleFileSelect({ target: { files: files } });
        }

        function handleDragOver(event) {
            event.preventDefault();
            event.stopPropagation();
            document.getElementById('uploadArea').classList.add('dragover');
        }

        function handleDragLeave(event) {
            event.preventDefault();
            event.stopPropagation();
            document.getElementById('uploadArea').classList.remove('dragover');
        }

        function handleFileSelect(event) {
            const files = event.target.files;
            const allowedTypes = ['image/png', 'image/jpeg', 'application/pdf', 'text/plain', 'text/csv', 'application/octet-stream'];
            const maxSize = 10 * 1024 * 1024; // 10 MB

            for (let file of files) {
                if (!allowedTypes.includes(file.type)) {
                    alert('Invalid file type: ' + file.name);
                    continue;
                }
                if (file.size > maxSize) {
                    alert('File too large: ' + file.name);
                    continue;
                }
            }
        }

        function handleFormSubmit(event) {
            event.preventDefault();

            // Validate required fields
            const subjectTitle = document.getElementById('subjectTitle').value;
            const complaintType = document.getElementById('complaintTypeSelect').value;
            const department = document.getElementById('departmentSelect').value;
            const category = document.getElementById('categorySelect').value;
            const subcategory = document.getElementById('subcategorySelect').value;
            const priority = document.querySelector('input[name="priority"]:checked');
            const description = document.getElementById('description').value;

            if (!subjectTitle || !complaintType || !department || !category || !subcategory || !priority || !description) {
                alert('Please fill in all required fields');
                return;
            }

            // Submit form
            const formData = new FormData(document.getElementById('complaintForm'));
            formData.append('complaintType', complaintType);

            // TODO: Send to server
            console.log('Form submitted');
            console.log(Object.fromEntries(formData));

            alert('Complaint submitted successfully!');
        }

        function handleCancel() {
            if (confirm('Are you sure you want to cancel? Any unsaved changes will be lost.')) {
                window.location.href = 'AllComplaints.aspx?type=' + encodeURIComponent(complaintType);
            }
        }

        // Close dropdowns on click outside
        document.addEventListener('click', function (event) {
            if (!event.target.closest('.sidebar-dropdown')) {
                document.querySelectorAll('.sidebar-dropdown').forEach(dropdown => {
                    dropdown.classList.remove('active');
                });
            }
        });
    </script>
</body>
</html>
