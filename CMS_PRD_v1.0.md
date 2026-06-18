# Product Requirements Document (PRD)
## Complaint Management System (CMS) — Manipal Group IT Helpdesk

---

| Field | Details |
|---|---|
| **Document Title** | Complaint Management System — Product Requirements Document |
| **Version** | 1.0 |
| **Status** | Draft for Review |
| **Prepared By** | Product & Technology Team |
| **Organization** | Manipal Group — Information Technology Division |
| **Date** | May 2026 |
| **Classification** | Internal — Confidential |

---

## Table of Contents

1. Executive Summary
2. Product Overview
3. User Roles & Permissions
4. Authentication & Authorization
5. Complaint Lifecycle & Workflow
6. Complaint Creation Module
7. Complaint Detail Workspace
8. Notification & Communication Requirements
9. Database Design
10. API & Stored Procedure Requirements
11. Security Requirements
12. Non-Functional Requirements
13. Future Enhancements
14. Acceptance Criteria

---

---

# 1. Executive Summary

## 1.1 Purpose

The Complaint Management System (CMS) is an enterprise IT helpdesk platform designed to streamline the end-to-end lifecycle of IT service requests and incident complaints across all Manipal Group business units. It replaces manual email-based and verbal complaint handling with a structured, auditable, and role-governed digital workflow.

## 1.2 Business Goals

| # | Goal | Metric |
|---|---|---|
| 1 | Centralize all IT complaints under a single platform | 100% complaints logged via CMS within 3 months of go-live |
| 2 | Enforce SLA-based resolution timelines per priority | SLA breach rate < 5% |
| 3 | Provide full audit trail for every complaint | 100% actions recorded with user, timestamp, and description |
| 4 | Reduce mean time to resolution (MTTR) | 20% reduction within 6 months |
| 5 | Enable role-based access to protect operational data | Zero unauthorized access incidents |
| 6 | Support multi-unit operations across Manipal Group | All 22 units onboarded at launch |

## 1.3 Target Users

| User Type | Description |
|---|---|
| **Employees** | Any Manipal Group staff member raising an IT complaint or service request |
| **Guest Users** | Contractors, vendors, or temporary staff with limited access |
| **Engineers** | IT support engineers handling and resolving complaints |
| **SOC Team** | Security Operations Center personnel monitoring and overseeing all complaints |
| **Admins** | IT administrators managing users, categories, units, and overall system configuration |

## 1.4 Key Capabilities

- Structured complaint creation with conditional category/subcategory dropdowns
- Multi-step status workflow: Created → Assigned → Accepted → In Progress → Resolved → Closed → Reopened
- Role-based action panels — each role sees only what it is authorized to perform
- Internal discussion thread (work notes) similar to Jira/ServiceNow work notes
- Activity timeline with full audit history per complaint
- SLA countdown widgets: SLA Remaining, Time in Status, Complaint Age
- Attachment upload and management
- Drag-and-drop file upload on complaint creation form
- Employee data synchronized from Adrenalin HRMS (Manipal Group HR system)

---

---

# 2. Product Overview

## 2.1 Dashboard

The Dashboard is the default landing screen post-login. It provides:

- **Summary Cards**: Total Complaints, Open, In Progress, Resolved, Closed, and SLA Breach counts
- **Status Pipeline**: Visual funnel showing distribution of complaints across each workflow stage
- **Recent Complaints Table**: Last 10 complaints across all modules, clickable to open the Complaint Workspace
- **Filter Bar**: Filter by Status, Priority, and free-text Search
- Accessible to all roles; data scope filtered per unit permissions

## 2.2 Complaint Submission

The Complaint Creation Form captures all required information to initiate a complaint:

- **Conditional field logic**: Category dropdown is filtered by Complaint Type (Incident vs. Service); Subcategory is filtered by selected Category
- **Priority auto-suggestion**: Based on Priority_Category_Linking table (can be overridden by Admin/SOC)
- **Attachment support**: Up to 5 files, drag-and-drop enabled, PDF/PNG/JPG/DOCX/XLSX up to 10 MB each
- **Inline validation**: Real-time field-level validation before submission
- **Success screen**: Complaint ID displayed on successful submission

## 2.3 Complaint Tracking

The Complaint Listing Pages (Technical, Telephone modules) provide:

- Sortable, filterable list of complaints by ID, Priority, and Date
- Quick filter tabs: All, My Complaints, High Priority
- Inline status badge per complaint
- Split-view: List on left, detail preview on right (desktop)
- Click-through to full Complaint Workspace

## 2.4 Complaint Resolution Workflow

The system enforces a defined state machine for each complaint. No status transition occurs without an authorized action from a permitted role. Each transition is recorded in the Complaint_Updates table with user, timestamp, and description.

## 2.5 Internal Collaboration

Each complaint contains an Internal Discussion Thread (Work Notes):

- Visible to all roles with access to the complaint
- Supports multi-line rich-text notes
- File attachment per comment (future enhancement)
- Sender identity, role badge, and timestamp recorded per message
- Notes appended to the Activity Timeline

---

---

# 3. User Roles & Permissions

## 3.1 Role Definitions

The system supports five distinct roles, each with a specific scope of access and action.

---

### Role: Employee

**Description**: A standard Manipal Group employee raising IT complaints or service requests.

| Capability | Permitted |
|---|---|
| Create Complaint | ✅ Yes |
| View Own Complaints | ✅ Yes |
| Add Work Notes / Comments | ✅ Yes |
| Reopen Closed / Resolved Complaint | ✅ Yes |
| View Activity Timeline | ✅ Yes |
| Assign Complaint to Engineer | ❌ No |
| Transfer Complaint | ❌ No |
| Close Complaint | ❌ No |
| Self-Assign | ❌ No |
| Resolve Complaint | ❌ No |

**Visible Modules**: Dashboard, Technical, Telephone, VC Booking
**Hidden Modules**: SOC

---

### Role: Guest

**Description**: Contractors, temporary staff, or external users with limited access. Registered via GuestUser_Master.

| Capability | Permitted |
|---|---|
| Create Complaint | ✅ Yes |
| View Own Complaints | ✅ Yes |
| Add Work Notes / Comments | ✅ Yes |
| Reopen Closed / Resolved Complaint | ✅ Yes |
| All other actions | ❌ No |

**Visible Modules**: Dashboard, Technical, Telephone, VC Booking
**Hidden Modules**: SOC

---

### Role: Engineer

**Description**: IT support engineer responsible for resolving assigned complaints.

| Capability | Permitted |
|---|---|
| Self-Assign Complaint | ✅ Yes |
| Accept Assignment | ✅ Yes |
| Mark In Progress | ✅ Yes |
| Transfer Complaint to Another Team | ✅ Yes |
| Resolve Complaint | ✅ Yes |
| Close Complaint | ✅ Yes |
| Add Work Notes / Comments | ✅ Yes |
| Assign to Another Engineer | ❌ No |
| Create Complaint on Behalf | ❌ No |
| Manage Categories / Units | ❌ No |

**Visible Modules**: Dashboard, Technical, Telephone, VC Booking, SOC

---

### Role: SOC (Security Operations Center)

**Description**: SOC analysts monitor all complaints for security relevance, assign, and close where necessary. SOC does not self-assign.

| Capability | Permitted |
|---|---|
| View All Complaints (all units) | ✅ Yes |
| Assign Complaint to Engineer | ✅ Yes |
| Transfer Complaint | ✅ Yes |
| Close Complaint | ✅ Yes |
| Add Internal Notes / Work Notes | ✅ Yes |
| Monitor Complaint Timeline | ✅ Yes |
| Self-Assign | ❌ No |
| Resolve Complaint | ❌ No |
| Create Complaint | ❌ No |

**Visible Modules**: Dashboard, Technical, Telephone, VC Booking, SOC

---

### Role: Admin

**Description**: IT Administrators with full system access including user management, category management, and all complaint actions.

| Capability | Permitted |
|---|---|
| All Employee + Engineer + SOC actions | ✅ Yes |
| Create Complaint (on behalf of any user) | ✅ Yes |
| Assign Complaint to Any Engineer | ✅ Yes |
| Self-Assign | ✅ Yes |
| Transfer Complaint | ✅ Yes |
| Reopen Complaint | ✅ Yes |
| Close Complaint | ✅ Yes |
| Resolve Complaint | ✅ Yes |
| Manage Category Master | ✅ Yes |
| Manage SubCategory Master | ✅ Yes |
| Manage Unit Master | ✅ Yes |
| Manage User Master | ✅ Yes |
| Manage Roles & Permissions | ✅ Yes |
| View All Complaints (all units) | ✅ Yes |

