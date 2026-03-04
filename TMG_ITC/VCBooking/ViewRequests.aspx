<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ViewRequests.aspx.cs" Inherits="VCBooking.ViewRequests" Async="true" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

    <style>
        .table thead th {
            background-color: dodgerblue !important;
            color: white !important;
            font-weight: bold;
        }
    </style>
</head>

<body>
    <form id="form1" runat="server">
        <div>
            <asp:GridView ID="gvRequests"
                runat="server"
                CssClass="table table-bordered table-striped"
                AutoGenerateColumns="false">
                <Columns>

                    <asp:BoundField DataField="VCId" HeaderText="VC ID" ><HeaderStyle CssClass="bg-primary text-white" /> </asp:BoundField>

                    <asp:BoundField DataField="CompanyName" HeaderText="Company" ><HeaderStyle CssClass="bg-primary text-white" /></asp:BoundField>

                    <asp:BoundField DataField="VCTypeName" HeaderText="VC Type" ><HeaderStyle CssClass="bg-primary text-white" /></asp:BoundField>

                    <asp:BoundField DataField="VCAccountName" HeaderText="VC Account" ><HeaderStyle CssClass="bg-primary text-white" /></asp:BoundField>

                    <asp:BoundField DataField="Topic" HeaderText="Topic" ><HeaderStyle CssClass="bg-primary text-white" /></asp:BoundField>

                    <asp:BoundField DataField="VCDate"
                        HeaderText="Date"
                        DataFormatString="{0:dd-MMM-yyyy}" ><HeaderStyle CssClass="bg-primary text-white" /></asp:BoundField>

                    <asp:BoundField DataField="FromTime"
                        HeaderText="From"
                        DataFormatString="{0:hh:mm tt}" ><HeaderStyle CssClass="bg-primary text-white" /></asp:BoundField>

                    <asp:BoundField DataField="ToTime"
                        HeaderText="To"
                        DataFormatString="{0:hh:mm tt}" ><HeaderStyle CssClass="bg-primary text-white" /></asp:BoundField>

                    <asp:BoundField DataField="LocationName" HeaderText="Location" ><HeaderStyle CssClass="bg-primary text-white" /></asp:BoundField>

                    <asp:BoundField DataField="VCStatus" HeaderText="Status" ><HeaderStyle CssClass="bg-primary text-white" /></asp:BoundField>

                </Columns>
            </asp:GridView>
        </div>
    </form>
</body>
</html>
