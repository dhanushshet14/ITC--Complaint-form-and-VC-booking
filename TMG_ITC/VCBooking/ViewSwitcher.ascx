<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ViewSwitcher.ascx.cs" Inherits="VCBooking.ViewSwitcher" %>
<div id="viewSwitcher">
    <%: CurrentView %> view | <a href="<%: SwitchUrl %>" data-ajax="false">Switch to <%: AlternateView %></a>
</div>