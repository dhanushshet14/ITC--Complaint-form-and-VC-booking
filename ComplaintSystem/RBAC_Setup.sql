-- Complaint System RBAC Setup Script
-- Run this script to create missing stored procedures and tables
-- This is a complete RBAC initialization script for .NET Framework 4.8.1 application

-- ============================================================================
-- 1. CREATE ROLES TABLE (if not exists)
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM information_schema.TABLES WHERE TABLE_NAME = 'Roles')
BEGIN
    CREATE TABLE dbo.Roles (
        RoleId INT PRIMARY KEY IDENTITY(1,1),
        RoleName NVARCHAR(50) NOT NULL UNIQUE,
        RoleDescription NVARCHAR(256),
        CreatedDate DATETIME DEFAULT GETDATE(),
        IsActive BIT DEFAULT 1
    );

    INSERT INTO dbo.Roles (RoleName, RoleDescription, IsActive) VALUES
    (1, 'admin', 'Administrator - Full system access', 1),
    (2, 'soc', 'Service Operations Center - Ticket management and assignment', 1),
    (3, 'engineer', 'Engineer - Ticket resolution and transfers', 1),
    (4, 'employee', 'Employee - Create and view own tickets', 1),
    (5, 'guest', 'Guest - Limited access', 1);

    PRINT 'Roles table created successfully.';
END
ELSE
BEGIN
    PRINT 'Roles table already exists. Skipping creation.';
    -- Verify data exists
    IF NOT EXISTS (SELECT 1 FROM dbo.Roles WHERE RoleName = 'admin')
    BEGIN
        INSERT INTO dbo.Roles (RoleName, RoleDescription, IsActive) VALUES
        ('admin', 'Administrator - Full system access', 1),
        ('soc', 'Service Operations Center - Ticket management and assignment', 1),
        ('engineer', 'Engineer - Ticket resolution and transfers', 1),
        ('employee', 'Employee - Create and view own tickets', 1),
        ('guest', 'Guest - Limited access', 1);
        PRINT 'Added missing role records.';
    END
END

-- ============================================================================
-- 2. CREATE ENGINEERUNITPERMISSIONS TABLE (if not exists)
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM information_schema.TABLES WHERE TABLE_NAME = 'EngineerUnitPermissions')
BEGIN
    CREATE TABLE dbo.EngineerUnitPermissions (
        PermissionId INT PRIMARY KEY IDENTITY(1,1),
        EmpCode NVARCHAR(50) NOT NULL,
        UnitId INT NOT NULL,
        PermissionType NVARCHAR(50),
        CreatedDate DATETIME DEFAULT GETDATE(),
        IsActive BIT DEFAULT 1,
        UNIQUE (EmpCode, UnitId)
    );

    PRINT 'EngineerUnitPermissions table created successfully.';
END
ELSE
BEGIN
    PRINT 'EngineerUnitPermissions table already exists. Skipping creation.';
END

-- ============================================================================
-- 3. CREATE sp_ValidateLoginUser STORED PROCEDURE
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND name = 'sp_ValidateLoginUser')
BEGIN
    EXEC sp_executesql N'
    CREATE PROCEDURE dbo.sp_ValidateLoginUser
        @EmpCode NVARCHAR(50),
        @LoginUserType NVARCHAR(50) OUTPUT,
        @RoleId INT OUTPUT
    AS
    BEGIN
        SET NOCOUNT ON;

        -- Default values
        SET @LoginUserType = NULL;
        SET @RoleId = 0;

        -- Try to find user and their role from user tables
        -- First check if user is in TBL_EmployeeDetails
        IF EXISTS (SELECT 1 FROM TBL_EmployeeDetails WHERE EmpCode = @EmpCode OR EmployeeCode = @EmpCode)
        BEGIN
            -- Check if there is a UserType or Role column
            IF EXISTS (SELECT 1 FROM information_schema.COLUMNS 
                      WHERE TABLE_NAME = ''TBL_EmployeeDetails'' AND COLUMN_NAME = ''UserType'')
            BEGIN
                SELECT TOP 1 
                    @LoginUserType = UserType,
                    @RoleId = ISNULL((SELECT RoleId FROM dbo.Roles WHERE RoleName = UserType), 4)
                FROM TBL_EmployeeDetails 
                WHERE EmpCode = @EmpCode OR EmployeeCode = @EmpCode;
            END
            ELSE IF EXISTS (SELECT 1 FROM information_schema.COLUMNS 
                           WHERE TABLE_NAME = ''TBL_EmployeeDetails'' AND COLUMN_NAME = ''Role'')
            BEGIN
                SELECT TOP 1 
                    @LoginUserType = Role,
                    @RoleId = ISNULL((SELECT RoleId FROM dbo.Roles WHERE RoleName = Role), 4)
                FROM TBL_EmployeeDetails 
                WHERE EmpCode = @EmpCode OR EmployeeCode = @EmpCode;
            END
            ELSE
            BEGIN
                -- Default to Employee role
                SET @LoginUserType = ''employee'';
                SET @RoleId = 4;
            END
        END
        -- Check if user is in User_Master (could be admin or other role)
        ELSE IF EXISTS (SELECT 1 FROM User_Master WHERE UserCode = @EmpCode OR EmpCode = @EmpCode)
        BEGIN
            -- If in User_Master without specific role marking, likely admin or Employee
            SET @LoginUserType = ''employee'';
            SET @RoleId = 4;
        END
        -- Check if user is a guest
        ELSE IF EXISTS (SELECT 1 FROM guestUser_master WHERE UserCode = @EmpCode OR EmpCode = @EmpCode)
        BEGIN
            SET @LoginUserType = ''guest'';
            SET @RoleId = 5;
        END
        ELSE
        BEGIN
            -- User not found - should not happen if SP_verifyLogin already validated
            SET @LoginUserType = NULL;
            SET @RoleId = 0;
        END
    END;
    ';
    PRINT 'Stored procedure sp_ValidateLoginUser created successfully.';
