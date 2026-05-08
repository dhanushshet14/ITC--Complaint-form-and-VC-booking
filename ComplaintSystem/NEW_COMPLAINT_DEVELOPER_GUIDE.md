# New Complaint Form - Developer Implementation Guide

## Implementation Details

### Architecture

The complaint form is implemented as a standalone ASP.NET Web Forms page that integrates with the existing ServiceCore application structure.

```
ComplaintSystem/
├── NewComplaint.aspx           (Front-end: HTML/CSS/JavaScript)
├── NewComplaint.aspx.cs        (Code-behind: C# server logic)
├── AllComplaints.aspx          (Updated with navigation link)
├── Auth/
│   └── AuthorizationHelper.cs  (Used for authentication)
└── Data/
    └── ComplaintDataService.cs (Can be used for backend)
```

### File Sizes & Structure

#### NewComplaint.aspx
- **Total Lines**: ~1150
- **CSS Embedded**: ~800 lines
- **HTML Content**: ~200 lines
- **JavaScript**: ~150 lines
- **Features**: Complete responsive design, no external CSS dependencies

#### NewComplaint.aspx.cs
- **Total Lines**: ~30
- **Functions**: Page_Load() with authentication check
- **Dependencies**: ComplaintSystem.Auth namespace

## Key Technologies Used

### Frontend
- **HTML5**: Semantic markup
- **CSS3**: 
  - CSS Grid for layout
  - Flexbox for components
  - CSS Variables (if implemented)
  - Media queries for responsiveness
  - Transitions and animations
- **JavaScript (ES6)**:
  - Arrow functions
  - Template literals
  - Event listeners
  - DOM manipulation

### Backend (C#)
- **ASP.NET Web Forms**
- **Page lifecycle**: Page_Load event
- **Authentication**: AuthorizationHelper.RequireAuthentication()

## Code Highlights

### C# Code-Behind

```csharp
public partial class NewComplaint : Page
{
    protected string complaintType = "Technical";

    protected void Page_Load(object sender, EventArgs e)
    {
        // Authentication check - redirects if not authenticated
        AuthorizationHelper.RequireAuthentication();

        // Get complaint type from query string
        string type = Request.QueryString["type"];
        if (!string.IsNullOrEmpty(type) && (type == "Technical" || type == "Telephone"))
        {
            complaintType = type;
        }
    }
}
```

### Key JavaScript Functions

#### 1. `updateSubcategories()`
- Triggered on category change
- Updates subcategory dropdown with available options
- Disables subcategory until category selected
- Updates progress percentage

#### 2. `handleImpactChange()`
- Triggered on customer impact radio button change
- Shows/hides impact reason section conditionally
- Clears impact reason if "No" selected
- Updates progress percentage

#### 3. `updateProgress()`
- Calculates form completion percentage
- Updates progress bar width
- Displays percentage text
- Triggered on any field change

#### 4. `handleFormSubmit(event)`
- Validates required fields
- Prevents empty form submission
- Prepares FormData object
- Ready for API integration

#### 5. `handleCancel()`
- Asks for user confirmation
- Navigates back to AllComplaints.aspx with complaint type

#### 6. File Upload Handlers
- `handleDrop()`: Drag-and-drop support
- `handleDragOver()`: Visual feedback on drag
- `handleDragLeave()`: Reset visual state
- `handleFileSelect()`: File validation

### Subcategory Mapping

```javascript
const subcategoriesMap = {
    'Hardware': ['Printer Issues', 'Monitor Issues', 'Keyboard/Mouse', 'Desktop PC', 'Laptop', 'Peripherals'],
    'Software': ['Email Client', 'Office Suite', 'Browser Issues', 'Antivirus', 'VPN', 'Custom Applications'],
    'Network': ['WiFi Connection', 'VPN Access', 'Internet Speed', 'Email Server', 'File Sharing', 'Remote Desktop'],
    'Database': ['Query Performance', 'Data Integrity', 'Backup Issues', 'Access Permissions', 'Connection Issues'],
    'Application': ['Login Issues', 'Performance', 'Features', 'Errors', 'Integration', 'Mobile App']
};
```

