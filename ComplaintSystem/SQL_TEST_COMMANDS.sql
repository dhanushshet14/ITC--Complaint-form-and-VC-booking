-- Quick SQL Commands for Testing
-- Copy/paste these in SQL Server Management Studio

-- ============================================================
-- TEST 1: Check if admin user exists and where
-- ============================================================
PRINT '=== STEP 1: Find Admin User ==='

-- Replace 'your_admin_empcode' with actual admin employee code (e.g., 'EMP001')
-- You can find this from your login records or User_Master table

DECLARE @AdminEmpCode NVARCHAR(50) = 'your_admin_empcode'

-- Check User_Master
SELECT 'User_Master' as TableName, * 
FROM User_Master 
WHERE UserCode = @AdminEmpCode OR EmpCode = @AdminEmpCode;

-- Check TBL_EmployeeDetails
SELECT 'TBL_EmployeeDetails' as TableName, * 
FROM TBL_EmployeeDetails 
WHERE EmpCode = @AdminEmpCode OR EmployeeCode = @AdminEmpCode;

-- Check guestUser_master
SELECT 'guestUser_master' as TableName, * 
FROM guestUser_master 
WHERE UserCode = @AdminEmpCode OR EmpCode = @AdminEmpCode;

-- ============================================================
-- TEST 2: Check what columns exist in TBL_EmployeeDetails
-- ============================================================
PRINT '=== STEP 2: Check EmployeeDetails Structure ==='

SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM information_schema.COLUMNS
WHERE TABLE_NAME = 'TBL_EmployeeDetails'
ORDER BY ORDINAL_POSITION;

-- ============================================================
-- TEST 3: Check Roles table
-- ============================================================
PRINT '=== STEP 3: Check Roles Data ==='

SELECT RoleId, RoleName, RoleDescription 
FROM dbo.Roles
ORDER BY RoleId;

-- ============================================================
-- TEST 4: Test sp_ValidateLoginUser directly
-- ============================================================
PRINT '=== STEP 4: Test sp_ValidateLoginUser SP ==='

DECLARE @EmpCode NVARCHAR(50) = 'your_admin_empcode'  -- CHANGE THIS
DECLARE @LoginUserType NVARCHAR(50);
DECLARE @RoleId INT;

EXEC sp_ValidateLoginUser 
    @EmpCode, 
    @LoginUserType OUTPUT, 
    @RoleId OUTPUT;

SELECT 
    @EmpCode AS EmployeeCode,
    @LoginUserType AS ReturningRole,
    @RoleId AS ReturningRoleId;

-- ============================================================
-- TEST 5: Verify stored procedures exist
-- ============================================================
PRINT '=== STEP 5: Check Stored Procedures ==='

SELECT OBJECT_NAME(OBJECT_ID) AS ProcedureName
FROM sys.objects
WHERE type = 'P' AND name IN ('sp_ValidateLoginUser', 'sp_GetTickets')
ORDER BY name;

-- ============================================================
-- TEST 6: View enums/all users for debugging
-- ============================================================
PRINT '=== STEP 6: Sample Users (for testing other roles) ==='

SELECT TOP 10 * FROM TBL_EmployeeDetails;

PRINT '=== END OF TESTS ==='
