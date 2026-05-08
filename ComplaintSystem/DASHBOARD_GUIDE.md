# ServiceCore Dashboard - UI Implementation Guide

## Overview
A professional, responsive complaint management dashboard built with ASP.NET WebForms and clean CSS. The design follows the mockup specification with a modern sidebar navigation, stat cards, status pipeline, and complaints table.

## Features

### 1. **Responsive Layout**
- **Sidebar Navigation** (Fixed, 200px wide)
  - Collapsible navigation menu with icons
  - Brand logo and company name
  - Main navigation items (Dashboard, Technical, SOC, Telephone, VC Booking)
  - Profile and Logout links at the bottom
  - Dark theme (#1a1a2e) with blue accents (#4a90e2)

- **Main Content Area**
  - Responsive grid that adjusts to sidebar width
  - Automatically adjusts on mobile devices (hides sidebar)
  - Proper spacing and padding throughout

### 2. **Dashboard Header**
- Title "Dashboard"
- Search box for complaint filtering
- Status dropdown filter (All Status, Assigned, Accepted, In Progress, Resolved, Closed)
- Priority dropdown filter (All Priority, Critical, High, Medium, Low)
- Notification bell with badge counter
- User profile icon with initials (JD)

### 3. **Statistics Cards Grid** (5 Cards)
- **Total Complaints** - Blue (#4a90e2)
  - Icon: 📋
  - Value: 248
  - Change: ↑ +12%

- **Ongoing** - Orange (#f39c12)
  - Icon: ⏳
  - Value: 64
  - Change: ↑ +5%

- **Resolved** - Green (#27ae60)
  - Icon: ✅
  - Value: 142
  - Change: ↑ +8%

- **Closed** - Gray (#95a5a6)
  - Icon: 🔒
  - Value: 35
  - Change: ↓ -2%

- **Transferred** - Purple (#9b59b6)
  - Icon: ↔️
  - Value: 7
  - Change: ↑ +3%

**Card Features:**
- Colored left border indicating card type
- Hover effect with shadow and slight lift
- Icon + large value + label + change percentage
- Responsive: 5 columns on large screens, 3 on medium, 2 on mobile

### 4. **Status Pipeline Section**
Workflow visualization showing complaint progression:

1. **Assigned** (✓)
   - Green badge
   - Shows count of assigned complaints

2. **Accepted** (✓)
   - Green badge  
   - Shows count of accepted complaints

3. **In Progress** (45)
   - Dark badge with count
   - Active workflow stage

4. **Resolved** (142)
   - Orange badge with count
   - Shows resolved complaints

5. **Closed** (35)
   - Gray badge with count
   - Final stage

**Features:**
- Connectors between stages (green for active, gray for completed)
- Click to filter functionality
- Stage labels and counts

### 5. **Recent Complaints Table**
Data table showing last 10 complaints with columns:
- **ID** (Sortable) - e.g., "TC-1024"
- **Type** (Sortable) - e.g., "Technical", "Telephone", "SOC", "VC Booking"
- **Status** (Sortable) - Color-coded badge
  - Assigned (Blue)
  - Accepted (Blue)
  - In Progress (Orange)
  - Resolved (Green)
  - Closed (Gray)
- **Priority** (Sortable) - Color-coded badge
  - Critical (Red)
  - High (Orange)
  - Medium (Pink)
  - Low (Teal)
- **Assigned To** (Sortable) - Person's name
- **Date** (Sortable) - e.g., "Apr 08, 2026"

**Features:**
- Sortable columns (indicator: ↓)
- Hover effect on rows
- Color-coded badges for status and priority
- Results count indicator (10 results)
- Pagination-ready (mock data)

## Color Scheme

| Element | Color | Hex |
|---------|-------|-----|
| Sidebar Background | Dark Blue | #1a1a2e |
| Primary Accent | Blue | #4a90e2 |
| Stat - Total | Blue | #4a90e2 |
| Stat - Ongoing | Orange | #f39c12 |
| Stat - Resolved | Green | #27ae60 |
| Stat - Closed | Gray | #95a5a6 |
| Stat - Transferred | Purple | #9b59b6 |
| Background | Light Gray | #f8f9fa |
| Card Background | White | #ffffff |
| Border/Divider | Light Gray | #e0e0e0 |
| Text Primary | Dark Gray | #333333 |
| Text Secondary | Medium Gray | #666666 |
| Text Tertiary | Light Gray | #999999 |

## File Structure

```
ComplaintSystem/
├── HomePage.aspx              (Main UI)
├── HomePage.aspx.cs           (Code-behind with data loading)
├── HomePage.aspx.designer.cs  (Auto-generated designer file)
└── Auth/
    ├── AuthorizationHelper.cs (Permission checking)
    └── AuthenticationService.cs (Auth logic)
```

## Data Integration

### Current State (Mock Data)
- All data is currently hardcoded in HTML for UI demonstration
- Dashboard loads with sample complaint data

### To-Do: Connect to Database

1. **Load Statistics**
   - Query database for complaint counts by status
   - Update stat cards dynamically
   - Use `updateStats()` JavaScript function

2. **Load Pipeline Data**
   - Query counts for each workflow stage
   - Update pipeline badges dynamically
   - Use `updatePipeline()` JavaScript function

3. **Load Recent Complaints**
   - Query complaints table with role-based filtering
   - Populate table rows dynamically
   - Use ComplaintDataService for data retrieval

### Example Implementation

```csharp
// In LoadStatistics() method
ComplaintDataService dataService = new ComplaintDataService();
var stats = dataService.GetComplaintStatistics(empCode, roleId);

// Generate JavaScript to update UI
string scriptStats = $@"
    <script>
        updateStats({stats.Total}, {stats.Ongoing}, {stats.Resolved}, {stats.Closed}, {stats.Transferred});
    </script>";

Page.ClientScript.RegisterClientScriptBlock(this.GetType(), "statsScript", scriptStats);
```

## Role-Based Display

The dashboard is role-aware and can be customized per role:

```csharp
if (roleId == 1) // Admin
{
    // Show all complaints, user management stats
}
else if (roleId == 2) // SOC
{
    // Show all complaints, assignment metrics
}
else if (roleId == 3) // Engineer
{
    // Show assigned and unit complaints
    // Show resolution metrics
}
else if (roleId == 4 || roleId == 5) // Employee/Guest
{
    // Show own complaints only
    // Simplified pipeline view
}
```

## JavaScript Functions

### `toggleDropdown(dropdownId, event)`
Opens/closes filter dropdowns, closes others

### `selectStatus(status)`
Filters complaints by selected status

### `selectPriority(priority)`
Filters complaints by selected priority

### `updateStats(total, ongoing, resolved, closed, transferred)`
Updates stat card values dynamically

### `updatePipeline(assigned, accepted, progress, resolved, closed)`
Updates pipeline stage counts dynamically

## Responsive Breakpoints

- **Large (>1200px)**: 5 stat columns, full sidebar visible
- **Medium (768px-1200px)**: 3 stat columns, full sidebar visible
- **Small (<768px)**: 2 stat columns, sidebar hidden

## Customization

### Change Colors
Edit CSS variables in `<style>` section:
```css
.stat-card.total { border-left-color: #4a90e2; }
```

### Add/Remove Navigation Items
Edit sidebar navigation in HTML:
```html
<ul class="sidebar-nav">
    <!-- Add new <li> items here -->
</ul>
```

### Modify Table Columns
Add new `<th>` in table header and corresponding `<td>` in rows

### Change Grid Layout
Modify stats-grid columns:
```css
.stats-grid {
    grid-template-columns: repeat(4, 1fr); /* Change number here */
}
```

## Browser Compatibility
- Modern browsers (Chrome, Firefox, Safari, Edge)
- IE 11+ (basic support)
- Mobile browsers (iOS Safari, Chrome Mobile)

## Performance Notes
- Uses semantic HTML5
- CSS Grid for responsive layout
- Minimal JavaScript (dropdown toggle only)
- Can handle 1000+ table rows with pagination

## Future Enhancements

1. **Export Functionality**
   - Export complaints as PDF/Excel
   - Export dashboard statistics

2. **Advanced Filtering**
   - Filter by date range
   - Filter by assigned person
   - Filter by category/department

3. **Dashboard Customization**
   - Drag-and-drop widgets
   - Save filter preferences
   - Custom stat cards

4. **Real-time Updates**
   - WebSocket updates for new complaints
   - Live stat card updates
   - Real-time pipeline visualization

5. **Charts & Analytics**
   - Trend charts for complaint metrics
   - Distribution pie charts
   - Performance dashboards

## Support

For questions or modifications, refer to the code comments in HomePage.aspx.cs for data integration placeholders.
