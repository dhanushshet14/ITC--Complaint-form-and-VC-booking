# 🧪 Testing Guide: Employee-Specific Dashboard Statistics

## Pre-Testing Setup

### Step 1: Prepare Your Environment
```
1. Open Visual Studio
2. Open Solution Explorer
3. Locate ComplaintSystem project
4. Right-click → Properties → Build
5. Verify Target Framework: 4.8.1
```

### Step 2: Clear Everything
```
1. Stop any running sessions (Shift+F5)
2. Close all browser tabs
3. Clear browser cache:
   - Chrome: Ctrl+Shift+Delete
   - Firefox: Ctrl+Shift+Delete  
   - Edge: Ctrl+Shift+Delete
4. Select "All time" and "All" and clear
```

### Step 3: Build Solution
```
1. Build → Build Solution (Ctrl+Shift+B)
2. Wait for "Build succeeded" message
3. Check Output window for errors
4. If errors exist, see Troubleshooting section below
```

---

## Testing Scenarios

### 🧪 TEST 1: Admin User Login

**Prerequisite Data Required:**
```sql
-- Ensure you have an Admin account
SELECT * FROM UserProfile WHERE RoleId = 1;

-- Ensure test complaints exist
SELECT COUNT(*) FROM Complaints;
```

**Test Steps:**
1. Start application (F5)
2. Login with Admin credentials
3. Verify you reach dashboard (HomePage.aspx)

**Expected Results:**
- ✅ Dashboard loads without errors
- ✅ Stat cards show numbers (not "-")
- ✅ Numbers match total complaints in system
- ✅ Pipeline shows all complaint statuses
- ✅ Recent complaints table populated

**Verification Checklist:**
```
Admin Dashboard Check:
☐ Page loads successfully
☐ Header shows "Dashboard"  
☐ 5 stat cards visible
☐ Stat values are numbers (not "-")
☐ Status Pipeline section shows counts
☐ Recent Complaints table has rows
☐ All emojis display correctly (not garbled)
☐ No red error messages in browser console (F12)
```

### 🧪 TEST 2: Employee User Login

**Prerequisite Data Required:**
```sql
-- Ensure you have an Employee account
SELECT * FROM UserProfile WHERE RoleId = 4;

-- Create test complaints for this employee
INSERT INTO Complaints (CreatedByEmpCode, Status, Priority, Type, Title, ...)
VALUES ('EMP003', 'InProgress', 'High', 'Technical', 'Test Complaint', ...);
```

**Test Steps:**
1. Logout from Admin account
2. Clear browser cache again
3. Reload application (F5)
4. Login with Employee credentials
5. Verify you reach dashboard

**Expected Results:**
- ✅ Dashboard loads without errors
- ✅ Stat cards show LOWER numbers than Admin
- ✅ Numbers match ONLY this employee's complaints
- ✅ Pipeline shows only their statuses
- ✅ Recent complaints show only their tickets

**Verification Checklist:**
```
Employee Dashboard Check:
☐ Page loads successfully
☐ Total Complaints < Admin's total
☐ Ongoing shows only their ongoing tickets
☐ Resolved shows only their resolved tickets
☐ Closed shows only their closed tickets
☐ Transferred shows only their transfers
☐ Table shows ONLY tickets for this employee
☐ Compare with Admin view - data should be different
```

**Data Validation:**
```sql
-- Verify by running these queries manually:

-- What Admin sees:
SELECT COUNT(*) AS Total FROM Complaints;
SELECT COUNT(*) AS Ongoing FROM Complaints WHERE Status = 'InProgress';

-- What Employee sees:
SELECT COUNT(*) AS Total FROM Complaints 
WHERE CreatedByEmpCode = 'EMP003' OR AssignedToEmpCode = 'EMP003';

SELECT COUNT(*) AS Ongoing FROM Complaints 
WHERE (CreatedByEmpCode = 'EMP003' OR AssignedToEmpCode = 'EMP003')
AND Status = 'InProgress';

-- Then compare the numbers on the dashboard!
```

