<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeFile="ComplaintPage.aspx.cs" Inherits="ComplaintPage.WebForm1" %>

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

        .complaint-wrapper {
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

        /* Navbar */
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

        .navbar-center {
            flex: 1;
            text-align: center;
        }

        .navbar-right {
            display: flex;
            align-items: center;
            gap: 15px;
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
            color: #4A3FDB;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            padding: 40px 20px;
            margin-left: 0;
        }

        .header-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
            padding: 0 60px;
        }

        .form-title {
            text-align: center;
            font-size: 32px;
            font-weight: 700;
            color: #4A3FDB;
            margin-bottom: 10px;
        }

        .form-subtitle {
            text-align: center;
            color: #7a7a7a;
            font-size: 14px;
            margin-bottom: 40px;
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

        /* Form Container */
        .form-container {
            background: white;
            border-radius: 16px;
            padding: 40px;
            max-width: 1100px;
            margin: 0 auto;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.15);
            backdrop-filter: blur(10px);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 30px;
        }

        .form-row.full {
            grid-template-columns: 1fr;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-label {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }

        .form-control {
            padding: 12px 15px;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            font-family: 'Segoe UI', sans-serif;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: #4A90E2;
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
        }

        .form-control::placeholder {
            color: #999;
        }

        textarea.form-control {
            resize: both;
            min-height: 200px;
            overflow: auto;
            width: 100%;
        }

        .dual-input-group {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 12px;
        }

        /* File Upload */
        .file-upload-area {
            border: 2px dashed #e0e0e0;
            border-radius: 12px;
            padding: 40px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            background-color: #f9f9f9;
        }

        .file-upload-area:hover {
            border-color: #4A90E2;
            background-color: #D4E9F7;
        }

        .upload-icon {
            font-size: 32px;
            margin-bottom: 10px;
        }

        .upload-text {
            color: #333;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .upload-subtext {
            color: #7a7a7a;
            font-size: 12px;
        }

        #fileInput {
            display: none;
        }

        /* Submit Button */
        .submit-section {
            display: flex;
            justify-content: center;
            margin-top: 40px;
        }

        .submit-button {
            background: linear-gradient(135deg, #4A90E2 0%, #357ABD 100%);
            color: white;
            border: none;
            padding: 14px 50px;
            border-radius: 25px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(74, 144, 226, 0.3);
            transition: all 0.3s ease;
        }

        .submit-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(74, 144, 226, 0.4);
        }

        .submit-button:active {
            transform: translateY(0);
        }

        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .dual-input-group {
                grid-template-columns: 1fr;
            }

            .form-container {
                padding: 20px;
            }

            .header-section {
                padding: 0 20px;
            }

            .form-title {
                font-size: 24px;
            }

            .main-content {
                padding: 20px 10px;
            }

            /* Stack Complaint Detail and Attachments vertically on mobile */
            .form-row.full > div[style*="grid-template-columns: 1fr 1fr"] {
                grid-template-columns: 1fr !important;
            }
        }
    </style>

    <div class="complaint-wrapper">
        <!-- Hamburger Menu -->
        <div class="hamburger-menu" id="hamburgerMenu">
            <button class="close-menu" onclick="toggleMenu()">&#x2715;</button>
            <a href="HomePage.aspx" class="menu-item">
                <span class="menu-icon">&#x1F3E0;</span>
                Home
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
            <!-- Header -->
            <div class="header-section">
                <div></div>
                <div>
                    <h1 class="form-title">COMPLAINT REGISTRATION FORM</h1>
                    <p class="form-subtitle">Please fill out all required fields to submit your complaint</p>
                </div>
                <div></div>
            </div>

            <!-- Form -->
            <div class="form-container">
                    <!-- Row 1: Subject and Priority -->
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Subject</label>
                            <asp:TextBox ID="txtSubject" runat="server" CssClass="form-control" Placeholder="Enter subject"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Priority</label>
                            <asp:DropDownList ID="ddlPriority" runat="server" CssClass="form-control">
                                <asp:ListItem Text="Select priority" Value="" />
                                <asp:ListItem Text="Low" Value="Low" />
                                <asp:ListItem Text="Medium" Value="Medium" />
                                <asp:ListItem Text="High" Value="High" />
                                <asp:ListItem Text="Critical" Value="Critical" />
                            </asp:DropDownList>
                        </div>
                    </div>

                    <!-- Row 2: Category and Unit -->
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Complaint Category</label>
                            <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-control">
                                <asp:ListItem Text="Select category" Value="" />
                                <asp:ListItem Text="Quality Issue" Value="1" />
                                <asp:ListItem Text="Service Issue" Value="2" />
                                <asp:ListItem Text="Billing Issue" Value="3" />
                                <asp:ListItem Text="Delivery Issue" Value="4" />
                                <asp:ListItem Text="Other" Value="5" />
                            </asp:DropDownList>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Unit / Which Office</label>
                            <asp:DropDownList ID="ddlUnit" runat="server" CssClass="form-control">
                                <asp:ListItem Text="Select unit/office" Value="" />
                                <asp:ListItem Text="Office 1" Value="1" />
                                <asp:ListItem Text="Office 2" Value="2" />
                                <asp:ListItem Text="Office 3" Value="3" />
                            </asp:DropDownList>
                        </div>
                    </div>

                    <!-- Row 3: Complaint Request Center -->
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Complaint Request Center</label>
                            <div class="dual-input-group">
                                <asp:TextBox ID="txtRequestCenterCode" runat="server" CssClass="form-control" Placeholder="Code"></asp:TextBox>
                                <asp:TextBox ID="txtRequestCenterDesc" runat="server" CssClass="form-control" Placeholder="Description"></asp:TextBox>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Complaint Request Type</label>
                            <div class="dual-input-group">
                                <asp:TextBox ID="txtRequestTypeCode" runat="server" CssClass="form-control" Placeholder="Code"></asp:TextBox>
                                <asp:TextBox ID="txtRequestTypeDesc" runat="server" CssClass="form-control" Placeholder="Description"></asp:TextBox>
                            </div>
                        </div>
                    </div>

                    <!-- Row 4: Complaint Detail and Attachments -->
                    <div class="form-row full">
                        <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 30px; align-items: stretch;">
                            <!-- Left: Complaint Detail -->
                            <div class="form-group" style="display: flex; flex-direction: column;">
                                <label class="form-label">Complaint Detail</label>
                                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" TextMode="MultiLine" Placeholder="Enter detailed description of the complaint" Style="flex:1; min-height:250px; resize:both;"></asp:TextBox>
                            </div>

                            <!-- Right: Attachments -->
                            <div class="form-group" style="display: flex; flex-direction: column;">
                                <label class="form-label">Attachments</label>
                                <div class="file-upload-area" onclick="document.getElementById('fileInput').click()" style="flex: 1; display: flex; flex-direction: column; justify-content: center;">
                                    <div class="upload-icon">&#x1F4E4;</div>
                                    <div class="upload-text">Click to upload or drag & drop</div>
                                    <div class="upload-subtext">PDF, JPG, PNG up to 10MB</div>
                                    <asp:FileUpload ID="fileInput" runat="server" CssClass="form-control" ClientIDMode="Static" AllowMultiple="true" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Row 5: Customer Impact -->
                    <div class="form-row full">
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px; align-items: start;">
                            <!-- Left: Customer Impact Yes/No -->
                            <div class="form-group">
                                <label class="form-label">Customer Impact</label>
                                <asp:DropDownList ID="ddlCustomerImpact" runat="server" CssClass="form-control" AutoPostBack="false" onchange="toggleReasonField()">
                                    <asp:ListItem Text="Select" Value="" />
                                    <asp:ListItem Text="Yes" Value="Yes" />
                                    <asp:ListItem Text="No" Value="No" />
                                </asp:DropDownList>
                            </div>

                            <!-- Right: Reason (Hidden by default) -->
                            <div class="form-group" id="reasonFieldContainer" style="display: none;">
                                <label class="form-label">Reason (Max 30 words)</label>
                                <textarea class="form-control" id="reasonTextarea" placeholder="Explain the reason..." maxlength="150"></textarea>
                                <div style="font-size: 12px; color: #7a7a7a; margin-top: 5px;">
                                    <span id="wordCount">0</span> / 30 words
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <div class="submit-section">
                        <asp:Button ID="btnSubmit" runat="server" CssClass="submit-button" Text="Submit Complaint" OnClick="SubmitComplaint_Click" />
                    </div>
            </div>
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

        function submitComplaint() {
            // Simple validation
            const subject = document.querySelector('input[placeholder="Enter subject"]').value.trim();
            const description = document.querySelector('textarea[placeholder="Enter detailed description of the complaint"]').value.trim();

            if (!subject || !description) {
                alert('Please fill in all required fields');
                return;
            }

            alert('Complaint submitted successfully!');
            // Here you can add code to send the form data to the server
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

        // File upload preview
        document.addEventListener('DOMContentLoaded', function () {
            const fileInput = document.getElementById('fileInput');
            if (fileInput) {
                fileInput.addEventListener('change', function (e) {
                    const files = e.target.files;
                    if (files.length > 0) {
                        const fileNames = Array.from(files).map(f => f.name).join(', ');
                        const uploadText = document.querySelector('.upload-text');
                        const uploadSubtext = document.querySelector('.upload-subtext');

                        if (uploadText) uploadText.textContent = fileNames;
                        if (uploadSubtext) uploadSubtext.textContent = files.length + ' file(s) selected';
                    }
                });
            }
        });

        // Toggle reason field based on Customer Impact selection
        function toggleReasonField(selectEl) {
            var customerImpactSelect = selectEl || document.getElementById('MainContent_ddlCustomerImpact');
            if (!customerImpactSelect) return; // prevent .value on null

            var value = customerImpactSelect.value;
            var reasonFieldContainer = document.getElementById('reasonFieldContainer');
            if (!reasonFieldContainer) return;

            reasonFieldContainer.style.display = (value === 'Other') ? '' : 'none';
        } else {
                reasonFieldContainer.style.display = 'none';
                reasonTextarea.value = '';
                document.getElementById('wordCount').textContent = '0';
            }
        }

        // Word count for reason textarea
        document.addEventListener('DOMContentLoaded', function () {
            const reasonTextarea = document.getElementById('reasonTextarea');
            if (reasonTextarea) {
                reasonTextarea.addEventListener('input', function () {
                    const words = this.value.trim().split(/\s+/).filter(word => word.length > 0).length;
                    document.getElementById('wordCount').textContent = words;

                    if (words > 30) {
                        // Remove extra words
                        const wordArray = this.value.trim().split(/\s+/);
                        this.value = wordArray.slice(0, 30).join(' ');
                        document.getElementById('wordCount').textContent = '30';
                    }
                });
            }
        });
    </script>
</asp:Content>
