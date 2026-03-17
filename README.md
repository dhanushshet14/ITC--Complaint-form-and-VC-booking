# ITC Complaint Form and VC Booking Setup Guide

This project requires certain credentials to be configured before it can be run successfully. All essential credentials are centrally located in the `Web.config` file within the `TMG-ITC` folder.

## Configuration Steps

1. Open `TMG-ITC\Web.config` in your code editor.
2. Locate the `<connectionStrings>` and `<appSettings>` sections to update the necessary information as outlined below.

### 1. Database Configuration
You need to set up the SQL Server database connection. Update the `HRConnection` string in `<connectionStrings>`:

```xml
<connectionStrings>
    <!-- Update 'Data Source' with your SQL server instance name -->
    <!-- 'Initial Catalog' is the database name (TMG_EmployeeData) -->
    <!-- Example: Data Source=YOUR_SERVER_NAME;Initial Catalog=TMG_EmployeeData;Integrated Security=True -->
    <add name="HRConnection" connectionString="Data Source=YOUR_SERVER_NAME;Initial Catalog=TMG_EmployeeData;Integrated Security=True" providerName="System.Data.SqlClient" />
</connectionStrings>
```

### 2. Zoom API Credentials
This application integrates with Zoom for Video Conferencing using Server-to-Server OAuth. Update the following keys in `<appSettings>` with your Zoom Server-to-Server OAuth app credentials:

```xml
<!-- Zoom OAuth Server-to-Server Credentials -->
<add key="ZoomAccountId" value="YOUR_ZOOM_ACCOUNT_ID" />
<add key="Zoom:ClientId" value="YOUR_ZOOM_CLIENT_ID" />
<add key="Zoom:ClientSecret" value="YOUR_ZOOM_CLIENT_SECRET" />
```

### 3. Email Settings (SMTP)
The application sends emails (e.g., meeting invitations). Provide the SMTP configurations in `<appSettings>`. The codebase is configured to use Gmail's SMTP server (`smtp.gmail.com` on port 587) in `EmailService.cs`.

```xml
<!-- SMTP Email Credentials -->
<add key="SmtpEmail" value="YOUR_EMAIL_ADDRESS@gmail.com" />
<add key="SmtpPassword" value="YOUR_APP_PASSWORD" />
```
*Note: If you are using Gmail, you will need to generate an "App Password" from your Google Account settings, rather than using your regular login password. Ensure IMAP/SMTP is enabled.*

### 4. Admin Setup (Database)
The application requires the `TBL_VC_Admins` table to manage admin access to the Video Conferencing dashboard. Run the following SQL script in your SQL Server Management Studio database to create the table and insert the first admin user:

```sql
USE TMG_Employeedata;
CREATE TABLE TBL_VC_Admins (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    EmpCode NVARCHAR(50) NOT NULL UNIQUE,
    AddedBy NVARCHAR(100) DEFAULT 'System Setup',
    AddedDate DATETIME DEFAULT GETDATE()
);

INSERT INTO TBL_VC_Admins (EmpCode)
VALUES ('56806');

SELECT * FROM TBL_VC_Admins;
```

## Getting Started

Once you have replaced all the placeholders with your actual credentials:
1. Rebuild the solution in Visual Studio.
2. Ensure the SQL database structure is created according to the models.
3. Run the application (F5 or Start Debugging).
