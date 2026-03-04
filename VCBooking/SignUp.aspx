<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SignUp.aspx.cs" Inherits="VCBooking.CreateEmployee" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>SignUp</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body>
    <form id="form1" runat="server" enctype="multipart/form-data">

        <div class="container py-5">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card shadow-lg p-4">
                        <h3 class="text-center mb-4">Sign Up</h3>

                        <asp:Label ID="lblEmployeeCode" Text="Employee code" runat="server" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtEmployeeCode" runat="server" CssClass="form-control mb-3"></asp:TextBox>

                        <asp:Label ID="lblEmployeeName" Text="Employee Name" runat="server" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtEmployeeName" runat="server" CssClass="form-control mb-3"></asp:TextBox>

                        <asp:Label ID="lblEmployeeLevel" Text="Employee Level" runat="server" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtEmployeeLevel" runat="server" CssClass="form-control mb-3"></asp:TextBox>

                        <asp:Label ID="lblEmployeeCompany" Text="Employee Company" runat="server" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtEmployeeCompany" runat="server" CssClass="form-control mb-3"></asp:TextBox>

                        <asp:Label ID="lblEmployeeDepartment" Text="Employee Department" runat="server" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtEmployeeDepartment" runat="server" CssClass="form-control mb-3"></asp:TextBox>

                        <asp:Label ID="lblEmployeeDesignation" Text="Employee Designation" runat="server" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtEmployeeDesignation" runat="server" CssClass="form-control mb-3"></asp:TextBox>

                        <asp:Label ID="lblEmployeeUnit" runat="server" Text="Employee Unit" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtEmployeeUnit" runat="server" CssClass="form-control mb-3"></asp:TextBox>

                        <asp:Label ID="lblEmployeeLocation" Text="Employee Location" runat="server" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtEmployeeLocation" runat="server" CssClass="form-control mb-3"></asp:TextBox>

                        <asp:Label ID="lblEmployeeEmail" Text="Employee Email" runat="server" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtEmployeeEmail" runat="server" CssClass="form-control mb-3"></asp:TextBox>

                        <asp:Label ID="lblEmployeePassword" Text="Employee Password" runat="server" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtEmployeePassword" TextMode="Password" runat="server" CssClass="form-control mb-3"></asp:TextBox>

                        <asp:Label ID="lblEmployeePhoneNo" runat="server" Text="Employee Phone Number" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtEmployeePhoneNo" runat="server" CssClass="form-control mb-3"></asp:TextBox>

                        <%-- 
                        <asp:Label ID="lblCostCenter" runat="server" Text="Cost Center"></asp:Label>
                        <asp:TextBox ID="txtCostCenter" runat="server"></asp:TextBox>
                        <br />
                        --%>

                        <%--
                        <asp:Label ID="lblDomainUsername" runat="server" Text="Domain Username"></asp:Label>
                        <asp:TextBox ID="txtDomainUsername" runat="server"></asp:TextBox>
                        <br />
                        --%>

                        <%-- 
                        <asp:Label ID="lblEmployeeUniqueId" runat="server" Text="Employee Unique_Id"></asp:Label>
                        <asp:TextBox ID="txtEmployeeUniqueId" runat="server"></asp:TextBox>
                        <br />--%>

                        <%--
                        <asp:Label ID="lblLastUpdatedTime" runat="server" Text="Last Updated Time"></asp:Label>
                        <asp:TextBox ID="txtLastUpdatedTime" runat="server"></asp:TextBox>
                        <br />
                        --%>

                        <%-- 
                        <asp:Label ID="lblEmployeeExtensionNo" runat="server" Text="Employee Extension Number"></asp:Label>
                        <asp:TextBox ID="txtlblEmployeeExtensionNo" runat="server"></asp:TextBox>
                        <br /> 
                        --%>

                        <%-- 
                        <asp:Label ID="lblEmployeeGroupJoinDate" runat="server" Text=" Group Join Date"></asp:Label>
                        <asp:TextBox ID="txtEmployeeGroupJoinDate" runat="server"></asp:TextBox>
                        <br />
                        --%>

                        <asp:Label ID="lblEmployeeDOJ" runat="server" Text="Date Of Joining" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtEmployeeDOJ" runat="server" CssClass="form-control mb-3"></asp:TextBox>

                        <%--
                        <asp:Label ID="lblEmployeeDOL" runat="server" Text="Date Of Leaving"></asp:Label>
                        <asp:TextBox ID="txtEmployeeDOL" runat="server"></asp:TextBox>
                        <br />
                        --%>

                        <asp:Label ID="lblReportingTo" runat="server" Text="Reporting To" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtReportingTo" runat="server" CssClass="form-control mb-3"></asp:TextBox>

                        <asp:Label ID="lblReportingEmpCode" runat="server" Text="Reporting Employer Code" CssClass="form-label"></asp:Label>
                        <asp:TextBox ID="txtReportingEmpCode" runat="server" CssClass="form-control mb-3"></asp:TextBox>

                        <asp:Label ID="lblEmployeeImage" Text="Employee Image" runat="server" CssClass="form-label"></asp:Label>
                        <asp:FileUpload ID="fuEmployeeImage" runat="server" CssClass="form-control mb-3" />

                        <asp:Label ID="lblMessage" runat="server" ForeColor="Red" CssClass="text-danger"></asp:Label>

                        <div class="d-grid mt-3">
                            <asp:Button ID="btnCreateEmployee"
                                runat="server"
                                Text="Create Employee"
                                CssClass="btn btn-primary btn-lg"
                                OnClick="btnCreateEmployee_Click" />
                        </div>
                    </div>
            </div>
        </div>
        </div>

    </form>
</body>
</html>
