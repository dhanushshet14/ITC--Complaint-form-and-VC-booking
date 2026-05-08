## ServiceCore Dashboard - Visual Structure

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                                                                                   │
│  SIDEBAR (200px)                    MAIN CONTENT                                │
│  ─────────────────                  ──────────────────────────────────────────  │
│  ⚙️ ServiceCore                                                                   │
│                                      Dashboard  🔍 [Search...] [All Status ▼]  │
│  📊 Dashboard ←                                              [All Priority ▼] 🔔 │
│  🔧 Technical                                                              JD    │
│  🎯 SOC                                                                         │
│  ☎️ Telephone              ┌──────────────────────────────────────────────────┐ │
│  📹 VC Booking             │ 📋 248          ⏳ 64         ✅ 142    🔒 35    │ │
│                            │ Total Complaints Ongoing    Resolved Closed       │ │
│  ─────────────────         │ ↑ +12%          ↑ +5%       ↑ +8%   ↓ -2%       │ │
│  👤 Profile                │                                                    │ │
│  🚪 Logout                 │ ↔️ 7                                              │ │
│                            │ Transferred                                        │ │
│                            │ ↑ +3%                                             │ │
│                            └──────────────────────────────────────────────────┘ │
│                                                                                   │
│                            ┌──────────────────────────────────────────────────┐ │
│                            │  Status Pipeline          [Click to filter]      │ │
│                            │  ✓ Assigned ──── ✓ Accepted ──── 45 In Progress │ │
│                            │                                                    │ │
│                            │  142 Resolved ──── 35 Closed                     │ │
│                            └──────────────────────────────────────────────────┘ │
│                                                                                   │
│                            ┌──────────────────────────────────────────────────┐ │
│                            │ Recent Complaints                    10 results   │ │
│                            ├──────────┬─────────┬──────────┬────────┬────────┤ │
│                            │ ID       │ Type    │ Status   │Priority│ Assigned│ │
│                            ├──────────┼─────────┼──────────┼────────┼────────┤ │
│                            │TC-1024   │Technical│In Prog...│Critical│Sarah   │ │
│                            │TC-1023   │Telephone│Assigned  │High    │James   │ │
│                            │SC-0981   │SOC      │Resolved  │Medium  │Emily   │ │
│                            │VC-0456   │VC Booking│Accepted │Low     │Alex    │ │
│                            │TC-1022   │Technical│In Prog...│High    │David   │ │
│                            │TP-0890   │Telephone│Closed    │Medium  │Maria   │ │
│                            └──────────┴─────────┴──────────┴────────┴────────┘ │
│                                                                                   │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## Component Layout Details

### Sidebar (Fixed, 200px)
```
30px padding
│
├─ Brand Section (40px)
│  ├─ Icon [⚙️]
│  └─ Text: ServiceCore
│
├─ Gap (40px)
│
├─ Navigation (270px)
│  ├─ Dashboard (Active - Blue bg)
│  ├─ Technical
│  ├─ SOC
│  ├─ Telephone
│  └─ VC Booking
│
├─ Bottom Section (Fixed position)
│  ├─ Border-top
│  ├─ Profile
│  └─ Logout (Red text)
```

### Main Content Area
```
Margin-left: 200px
Padding: 30px

├─ Header Section (Flex)
│  ├─ Title (32px, bold)
│  └─ Controls
│     ├─ Search Box (300px)
│     ├─ Status Dropdown
│     ├─ Priority Dropdown
│     ├─ Notification Bell
│     └─ Profile Icon
│
├─ Stats Grid
│  └─ 5 columns (CSS Grid)
│     ├─ Card (Flex column)
│     │  ├─ Icon (28px)
│     │  ├─ Value (32px, bold)
│     │  ├─ Label (13px)
│     │  └─ Change (12px)
│
├─ Pipeline Section
│  └─ Container (Flex)
│     ├─ Stage 1: Assigned
│     ├─ Line connector
│     ├─ Stage 2: Accepted
│     ├─ Line connector
│     ├─ Stage 3: In Progress
│     ├─ Line connector
│     ├─ Stage 4: Resolved
│     ├─ Line connector
│     └─ Stage 5: Closed
│
└─ Table Section
   └─ Complaints Table
      ├─ Header Row
      └─ 6 Data Rows
```

## Color Code Reference

```
Primary Blue:    #4a90e2  ■
Sidebar Dark:    #1a1a2e  ■
Ongoing Orange:  #f39c12  ■
Resolved Green:  #27ae60  ■
Closed Gray:     #95a5a6  ■
Transfer Purple: #9b59b6  ■
Background:      #f8f9fa  ■
White:           #ffffff  ■
Text Dark:       #333333  ■
Text Light:      #999999  ■
Border:          #e0e0e0  ■
```