END
ELSE
BEGIN
    PRINT 'Stored procedure sp_ValidateLoginUser already exists. Skipping creation.';
    -- Optional: Drop and recreate to update logic
    -- PRINT 'To update this procedure, execute: DROP PROCEDURE sp_ValidateLoginUser; then run this script again.';
END

-- ============================================================================
-- 4. CREATE sp_GetTickets STORED PROCEDURE (for role-based filtering)
-- ============================================================================
IF NOT EXISTS (SELECT 1 FROM sys.objects WHERE type = 'P' AND name = 'sp_GetTickets')
BEGIN
    EXEC sp_executesql N'
    CREATE PROCEDURE dbo.sp_GetTickets
        @EmpCode NVARCHAR(50),
        @RoleId INT,
        @Status NVARCHAR(50) = NULL
    AS
    BEGIN
        SET NOCOUNT ON;

        -- Role-based ticket filtering
        -- 1 = Admin (all tickets)
        -- 2 = SOC (all tickets) 
        -- 3 = Engineer (assigned + unit tickets)
        -- 4,5 = Employee/Guest (own tickets only)

        IF @RoleId = 1 OR @RoleId = 2
        BEGIN
            -- Admin and SOC see all tickets
            SELECT *
            FROM Complaint_Header
            WHERE (@Status IS NULL OR Status = @Status)
            ORDER BY CreatedDate DESC;
        END
        ELSE IF @RoleId = 3
        BEGIN
            -- Engineer sees assigned tickets and tickets from their units
            SELECT DISTINCT ch.*
            FROM Complaint_Header ch
            LEFT JOIN EngineerUnitPermissions eup ON ch.UnitId = eup.UnitId
            WHERE (@Status IS NULL OR ch.Status = @Status)
            AND (ch.AssignedTo = @EmpCode OR eup.EmpCode = @EmpCode OR ch.CreatedBy = @EmpCode)
            ORDER BY ch.CreatedDate DESC;
        END
        ELSE
        BEGIN
            -- Employee and Guest see only their own tickets
            SELECT *
            FROM Complaint_Header
            WHERE CreatedBy = @EmpCode
            AND (@Status IS NULL OR Status = @Status)
            ORDER BY CreatedDate DESC;
        END
    END;
    ';
    PRINT 'Stored procedure sp_GetTickets created successfully.';
END
ELSE
BEGIN
    PRINT 'Stored procedure sp_GetTickets already exists. Skipping creation.';
END

-- ============================================================================
-- 5. VERIFY SETUP
-- ============================================================================
PRINT '=== RBAC SETUP VERIFICATION ==='
SELECT 'Roles Table' AS Component, COUNT(*) AS RecordCount FROM dbo.Roles
UNION ALL
SELECT 'EngineerUnitPermissions' AS Component, COUNT(*) AS RecordCount FROM dbo.EngineerUnitPermissions;

SELECT 
    OBJECT_NAME(OBJECT_ID) AS ProcedureName
FROM sys.objects
WHERE type = 'P' AND name IN ('sp_ValidateLoginUser', 'sp_GetTickets');

PRINT '=== SETUP COMPLETE ==='
PRINT 'All RBAC components have been created/verified.'
PRINT ''
PRINT 'Next Steps:'
PRINT '1. Verify TBL_EmployeeDetails has UserType or Role column'
PRINT '2. Ensure user records are assigned to correct roles'
PRINT '3. For Engineers: Add entries to EngineerUnitPermissions table'
PRINT '4. Test login with your admin user'