**Visible Modules**: Dashboard, Technical, Telephone, VC Booking, SOC, Admin Panel

---

## 3.2 Role × Action Matrix Summary

| Action | Employee | Guest | Engineer | SOC | Admin |
|---|:---:|:---:|:---:|:---:|:---:|
| Create Complaint | ✅ | ✅ | ❌ | ❌ | ✅ |
| View Own Complaints | ✅ | ✅ | ✅ | ✅ | ✅ |
| View All Complaints | ❌ | ❌ | ✅ (Unit) | ✅ (All) | ✅ (All) |
| Assign to Engineer | ❌ | ❌ | ❌ | ✅ | ✅ |
| Self-Assign | ❌ | ❌ | ✅ | ❌ | ✅ |
| Transfer | ❌ | ❌ | ✅ | ✅ | ✅ |
| Resolve | ❌ | ❌ | ✅ | ❌ | ✅ |
| Close | ❌ | ❌ | ✅ | ✅ | ✅ |
| Reopen | ✅ | ✅ | ❌ | ❌ | ✅ |
| Add Work Notes | ✅ | ✅ | ✅ | ✅ | ✅ |
| Manage Masters | ❌ | ❌ | ❌ | ❌ | ✅ |

---

---

# 4. Authentication & Authorization

## 4.1 Authentication Flow

```
User visits /login
      ↓
Enters Username + Password
      ↓
System checks LoginType (LDAP or CUST) from User_Master
      ↓
┌─────────────────────────────────────────────┐
│  LoginType = LDAP                           │
│  → Validate credentials against AD/LDAP     │
│                                             │
│  LoginType = CUST                           │
│  → Validate against User_Master.Password    │
│    (BCrypt hashed)                          │
└─────────────────────────────────────────────┘
      ↓
Credential validation result:
  ❌ Invalid → Return error "Invalid username or password"
  ✅ Valid   → Proceed
      ↓
Fetch Role from User_Master.Role
Fetch Unit Permissions from User_Unit_Permission
      ↓
Create Session / JWT Token
  Token payload: EmpCode, FullName, Role, UnitIds[], LoginType
  Token expiry: 8 hours (configurable)
      ↓
Redirect to Dashboard
```

## 4.2 Session Management

| Parameter | Value |
|---|---|
| Token Type | JWT (JSON Web Token) |
| Token Expiry | 8 hours |
| Refresh Strategy | Sliding window (re-issue on activity) |
| Storage | HttpOnly Cookie (recommended) or localStorage |
| Logout | Token invalidation + session clear |
| Concurrent Sessions | Allowed (multi-device) |
| Inactivity Timeout | 30 minutes (configurable) |

## 4.3 Role-Based Access Control (RBAC)

The system implements RBAC at three levels:

### 4.3.1 Menu / Module Visibility

| Module | Employee | Guest | Engineer | SOC | Admin |
|---|:---:|:---:|:---:|:---:|:---:|
| Dashboard | ✅ | ✅ | ✅ | ✅ | ✅ |
| Technical | ✅ | ✅ | ✅ | ✅ | ✅ |
| Telephone | ✅ | ✅ | ✅ | ✅ | ✅ |
| VC Booking | ✅ | ✅ | ✅ | ✅ | ✅ |
| SOC | ❌ | ❌ | ✅ | ✅ | ✅ |
| Admin Panel | ❌ | ❌ | ❌ | ❌ | ✅ |

### 4.3.2 Data Scope (Unit Filtering)

- **Employee / Guest**: See only complaints they created, or complaints belonging to their assigned unit.
- **Engineer**: Sees complaints within units assigned to them in User_Unit_Permission.
- **SOC / Admin**: Sees all complaints across all units.

### 4.3.3 Action Authorization

All sensitive actions (assign, transfer, resolve, close, reopen) are validated server-side against the user's role. Client-side hiding is for UX only and never a security boundary.

---

---

# 5. Complaint Lifecycle & Workflow

## 5.1 State Machine Diagram

```
┌──────────┐
│  Created │  ← Initial state on complaint submission
└────┬─────┘
     │  [Admin / SOC: Assign to Engineer]
     │  [Engineer: Self-Assign]
     ▼
┌──────────┐
│ Assigned │  ← Engineer has been assigned
└────┬─────┘
     │  [Engineer: Accept Assignment]
     ▼
┌──────────┐
│ Accepted │  ← Engineer acknowledged the complaint
└────┬─────┘
     │  [Engineer: Begin work]
     ▼
┌─────────────┐
│  In Progress│  ← Active investigation/resolution
└────┬────────┘
     │  [Engineer / Admin / SOC: Transfer]
     │         ↓
     │    ┌────────────┐
     │    │ Transferred│ ← Reassigned to different team/dept
     │    └────────────┘
     │  (Transferred → re-enters Assigned state for new team)
     │
     │  [Engineer / Admin: Resolve]
     ▼
┌──────────┐
│ Resolved │  ← Fix applied, pending verification
└────┬─────┘
     │  [Admin / SOC / Engineer: Close]
     ▼
┌────────┐
│ Closed │  ← Final state
└────┬───┘
     │  [Employee / Admin: Reopen]
     ▼
┌──────────┐
│ Reopened │  ← Re-enters Assigned for re-investigation
└──────────┘
```

## 5.2 State Definitions

### State: Created (New)

| Property | Details |
|---|---|
| **Entry Criteria** | Complaint form submitted successfully |
| **Exit Criteria** | Admin/SOC assigns an engineer; or Engineer self-assigns |
| **Allowed Actions** | View, Add Comment, Edit (creator only, within 30 min) |
| **Permitted Roles** | All roles can view; only Admin/SOC can assign |
| **DB Status Value** | `New` |
| **Complaint_Updates Entry** | UpdateType = `New` |

---

### State: Assigned

| Property | Details |
|---|---|
| **Entry Criteria** | Admin/SOC assigns engineer, or Engineer self-assigns |
| **Exit Criteria** | Engineer accepts the assignment |
| **Allowed Actions** | View, Add Comment, Transfer, Re-assign (Admin/SOC) |
| **Permitted Roles** | Admin, SOC (re-assign); Engineer (accept/self-assign) |
| **DB Status Value** | `Assigned` |
| **Complaint_Updates Entry** | UpdateType = `Assign`, AssignType = `ASSIGN` or `SELF-ASSIGN` |

---

### State: Accepted

| Property | Details |
|---|---|
| **Entry Criteria** | Assigned engineer explicitly accepts the complaint |
| **Exit Criteria** | Engineer marks In Progress |
| **Allowed Actions** | View, Add Comment, Transfer |
| **Permitted Roles** | Assigned Engineer, Admin, SOC |
| **DB Status Value** | `Assigned` (sub-state, AcceptedFlag = 1) |
| **Complaint_Updates Entry** | UpdateType = `Update` with Description = "Accepted" |

---

### State: In Progress

| Property | Details |
|---|---|
| **Entry Criteria** | Engineer begins active work on the complaint |
| **Exit Criteria** | Engineer resolves; or complaint is transferred |
| **Allowed Actions** | View, Add Comment, Transfer, Resolve |
| **Permitted Roles** | Assigned Engineer, Admin |
| **DB Status Value** | `Assigned` (with progress indicator in Complaint_Updates) |
| **Complaint_Updates Entry** | UpdateType = `Update` with Description = "In Progress" |

---

### State: Transferred

| Property | Details |
|---|---|
| **Entry Criteria** | Current handler transfers to another department/engineer |
| **Exit Criteria** | New assignee accepts (re-enters Assigned) |
| **Allowed Actions** | View, Add Comment (by new assignee) |
| **Permitted Roles** | Engineer, SOC, Admin |
| **DB Status Value** | `Assigned` (new AssignedTo value) |
| **Complaint_Updates Entry** | UpdateType = `Assign`, AssignType = `TRANSFER` |

---

### State: Resolved

| Property | Details |
|---|---|
| **Entry Criteria** | Engineer marks complaint as resolved with resolution notes |
| **Exit Criteria** | Admin/SOC closes; or employee reopens |
| **Allowed Actions** | View, Add Comment, Close (Admin/SOC/Engineer), Reopen (Employee/Admin) |
| **Permitted Roles** | Admin, SOC, Engineer (resolve/close); Employee (reopen) |
| **DB Status Value** | `Resolved` |
| **Complaint_Updates Entry** | UpdateType = `Resolve` |

---

### State: Closed

