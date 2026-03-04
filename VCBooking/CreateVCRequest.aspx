<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CreateVCRequest.aspx.cs" Inherits="VCBooking.CreateVCRequest" Async="true" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Create VC Request</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-light">

    <form id="form1" runat="server">

        <div class="container mt-5 mb-5">

            <div class="card shadow-lg p-4">

                <h3 class="text-center text-primary mb-4">Create VC Request</h3>

                <!-- ================= BASIC INFO ================= -->
                <h5 class="text-secondary mb-3">Basic Information</h5>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <asp:Label runat="server" ID="lblCompany" Text="Company" CssClass="form-label" />
                        <asp:DropDownList runat="server" ID="ddlCompany" CssClass="form-select" />
                    </div>

                    <div class="col-md-6">
                        <asp:Label runat="server" ID="lblTopic" Text="Topic" CssClass="form-label" />
                        <asp:TextBox runat="server" ID="txtTopic" CssClass="form-control" />
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-4">
                        <asp:Label runat="server" ID="lblDate" Text="Booking Date" CssClass="form-label" />
                        <asp:TextBox ID="txtDate" runat="server" TextMode="Date"
                            AutoPostBack="true" OnTextChanged="DateOrTimeChanged"
                            CssClass="form-control" />
                    </div>

                    <div class="col-md-4">
                        <asp:Label runat="server" ID="lblFrom" Text="From Time" CssClass="form-label" />
                        <asp:TextBox ID="txtFrom" runat="server" TextMode="Time"
                            AutoPostBack="true" OnTextChanged="DateOrTimeChanged"
                            CssClass="form-control" />
                    </div>

                    <div class="col-md-4">
                        <asp:Label runat="server" ID="lblTo" Text="To Time" CssClass="form-label" />
                        <asp:TextBox ID="txtTo" runat="server" TextMode="Time"
                            AutoPostBack="true" OnTextChanged="DateOrTimeChanged"
                            CssClass="form-control" />
                    </div>
                </div>

                <!-- ================= VC DETAILS ================= -->
                <h5 class="text-secondary mt-4 mb-3">VC Details</h5>

                <div class="row mb-3">
                    <div class="col-md-4">
                        <asp:Label runat="server" ID="lblVCType" Text="VC Type" CssClass="form-label" />
                        <asp:DropDownList runat="server" ID="ddlVCType"
                            AutoPostBack="true"
                            OnSelectedIndexChanged="ddlVCType_SelectedIndexChanged"
                            CssClass="form-select">
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-4">
                        <asp:Label runat="server" ID="lblVCAccount" Text="VC Account" CssClass="form-label" />
                        <asp:DropDownList runat="server" ID="ddlVCAccount" CssClass="form-select">
                        </asp:DropDownList>
                    </div>

                    <div class="col-md-4">
                        <asp:Label runat="server" ID="lblLocation" Text="Location" CssClass="form-label" />
                        <asp:DropDownList runat="server" ID="ddlLocation" CssClass="form-select">
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="row mb-3">
                    <div class="col-md-6">
                        <asp:Label runat="server" ID="lblUnitFloor" Text="Unit / Floor Details" CssClass="form-label" />
                        <asp:TextBox runat="server" ID="txtUnitFloor" CssClass="form-control" />
                    </div>

                    <div class="col-md-6">
                        <asp:Label runat="server" ID="lblVCDetails" Text="VC Details" CssClass="form-label" />
                        <asp:TextBox runat="server" ID="txtVCDetails" TextMode="MultiLine" Rows="3" CssClass="form-control" />
                    </div>
                </div>

                <!-- ================= PARTICIPANTS ================= -->
                <h5 class="text-secondary mt-4 mb-3">Participants</h5>

                <div class="row mb-3">
                    <div class="col-md-8">
                        <asp:TextBox runat="server" ID="txtParticipant"
                            TextMode="Email"
                            CssClass="form-control"
                            placeholder="Enter participant email" />
                    </div>

                    <div class="col-md-4">
                        <asp:Button runat="server"
                            ID="btnParticipant"
                            Text="Add Participant"
                            OnClick="btnAddParticipant_Click"
                            CssClass="btn btn-success w-100" />
                    </div>
                </div>

                <asp:Label runat="server" ID="lblParticipantMessage" CssClass="text-danger mb-3 d-block" />

                <asp:GridView runat="server"
                    ID="gvParticipants"
                    CssClass="table table-bordered table-striped"
                    AutoGenerateColumns="true">
                </asp:GridView>

                <!-- ================= SUBMIT ================= -->
                <div class="text-center mt-4">
                    <asp:Button runat="server"
                        ID="btnFormSubmit"
                        Text="Create VC Request"
                        OnClick="btnFormSubmit_Click"
                        CssClass="btn btn-primary btn-lg px-5" />
                </div>

            </div>
        </div>

    </form>
</body>
</html>
