<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="row">
        <div class="col-md-6 col-md-offset-3">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Employee Login</h3>
                </div>
                <div class="panel-body">
                    <div class="form-group">
                        <asp:Label ID="lblEmpCode" runat="server" Text="Employee Code:" AssociatedControlID="txtEmpCode" CssClass="control-label"></asp:Label>
                        <asp:TextBox ID="txtEmpCode" runat="server" CssClass="form-control" placeholder="Enter your Employee Code"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvEmpCode" runat="server" ControlToValidate="txtEmpCode" 
                            ErrorMessage="Employee Code is required." CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                    <div class="form-group">
                        <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-primary btn-block" OnClick="btnLogin_Click" />
                    </div>
                    <asp:Label ID="lblMessage" runat="server" CssClass="text-danger"></asp:Label>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