| Property | Details |
|---|---|
| **Entry Criteria** | Admin/SOC/Engineer closes a resolved complaint |
| **Exit Criteria** | Employee/Admin reopens |
| **Allowed Actions** | View only; Reopen (Employee/Admin) |
| **Permitted Roles** | All roles (view); Employee, Admin (reopen) |
| **DB Status Value** | `Closed` |
| **Complaint_Updates Entry** | UpdateType = `Close` |

---

### State: Reopened

| Property | Details |
|---|---|
| **Entry Criteria** | Employee or Admin reopens a resolved or closed complaint |
| **Exit Criteria** | Re-assigned (enters Assigned state) |
| **Allowed Actions** | View, Assign (Admin/SOC), Self-Assign (Engineer) |
| **Permitted Roles** | Employee, Admin (reopen); Admin/SOC (re-assign) |
| **DB Status Value** | `Reopened` |
| **Complaint_Updates Entry** | UpdateType = `Reopen` |

---

---

# 6. Complaint Creation Module

## 6.1 Form Fields

### 6.1.1 Subject / Title

| Property | Details |
|---|---|
| Field Label | Subject |
| Field Type | Text Input |
| Mandatory | ✅ Yes |
| Max Length | 200 characters |
| Min Length | 10 characters |
| Placeholder | "Brief description of the issue..." |
| DB Column | Complaint_Header.Title |

---

### 6.1.2 Complaint Type

| Property | Details |
|---|---|
| Field Label | Complaint Type |
| Field Type | Dropdown (Single Select) |
| Mandatory | ✅ Yes |
| Source | ComplaintType_Master |
| DB Column | Complaint_Header.ComplaintTypeId |
| Cascade Effect | Resets Category and Subcategory on change |

**Complaint Type Master Data:**

| ID | Name | Alias |
|---|---|---|
| 1 | Incident | INC |
| 2 | Service | SRV |

---

### 6.1.3 Unit

| Property | Details |
|---|---|
| Field Label | Unit |
| Field Type | Dropdown (Single Select) |
| Mandatory | ✅ Yes |
| Source | Unit_Master (filtered by User_Unit_Permission for non-Admin) |
| Default | User's primary unit from EMP_Unit (if available) |
| DB Column | Complaint_Header.UnitId |

**Unit Master Data (22 Units):**

| # | Unit Name |
|---|---|
| 1 | Manipal Fintech |
| 2 | MBS-Gurgaon |
| 3 | MBS-Manipal |
| 4 | MCT-InTouch |
| 5 | MDS-Bangalore |
| 6 | MDS-Kumta |
| 7 | MDS-Manipal |
| 8 | MMNL-Bangalore |
| 9 | MMNL-Delhi |
| 10 | MMNL-Editorial-Manipal |
| 11 | MMNL-Hubli |
| 12 | MMNL-Mangalore |
| 13 | MMNL-Mumbai |
| 14 | MMNL-Udupi |
| 15 | MPi-Manipal |
| 16 | MPi-Mumbai |
| 17 | MPi-Noida |
| 18 | MTL - Noida |
| 19 | MTL-Bangalore |
| 20 | MTL-Chennai |
| 21 | MTL-Coimbatore |
| 22 | UNIT-3 - HO (UDAYAVANI) |

---

### 6.1.4 Category

| Property | Details |
|---|---|
| Field Label | Category |
| Field Type | Dropdown (Single Select) |
| Mandatory | ✅ Yes |
| Source | Category_Master filtered by ComplaintType (RequestType) |
| Enabled | Only after Complaint Type is selected |
| DB Column | Complaint_Header.CategoryId |
| Cascade Effect | Resets Subcategory on change |

#### Categories — Complaint Type: Incident

| # | Category Name |
|---|---|
| 1 | Network Issues |
| 2 | Outlook / Mail Issues |
| 3 | Printer Issues |
| 4 | Software Issues |
| 5 | System / Laptop Issues |
| 6 | Others |

#### Categories — Complaint Type: Service

| # | Category Name |
|---|---|
| 1 | CD Request |
| 2 | Colour Print Request |
| 3 | Need Anydesk |
| 4 | SAP Installation |
| 5 | Share Folder Access |
| 6 | Site Access |
| 7 | Skype Installation |
| 8 | Tally Software Installation |
| 9 | Updating Saral TDS Software |
| 10 | User Activation |
| 11 | User Deactivation |
| 12 | Video Download |
| 13 | VPN Installation |
| 14 | Zoom Installation |
| 15 | Others |

---

### 6.1.5 Subcategory

| Property | Details |
|---|---|
| Field Label | Subcategory |
| Field Type | Dropdown (Single Select) |
| Mandatory | Conditional: Required for Incident type; Optional for Service type |
| Source | Sub_Category_Master filtered by CategoryId |
| Enabled | Only after Category is selected |
| DB Column | Complaint_Header.SubCategoryId |

**Note**: Service categories have no subcategories. The Subcategory field is hidden when Complaint Type = Service.

#### Subcategory Master Data (Incident Only)

**Network Issues**

| Subcategory Name |
|---|
| Data Transfer |
| Internet Issue |
| Network Connection Issue |
| Network Down |
| Share Folder Access Issue |
| VPN Issue |
| Others |

**Outlook / Mail Issues**

| Subcategory Name |
|---|
| File Attachment Issue |
| Incoming / Outgoing Mail Issues |
| Outlook Opening Problem |
| PST Issue |
| Synchronisation Issue |
| Others |

**Printer Issues**

| Subcategory Name |
|---|
| Paper Jam |
| Printer Down |
| Printer Error |
| Scanner Issue |
| Others |

**Software Issues**

| Subcategory Name |
|---|
| Adobe Software Issue |
| Excel / PowerPoint / Word Issue |
| Issue in Browser |
| Office Activation Issue |
| Tally Application Issue |
| Others |

**System / Laptop Issues**

| Subcategory Name |
|---|
| Disk is Full |
| Keyboard Not Working |
| Login Issue |
| Monitor / Display Issue |
| Mouse Not Working |
| System Down |
| System is Slow |
| Others |

---

### 6.1.6 Priority

| Property | Details |
|---|---|
| Field Label | Priority |
| Field Type | Dropdown (Single Select) |
| Mandatory | ✅ Yes |
| Options | Critical, High, Medium, Low |
| Default | Auto-suggested from Priority_Category_Linking based on Category + Subcategory |
| Override | Admin/SOC may override the suggested priority |
| DB Column | Complaint_Header.Priority |

**Priority SLA Matrix:**

| Priority | Initial Response | Resolution Target |
|---|---|---|
| Critical | 1 hour | 4 hours |
| High | 2 hours | 8 hours |
| Medium | 4 hours | 24 hours |
| Low | 8 hours | 72 hours |

---

### 6.1.7 Customer Impact

| Property | Details |
|---|---|
| Field Label | Does this affect customers? |
| Field Type | Radio Button (Yes / No) |
| Mandatory | ✅ Yes |
| DB Column | Complaint_Header.CustomerImpactFlag (1 = Yes, 0 = No) |
| Conditional | If Yes: show Customer Name field |

**Customer Name (Conditional)**

| Property | Details |
|---|---|
| Field Label | Customer Name |
| Field Type | Text Input |
| Mandatory | Required if CustomerImpactFlag = 1 |
| Max Length | 100 characters |
| DB Column | Complaint_Header.CustomerName |

---

### 6.1.8 Description

| Property | Details |
|---|---|
| Field Label | Description |
| Field Type | Multi-line Textarea |
| Mandatory | ✅ Yes |
| Min Length | 20 characters |
| Max Length | 1000 characters |
| Placeholder | "Describe the issue in detail..." |
| DB Column | Complaint_Header.Description |

---

### 6.1.9 Attachments

| Property | Details |
|---|---|
| Field Label | Attachments |
| Field Type | File Upload (Drag-and-Drop + Browse) |
| Mandatory | ❌ Optional |
| Max Files | 5 |
| Max File Size | 10 MB per file |
| Allowed Types | .pdf, .png, .jpg, .jpeg, .docx, .doc, .xlsx, .xls, .txt |
| Upload Target | Server file storage; path stored in Complaint_Attachments.FilePath |
| Preview | Inline file name chip with remove button |

---

## 6.2 Complaint ID Generation

Complaint IDs are system-generated using the following format:

```
Format: [PREFIX]-[YYYYMMDD]-[SEQUENCE]

Examples:
  INC-20260508-0001   (Incident, 8 May 2026, sequence 1)
  SRV-20260508-0042   (Service, 8 May 2026, sequence 42)
```

| Segment | Rule |
|---|---|
| PREFIX | `INC` for Incident, `SRV` for Service |
| YYYYMMDD | Date of creation |
| SEQUENCE | 4-digit zero-padded daily sequence, resets each day |

---

## 6.3 Form Validation Rules