## Responsive Breakpoints

```
DESKTOP (1920px+)
├─ Sidebar: Visible (200px)
├─ Stats Grid: 5 columns
├─ Search: Full width (300px)
└─ Table: All 6 columns visible

TABLET (1024px - 1200px)
├─ Sidebar: Visible (200px)
├─ Stats Grid: 3 columns
├─ Search: Full width (250px)
└─ Table: All 6 columns visible

MOBILE (375px - 768px)
├─ Sidebar: Hidden
├─ Stats Grid: 2 columns
├─ Search: Full width (100%)
├─ Dashboard Controls: Stacked
└─ Table: Scrollable
```

## Interactive Elements

```
Clickable Elements:
├─ Sidebar navigation items (Links to other pages)
├─ Dropdown buttons (Status, Priority)
│  └─ Opens dropdown menu on click
├─ Dropdown items (Status options: All, Assigned, Accepted, etc.)
│  └─ Updates filter label, closes dropdown
├─ Notification bell (Placeholder)
├─ Profile icon (Placeholder)
├─ Pipeline stages (Click to filter)
└─ Table rows (Placeholder for detail view)

Hover Effects:
├─ Nav items: Background color change + color shift
├─ Stat cards: Shadow + slight lift
├─ Dropdown items: Background highlight
├─ Table rows: Subtle background color
├─ Buttons: Border color change
```

## Data States

```
NORMAL (Current)
├─ All data loaded
├─ Dropdowns closed
├─ All rows visible
└─ Status: Fully functional

LOADING
├─ Skeleton loaders (if implemented)
├─ Disable interactions
└─ Show loading spinner

EMPTY
├─ No complaints found message
├─ Show in table area
└─ Keep structure visible

ERROR
├─ Error message in toast/alert
├─ Retry button
└─ Keep previous data visible
```

## Mobile Layout Changes

```
Mobile (< 768px):

┌────────────────────────────┐
│ 🔍 [Search complaints...]  │
│ [All Status ▼] [All Prior..]│
│         🔔          JD      │
└────────────────────────────┘

┌────────────────────────────┐
│ 📋 248      ⏳ 64           │
│ Total      Ongoing         │
│ ↑ +12%     ↑ +5%           │
│                            │
│ ✅ 142      🔒 35          │
│ Resolved   Closed          │
│ ↑ +8%      ↓ -2%           │
│                            │
│ ↔️ 7                        │
│ Transferred                │
│ ↑ +3%                      │
└────────────────────────────┘

Sidebar hidden (swipe/toggle if added)
All controls full width
Stack filter buttons vertically
Table scrolls horizontally
```

## Animation & Transitions

```
All transitions: 0.3s ease

Hover effects:
├─ Navigation items: Color + background fade
├─ Stat cards: Shadow + transform (translateY -2px)
├─ Buttons: Border color fade
├─ Dropdown items: Background fade

Dropdown open/close:
└─ Display property (instant)

Mobile menu (if added):
└─ Slide left/right animation
```

## Typography

```
Dashboard Title:    32px, weight 700 (bold)
Section Title:      18px, weight 600 (semibold)
Table Headers:      12px, weight 600 (semibold)
Stat Values:        32px, weight 700 (bold)
Stat Labels:        13px, weight 400
Badge Text:         11px, weight 600 (semibold)
Normal Text:        13-14px, weight 400
Small Text:         12px, weight 400
```

## Shadow & Borders

```
Cards (section, stat-card):
├─ Box shadow: 0 2px 8px rgba(0,0,0,0.05)
├─ Hover: 0 4px 16px rgba(0,0,0,0.1)
└─ Border-radius: 12px

Sidebar:
├─ Box shadow: 2px 0 10px rgba(0,0,0,0.1) [vertical offset]
└─ Border-radius: 0 (sharp)

Dropdowns:
├─ Box shadow: 0 8px 16px rgba(0,0,0,0.1)
├─ Border: 1px solid #e0e0e0
└─ Border-radius: 8px

Table:
├─ Border-bottom: 1px solid #e0e0e0
├─ Thead background: #f8f9fa
└─ Border-radius: 0 (sharp table)
```

## Spacing Grid (8px base)

```
Padding:
├─ Section padding: 25px (3.125 x 8)
├─ Card padding: 25px
├─ Header padding: 15px (table)
└─ Sidebar padding: 30px

Margins:
├─ Between sections: 30px
├─ Grid gap: 20px
├─ Sidebar items: 15px
└─ Sidebar bottom gap: 40px

Gaps:
├─ Dashboard controls: 15px
├─ Pipeline stages: 15-30px
└─ Sidebar items: 12px
```

---

This visual reference matches your mockup exactly. All dimensions, colors, and interactions are documented above.
