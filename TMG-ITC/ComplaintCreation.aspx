<%@ Page Title="New Complaint" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"
    CodeBehind="ComplaintCreation.aspx.cs" Inherits="TMG_ITC.ComplaintCreation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row justify-content-center">
        <div class="col-lg-8">

            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white py-3">
                    <h5 class="mb-0"><i class="bi bi-plus-circle me-2"></i>New Complaint</h5>
                </div>
                <div class="card-body">

                    <asp:Panel ID="panelSuccess" runat="server" Visible="false" CssClass="text-center py-5">
                        <i class="bi bi-check-circle-fill text-success" style="font-size: 48px;"></i>
                        <h4 class="mt-3">Complaint Registered Successfully</h4>
                        <p class="text-muted">Your complaint has been submitted. Reference ID:</p>
                        <h2 class="fw-bold text-primary" id="lblComplaintId" runat="server"></h2>
                        <div class="mt-4">
                            <a id="lnkViewComplaint" runat="server" class="btn btn-primary me-2">
                                <i class="bi bi-eye"></i> View Complaint
                            </a>
                            <a href="Dashboard.aspx" class="btn btn-outline-secondary">
                                <i class="bi bi-speedometer2"></i> Back to Dashboard
                            </a>
                        </div>
                    </asp:Panel>

                    <asp:Panel ID="panelForm" runat="server">

                        <asp:Panel ID="panelError" runat="server" Visible="false" CssClass="alert alert-danger alert-dismissible fade show"
                            role="alert">
                            <asp:Literal ID="litError" runat="server" />
                        </asp:Panel>

                        <div class="row g-3">

                            <div class="col-12">
                                <label class="form-label">Subject <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" MaxLength="200"
                                    placeholder="Enter a brief subject (min 10 characters)" />
                                <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle"
                                    ErrorMessage="Subject is required" CssClass="text-danger small" Display="Dynamic" />
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Complaint Type <span class="text-danger">*</span></label>
                                <asp:DropDownList ID="ddlType" runat="server" CssClass="form-select"
                                    DataTextField="ComplaintTypeName" DataValueField="ComplaintTypeId"
                                    AppendDataBoundItems="true" AutoPostBack="true"
                                    OnSelectedIndexChanged="ddlType_SelectedIndexChanged">
                                    <asp:ListItem Text="-- Select Type --" Value="" />
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvType" runat="server" ControlToValidate="ddlType"
                                    ErrorMessage="Type is required" CssClass="text-danger small" Display="Dynamic" />
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Unit <span class="text-danger">*</span></label>
                                <asp:DropDownList ID="ddlUnit" runat="server" CssClass="form-select"
                                    DataTextField="UnitName" DataValueField="UnitId"
                                    AppendDataBoundItems="true">
                                    <asp:ListItem Text="-- Select Unit --" Value="" />
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvUnit" runat="server" ControlToValidate="ddlUnit"
                                    ErrorMessage="Unit is required" CssClass="text-danger small" Display="Dynamic" />
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Category <span class="text-danger">*</span></label>
                                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select"
                                    DataTextField="CategoryName" DataValueField="CategoryId"
                                    AppendDataBoundItems="true" AutoPostBack="true"
                                    OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged">
                                    <asp:ListItem Text="-- Select Type first --" Value="" />
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvCategory" runat="server" ControlToValidate="ddlCategory"
                                    ErrorMessage="Category is required" CssClass="text-danger small" Display="Dynamic" />
                            </div>

                            <div class="col-md-6" id="subCategoryRow" runat="server">
                                <label class="form-label">Sub Category</label>
                                <asp:DropDownList ID="ddlSubCategory" runat="server" CssClass="form-select"
                                    DataTextField="SubCategoryName" DataValueField="SubCategoryId"
                                    AppendDataBoundItems="true" AutoPostBack="true"
                                    OnSelectedIndexChanged="ddlSubCategory_SelectedIndexChanged">
                                    <asp:ListItem Text="-- Select Category first --" Value="" />
                                </asp:DropDownList>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label">Priority</label>
                                <asp:TextBox ID="txtPriority" runat="server" CssClass="form-control" ReadOnly="true"
                                    placeholder="Auto-suggested" />
                                <asp:Panel ID="panelPriorityOverride" runat="server" Visible="false" CssClass="mt-1">
                                    <asp:DropDownList ID="ddlPriorityOverride" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Low" Value="Low" />
                                        <asp:ListItem Text="Medium" Value="Medium" />
                                        <asp:ListItem Text="High" Value="High" />
                                        <asp:ListItem Text="Critical" Value="Critical" />
                                    </asp:DropDownList>
                                    <small class="text-muted">Override auto-suggested priority</small>
                                </asp:Panel>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label">Customer Impact</label>
                                <div class="d-flex gap-3 mt-1">
                                    <asp:RadioButton ID="rdoImpactYes" runat="server" GroupName="Impact" Text="Yes"
                                        AutoPostBack="true" OnCheckedChanged="rdoImpact_CheckedChanged" />
                                    <asp:RadioButton ID="rdoImpactNo" runat="server" GroupName="Impact" Text="No"
                                        Checked="true" AutoPostBack="true" OnCheckedChanged="rdoImpact_CheckedChanged" />
                                </div>
                            </div>

                            <div class="col-md-4" id="customerNameRow" runat="server" visible="false">
                                <label class="form-label">Customer Name</label>
                                <asp:TextBox ID="txtCustomerName" runat="server" CssClass="form-control" MaxLength="100"
                                    placeholder="Enter customer name" />
                            </div>

                            <div class="col-12">
                                <label class="form-label">Description <span class="text-danger">*</span></label>
                                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control"
                                    TextMode="MultiLine" Rows="5" MaxLength="1000"
                                    placeholder="Provide a detailed description (min 20 characters)" />
                                <asp:RequiredFieldValidator ID="rfvDescription" runat="server"
                                    ControlToValidate="txtDescription" ErrorMessage="Description is required"
                                    CssClass="text-danger small" Display="Dynamic" />
                            </div>

                            <div class="col-12">
                                <label class="form-label">Attachments <small class="text-muted">(optional)</small></label>
                                <div class="upload-zone" id="dropZone"
                                    onclick="document.getElementById('<%= fileUpload.ClientID %>').click(); return false;">
                                    <i class="bi bi-cloud-upload fs-1 text-muted"></i>
                                    <p class="mb-1">Drag & drop files here or <a href="#"
                                            onclick="document.getElementById('<%= fileUpload.ClientID %>').click(); return false;">browse</a>
                                    </p>
                                    <small class="text-muted">Max 5 files, 10MB each (jpg, png, gif, pdf, doc, docx, xls, xlsx)</small>
                                </div>
                                <asp:FileUpload ID="fileUpload" runat="server" AllowMultiple="true" style="display:none" />
                                <ul class="list-group mt-2" id="fileList"></ul>
                            </div>

                        </div>

                        <div class="mt-4 d-flex gap-2">
                            <asp:Button ID="btnSubmit" runat="server" Text="Submit Complaint"
                                CssClass="btn btn-primary px-4" OnClick="btnSubmit_Click" />
                            <a href="Dashboard.aspx" class="btn btn-outline-secondary px-4">Cancel</a>
                        </div>

                    </asp:Panel>

                </div>
            </div>

        </div>
    </div>

    <style>
        .upload-zone {
            border: 2px dashed #dee2e6;
            border-radius: 8px;
            padding: 30px 20px;
            text-align: center;
            cursor: pointer;
            transition: border-color 0.3s, background 0.3s;
        }
        .upload-zone:hover,
        .upload-zone.dragover {
            border-color: #0d6efd;
            background: #f0f7ff;
        }
        .file-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 8px 12px;
            background: #f8f9fa;
            border-radius: 6px;
            margin-bottom: 4px;
        }
        .file-item .file-name {
            font-size: 13px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .file-item .file-size {
            font-size: 11px;
            color: #6c757d;
            flex-shrink: 0;
            margin-left: 8px;
        }
        .file-item .file-remove {
            cursor: pointer;
            color: #dc3545;
            font-size: 18px;
            line-height: 1;
            margin-left: 8px;
        }
    </style>

    <script>
        (function () {
            var fileInput = document.getElementById('<%= fileUpload.ClientID %>');
            var fileList = document.getElementById('fileList');
            var dropZone = document.getElementById('dropZone');
            var maxFiles = 5;
            var maxSize = 10 * 1024 * 1024;
            var allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'application/pdf',
                'application/msword',
                'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                'application/vnd.ms-excel',
                'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
            ];

            function updateFileList(files) {
                fileList.innerHTML = '';
                var fileArr = Array.from(files);
                fileArr.forEach(function (f, i) {
                    var sizeStr = f.size > 1024 * 1024 ?
                        (f.size / (1024 * 1024)).toFixed(1) + ' MB' :
                        (f.size / 1024).toFixed(0) + ' KB';
                    var icon = 'bi-file-earmark';
                    if (f.type.startsWith('image/')) icon = 'bi-file-earmark-image';
                    else if (f.type.includes('pdf')) icon = 'bi-file-earmark-pdf';
                    else if (f.type.includes('word')) icon = 'bi-file-earmark-word';
                    else if (f.type.includes('excel') || f.type.includes('spreadsheet')) icon = 'bi-file-earmark-excel';
                    var li = document.createElement('li');
                    li.className = 'list-group-item d-flex justify-content-between align-items-center py-2 px-3';
                    li.innerHTML =
                        '<span><i class="bi ' + icon + ' me-2"></i><span class="file-name">' + f.name + '</span></span>' +
                        '<span><span class="file-size badge bg-light text-dark me-2">' + sizeStr + '</span>' +
                        '<span class="file-remove" data-index="' + i + '">&times;</span></span>';
                    fileList.appendChild(li);
                });
                document.querySelectorAll('.file-remove').forEach(function (el) {
                    el.addEventListener('click', function () {
                        removeFile(parseInt(this.getAttribute('data-index')));
                    });
                });
            }

            function removeFile(index) {
                var dt = new DataTransfer();
                var files = fileInput.files;
                for (var i = 0; i < files.length; i++) {
                    if (i !== index) dt.items.add(files[i]);
                }
                fileInput.files = dt.files;
                updateFileList(fileInput.files);
            }

            fileInput.addEventListener('change', function () {
                validateAndShow(this.files);
            });

            function validateAndShow(files) {
                var errors = [];
                if (files.length > maxFiles) {
                    errors.push('Maximum ' + maxFiles + ' files allowed.');
                }
                for (var i = 0; i < files.length; i++) {
                    var f = files[i];
                    if (f.size > maxSize) {
                        errors.push('"' + f.name + '" exceeds 10 MB.');
                    }
                    if (allowedTypes.indexOf(f.type) === -1 && f.type !== '') {
                        errors.push('"' + f.name + '" has an unsupported format.');
                    }
                }
                if (errors.length > 0) {
                    alert(errors.join('\n'));
                    fileInput.value = '';
                    fileList.innerHTML = '';
                    return;
                }
                updateFileList(files);
            }

            dropZone.addEventListener('dragover', function (e) {
                e.preventDefault();
                e.stopPropagation();
                this.classList.add('dragover');
            });
            dropZone.addEventListener('dragleave', function (e) {
                e.preventDefault();
                e.stopPropagation();
                this.classList.remove('dragover');
            });
            dropZone.addEventListener('drop', function (e) {
                e.preventDefault();
                e.stopPropagation();
                this.classList.remove('dragover');
                if (e.dataTransfer.files.length > 0) {
                    fileInput.files = e.dataTransfer.files;
                    validateAndShow(fileInput.files);
                }
            });
        })();
    </script>
</asp:Content>