Easily extendable by adding more entries to this object.

## CSS Class Hierarchy

### Layout Classes
- `.dashboard-container`: Main flex container
- `.main-content`: Right content area with sidebar offset
- `.form-container`: Form wrapper with max-width and padding
- `.form-section`: Individual form section with spacing

### Form Field Classes
- `.form-row`: Grid layout for 1-2 column forms
- `.form-group`: Individual field wrapper
- `.form-label`: Field labels with required indicator
- `.form-control`: Input/select/textarea styles
- `.form-control:focus`: Focus state styling

### Component Classes
- `.priority-grid`: 4-column priority card grid
- `.priority-card`: Individual priority option
- `.radio-group`: Radio button container
- `.radio-option`: Individual radio button wrapper
- `.conditional-section`: Conditionally shown sections
- `.upload-area`: Drag-and-drop zone

### Utility Classes
- `.required::after`: Red asterisk indicator
- `.info-icon`: Help icon styling
- `.char-count`: Character limit display
- `.alert-message`: Warning/info messages
- `.progress-bar`: Form progress indicator

## Integration Points

### Navigation Link (AllComplaints.aspx)
```html
<button type="button" class="new-complaint-btn" onclick="goToNewComplaint()">
    <span>+</span>
    New Complaint
</button>

<script>
function goToNewComplaint() {
    window.location.href = 'NewComplaint.aspx?type=' + encodeURIComponent(currentComplaintType);
}
</script>
```

### Sidebar Links (AllComplaints.aspx & NewComplaint.aspx)
```html
<a href="NewComplaint.aspx?type=Technical">New Complaint</a>
<a href="NewComplaint.aspx?type=Telephone">New Complaint</a>
```

## Backend Integration Points (TODO)

### Form Submission Handler
Currently, form submission is handled by client-side validation and console logging. To implement backend:

```csharp
// In NewComplaint.aspx.cs
[WebMethod]
public static string SubmitComplaint(ComplaintModel model)
{
    try
    {
        // Validate input
        // Save to database
        // Send email notifications
        // Log activity
        return JsonConvert.SerializeObject(new { success = true, id = complaintId });
    }
    catch (Exception ex)
    {
        return JsonConvert.SerializeObject(new { success = false, error = ex.Message });
    }
}
```

### Complaint Model
```csharp
public class ComplaintModel
{
    public string Category { get; set; }
    public string Subcategory { get; set; }
    public string Priority { get; set; }
    public bool CustomerImpacted { get; set; }
    public string ImpactReason { get; set; }
    public string Description { get; set; }
    public string ComplaintType { get; set; }
    public DateTime CreatedDate { get; set; }
    public string CreatedBy { get; set; }
}
```

### Database Schema (Recommended)
```sql
CREATE TABLE Complaint_Header (
    ComplaintId INT PRIMARY KEY IDENTITY(1,1),
    Title NVARCHAR(255),
    Category NVARCHAR(100),
    Subcategory NVARCHAR(100),
    Priority NVARCHAR(20),
    Description NVARCHAR(MAX),
    Type NVARCHAR(50),
    Status NVARCHAR(50),
    CreatedBy NVARCHAR(50),
    CreatedDate DATETIME,
    CustomerImpacted BIT,
    ImpactReason NVARCHAR(500),
    AssignedTo NVARCHAR(50),
    UpdatedDate DATETIME
);

CREATE TABLE Complaint_Attachments (
    AttachmentId INT PRIMARY KEY IDENTITY(1,1),
    ComplaintId INT FOREIGN KEY REFERENCES Complaint_Header(ComplaintId),
    FileName NVARCHAR(255),
    FileType NVARCHAR(10),
    FilePath NVARCHAR(MAX),
    FileSize INT,
    UploadedDate DATETIME
);
```

## Validation Rules