| Field | Rule | Error Message |
|---|---|---|
| Subject | Required, min 10 chars, max 200 | "Subject must be at least 10 characters" |
| Complaint Type | Required | "Please select a Complaint Type" |
| Unit | Required | "Please select your Unit" |
| Category | Required, depends on Type | "Please select a Category" |
| Subcategory | Required for Incident type | "Please select a Subcategory" |
| Priority | Required | "Please select a Priority" |
| Customer Impact | Required | "Please indicate customer impact" |
| Customer Name | Required if impact = Yes | "Please enter the affected customer name" |
| Description | Required, min 20 chars, max 1000 | "Description must be at least 20 characters" |
| Attachments | Optional; max 5 files, 10 MB each | "Maximum 5 files allowed" / "File exceeds 10 MB limit" |
| Attachment Type | Must be in allowed list | "File type not allowed. Use PDF, PNG, JPG, DOCX, XLSX" |

---

## 6.4 Dropdown Dependency Logic

```
User selects Complaint Type
  ↓
System loads Category list filtered by ComplaintType_Master
  ↓
User selects Category
  ↓
System loads Subcategory list filtered by CategoryId
  (If Complaint Type = Service, Subcategory field is hidden)
  ↓
System fetches suggested Priority from Priority_Category_Linking
  ↓
User may override Priority (Admin/SOC only)
```

---

---

# 7. Complaint Detail Workspace

## 7.1 Workspace Layout

The Complaint Detail Workspace is a full-screen view that opens when any complaint row is clicked. It maintains the sidebar navigation and provides a comprehensive resolution interface.

```
┌────────────────────────────────────────────────────────────────┐
│  Sub-Header: Back | ID | Status | Priority | Dates | Engineer  │
│              Role Switcher (demo) | Assigned Engineer          │
├────────────────────────────────────────────────────────────────┤
│  SLA Widget | Time in Status Widget | Complaint Age Widget     │
├────────────────────────────────────────────────────────────────┤
│  Status Workflow Stepper: Created→Assigned→Accepted→...→Closed │
├───────────────────────────────┬────────────────────────────────┤
│  LEFT PANEL (70%)             │  RIGHT PANEL (30%)             │
│                               │                                │
│  ┌─────────────────────────┐  │  ┌──────────────────────────┐  │
│  │ Complaint Info Card     │  │  │ Role-Based Action Panel  │  │
│  │ ID / Title / Type /     │  │  │ (Changes per user role)  │  │
│  │ Unit / Category / Sub   │  │  └──────────────────────────┘  │
│  └─────────────────────────┘  │                                │
│                               │  ┌──────────────────────────┐  │
│  ┌─────────────────────────┐  │  │ Quick Details            │  │
│  │ Description Card        │  │  │ Assigned To / Team /     │  │
│  └─────────────────────────┘  │  │ Created By / Priority    │  │
│                               │  └──────────────────────────┘  │
│  ┌─────────────────────────┐  │                                │
│  │ Attachments Card        │  │  ┌──────────────────────────┐  │
│  │ [file cards w/          │  │  │ Activity Timeline        │  │
│  │  preview + download]    │  │  │ (Vertical, chronological)│  │
│  └─────────────────────────┘  │  └──────────────────────────┘  │
│                               │                                │
│  ┌─────────────────────────┐  │                                │
│  │ Internal Discussion     │  │                                │
│  │ [Comment Thread]        │  │                                │
│  │ ─────────────────────── │  │                                │
│  │ [Composer + Send]       │  │                                │
│  └─────────────────────────┘  │                                │
└───────────────────────────────┴────────────────────────────────┘
```

---

## 7.2 SLA Metric Widgets

### Widget 1 — SLA Status

Displays time remaining against the SLA for the complaint's priority tier.

| State | Color | Label |
|---|---|---|
| < 65% consumed | Green | ON TRACK |
| 65–89% consumed | Amber | WATCH |
| ≥ 90% consumed | Red | ⚠ BREACH RISK |

### Widget 2 — Time in Current Status

Displays elapsed time since the complaint entered its current status, helping identify stalled complaints.

### Widget 3 — Complaint Age

Displays total elapsed time since the complaint was created (CreatedDate). Helps identify aged tickets.

---

## 7.3 Status Workflow Stepper

A horizontal 6-step progress indicator:

```
Created ──── Assigned ──── Accepted ──── In Progress ──── Resolved ──── Closed
  (✓)           (✓)         (active)         (grey)          (grey)      (grey)
```

- Completed steps: Green circle with checkmark
- Current step: Primary color circle with ring highlight
- Future steps: Grey circle
- Reopened state: Shown with an annotation below the stepper

---

## 7.4 Complaint Information Card

Displays all metadata in a structured 3-column grid:

| Field | Source |
|---|---|
| Complaint Number | Complaint_Header.ComplaintId |
| Title | Complaint_Header.Title |
| Complaint Type | ComplaintType_Master.ComplaintTypeName |
| Unit / Location | Unit_Master.UnitName |
| Category | Category_Master.CategoryName |
| Subcategory | Sub_Category_Master.SubCategoryName |
| Reported By | User_Master.FullName (CreatedBy) |
| Assigned Team | Complaint_Header derived |

---

## 7.5 Internal Discussion Thread (Work Notes)

Each note entry displays:

| Component | Details |
|---|---|
| Avatar | Initials-based, color-coded by role |
| Username | User_Master.FullName |
| Role Badge | Color-coded pill: Admin (violet), Engineer (blue), SOC (orange), Employee (teal) |
| Timestamp | UpdateDate from Complaint_Updates |
| Message Body | Description from Complaint_Updates |

**Composer Requirements:**
- Multi-line textarea (minimum 3 rows)
- `Ctrl + Enter` keyboard shortcut to send
- Attach file button (future: uploads to Complaint_Attachments)
- Send button (disabled when textarea is empty)
- Placeholder: "Add an internal note or update..."

---

## 7.6 Activity Timeline

A vertical chronological timeline showing all state changes and note additions. Each entry contains:

| Component | Details |
|---|---|
| Event Icon | Context-specific (circle for created, checkmark for resolved, etc.) |
| Event Color | Color-coded by event type |
| Action Label | Human-readable description of the action |
| Actor Name | User who performed the action |
| Role Badge | Actor's role |
| Detail Note | Additional context (e.g., "Assigned to Sarah Chen") |
| Timestamp | UTC datetime |

---

## 7.7 Role-Based Action Panel

The action panel changes completely based on the logged-in user's role:

### Admin Action Panel

| Button | Style | Action |
|---|---|---|
| Assign Complaint | Primary (solid dark) | Opens Assign Modal |
| Self Assign | Secondary (outlined) | Immediate self-assignment |
| Transfer | Secondary (outlined) | Opens Transfer Modal |
| Resolve | Success (green solid) | Opens Resolve Confirmation |
| Reopen | Secondary (outlined) | Opens Reopen Confirmation |
| Close Complaint | Danger (red outlined) | Opens Close Confirmation |

### Engineer Action Panel

| Button | Style | Action |
|---|---|---|
| Self Assign | Primary (solid dark) | Immediate self-assignment |
| Transfer | Secondary (outlined) | Opens Transfer Modal |
| Resolve | Success (green solid) | Opens Resolve Confirmation |
| Close Complaint | Danger (red outlined) | Opens Close Confirmation |

### SOC Action Panel

| Button | Style | Action |
|---|---|---|
| Assign Complaint | Primary (solid dark) | Opens Assign Modal |
| Transfer | Secondary (outlined) | Opens Transfer Modal |
| Close Complaint | Danger (red outlined) | Opens Close Confirmation |

### Employee Action Panel

| Button | Style | Action |
|---|---|---|
| Reopen | Secondary (outlined) | Opens Reopen Confirmation |

*Note: Employee is informational — can only reopen and add notes.*

---

## 7.8 Modal Definitions

### Assign Modal

| Field | Type | Required |
|---|---|---|
| Engineer | Dropdown (from User_Master where Role = Engineer) | ✅ Yes |
| Assignment Note | Textarea | ❌ Optional |

### Transfer Modal

| Field | Type | Required |
|---|---|---|
| Department / Team | Dropdown (from DEPARTMENTS master) | ✅ Yes |
| Reason for Transfer | Textarea | ✅ Yes |

### Resolve Confirmation Modal

| Field | Type | Required |
|---|---|---|
| Resolution Summary | Textarea | ✅ Yes (min 20 chars) |

### Close Complaint Modal

| Field | Type | Required |
|---|---|---|
| Closure Reason | Textarea | ✅ Yes |

### Reopen Confirmation Modal

