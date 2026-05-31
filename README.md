# 🎫 ITC Complaint Form and VC Booking System

A comprehensive **ASP.NET** web application for managing complaints and virtual consultation (VC) bookings for The Manipal Group. This system provides role-based access control, complaint tracking, and status timeline management.

**Repository**: [dhanushshet14/ITC--Complaint-form-and-VC-booking](https://github.com/dhanushshet14/ITC--Complaint-form-and-VC-booking)  
**Branch**: dhanush  
**Status**: ✅ Production Ready

---

## 📋 Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Key Components](#key-components)
- [Database](#database)
- [Authentication & Authorization](#authentication--authorization)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

---

## ✨ Features

### 🔐 Authentication & Authorization
- **Role-Based Access Control (RBAC)** with multiple user types:
  - Admin: Full system access and management
  - Employee: File and view complaints
  - Guest: Limited access for external users
  - VC Manager: Manage virtual consultations
- **Secure login** with SQL Server stored procedures
- **Session management** and timeout handling

### 📝 Complaint Management
- **Create Complaints**: Users can file new complaints with detailed information
- **View Complaints**: Browse all complaints with filtering and sorting
- **Track Status**: Real-time status updates and history
- **Horizontal Timeline**: Visual representation of complaint progress through various stages

### 📅 Virtual Consultation (VC) Booking
- **Book VC Sessions**: Schedule virtual consultations
- **Manage Bookings**: View and modify bookings
- **Calendar Integration**: Date/time selection for consultations

### 📊 Dashboard & Reporting
- **Role-Based Dashboard**: Customized views for different user roles
- **Statistics**: View complaint metrics and booking statistics
- **Filtering & Search**: Advanced filtering capabilities

### 📱 Responsive Design
- **Mobile Friendly**: Works seamlessly on all devices
- **Modern UI**: Clean and intuitive interface with gradient styling
- **Bootstrap 4**: Professional responsive framework

---

## 🛠️ Tech Stack

### Backend
- **Framework**: ASP.NET 4.8.1 (WebForms)
- **Language**: C#
- **Database**: SQL Server
- **ORM**: ADO.NET

### Frontend
- **Bootstrap 4**: Responsive UI framework
- **jQuery**: JavaScript library
- **Font Awesome**: Icon library
- **HTML5/CSS3**: Web standards

### Tools & Libraries
- **Visual Studio 2026**: Development IDE
- **Newtonsoft.Json**: JSON serialization
- **Waves Effect**: Interactive UI animations

---

## 📁 Project Structure

```
ComplaintSystem/
├── Auth/                           # Authentication & Authorization
│   ├── AuthenticationService.cs    # Login validation & role determination
│   ├── AuthorizationHelper.cs      # Permission checking
│   ├── RBACQuickReference.cs       # Role definitions
│   └── Complaints_UserProfile.cs   # User profile management
│
├── Data/                           # Data Access Layer
│   └── ComplaintDataService.cs     # Database operations
│
├── App_Start/                      # Application Configuration
│   ├── BundleConfig.cs            # CSS/JS bundling
│   └── RouteConfig.cs             # URL routing
│
├── assets/
│   ├── css/                       # Stylesheets
│   ├── js/                        # JavaScript files
│   └── images/                    # Image assets
│
├── Pages/
│   ├── Login.aspx                 # Login page
│   ├── Default.aspx               # Home page
│   ├── NewComplaint.aspx          # Create complaint
│   ├── ViewComplaints.aspx        # View complaints list
│   ├── ComplaintPage.aspx         # Complaint details
│   ├── StatusTimeline.aspx        # Complaint timeline
│   ├── About.aspx                 # About page
│   ├── Contact.aspx               # Contact page
│   ├── HomePage.aspx              # Home alternative
│   ├── AllComplaints.aspx         # All complaints view
│   └── DebugComplaints.aspx       # Debug/testing page
│
├── Master Pages/
│   ├── Site.Master                # Main layout template
│   └── Site.Mobile.Master         # Mobile layout
│
└── Global.asax                     # Application lifecycle
```

---

## 🚀 Getting Started

### Prerequisites
- **Visual Studio 2022/2026** or later
- **.NET Framework 4.8.1** or higher
- **SQL Server 2016** or later
- **IIS 7.5** or later (for deployment)

### System Requirements
- Windows 7 SP1 or later
- 2GB RAM minimum
- 500MB disk space

---

## 📥 Installation

### 1. Clone the Repository
```bash
git clone https://github.com/dhanushshet14/ITC--Complaint-form-and-VC-booking.git
cd ITC--Complaint-form-and-VC-booking
```

### 2. Open in Visual Studio
```bash
# Open the solution file
ComplaintSystem.sln
```

### 3. Restore NuGet Packages
```bash
# In Visual Studio Package Manager Console
Update-Package
```

### 4. Build the Solution
```
Build → Build Solution (Ctrl+Shift+B)
```

### 5. Set Up Database
- Execute the SQL scripts provided in the database folder
- Ensure SQL Server is running and accessible
- Update connection string in `Web.config`

### 6. Configure IIS (Local Development)
```
Debug → Start Debugging (F5)
```
The application will start on `https://localhost:44327/`

---

## ⚙️ Configuration

### Web.config Settings

```xml
<configuration>
  <connectionStrings>
    <add name="DefaultConnection" 
         connectionString="Server=YOUR_SERVER;Database=ComplaintDB;User Id=sa;Password=YOUR_PASSWORD;" 
         providerName="System.Data.SqlClient" />
  </connectionStrings>

  <system.web>
    <authentication mode="Forms">
      <forms loginUrl="~/Login.aspx" timeout="30" />
    </authentication>
    <sessionState timeout="30" />
  </system.web>
</configuration>
```

### Key Configuration Steps

1. **Database Connection**: Update `Web.config` with your SQL Server details
2. **Authentication**: Configure forms authentication timeout
3. **Session**: Set appropriate session timeout values
4. **IIS Binding**: Configure SSL certificate for HTTPS

---

## 💻 Usage

### Login
1. Navigate to `https://localhost:44327/Login.aspx`
2. Enter your credentials (Employee Code & Password)
3. Select appropriate user role if applicable
4. Click "Log In"

### Filing a Complaint
1. Click "New Complaint" from the dashboard
2. Fill in complaint details:
   - Title
   - Description
   - Category
   - Priority
   - Attachments (optional)
3. Submit the form
4. You'll receive a ticket number for tracking

### Viewing Complaint Status
1. Go to "View Complaints"
2. Click on a complaint to view details
3. Click "View Timeline" to see the progress
4. Timeline shows all status changes with timestamps

### Booking Virtual Consultation
1. Navigate to "VC Booking"
2. Select date and time
3. Choose consultation type
4. Confirm booking
5. Receive confirmation email

---

## 🔑 Key Components

### Authentication Service
**File**: `Auth/AuthenticationService.cs`

Handles user authentication and role determination using the stored procedure `sp_ValidateLoginUser`.

**Key Methods**:
- `ValidateLogin()`: Validates credentials
- `GetUserRoleAndDetails()`: Determines user role and fetches details
- `ConvertLoginUserTypeToRoleName()`: Converts database role to application role

### Complaint Data Service
**File**: `Data/ComplaintDataService.cs`

Manages all database operations related to complaints.

**Key Methods**:
- `GetComplaintsByUserId()`: Fetch user's complaints
- `CreateComplaint()`: Create new complaint
- `UpdateComplaintStatus()`: Update complaint status
- `GetComplaintDetails()`: Fetch detailed complaint info

### Authorization Helper
**File**: `Auth/AuthorizationHelper.cs`

Checks user permissions for various actions.

**Key Methods**:
- `IsAuthorizedToView()`: Check view permission
- `IsAuthorizedToEdit()`: Check edit permission
- `HasRole()`: Check if user has specific role

### Status Timeline
**File**: `StatusTimeline.aspx`

Displays complaint progress through different stages with visual indicators.

---

## 🗄️ Database

### Key Tables

#### User_Master
```sql
- UserId (PK)
- EmpCode (Unique)
- Password
- LoginUserType
- IsActive
- CreatedDate
```

#### TBL_EmployeeDetails
```sql
- EmpId (PK)
- EmpCode (FK)
- Name
- Email
- Department
- Designation
```

#### TBL_Complaints
```sql
- ComplaintId (PK)
- UserId (FK)
- Title
- Description
- Status
- CreatedDate
- UpdatedDate
```

#### TBL_ComplaintTimeline
```sql
- TimelineId (PK)
- ComplaintId (FK)
- Status
- Timestamp
- Notes
```

### Key Stored Procedures

#### sp_ValidateLoginUser
Validates user credentials and returns role information.

```sql
EXECUTE sp_ValidateLoginUser 
  @EmpCode = 'EMP001',
  @LoginUserType = @type OUTPUT,
  @RoleId = @roleId OUTPUT
```

---

## 🔐 Authentication & Authorization

### Role-Based Access Control

| Role | Create | View | Edit | Delete | Approve | Delete |
|------|--------|------|------|--------|---------|--------|
| **Admin** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Employee** | ✅ | Own Only | ✅ | ✅ | ❌ | ❌ |
| **Guest** | ✅ | Own Only | ❌ | ❌ | ❌ | ❌ |
| **VC Manager** | ❌ | ✅ | ✅ | ❌ | ✅ | ❌ |

### Session Management
- Default timeout: 30 minutes
- Automatic logout on inactivity
- Session variables for user context
- Secure cookie handling

---

## 🧪 Testing

### Test Cases

#### Test 1: Admin Login
```
Credentials: Admin user account
Expected: Access to all features and admin dashboard
```

#### Test 2: Employee Complaint Filing
```
Steps:
  1. Login as employee
  2. Navigate to "New Complaint"
  3. Fill complaint details
  4. Submit form
Expected: Complaint created successfully, ticket number generated
```

#### Test 3: Complaint Timeline View
```
Steps:
  1. View complaints list
  2. Click "View Timeline" on a complaint
  3. Review progress display
Expected: Timeline displayed with all status changes
```

#### Test 4: Role-Based Access Control
```
Steps:
  1. Login as guest user
  2. Attempt to access admin panel
Expected: Access denied, redirected to home
```

### Running Tests
```bash
# Visual Studio Test Explorer
Test → Run All Tests
```

---

## 🔧 Troubleshooting

### Common Issues

#### Issue: "Login Failed"
**Causes**:
- Incorrect credentials
- User account inactive
- Database connection issue

**Solution**:
1. Verify user exists in `User_Master` table
2. Check `IsActive` flag is set to 1
3. Verify database connection string
4. Check SQL Server is running

#### Issue: "Role Not Found"
**Causes**:
- Incorrect `sp_ValidateLoginUser` stored procedure
- Missing role mappings

**Solution**:
1. Re-execute database setup script
2. Verify `Roles` table has all roles defined
3. Check stored procedure returns valid role ID

#### Issue: "Database Connection Error"
**Causes**:
- SQL Server not running
- Incorrect connection string
- Network issues

**Solution**:
```xml
<!-- Update Web.config -->
<connectionStrings>
  <add name="DefaultConnection" 
       connectionString="Server=YOUR_SERVER;Database=ComplaintDB;Integrated Security=true;" />
</connectionStrings>
```

#### Issue: "ASPX Page Not Loading"
**Causes**:
- IIS not configured
- Missing file permissions
- Syntax errors in page

**Solution**:
1. Check IIS has application pool running
2. Verify file permissions for IIS user
3. Check browser console for errors
4. Review Application event log

---

## 📚 Documentation

For detailed information on specific features, see:

- **Login Implementation**: Review `Login.aspx` and `Login.aspx.cs`
- **Complaint Management**: See `NewComplaint.aspx` and `ViewComplaints.aspx`
- **Timeline Feature**: Check `StatusTimeline.aspx` implementation
- **Database Setup**: Execute scripts in `Database` folder
- **Authentication Flow**: Review `AuthenticationService.cs`

---

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **Fork the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/ITC--Complaint-form-and-VC-booking.git
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow existing code style
   - Add comments for complex logic
   - Test thoroughly

4. **Commit your changes**
   ```bash
   git commit -m "Add: Description of your changes"
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **Create a Pull Request**
   - Describe your changes clearly
   - Link related issues
   - Request review from maintainers

### Code Style Guidelines
- Use meaningful variable names
- Add XML documentation for public methods
- Follow Microsoft C# coding conventions
- Test code before submitting PR

---

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 📞 Support

### Getting Help
- 📧 **Email**: Contact the development team
- 🐛 **Bug Reports**: Open an issue on GitHub
- 💡 **Feature Requests**: Submit via GitHub Issues
- 📖 **Documentation**: Check the README_IMPLEMENTATION.md file

### Quick Links
- [GitHub Repository](https://github.com/dhanushshet14/ITC--Complaint-form-and-VC-booking)
- [Issue Tracker](https://github.com/dhanushshet14/ITC--Complaint-form-and-VC-booking/issues)
- [Pull Requests](https://github.com/dhanushshet14/ITC--Complaint-form-and-VC-booking/pulls)

---

## 🎯 Project Status

### Current Release
- **Version**: 1.0.0
- **Status**: ✅ Production Ready
- **Last Updated**: 2026-05-08

### Recent Updates
- ✅ Modern login page UI with gradient styling
- ✅ Authentication service optimization
- ✅ Horizontal timeline feature
- ✅ Role-based access control
- ✅ Responsive design improvements

### Upcoming Features (Roadmap)
- [ ] Mobile app for complaint filing
- [ ] Email notifications for status updates
- [ ] Advanced analytics dashboard
- [ ] Multi-language support
- [ ] Two-factor authentication
- [ ] Offline mode support

---

## 👨‍💻 Development Team

**Repository Owner**: [Dhanush Shet](https://github.com/dhanushshet14)

---

## 📄 Additional Resources

- [ASP.NET Documentation](https://docs.microsoft.com/aspnet/)
- [SQL Server Documentation](https://docs.microsoft.com/sql/)
- [Bootstrap 4 Documentation](https://getbootstrap.com/docs/4.0/)
- [C# Coding Guidelines](https://docs.microsoft.com/dotnet/csharp/fundamentals/coding-style)

---

**Made with ❤️ for The Manipal Group**

For questions or support, please open an issue on GitHub or contact the development team.