### 🧪 TEST 3: SOC User Login

**Prerequisite Data Required:**
```sql
-- Ensure you have a SOC account (RoleId = 2)
SELECT * FROM UserProfile WHERE RoleId = 2;
```

**Test Steps:**
1. Logout from Employee account
2. Clear cache
3. Login with SOC credentials
4. Navigate to HomePage

**Expected Results:**
- ✅ SOC sees ALL complaints (like Admin)
- ✅ Numbers match total system complaints
- ✅ Pipeline shows all statuses with same totals as Admin
- ✅ Recent complaints shows complaints from all employees

**Comparison:**
```
Admin Dashboard     vs.     SOC Dashboard
───────────────────────────────────────────
📋 248             vs.     📋 248    ✓ SAME
⏳ 64              vs.     ⏳ 64     ✓ SAME
✅ 142             vs.     ✅ 142    ✓ SAME
🔒 35              vs.     🔒 35     ✓ SAME
↔️ 7               vs.     ↔️ 7      ✓ SAME
```

### 🧪 TEST 4: Engineer User Login

**Prerequisite Data Required:**
```sql
-- Ensure you have Engineer account (RoleId = 3)
SELECT * FROM UserProfile WHERE RoleId = 3;

-- Assign some complaints to this engineer
UPDATE Complaints SET AssignedToEmpCode = 'ENG002' 
WHERE ComplaintId IN (5, 6, 7);
```

**Test Steps:**
1. Logout
2. Clear cache
3. Login with Engineer credentials
4. Check dashboard

**Expected Results:**
- ✅ Engineer sees ONLY their assigned complaints
- ✅ Numbers less than Admin/SOC
- ✅ Statistics reflect their workload only
- ✅ Recent complaints shows only their assignments

### 🧪 TEST 5: Emoji Display Test

**Test Steps:**
1. Login with any role
2. Look at stat card icons
3. Verify each displays correctly:
   - 📋 (clipboard - total)
   - ⏳ (hourglass - ongoing)
   - ✅ (checkmark - resolved)
   - 🔒 (lock - closed)
   - ↔️ (arrows - transferred)

**Expected Results:**
- ✅ All emojis display as colorful icons
- ✅ NO garbled text like: δΥ"<, å□³, etc.
- ✅ Emojis same on all pages (header, sidebar, etc.)

**If Emojis Are Garbled:**
1. Hard refresh: Ctrl+F5
2. Clear cache: Ctrl+Shift+Delete
3. Close all tabs and reopen
4. Try different browser (Chrome, Firefox, Edge)
5. Check Web.config has UTF-8 settings

---

## Performance Tests

### 🚀 TEST 6: Page Load Time

**Measurement:**
1. Open Developer Tools (F12)
2. Go to Network tab
3. Reload page (F5)
4. Check "Load" time

**Expected Results:**
- ✅ Page loads in under 3 seconds
- ✅ Stat cards update within 1 second of page load
- ✅ Table loads within 2 seconds

### 📊 TEST 7: Real-Time Data Accuracy

**Test Steps:**
1. Login as Employee
2. Note current stat values
3. Open second browser window
4. As Admin, create a new complaint assigned to this employee
5. Return to Employee's window
6. Refresh page (F5)
7. Verify stat values updated

**Expected Results:**
- ✅ After refresh, new complaint appears in stats
- ✅ Total Complaints increased by 1
- ✅ Appropriate status category increased by 1

---

## Error Scenarios (Expected Failures)

### ❌ TEST 8: Access Without Authentication

**Test Steps:**
1. Without logging in, try to access: `HomePage.aspx`
2. Type URL directly in address bar

**Expected Result:**
- ✅ SHOULD redirect to Login.aspx
- ✅ SHOULD NOT allow viewing dashboard
- ✅ This is correct security behavior

### ❌ TEST 9: SQL Connection Error

**Test Steps:**
1. Disconnect from database
2. Try to login and access dashboard
3. Check for error messages

**Expected Result:**
- ✅ Error message or loading failure
- ✅ Check browser console for details
- ✅ Check IIS logs for SQL error