| Field | Type | Required |
|---|---|---|
| Reason for Reopening | Textarea | ✅ Yes |

---

---

# 8. Notification & Communication Requirements

## 8.1 Notification Trigger Matrix

| Event | Notify | Channel | Priority |
|---|---|---|---|
| Complaint Created | Creator (confirmation) | Email + In-App | Medium |
| Complaint Assigned | Assigned Engineer | Email + In-App | High |
| Complaint Transferred | New Assignee, Previous Assignee | Email + In-App | High |
| Complaint Accepted | Complaint Creator | Email + In-App | Low |
| Complaint In Progress | Complaint Creator | In-App | Low |
| Complaint Resolved | Creator, Admin | Email + In-App | Medium |
| Complaint Closed | Creator | Email + In-App | Low |
| Complaint Reopened | Last Assigned Engineer, Admin | Email + In-App | High |
| Work Note Added | All parties on the complaint | In-App | Low |
| SLA Breach Imminent (≥ 75%) | Assigned Engineer, Admin, SOC | Email + In-App | Critical |
| SLA Breached (100%) | Admin, SOC | Email + In-App | Critical |

## 8.2 Email Notification Template Requirements

Each email must include:
- Manipal Group logo header
- Complaint ID (bold, prominent)
- Subject / Title
- Current Status
- Priority badge
- Direct link to complaint workspace
- Footer: IT Helpdesk contact details

## 8.3 Future Notification Architecture

The following notification system is planned for Phase 2:

| Component | Technology |
|---|---|
| Email Service | SMTP relay via Manipal Group mail server |
| In-App Notifications | WebSocket or polling (every 30s) |
| Notification Queue | Message queue (RabbitMQ or Azure Service Bus) |
| Template Engine | Razor / Handlebars server-side templates |

---

---

# 9. Database Design

## 9.1 Entity Relationship Overview

```
Unit_Master ←─────────────────────── Complaint_Header ──────────→ ComplaintType_Master
                                            │
                              ┌─────────────┼─────────────┐
                              │             │             │
                     Category_Master  Sub_Category_Master  Complaint_Attachments
                              │
                     Priority_Category_Linking

Complaint_Header ────────────→ Complaint_Updates (1:N)

User_Master ─────────────────→ Complaint_Header (CreatedBy, AssignedTo)
User_Master ─────────────────→ User_Unit_Permission (1:N)
User_Master (Guest) ──────────→ GuestUser_Master (1:1)
```

---

## 9.2 Table Definitions

### TABLE: Complaint_Header

*Primary complaint record. One row per complaint.*

| Column | Data Type | Constraints | Description |
|---|---|---|---|
| ComplaintId | VARCHAR(20) | PK | System-generated ID (e.g., INC-20260508-0001) |
| CreatedBy | VARCHAR(20) | FK → User_Master.EmpCode | Employee who raised the complaint |
| CreatedDate | DATETIME | NOT NULL, DEFAULT GETDATE() | Timestamp of creation |
| Title | VARCHAR(200) | NOT NULL | Complaint subject line |
| Priority | VARCHAR(20) | NOT NULL | Critical / High / Medium / Low |
| ComplaintTypeId | INT | FK → ComplaintType_Master | Incident or Service |
| UnitId | INT | FK → Unit_Master | Business unit |
| RequestType | NVARCHAR(20) | NOT NULL | Mirrors ComplaintType (INC/SRV) |
| CategoryId | INT | FK → Category_Master | Main category |
| SubCategoryId | INT | FK → Sub_Category_Master, Nullable | Subcategory (Incident only) |
| Description | NVARCHAR(1000) | NOT NULL | Full description |
| CustomerImpactFlag | INT | NOT NULL, DEFAULT 0 | 1 = Customer affected |
| CustomerName | NVARCHAR(100) | Nullable | Name of affected customer |
| AssignedTo | VARCHAR(20) | FK → User_Master.EmpCode, Nullable | Currently assigned engineer |
| AssignedDate | DATETIME | Nullable | When last assigned |
| AssignmentType | VARCHAR(20) | Nullable | ASSIGN / SELF-ASSIGN / TRANSFER |
| Status | VARCHAR(20) | NOT NULL, DEFAULT 'New' | New / Assigned / Resolved / Closed / Reopened / Hold |
| LastUpdate | DATETIME | NOT NULL | Last modification timestamp |
| LastUpdateBy | VARCHAR(20) | FK → User_Master.EmpCode | Who last modified |

---

### TABLE: Complaint_Updates

*Full audit trail of all actions and notes. Append-only.*

| Column | Data Type | Constraints | Description |
|---|---|---|---|
| UpdateId | BIGINT | PK, IDENTITY | Auto-increment primary key |
| ComplaintId | VARCHAR(20) | FK → Complaint_Header.ComplaintId | Parent complaint |
| UpdateType | VARCHAR(20) | NOT NULL | New / Assign / Update / Resolve / Close / Reopen |
| UpdateBy | VARCHAR(20) | FK → User_Master.EmpCode | Actor |
| UpdateDate | DATETIME | NOT NULL, DEFAULT GETDATE() | Action timestamp |
| AssignType | VARCHAR(20) | Nullable | SELF-ASSIGN / TRANSFER / ASSIGN (when UpdateType = Assign) |
| AssignedTo | VARCHAR(20) | Nullable | New assignee (when UpdateType = Assign) |
| Description | NVARCHAR(1000) | Nullable | Notes, resolution summary, comment text |

---

### TABLE: ComplaintType_Master

*Lookup table for Incident vs Service.*

| Column | Data Type | Constraints | Description |
|---|---|---|---|
| ComplaintTypeId | INT | PK, IDENTITY | Auto ID |
| ComplaintTypeName | NVARCHAR(100) | NOT NULL, UNIQUE | Incident / Service |
| ComplaintTypeAlias | NVARCHAR(100) | NOT NULL | INC / SRV |
| Status | VARCHAR(20) | NOT NULL, DEFAULT 'Active' | Active / Inactive |
| CreatedBy | VARCHAR(20) | NOT NULL | |
| CreatedDate | DATETIME | NOT NULL | |
| UpdatedBy | VARCHAR(20) | Nullable | |
| UpdatedDate | DATETIME | Nullable | |

---

### TABLE: Unit_Master

*Master list of all Manipal Group business units.*

| Column | Data Type | Constraints | Description |
|---|---|---|---|
| UnitId | INT | PK, IDENTITY | Auto ID |
| UnitName | NVARCHAR(100) | NOT NULL, UNIQUE | e.g., MTL-Bangalore |
| UnitAlias | NVARCHAR(100) | NOT NULL | Short code |
| Status | VARCHAR(20) | NOT NULL, DEFAULT 'Active' | Active / Inactive |
| CreatedBy | VARCHAR(20) | NOT NULL | |
| CreatedDate | DATETIME | NOT NULL | |
| UpdatedBy | VARCHAR(20) | Nullable | |
| UpdatedDate | DATETIME | Nullable | |

---

### TABLE: Category_Master

*Complaint categories, linked to RequestType (Incident/Service).*

| Column | Data Type | Constraints | Description |
|---|---|---|---|
| CategoryId | INT | PK, IDENTITY | Auto ID |
| CategoryName | NVARCHAR(100) | NOT NULL | e.g., Network Issues |
| CategoryAlias | NVARCHAR(100) | NOT NULL | Short code |
| RequestType | VARCHAR(20) | NOT NULL | INC / SRV (links to ComplaintType) |
| Status | VARCHAR(20) | NOT NULL, DEFAULT 'Active' | Active / Inactive |
| CreatedBy | VARCHAR(20) | NOT NULL | |
| CreatedDate | DATETIME | NOT NULL | |
| UpdatedBy | VARCHAR(20) | Nullable | |
| UpdatedDate | DATETIME | Nullable | |

---

### TABLE: Sub_Category_Master

*Subcategories linked to a parent Category.*

| Column | Data Type | Constraints | Description |
|---|---|---|---|
| SubCategoryId | INT | PK, IDENTITY | Auto ID |
| SubCategoryName | NVARCHAR(100) | NOT NULL | e.g., VPN Issue |
| SubCategoryAlias | NVARCHAR(100) | NOT NULL | Short code |
| CategoryId | INT | FK → Category_Master.CategoryId | Parent category |
| Status | VARCHAR(20) | NOT NULL, DEFAULT 'Active' | Active / Inactive |
| CreatedBy | VARCHAR(20) | NOT NULL | |
| CreatedDate | DATETIME | NOT NULL | |
| UpdatedBy | VARCHAR(20) | Nullable | |
| UpdatedDate | DATETIME | Nullable | |

---

### TABLE: Complaint_Attachments

