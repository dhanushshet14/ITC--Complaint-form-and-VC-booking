<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Dashboard.aspx.cs" Inherits="Dashboard" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="jumbotron">
        <h1>Welcome to Internal Ticketing System</h1>
        <p class="lead">
            <asp:Label ID="lblWelcome" runat="server"></asp:Label>
        </p>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="panel panel-primary">
                <div class="panel-heading">
                    <h3 class="panel-title">Dashboard</h3>
                </div>
                <div class="panel-body">
                    <p>You have successfully logged in to the Internal Ticketing System.</p>
                    <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn btn-danger" OnClick="btnLogout_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
