<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="TMG_ITC.Dashboard" %>

    <!DOCTYPE html>
    <html xmlns="http://www.w3.org/1999/xhtml">

    <head runat="server">
        <title>Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    </head>

    <body>
        <form id="form1" runat="server">

            <div class="container d-flex justify-content-center align-items-center vh-100">

                <div class="card shadow-lg p-4" style="width:400px;">

                    <h3 class="text-center mb-4">Employee Dashboard</h3>

                    <div class="d-grid gap-3">

                        <asp:Button ID="btnComplaints" runat="server" Text="Complaints" CssClass="btn btn-primary"
                            OnClick="btnComplaints_Click" />

                        <asp:Button ID="btnVCBooking" runat="server" Text="VC Booking" CssClass="btn btn-primary"
                            OnClick="btnVCBooking_Click" />

                        <asp:Button ID="btnAdminDashboard" runat="server" Text="Admin Dashboard (View All)"
                            CssClass="btn btn-warning" OnClick="btnAdminDashboard_Click" />

                    </div>

                    <div class="mt-3 text-center">
                        <asp:Button ID="btnLogout" runat="server" Text="Logout"
                            CssClass="btn btn-outline-secondary btn-sm" OnClick="btnLogout_Click" />
                    </div>

                </div>

            </div>

        </form>
    </body>

    </html>