*File attachments linked to complaints.*

| Column | Data Type | Constraints | Description |
|---|---|---|---|
| AttachmentId | INT | PK, IDENTITY | Auto ID |
| ComplaintId | VARCHAR(20) | FK → Complaint_Header.ComplaintId | Parent complaint |
| FileName | VARCHAR(200) | NOT NULL | Original filename |
| FilePath | VARCHAR(200) | NOT NULL | Server storage path |
| UpdateId | BIGINT | FK → Complaint_Updates.UpdateId, Nullable | If attached via a note |
| UserId | VARCHAR(20) | FK → User_Master.EmpCode | Uploader |
| UploadedDate | DATETIME | NOT NULL, DEFAULT GETDATE() | Upload timestamp |

---

### TABLE: User_Master

*All authenticated system users (internal employees).*

| Column | Data Type | Constraints | Description |
|---|---|---|---|
| UserId | INT | IDENTITY | Internal ID |
| EmpCode | VARCHAR(20) | PK, UNIQUE | From HRMS (e.g., 44886) |
| FullName | NVARCHAR(200) | NOT NULL | From HRMS |
| Username | VARCHAR(100) | NOT NULL, UNIQUE | Domain username (e.g., jayaraj) |
| Password | VARCHAR(200) | Nullable | BCrypt hash (for CUST login only) |
| LoginType | VARCHAR(20) | NOT NULL | LDAP / CUST |
| Status | VARCHAR(20) | NOT NULL, DEFAULT 'Active' | Active / Inactive / Locked |
| Role | VARCHAR(20) | NOT NULL | Admin / SOC / Engineer / Employee |
| CreatedBy | VARCHAR(20) | NOT NULL | |
| CreatedDate | DATETIME | NOT NULL | |
| UpdatedBy | VARCHAR(20) | Nullable | |
| UpdatedDate | DATETIME | Nullable | |

---

### TABLE: GuestUser_Master

*Temporary/external users without HRMS accounts.*

| Column | Data Type | Constraints | Description |
|---|---|---|---|
| GuestEmpCode | VARCHAR(50) | PK | System-generated guest ID |
| FullName | VARCHAR(200) | NOT NULL | Full name |
| Email | VARCHAR(200) | NOT NULL, UNIQUE | Guest email |
| Mobile | VARCHAR(50) | Nullable | Contact number |
| UnitId | INT | FK → Unit_Master.UnitId | Associated unit |
| Department | VARCHAR(100) | Nullable | Department |
| Designation | VARCHAR(100) | Nullable | Job title |
| Location | VARCHAR(100) | Nullable | Office location |
| Extension | VARCHAR(20) | Nullable | Phone extension |
| Status | VARCHAR(10) | NOT NULL, DEFAULT 'Active' | Active / Inactive |
| CreatedDate | DATETIME | NOT NULL | |
| DomainUsername | VARCHAR(100) | Nullable | Windows domain username |

---

### TABLE: User_Unit_Permission

*Grants a user access to specific units with a defined role level.*

| Column | Data Type | Constraints | Description |
|---|---|---|---|
| EmpCode | VARCHAR(20) | FK → User_Master.EmpCode | User |
| UnitId | INT | FK → Unit_Master.UnitId | Unit |
| Role | VARCHAR(20) | NOT NULL | View / Manage |
| AssignedBy | VARCHAR(20) | NOT NULL | Admin who granted access |
| AssignedDate | DATETIME | NOT NULL | Grant timestamp |

*Composite PK: (EmpCode, UnitId)*

---

### TABLE: Priority_Category_Linking

*Maps Category + Subcategory to a default Priority.*

| Column | Data Type | Constraints | Description |
|---|---|---|---|
| LinkingId | INT | PK, IDENTITY | Auto ID |
| CategoryId | INT | FK → Category_Master | Category |
| SubCategoryId | INT | FK → Sub_Category_Master, Nullable | Subcategory (optional) |
| Priority | VARCHAR(20) | NOT NULL | Critical / High / Medium / Low |

---

---

# 10. API & Stored Procedure Requirements

## 10.1 Authentication

### SP: usp_UserLogin

**Purpose**: Validate credentials and return user session data.

**Input Parameters**:
```sql
@Username   VARCHAR(100),
@Password   VARCHAR(200),  -- Raw; hashed comparison done in SP
@LoginType  VARCHAR(20)    -- LDAP / CUST
```

**Output**:
```json
{
  "empCode": "44886",
  "fullName": "Jayaraj K",
  "role": "Engineer",
  "loginType": "LDAP",
  "unitIds": [3, 7, 15],
  "status": "Active",
  "token": "jwt_string"
}
```

**Logic**:
1. Fetch user from User_Master by Username
2. Check Status = 'Active'
3. If LDAP: delegate to AD validation; if CUST: compare BCrypt hash
4. Return user data + unit permissions + JWT

---

## 10.2 Dropdown / Master Data Retrieval

### SP: usp_GetComplaintTypes

Returns all active ComplaintType_Master records.

### SP: usp_GetUnits

Returns units accessible to the calling user (filtered by User_Unit_Permission).

```sql
@EmpCode   VARCHAR(20),
@Role      VARCHAR(20)
-- Admin/SOC: return all active units
-- Others: return only units in User_Unit_Permission
```

### SP: usp_GetCategoriesByType

```sql
@RequestType  VARCHAR(20)   -- 'INC' or 'SRV'
```

Returns active Category_Master records matching RequestType.

### SP: usp_GetSubCategoriesByCategory

```sql
@CategoryId  INT
```

Returns active Sub_Category_Master records for the given category.

### SP: usp_GetPriorityByCategory

```sql
@CategoryId     INT,
@SubCategoryId  INT  -- Nullable
```

Returns suggested Priority from Priority_Category_Linking.

### SP: usp_GetEngineers

Returns list of active users with Role = 'Engineer', used for Assign dropdown.

---

## 10.3 Complaint Creation

### SP: usp_CreateComplaint

**Input**:
```sql
@CreatedBy          VARCHAR(20),
@Title              VARCHAR(200),
@Priority           VARCHAR(20),
@ComplaintTypeId    INT,
@UnitId             INT,
@CategoryId         INT,
@SubCategoryId      INT,          -- Nullable
@Description        NVARCHAR(1000),
@CustomerImpactFlag INT,
@CustomerName       NVARCHAR(100) -- Nullable
```

**Logic**:
1. Generate ComplaintId (PREFIX-YYYYMMDD-SEQUENCE)
2. Insert into Complaint_Header with Status = 'New'
3. Insert initial row into Complaint_Updates (UpdateType = 'New')
4. Return new ComplaintId

**Output**:
```json
{
  "complaintId": "INC-20260508-0001",
  "status": "New",
  "createdDate": "2026-05-08T09:30:00Z"
}
```

---

## 10.4 Attachment Upload

### API: POST /api/complaints/{complaintId}/attachments

**Request**: Multipart form data with files.

**Server Logic**:
1. Validate file count ≤ 5, size ≤ 10 MB, type in allowed list
2. Save file to server storage path: `/attachments/{YYYY}/{MM}/{complaintId}/`
3. Insert into Complaint_Attachments

**Response**:
```json
{
  "attachments": [
    {
      "attachmentId": 1,
      "fileName": "diagnostic_report.pdf",
      "filePath": "/attachments/2026/05/INC-20260508-0001/diagnostic_report.pdf",
      "uploadedDate": "2026-05-08T09:31:00Z"
    }
  ]
}
```

---

## 10.5 Complaint Status Updates

### SP: usp_AssignComplaint

```sql
@ComplaintId    VARCHAR(20),
@AssignedTo     VARCHAR(20),   -- Engineer EmpCode
@AssignedBy     VARCHAR(20),
@AssignType     VARCHAR(20),   -- ASSIGN / SELF-ASSIGN
@Note           NVARCHAR(1000) -- Optional
```

**Logic**: Update Complaint_Header (AssignedTo, Status = 'Assigned'); Insert Complaint_Updates.

---

### SP: usp_TransferComplaint

```sql
@ComplaintId  VARCHAR(20),
@TransferTo   VARCHAR(20),   -- New Assignee EmpCode or Team
@TransferBy   VARCHAR(20),
@Reason       NVARCHAR(1000)
```

**Logic**: Update AssignedTo; Set AssignType = 'TRANSFER'; Insert Complaint_Updates.

---

### SP: usp_ResolveComplaint

```sql
@ComplaintId       VARCHAR(20),
@ResolvedBy        VARCHAR(20),
@ResolutionSummary NVARCHAR(1000)
```