### Client-Side Validation (JavaScript)
- Category: Must be selected
- Priority: Must be selected
- Description: Must have content
- Subcategory: Auto-required when category selected
- Customer Impact: Default "No", optional field
- Attachments: Optional

### Server-Side Validation (TODO)
- All required fields not empty
- File types: Only PNG, JPG, PDF, TXT, CSV, LOG
- File size: Max 10 MB per file
- Description: Max length validation
- Impact reason: Max 500 characters
- User authentication and authorization

## Error Handling

### Client-Side
```javascript
if (!category || !priority || !description) {
    alert('Please fill in all required fields');
    return;
}
```

### File Validation
```javascript
const allowedTypes = ['image/png', 'image/jpeg', 'application/pdf', 
                      'text/plain', 'text/csv', 'application/octet-stream'];
const maxSize = 10 * 1024 * 1024; // 10 MB
```

## Browser Support

- Chrome/Edge: Full support (ES6+)
- Firefox: Full support
- Safari: Full support (ES6+)
- IE11: Requires polyfills and transpilation

## Performance Considerations

### Optimizations Made
- Embedded CSS (no external file load)
- Inline JavaScript (no separate file load)
- CSS Grid for efficient layout
- Event delegation where applicable
- Minimal DOM manipulation

### Future Optimizations
- CSS minification
- JavaScript minification
- Asset bundling
- Lazy loading for heavy sections
- Service worker caching

## Security Considerations

### Current Implementation
- Authentication required before page load
- User validation via AuthorizationHelper
- HTML escaping in form placeholders

### Recommendations for Production
- Server-side input validation and sanitization
- CSRF token validation on form submission
- File upload validation on server
- SQL injection prevention (parameterized queries)
- XSS protection (output encoding)
- Rate limiting on form submissions
- File upload virus scanning
- Secure file storage outside web root

## Testing Checklist

- [ ] Form loads with correct complaint type
- [ ] Category/subcategory updates work correctly
- [ ] Priority selection highlights and shows checkmark
- [ ] Customer impact section shows/hides on toggle
- [ ] Character counter updates for impact reason
- [ ] Progress bar updates on field changes
- [ ] File upload accepts correct file types
- [ ] File upload rejects oversized files
- [ ] Form submission validates required fields
- [ ] Cancel button shows confirmation dialog
- [ ] Responsive design works on mobile (375px)
- [ ] Responsive design works on tablet (768px)
- [ ] Responsive design works on desktop (1200px+)
- [ ] Keyboard navigation works (Tab, Enter, Space)
- [ ] Authentication redirect works for unauthenticated users
- [ ] Sidebar navigation links work correctly

## Deployment Checklist

- [ ] Files added to project (.csproj updated)
- [ ] Build succeeds without errors or warnings
- [ ] Authentication configured correctly
- [ ] Database schema created (if backend implemented)
- [ ] Error logging configured
- [ ] File upload directory created and configured
- [ ] Virus scanning service configured (if applicable)
- [ ] Email notifications configured (if applicable)
- [ ] CSS and JS minified for production
- [ ] Testing completed on target browsers
- [ ] Cross-browser testing passed
- [ ] Performance testing completed
- [ ] Security audit completed
- [ ] User documentation updated

## Support & Maintenance

### Common Issues & Solutions

**Issue**: Subcategories not showing after category selection
- **Solution**: Check subcategoriesMap object for the selected category

**Issue**: Progress bar not updating
- **Solution**: Ensure updateProgress() is called on field changes

**Issue**: Form not submitting
- **Solution**: Check console for validation errors, verify all required fields filled

**Issue**: File upload not working
- **Solution**: Check file size and type, verify browser supports drag-drop

## Documentation Files

- `NEW_COMPLAINT_FORM_IMPLEMENTATION.md`: Feature overview
- `NEW_COMPLAINT_USER_GUIDE.md`: User-facing documentation
- `NEW_COMPLAINT_DEVELOPER_GUIDE.md`: This file - Developer reference
