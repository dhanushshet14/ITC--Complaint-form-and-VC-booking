# New Complaint Form - Visual Reference & User Guide

## Form Structure Overview

The complaint form is organized into 5 main sections, each clearly numbered and described:

```
┌─────────────────────────────────────────────────────────────────┐
│ New Technical Complaint                              🔔    JD   │
├─────────────────────────────────────────────────────────────────┤
│ Form progress [████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░] 22% complete │
├─────────────────────────────────────────────────────────────────┤
│ ┌─ 02 Classification ────────────────────────────────────────┐  │
│ │ Category *                    Subcategory *                 │  │
│ │ [Select category...  ▼]      [Select a category first ▼]  │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                   │
│ ┌─ 03 Priority & Impact ─────────────────────────────────────┐  │
│ │ Priority Level *                                            │  │
│ │ ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐    │  │
│ │ │🟢 Low    │  │🟡 Medium │  │🟠 High   │  │🔴 Critical│   │  │
│ │ │Minor     │  │Moderate  │  │Signif.   │  │System-wide│   │  │
│ │ │72 hrs    │  │24 hrs    │  │4 hrs     │  │Immediate  │   │  │
│ │ └──────────┘  └──────────┘  └──────────┘  └──────────┘    │  │
│ │                                                              │  │
│ │ Customer / End-user Impact * ⓘ                              │  │
│ │ ⬜ Yes — customers affected    ⚫ No — internal only        │  │
│ │                                                              │  │
│ │ [⚠️ Customer impact detected message if "Yes" selected]     │  │
│ │ [Impact Reason text area appears conditionally]            │  │
│ └────────────────────────────────────────────────────────────┘  │
│                                                                   │
│ ┌─ 04 Description ──────────────────────────────────────────┐   │
│ │ Detailed Description *                                      │   │
│ │ [Large text area for detailed issue description]           │   │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                   │
│ ┌─ 05 Attachments ──────────────────────────────────────────┐   │
│ │ [Drag & drop area]                                          │   │
│ │ PNG, JPG, PDF, TXT, CSV, LOG — up to 10 MB each           │   │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                   │
│         [Cancel]     Form progress: 22% complete  [Submit →]    │
└─────────────────────────────────────────────────────────────────┘
```

## Section Descriptions

### Section 02: Classification
- **Purpose**: Categorize the complaint by type
- **Fields**:
  - Category (required): Choose the primary category
  - Subcategory (required): Auto-populated based on category
- **Categories Available**:
  - Hardware
  - Software
  - Network
  - Database
  - Application

### Section 03: Priority & Impact
- **Priority Selection**: Choose urgency level
  - **Low** (Green): Minor impact, resolve within 72 hours
  - **Medium** (Yellow): Moderate impact, resolve within 24 hours
  - **High** (Orange): Significant impact, resolve within 4 hours
  - **Critical** (Red): System-wide impact, immediate action required

- **Customer Impact**: Specify if customers are affected
  - **Yes**: Shows additional field for impact details
  - **No**: Only internal concern (default)

- **Conditional Impact Reason**: Appears only when "Yes" is selected
  - 500-character limit
  - Character counter displays
  - Red background to indicate importance

### Section 04: Description
- **Purpose**: Provide detailed information about the issue
- **Expected Content**:
  - What happened
  - When it started
  - How many users affected
  - Error messages received
  - Steps already taken to resolve

### Section 05: Attachments
- **Purpose**: Upload supporting documents (optional)
- **Supported File Types**: PNG, JPG, PDF, TXT, CSV, LOG
- **File Size Limit**: 10 MB per file
- **Features**:
  - Drag and drop support
  - Click to browse
  - Visual feedback on drag-over

## Interactive Behaviors

### 1. Category Selection
```
User selects category → Subcategory dropdown enabled
                    → Available subcategories populated
                    → Progress bar updates
```

### 2. Priority Selection
```
User clicks priority card → Card highlighted with checkmark
                        → Border color changes
                        → Progress bar updates
```

### 3. Customer Impact Selection
```
User selects "Yes" → Impact section appears with animation
                  → Text area becomes editable
                  → Warning message displays

User selects "No"  → Impact section disappears
                  → Text area clears
                  → Warning message hides
```

### 4. Form Progress
```
Progress calculation based on:
- Category: 16.67%
- Subcategory: 16.67%
- Priority: 16.67%
- Customer Impact: 16.67%
- Impact Reason (if applicable): 16.67%
- Description: 16.67%

Total: 100% when all fields completed
```

## Form States

### Initial State (Empty)
- All fields empty
- Subcategory disabled ("Select a category first")
- Impact section hidden
- Progress: 22% (form page loaded)
- Submit button enabled but validation will prevent submission

### Partial Completion
- Some fields filled
- Progress percentage updates in real-time
- Conditional sections appear/disappear as needed
- Submit button remains enabled

### Ready to Submit
- All required fields filled
- Progress: 100%
- All sections visible/completed
- Form passes validation
- User can click "Submit Complaint"

### After Cancel
- Confirmation dialog appears
- User can choose to cancel or continue editing
- On confirmation, returns to AllComplaints.aspx

## Error Handling

### Missing Required Fields
```
Alert Message: "Please fill in all required fields"
Prevents submission of incomplete form
Highlights missing fields (red asterisks already visible)
```

### Invalid File Upload
```
Alert Message: "Invalid file type: [filename]"
Alert Message: "File too large: [filename]"
File rejected, allows re-selection
```

## Responsive Design

### Desktop (1200px+)
- Sidebar visible (200px fixed)
- Full form width
- Priority grid: 4 columns
- 2-column form layout where applicable

### Tablet (768px - 1200px)
- Sidebar visible (160px)
- Adjusted spacing
- Priority grid: 2 columns
- Responsive form layout

### Mobile (<768px)
- Sidebar hidden
- Full-width form
- Single-column layout
- Full-width buttons
- Touch-friendly spacing

## Navigation Flow

### Entry Points
1. From AllComplaints.aspx via "New Complaint" button
   - URL: `NewComplaint.aspx?type=Technical`
   - URL: `NewComplaint.aspx?type=Telephone`

2. From Sidebar
   - Technical → New Complaint
   - Telephone → New Complaint

### Exit Points
1. Cancel button → Back to AllComplaints.aspx with confirmation
2. Submit button → Submit form (requires backend implementation)

## Keyboard Navigation

- **Tab**: Navigate between form fields
- **Enter**: Submit form (on button focus)
- **Space**: Toggle radio buttons and checkboxes
- **Escape**: Close any open dropdowns

## Accessibility Features

- Proper label associations with form fields
- ARIA labels for icon buttons
- Color coding supplemented with text labels
- Focus states for keyboard navigation
- Semantic HTML structure
- Alt text for UI icons

## Quick Reference: URL Parameters

```
?type=Technical   → Shows "New Technical Complaint"
?type=Telephone   → Shows "New Telephone Complaint"
```

Both forms have identical functionality, only the heading changes.