**Logic**: Update Status = 'Resolved'; Insert Complaint_Updates (UpdateType = 'Resolve').

---

### SP: usp_CloseComplaint

```sql
@ComplaintId  VARCHAR(20),
@ClosedBy     VARCHAR(20),
@Reason       NVARCHAR(1000)
```

**Logic**: Update Status = 'Closed'; Insert Complaint_Updates (UpdateType = 'Close').

---

### SP: usp_ReopenComplaint

```sql
@ComplaintId  VARCHAR(20),
@ReopenedBy   VARCHAR(20),
@Reason       NVARCHAR(1000)
```

**Logic**: Update Status = 'Reopened'; Insert Complaint_Updates (UpdateType = 'Reopen').

---

## 10.6 Work Notes (Comments)

### SP: usp_AddWorkNote

```sql
@ComplaintId  VARCHAR(20),
@AddedBy      VARCHAR(20),
@NoteText     NVARCHAR(1000)
```

**Logic**: Insert into Complaint_Updates (UpdateType = 'Update', Description = NoteText).

---

## 10.7 Complaint Retrieval

### SP: usp_GetComplaints

```sql
@EmpCode      VARCHAR(20),
@Role         VARCHAR(20),
@StatusFilter VARCHAR(20),  -- Nullable
@PriorityFilter VARCHAR(20),-- Nullable
@SearchQuery  NVARCHAR(200),-- Nullable
@PageNumber   INT,
@PageSize     INT
```

**Returns**: Paginated list of complaints, scoped by role and unit permissions.

### SP: usp_GetComplaintDetail

```sql
@ComplaintId  VARCHAR(20),
@EmpCode      VARCHAR(20)  -- For access validation
```

**Returns**: Full complaint header + all updates (timeline) + attachments.

---

---

# 11. Security Requirements

## 11.1 Authentication Security

| Requirement | Implementation |
|---|---|
| Password Storage | BCrypt hash with salt (minimum cost factor 12) |
| LDAP Integration | SSL/TLS required for LDAP connection |
| Account Lockout | Lock after 5 consecutive failed attempts; unlock after 15 min or by Admin |
| Token Signing | JWT signed with RS256 (asymmetric key) |
| Token Transmission | HTTPS only; token in HttpOnly Secure cookie |
| Logout | Server-side token invalidation (blacklist or short expiry + refresh) |

## 11.2 Authorization Security

| Requirement | Implementation |
|---|---|
| Server-side RBAC | Every API endpoint validates role from JWT before processing |
| Unit Scope | All complaint queries filtered by user's unit permissions server-side |
| Frontend hiding | UI hides unauthorized elements (UX only; never relied upon for security) |
| Privilege escalation | User cannot modify their own role or unit permissions |

## 11.3 Input Validation

| Requirement | Implementation |
|---|---|
| SQL Injection | Parameterized queries / stored procedures only; no string concatenation |
| XSS Prevention | All user input HTML-encoded on output; Content Security Policy headers |
| File Upload | MIME type validation server-side (not just extension); scan with AV |
| Request Size | Max payload size enforced at API gateway (e.g., 50 MB) |
| Field Length | All fields validated against max length server-side |

## 11.4 Attachment Security

| Requirement | Implementation |
|---|---|
| Allowed Types | Whitelist: PDF, PNG, JPG, JPEG, DOCX, DOC, XLSX, XLS, TXT |
| File Naming | Files renamed server-side to UUID to prevent path traversal |
| Storage Location | Outside web root; served via authenticated API endpoint only |
| Max Size | 10 MB per file, 5 files per complaint |

## 11.5 Audit Logging

| Event | Logged |
|---|---|
| Login success / failure | ✅ (EmpCode, IP, timestamp, result) |
| Complaint created | ✅ (Complaint_Updates: UpdateType = New) |
| Complaint status changed | ✅ (Complaint_Updates) |
| Work note added | ✅ (Complaint_Updates) |
| Admin master data changes | ✅ (separate AuditLog table recommended) |
| User account changes | ✅ (User_Master UpdatedBy, UpdatedDate) |

---

---

# 12. Non-Functional Requirements

## 12.1 Performance

| Metric | Target |
|---|---|
| Dashboard load time | < 2 seconds (P95) |
| Complaint list page load | < 1.5 seconds (P95) |
| Complaint detail workspace load | < 1 second (P95) |
| Complaint creation submission | < 3 seconds (P95) |
| File upload (per file) | < 5 seconds for 10 MB file |
| Concurrent users | 500 simultaneous users without degradation |
| Database query response | < 200 ms for all stored procedures |

## 12.2 Availability

| Metric | Target |
|---|---|
| System Uptime | 99.5% monthly (≈ 3.6 hours downtime/month) |
| Planned Maintenance Window | Sundays, 01:00–05:00 IST |
| Backup Frequency | Daily full + hourly incremental |
| Recovery Point Objective (RPO) | 1 hour |
| Recovery Time Objective (RTO) | 4 hours |

## 12.3 Scalability

- Horizontal scaling of application tier via load balancer
- Database read replicas for reporting queries
- File storage on network-attached storage (NAS) or cloud blob storage (future)
- Session management stateless via JWT (no sticky sessions required)

## 12.4 Maintainability

- All master data (units, categories, subcategories, types) manageable via Admin panel without code changes
- Database migrations tracked via version-controlled scripts
- Stored procedures documented with inline comments
- UI components modular and independently updatable

## 12.5 Browser & Device Compatibility

| Browser | Minimum Version |
|---|---|
| Google Chrome | Last 2 versions |
| Mozilla Firefox | Last 2 versions |
| Microsoft Edge | Last 2 versions |
| Safari | Last 2 versions |

| Device | Support Level |
|---|---|
| Desktop (1280px+) | Full |
| Tablet (768px–1279px) | Full |
| Mobile (< 768px) | Basic (Phase 2) |

## 12.6 Logging

| Log Type | Retention |
|---|---|
| Application error logs | 90 days |
| Access logs | 30 days |
| Audit logs (complaint actions) | 5 years |
| Authentication logs | 1 year |

---

---

# 13. Future Enhancements

## Phase 2 — Planned

| Enhancement | Description | Priority |
|---|---|---|
| Email Notifications | Automated email alerts for all status changes via SMTP relay | High |
| SLA Escalation Engine | Auto-escalate to Admin/SOC when SLA > 80% consumed | High |
| Dashboard Analytics | Charts for resolution trends, SLA performance, engineer workload | Medium |
| Mobile Application | React Native app for engineers to manage complaints on-the-go | Medium |
| Knowledge Base | Searchable resolution guides linked to complaint categories | Medium |

## Phase 3 — Future Consideration

| Enhancement | Description |
|---|---|
| SOC Monitoring Dashboard | Dedicated real-time SOC view with security event correlation |
| Advanced Reporting Module | Exportable reports (Excel/PDF) with filters by unit, date, category |
| Customer Portal | External-facing portal for vendors/clients to track their complaints |
| AI-Assisted Triage | Auto-suggest category, subcategory, and priority using NLP |
| Integration with Adrenalin HRMS | Real-time employee sync (currently manual/batch CSV import) |
| VC Booking Module | Full video conferencing room booking with calendar integration |
| WhatsApp / SMS Notifications | Push updates via WhatsApp Business API or SMS gateway |

---

---

# 14. Acceptance Criteria

## 14.1 Complaint Creation

```
GIVEN a logged-in Employee/Guest
WHEN they navigate to New Complaint
THEN the form loads with all required fields visible

GIVEN Complaint Type = Incident is selected
WHEN Category dropdown is rendered
THEN only Incident categories appear (Network Issues, Outlook/Mail Issues, Printer Issues, Software Issues, System/Laptop Issues, Others)

GIVEN Complaint Type = Service is selected
WHEN Category dropdown is rendered
THEN only Service categories appear AND Subcategory field is hidden

GIVEN a valid Category is selected with ComplaintType = Incident
WHEN Subcategory dropdown is rendered
THEN only subcategories for that specific category appear

GIVEN all mandatory fields are filled
WHEN the form is submitted
THEN a complaint is created with Status = "New"
AND a unique ComplaintId is generated (format: INC/SRV-YYYYMMDD-XXXX)
AND a success screen shows the ComplaintId

GIVEN mandatory fields are missing
WHEN the form is submitted
THEN inline validation errors appear per field
AND the form is NOT submitted
```

## 14.2 Complaint Assignment

