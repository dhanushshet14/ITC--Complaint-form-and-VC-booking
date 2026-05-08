-- Complaint System Database Diagnostic Script
-- Run this in SQL Server Management Studio to diagnose role/permission issues

-- 1. Check for existing stored procedures
PRINT '=== CHECKING FOR STORED PROCEDURES ==='
SELECT 
    OBJECT_NAME(OBJECT_ID) AS ProcedureName,
    OBJECT_TYPE_DESC = 'PROCEDURE',
    CREATE_DATE,
    MODIFY_DATE
FROM sys.objects
WHERE type = 'P' AND name IN ('sp_ValidateLoginUser', 'SP_verifyLogin', 'sp_GetTickets', 'SP_getUserProfile')
ORDER BY name;

-- 2. Check for Roles table
PRINT '=== CHECKING FOR ROLES TABLE ==='
SELECT 
    TABLE_NAME,
    TABLE_SCHEMA
FROM information_schema.TABLES
WHERE TABLE_NAME = 'Roles';

-- If Roles table exists, show its structure and data
IF EXISTS (SELECT 1 FROM information_schema.TABLES WHERE TABLE_NAME = 'Roles')
BEGIN
    PRINT '--- Roles Table Structure ---'
    SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
    FROM information_schema.COLUMNS
    WHERE TABLE_NAME = 'Roles'
    ORDER BY ORDINAL_POSITION;

    PRINT '--- Roles Table Data ---'
    SELECT * FROM dbo.Roles;
END
ELSE
BEGIN
    PRINT 'WARNING: Roles table does not exist!'
END

-- 3. Check for User_Master table
PRINT '=== CHECKING FOR USER_MASTER TABLE ==='
SELECT 
    TABLE_NAME,
    TABLE_SCHEMA
FROM information_schema.TABLES
WHERE TABLE_NAME = 'User_Master';

IF EXISTS (SELECT 1 FROM information_schema.TABLES WHERE TABLE_NAME = 'User_Master')
BEGIN
    PRINT '--- User_Master Table Structure ---'
    SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
    FROM information_schema.COLUMNS
    WHERE TABLE_NAME = 'User_Master'
    ORDER BY ORDINAL_POSITION;

    PRINT '--- Sample User_Master Records (Admin Users) ---'
    SELECT TOP 5 * FROM dbo.User_Master;
END

-- 4. Check for TBL_EmployeeDetails table
PRINT '=== CHECKING FOR TBL_EMPLOYEEDETAILS TABLE ==='
SELECT 
    TABLE_NAME,
    TABLE_SCHEMA
FROM information_schema.TABLES
WHERE TABLE_NAME = 'TBL_EmployeeDetails';

IF EXISTS (SELECT 1 FROM information_schema.TABLES WHERE TABLE_NAME = 'TBL_EmployeeDetails')
BEGIN
    PRINT '--- TBL_EmployeeDetails Table Structure ---'
    SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
    FROM information_schema.COLUMNS
    WHERE TABLE_NAME = 'TBL_EmployeeDetails'
    ORDER BY ORDINAL_POSITION;

    PRINT '--- Sample TBL_EmployeeDetails Records ---'
    SELECT TOP 5 * FROM dbo.TBL_EmployeeDetails;
END

-- 5. Check for guestUser_master table
PRINT '=== CHECKING FOR GUESTUSER_MASTER TABLE ==='
SELECT 
    TABLE_NAME,
    TABLE_SCHEMA
FROM information_schema.TABLES
WHERE TABLE_NAME = 'guestUser_master';

IF EXISTS (SELECT 1 FROM information_schema.TABLES WHERE TABLE_NAME = 'guestUser_master')
BEGIN
    PRINT '--- guestUser_master Table Structure ---'
    SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
    FROM information_schema.COLUMNS
    WHERE TABLE_NAME = 'guestUser_master'
    ORDER BY ORDINAL_POSITION;
END

-- 6. Check for EngineerUnitPermissions table
PRINT '=== CHECKING FOR ENGINEERUNITPERMISSIONS TABLE ==='
SELECT 
    TABLE_NAME,
    TABLE_SCHEMA
FROM information_schema.TABLES
WHERE TABLE_NAME = 'EngineerUnitPermissions';

IF EXISTS (SELECT 1 FROM information_schema.TABLES WHERE TABLE_NAME = 'EngineerUnitPermissions')
BEGIN
    PRINT '--- EngineerUnitPermissions Table Structure ---'
    SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
    FROM information_schema.COLUMNS
    WHERE TABLE_NAME = 'EngineerUnitPermissions'
    ORDER BY ORDINAL_POSITION;
END

-- 7. Test SP_verifyLogin with a test user (replace with your test credentials)
PRINT '=== TESTING SP_VERIFYLOGIN ==='
-- NOTE: You need to replace these with your actual admin test credentials
-- DECLARE @Username NVARCHAR(100) = 'admin_username';
-- DECLARE @Password NVARCHAR(100) = 'admin_password';
-- EXEC SP_verifyLogin @Username, @Password;

PRINT 'Testing requires actual credentials. Please provide username/password.'

-- 8. Check Connection String in web.config
PRINT '=== CONNECTION STRING INFO (from database name only) ==='
SELECT 
    db_name() AS CurrentDatabase,
    SERVERPROPERTY('ServerName') AS ServerName,
    SERVERPROPERTY('Edition') AS Edition,
    SERVERPROPERTY('ProductVersion') AS Version;

PRINT '=== DIAGNOSTIC COMPLETE ==='
PRINT 'If you see warnings about missing tables, those need to be created.'
PRINT 'If sp_ValidateLoginUser does not exist, the application will use table-based role determination.'