---

## Browser Console Testing

### 🔧 TEST 10: JavaScript Console Errors

**Test Steps:**
1. Login to dashboard
2. Press F12 to open Developer Tools
3. Click "Console" tab
4. Reload page (F5)
5. Check for red error messages

**Expected Results:**
- ✅ NO red errors
- ✅ May see blue info messages
- ✅ May see yellow warnings (okay)

**Common Errors and Fixes:**
```javascript
// Error: "Cannot read property 'textContent' of undefined"
// Fix: Wait for page to fully load

// Error: "Unexpected token" in script
// Fix: Check encoding of HomePage.aspx file

// Error: "SQL error"
// Fix: Check Web.config connection string
```

---

## Testing Checklist (Complete)

```
PRE-TESTING:
☐ Backed up Web.config
☐ Backed up HomePage.aspx files
☐ Database has test data
☐ Test user accounts exist for all roles
☐ IIS configured correctly

FUNCTIONALITY TESTING:
☐ Admin sees all complaints
☐ Employee sees only own complaints
☐ SOC sees all complaints
☐ Engineer sees assigned complaints
☐ Guest sees own complaints
☐ Stat cards show correct numbers
☐ Pipeline shows correct counts
☐ Recent complaints table populated
☐ Emojis display correctly
☐ No JavaScript errors

SECURITY TESTING:
☐ Cannot access without login
☐ Employees cannot see other's data
☐ Admins can see all data
☐ No SQL injection errors
☐ Session validation works
☐ Role checking enforced

PERFORMANCE TESTING:
☐ Page loads in < 3 seconds
☐ Stat cards update < 1 second
☐ Table loads < 2 seconds
☐ Real-time data accurate
☐ No memory leaks

BROWSER TESTING:
☐ Chrome (latest)
☐ Firefox (latest)
☐ Edge (latest)
☐ Safari (if Mac)
```

---

## Troubleshooting During Testing

### Problem: Stats Show "-"
```
Symptoms: Dashboard loads but stat cards show "-"
Cause: Page still loading or JavaScript not executed
Solution:
  1. Wait 3-5 seconds
  2. Reload page (F5)
  3. Check browser console for JS errors (F12)
  4. Hard refresh (Ctrl+F5)
```

### Problem: Stats Show 0
```
Symptoms: Stat cards show 0 for everything
Cause: No test data in database
Solution:
  1. Add test complaints to database
  2. INSERT sample data
  3. Reload page
  4. Verify with SQL query
```

### Problem: Emojis Garbled (δΥ"<)
```
Symptoms: Emoji shows as cryptic characters
Cause: Encoding issue
Solution:
  1. Hard refresh: Ctrl+F5
  2. Clear cache: Ctrl+Shift+Delete
  3. Check Web.config has UTF-8
  4. Check file encoding is UTF-8
  5. Try different browser
```

### Problem: SQL Connection Error
```
Symptoms: Dashboard shows error or loading fails
Cause: Database connection issue
Solution:
  1. Check connection string in Web.config
  2. Verify SQL Server is running
  3. Verify credentials are correct
  4. Check network connectivity
  5. Review IIS logs
```

### Problem: Role Not Recognized
```
Symptoms: Wrong data displayed for role
Cause: Session/role issue
Solution:
  1. Logout and login again
  2. Clear session cache
  3. Verify role in database
  4. Check AuthenticationHelper code
```

---

## Sign-Off

Once all tests pass, fill out this checklist:

```
Testing Complete on: _________________ (Date)
Tester Name: _______________________
Environment: _______________________ (Dev/Staging/Prod)

All Tests Passed:    ☐ YES  ☐ NO

Issues Found: ______________________

Recommendations: __________________

Sign-Off: __________________________
```

---

## Additional Notes

- Keep browser console open while testing to catch any JavaScript errors
- Test with realistic data amounts (hundreds of complaints)
- Have multiple tabs open as different users to compare data
- Document any differences from expectations
- Report all issues with screenshots/error messages

Good luck with testing! 🚀