```
GIVEN an Admin or SOC user viewing a complaint with Status = "New" or "Reopened"
WHEN they click "Assign Complaint"
THEN the Assign Modal opens with a dropdown of active Engineers

GIVEN an Engineer is selected and Assign is confirmed
THEN Complaint_Header.AssignedTo = selected EmpCode
AND Complaint_Header.Status = "Assigned"
AND Complaint_Updates entry is created (UpdateType = "Assign", AssignType = "ASSIGN")

GIVEN an Engineer user viewing an unassigned complaint
WHEN they click "Self Assign"
THEN the complaint is immediately assigned to their EmpCode
AND Complaint_Updates entry created (AssignType = "SELF-ASSIGN")

GIVEN a complaint is already closed
WHEN any user attempts to assign
THEN the action is rejected with message "Cannot assign a closed complaint"
```

## 14.3 Complaint Transfer

```
GIVEN an Engineer/SOC/Admin viewing an assigned complaint
WHEN they click "Transfer"
THEN the Transfer Modal opens with Department dropdown and mandatory Reason field

GIVEN Department and Reason are provided
WHEN Transfer is confirmed
THEN Complaint_Updates entry created (UpdateType = "Assign", AssignType = "TRANSFER")
AND the new assignee receives a notification

GIVEN Reason is empty
WHEN Transfer is attempted
THEN the confirm button is disabled
AND validation error is shown
```

## 14.4 Complaint Resolution

```
GIVEN an Engineer or Admin viewing a complaint with Status = "In Progress" or "Assigned"
WHEN they click "Resolve"
THEN the Resolve Modal opens with a mandatory Resolution Summary textarea

GIVEN a Resolution Summary of at least 20 characters is provided
WHEN Resolve is confirmed
THEN Complaint_Header.Status = "Resolved"
AND Complaint_Updates entry created (UpdateType = "Resolve")
AND the complaint creator receives a notification

GIVEN the complaint is already "Closed"
THEN the Resolve button is disabled
```

## 14.5 Complaint Closure

```
GIVEN an Admin, SOC, or Engineer viewing a "Resolved" complaint
WHEN they click "Close Complaint"
THEN the Close Modal opens requiring a closure reason

GIVEN reason is provided and confirmed
THEN Complaint_Header.Status = "Closed"
AND Complaint_Updates entry created (UpdateType = "Close")

GIVEN an Employee viewing a closed complaint
THEN the Close button is NOT visible
```

## 14.6 Complaint Reopen

```
GIVEN an Employee or Admin viewing a "Resolved" or "Closed" complaint
WHEN they click "Reopen"
THEN the Reopen Modal opens requiring a reason

GIVEN reason is provided and confirmed
THEN Complaint_Header.Status = "Reopened"
AND Complaint_Updates entry created (UpdateType = "Reopen")
AND the previously assigned engineer receives a notification

GIVEN the complaint is In Progress (not Resolved/Closed)
THEN the Reopen button is disabled
```

## 14.7 Role-Based Visibility

```
GIVEN a logged-in Employee
WHEN the sidebar is rendered
THEN SOC menu item is NOT visible
AND the Action Panel shows only: Reopen (disabled unless Resolved/Closed)

GIVEN a logged-in SOC user
WHEN the sidebar is rendered
THEN SOC menu item IS visible
AND the Action Panel shows: Assign, Transfer, Close

GIVEN a logged-in Engineer
WHEN the Action Panel is rendered
THEN "Assign Complaint" (to others) button is NOT visible
AND "Self Assign", "Transfer", "Resolve", "Close" ARE visible

GIVEN a logged-in Admin
WHEN the Action Panel is rendered
THEN ALL action buttons are visible and enabled
```

## 14.8 Authentication

```
GIVEN a user with valid LDAP credentials
WHEN they submit the login form
THEN they are authenticated via Active Directory
AND redirected to Dashboard

GIVEN a user with invalid credentials
WHEN they submit the login form
THEN an error message is shown: "Invalid username or password"
AND no session is created

GIVEN a locked account
WHEN the user attempts login
THEN they see: "Your account is locked. Contact IT Administrator."

GIVEN a logged-in user
WHEN they are inactive for 30 minutes
THEN the session expires and they are redirected to login
```

## 14.9 Data Integrity

```
GIVEN a complaint is created
THEN all FK references (UnitId, CategoryId, SubCategoryId, ComplaintTypeId) must exist in master tables

GIVEN an attachment is uploaded
THEN file type must be in the allowed whitelist
AND file size must be ≤ 10 MB
AND filename is stored as UUID on server (original name stored in DB)

GIVEN any status change occurs
THEN a corresponding Complaint_Updates record MUST be created
AND no status change occurs without a Complaint_Updates entry (enforced by SP)
```

---

---

# Appendix A — Master Data Seed Reference

## Complaint Types

| ID | Name | Alias |
|---|---|---|
| 1 | Incident | INC |
| 2 | Service | SRV |

## Units (22)

| ID | Unit Name |
|---|---|
| 1 | Manipal Fintech |
| 2 | MBS-Gurgaon |
| 3 | MBS-Manipal |
| 4 | MCT-InTouch |
| 5 | MDS-Bangalore |
| 6 | MDS-Kumta |
| 7 | MDS-Manipal |
| 8 | MMNL-Bangalore |
| 9 | MMNL-Delhi |
| 10 | MMNL-Editorial-Manipal |
| 11 | MMNL-Hubli |
| 12 | MMNL-Mangalore |
| 13 | MMNL-Mumbai |
| 14 | MMNL-Udupi |
| 15 | MPi-Manipal |
| 16 | MPi-Mumbai |
| 17 | MPi-Noida |
| 18 | MTL - Noida |
| 19 | MTL-Bangalore |
| 20 | MTL-Chennai |
| 21 | MTL-Coimbatore |
| 22 | UNIT-3 - HO (UDAYAVANI) |

## Categories × Subcategories (Incident)

| Category | Subcategory |
|---|---|
| Network Issues | Data Transfer |
| Network Issues | Internet Issue |
| Network Issues | Network Connection Issue |
| Network Issues | Network Down |
| Network Issues | Share Folder Access Issue |
| Network Issues | VPN Issue |
| Network Issues | Others |
| Outlook / Mail Issues | File Attachment Issue |
| Outlook / Mail Issues | Incoming / Outgoing Mail Issues |
| Outlook / Mail Issues | Outlook Opening Problem |
| Outlook / Mail Issues | PST Issue |
| Outlook / Mail Issues | Synchronisation Issue |
| Outlook / Mail Issues | Others |
| Printer Issues | Paper Jam |
| Printer Issues | Printer Down |
| Printer Issues | Printer Error |
| Printer Issues | Scanner Issue |
| Printer Issues | Others |
| Software Issues | Adobe Software Issue |
| Software Issues | Excel / PowerPoint / Word Issue |
| Software Issues | Issue in Browser |
| Software Issues | Office Activation Issue |
| Software Issues | Tally Application Issue |
| Software Issues | Others |
| System / Laptop Issues | Disk is Full |
| System / Laptop Issues | Keyboard Not Working |
| System / Laptop Issues | Login Issue |
| System / Laptop Issues | Monitor / Display Issue |
| System / Laptop Issues | Mouse Not Working |
| System / Laptop Issues | System Down |
| System / Laptop Issues | System is Slow |
| System / Laptop Issues | Others |
| Others | Others |

## Service Categories (No Subcategories)

| Category |
|---|
| CD Request |
| Colour Print Request |
| Need Anydesk |
| SAP Installation |
| Share Folder Access |
| Site Access |
| Skype Installation |
| Tally Software Installation |
| Updating Saral TDS Software |
| User Activation |
| User Deactivation |
| Video Download |
| VPN Installation |
| Zoom Installation |
| Others |

---

# Appendix B — Employee Data Structure (HRMS Sync)

The CMS user database is seeded and periodically synchronized from the Manipal Group Adrenalin HRMS. The following fields are used:

| HRMS Field | CMS Mapping | Notes |
|---|---|---|
| EMP_Empcode | User_Master.EmpCode | Primary identifier |
| EMP_Name | User_Master.FullName | Display name |
| EMP_DomainUsername | User_Master.Username | Used for LDAP login |
| EMP_EmailId | For notifications | Stored separately |
| EMP_Unit | Unit_Master lookup | Maps to UnitId |
| EMP_CompanyName | Reference only | Manipal Technologies Limited, etc. |
| EMP_DOL | Deactivation trigger | If not NULL: Status = Inactive |
| EMP_ImageName | Profile avatar URL | Optional display |

**Sync Frequency**: Recommended daily batch job (overnight) pulling from HRMS API or CSV export.

---

*End of Document*

---

**Document Control**

| Version | Date | Author | Changes |
|---|---|---|---|
| 1.0 | May 2026 | Product & Technology Team | Initial release |

*This document is confidential and intended for internal Manipal Group use only.*
