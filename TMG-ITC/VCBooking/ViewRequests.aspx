<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewRequests.aspx.cs" Inherits="VCBooking.ViewRequests"
    Async="true" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title>My VC Requests</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet" />
    <style>
        body { font-family: 'Inter', sans-serif; }
        .table thead th {
            background-color: dodgerblue !important;
            color: white !important;
            font-weight: bold;
        }
        .modal-content { border-radius: 16px; border: none; }
        .success-icon { color: #198754; }
    </style>
</head>

<body>
    <form id="form1" runat="server">
        <div class="container mt-4 mb-5">

            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="fw-bold text-primary mb-0">My VC Requests</h4>
                <a href="EmployeeDashboard.aspx" class="btn btn-outline-secondary btn-sm">← Back</a>
            </div>

            <asp:GridView ID="gvRequests" runat="server" CssClass="table table-bordered table-striped"
                AutoGenerateColumns="false" EmptyDataText="No requests found.">
                <Columns>
                    <asp:BoundField DataField="VCId" HeaderText="VC ID"><HeaderStyle CssClass="bg-primary text-white" /></asp:BoundField>
                    <asp:BoundField DataField="CompanyName" HeaderText="Company"><HeaderStyle CssClass="bg-primary text-white" /></asp:BoundField>
                    <asp:BoundField DataField="VCTypeName" HeaderText="VC Type"><HeaderStyle CssClass="bg-primary text-white" /></asp:BoundField>
                    <asp:BoundField DataField="VCAccountName" HeaderText="VC Account"><HeaderStyle CssClass="bg-primary text-white" /></asp:BoundField>
                    <asp:BoundField DataField="Topic" HeaderText="Topic"><HeaderStyle CssClass="bg-primary text-white" /></asp:BoundField>
                    <asp:BoundField DataField="VCDate" HeaderText="Date" DataFormatString="{0:dd-MMM-yyyy}"><HeaderStyle CssClass="bg-primary text-white" /></asp:BoundField>
                    <asp:BoundField DataField="FromTime" HeaderText="From" DataFormatString="{0:hh:mm tt}"><HeaderStyle CssClass="bg-primary text-white" /></asp:BoundField>
                    <asp:BoundField DataField="ToTime" HeaderText="To" DataFormatString="{0:hh:mm tt}"><HeaderStyle CssClass="bg-primary text-white" /></asp:BoundField>
                    <asp:BoundField DataField="LocationName" HeaderText="Location"><HeaderStyle CssClass="bg-primary text-white" /></asp:BoundField>
                    <asp:BoundField DataField="VCStatus" HeaderText="Status"><HeaderStyle CssClass="bg-primary text-white" /></asp:BoundField>
                </Columns>
            </asp:GridView>

        </div>

        <!-- Hidden field used by code-behind to signal success -->
        <asp:HiddenField ID="hdnShowSuccess" runat="server" Value="0" />
    </form>

    <!-- Meeting Created Success Modal -->
    <div class="modal fade" id="successModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content shadow text-center p-5">
                <div class="success-icon mb-3">
                    <svg xmlns="http://www.w3.org/2000/svg" width="72" height="72" fill="currentColor" viewBox="0 0 16 16">
                        <path d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0m-3.97-3.03a.75.75 0 0 0-1.08.022L7.477 9.417 5.384 7.323a.75.75 0 0 0-1.06 1.06L6.97 11.03a.75.75 0 0 0 1.079-.02l3.992-4.99a.75.75 0 0 0-.01-1.05z" />
                    </svg>
                </div>
                <h4 class="fw-bold mb-2">Meeting Created Successfully!</h4>
                <p class="text-secondary mb-4">Your VC request has been submitted and a Zoom meeting has been scheduled.</p>
                <button type="button" class="btn btn-success px-4" data-bs-dismiss="modal">View My Requests</button>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        window.addEventListener('DOMContentLoaded', function () {
            var flag = document.getElementById('<%= hdnShowSuccess.ClientID %>');
            if (flag && flag.value === '1') {
                var modal = new bootstrap.Modal(document.getElementById('successModal'));
                modal.show();
            }
        });
    </script>
</body>

</html>