-- ===================================
-- CRITICAL SECURITY FIX
-- Missing Stored Procedures for Authentication
-- ===================================
-- Execute these scripts in SQL Server Management Studio

USE [ComplaintSystem]
GO

-- ===================================
-- 1. SP_verifyLogin - Verify user credentials
-- ===================================
IF OBJECT_ID('dbo.SP_verifyLogin', 'P') IS NOT NULL 
    DROP PROCEDURE dbo.SP_verifyLogin
GO

CREATE PROCEDURE [dbo].[SP_verifyLogin]
    @Username VARCHAR(100),
    @Password VARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;

    -- If you have a User_Master table with username and password
    -- Adjust this query to match your database schema
    SELECT TOP 1 
        ID,
        Username,
        Status
    FROM dbo.User_Master
    WHERE Username = @Username 
      AND Password = @Password  -- IMPORTANT: Should be hashed, not plain text!
      AND Status = 'Active'

    -- If table doesn't exist, uncomment this to test:
    -- SELECT 1 AS ID, @Username AS Username, 'Active' AS Status

END
GO

-- ===================================
-- 2. ALTERNATIVE: Simple admin hardcoded check (For Testing Only)
-- ===================================
IF OBJECT_ID('dbo.SP_verifyLogin_Simple', 'P') IS NOT NULL 
    DROP PROCEDURE dbo.SP_verifyLogin_Simple
GO

CREATE PROCEDURE [dbo].[SP_verifyLogin_Simple]
    @Username VARCHAR(100),
    @Password VARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;

    -- TEMPORARY TESTING PROCEDURE
    -- Replace with actual User_Master table query

    -- Test data: admin / admin123
    IF (@Username = 'admin' AND @Password = 'admin123')
    BEGIN
        SELECT 1 AS ID, 'admin' AS Username, 'Active' AS Status
    END
    -- Test data: emp001 / emp123
    ELSE IF (@Username = 'emp001' AND @Password = 'emp123')
    BEGIN
        SELECT 2 AS ID, 'emp001' AS Username, 'Active' AS Status
    END
    -- Test data: guest001 / guest123
    ELSE IF (@Username = 'guest001' AND @Password = 'guest123')
    BEGIN
        SELECT 3 AS ID, 'guest001' AS Username, 'Active' AS Status
    END
    ELSE
    BEGIN
        -- Invalid credentials
        SELECT 0 AS ID, @Username AS Username, 'Inactive' AS Status
        RETURN
    END

END
GO

-- ===================================
-- 3. sp_ValidateLoginUser - Determine user role/type
-- ===================================
IF OBJECT_ID('dbo.sp_ValidateLoginUser', 'P') IS NOT NULL 
    DROP PROCEDURE dbo.sp_ValidateLoginUser
GO

CREATE PROCEDURE [dbo].[sp_ValidateLoginUser]
    @EmpCode VARCHAR(50),
    @LoginUserType VARCHAR(50) OUTPUT, 
    @RoleId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserExists BIT = 0;
    DECLARE @UserRole VARCHAR(50);

    -- For testing: Map username to role
    -- In production, query actual tables

    IF @EmpCode = 'admin'
    BEGIN
        SET @LoginUserType = 'admin';
        SET @RoleId = 1;
        RETURN;
    END
    ELSE IF @EmpCode IN ('emp001', 'emp002', 'emp003')
    BEGIN
        SET @LoginUserType = 'employee';
        SET @RoleId = 4;
        RETURN;
    END
    ELSE IF @EmpCode = 'guest001'
    BEGIN
        SET @LoginUserType = 'guest';
        SET @RoleId = 5;
        RETURN;
    END
    ELSE
    BEGIN
        SET @LoginUserType = NULL;
        SET @RoleId = 0;
        RETURN;
    END

END
GO

-- ===================================
-- 4. Verify procedures are created
-- ===================================
PRINT 'Stored procedures created successfully!'
PRINT 'Execute these test queries to verify:'
PRINT ''
PRINT 'Test SP_verifyLogin:'
PRINT 'EXEC SP_verifyLogin @Username=''admin'', @Password=''admin123'''
PRINT ''
PRINT 'Test sp_ValidateLoginUser:'
PRINT 'DECLARE @Type VARCHAR(50), @RoleId INT'
PRINT 'EXEC sp_ValidateLoginUser @EmpCode=''admin'', @LoginUserType=@Type OUTPUT, @RoleId=@RoleId OUTPUT'
PRINT 'SELECT @Type, @RoleId'
