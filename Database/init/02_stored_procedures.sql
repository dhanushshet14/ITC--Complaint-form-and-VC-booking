-- ============================================================
-- ITC Complaint Management System - Stored Procedures
-- ============================================================
USE [EnterpriseHRDB]
GO

-- ============================================================
-- AUTHENTICATION
-- ============================================================

-- usp_UserLogin: Validate credentials and return session data
-- Supports LDAP (validated externally) and CUST (BCrypt hash compare in app)
-- This SP handles user lookup and unit permissions
-- ============================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_UserLogin')
    DROP PROCEDURE [dbo].[usp_UserLogin]
GO

CREATE PROCEDURE [dbo].[usp_UserLogin]
    @Username   VARCHAR(100),
    @LoginType  VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @EmpCode VARCHAR(20)
    DECLARE @FullName NVARCHAR(200)
    DECLARE @Role VARCHAR(20)
    DECLARE @UserStatus VARCHAR(20)
    DECLARE @PasswordHash VARCHAR(200)
    DECLARE @FailedAttempts INT
    DECLARE @StoredLoginType VARCHAR(20)

    SELECT
        @EmpCode = EmpCode,
        @FullName = FullName,
        @Role = Role,
        @UserStatus = Status,
        @PasswordHash = [Password],
        @FailedAttempts = FailedAttempts,
        @StoredLoginType = LoginType
    FROM [dbo].[User_Master]
    WHERE Username = @Username

    IF @EmpCode IS NULL
    BEGIN
        SELECT
            CAST(0 AS BIT) AS Success,
            'Invalid username or password' AS Message,
            CAST(NULL AS VARCHAR(20)) AS EmpCode,
            CAST(NULL AS NVARCHAR(200)) AS FullName,
            CAST(NULL AS VARCHAR(20)) AS Role,
            CAST(NULL AS VARCHAR(20)) AS LoginType,
            CAST(NULL AS VARCHAR(MAX)) AS UnitIds,
            CAST(NULL AS VARCHAR(20)) AS [Status]
        RETURN
    END

    IF @UserStatus = 'Locked'
    BEGIN
        SELECT
            CAST(0 AS BIT) AS Success,
            'Your account is locked. Contact IT Administrator.' AS Message,
            CAST(NULL AS VARCHAR(20)) AS EmpCode,
            CAST(NULL AS NVARCHAR(200)) AS FullName,
            CAST(NULL AS VARCHAR(20)) AS Role,
            CAST(NULL AS VARCHAR(20)) AS LoginType,
            CAST(NULL AS VARCHAR(MAX)) AS UnitIds,
            CAST(NULL AS VARCHAR(20)) AS [Status]
        RETURN
    END

    IF @UserStatus = 'Inactive'
    BEGIN
        SELECT
            CAST(0 AS BIT) AS Success,
            'Your account is inactive. Contact IT Administrator.' AS Message,
            CAST(NULL AS VARCHAR(20)) AS EmpCode,
            CAST(NULL AS NVARCHAR(200)) AS FullName,
            CAST(NULL AS VARCHAR(20)) AS Role,
            CAST(NULL AS VARCHAR(20)) AS LoginType,
            CAST(NULL AS VARCHAR(MAX)) AS UnitIds,
            CAST(NULL AS VARCHAR(20)) AS [Status]
        RETURN
    END

    -- Return success with user data (password validation done in app layer)
    SELECT
        CAST(1 AS BIT) AS Success,
        'Login successful' AS Message,
        @EmpCode AS EmpCode,
        @FullName AS FullName,
        @Role AS Role,
        @StoredLoginType AS LoginType,
        CASE
            WHEN @Role IN ('Admin', 'SOC') THEN NULL -- All units
            ELSE (
                SELECT STRING_AGG(CAST(UnitId AS VARCHAR(10)), ',')
                FROM [dbo].[User_Unit_Permission]
                WHERE EmpCode = @EmpCode
            )
        END AS UnitIds,
        @UserStatus AS [Status]
END
GO

-- ============================================================
-- DROPDOWN / MASTER DATA RETRIEVAL
-- ============================================================

-- usp_GetComplaintTypes: Returns active complaint types
-- ============================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_GetComplaintTypes')
    DROP PROCEDURE [dbo].[usp_GetComplaintTypes]
GO

CREATE PROCEDURE [dbo].[usp_GetComplaintTypes]
AS
BEGIN
    SET NOCOUNT ON
    SELECT ComplaintTypeId, ComplaintTypeName, ComplaintTypeAlias
    FROM [dbo].[ComplaintType_Master]
    WHERE Status = 'Active'
    ORDER BY ComplaintTypeName
END
GO

-- usp_GetUnits: Returns units accessible to calling user
-- ============================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_GetUnits')
    DROP PROCEDURE [dbo].[usp_GetUnits]
GO

CREATE PROCEDURE [dbo].[usp_GetUnits]
    @EmpCode   VARCHAR(20),
    @Role      VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON

    IF @Role IN ('Admin', 'SOC')
    BEGIN
        SELECT UnitId, UnitName, UnitAlias
        FROM [dbo].[Unit_Master]
        WHERE Status = 'Active'
        ORDER BY UnitName
    END
    ELSE
    BEGIN
        SELECT u.UnitId, u.UnitName, u.UnitAlias
        FROM [dbo].[Unit_Master] u
        INNER JOIN [dbo].[User_Unit_Permission] p ON u.UnitId = p.UnitId
        WHERE p.EmpCode = @EmpCode
          AND u.Status = 'Active'
        ORDER BY u.UnitName
    END
END
GO

-- usp_GetCategoriesByType: Returns active categories for a request type
-- ============================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_GetCategoriesByType')
    DROP PROCEDURE [dbo].[usp_GetCategoriesByType]
GO

CREATE PROCEDURE [dbo].[usp_GetCategoriesByType]
    @RequestType VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON
    SELECT CategoryId, CategoryName, CategoryAlias
    FROM [dbo].[Category_Master]
    WHERE RequestType = @RequestType
      AND Status = 'Active'
    ORDER BY CategoryName
END
GO

-- usp_GetSubCategoriesByCategory: Returns subcategories for a category
-- ============================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_GetSubCategoriesByCategory')
    DROP PROCEDURE [dbo].[usp_GetSubCategoriesByCategory]
GO

CREATE PROCEDURE [dbo].[usp_GetSubCategoriesByCategory]
    @CategoryId INT
AS
BEGIN
    SET NOCOUNT ON
    SELECT SubCategoryId, SubCategoryName, SubCategoryAlias
    FROM [dbo].[Sub_Category_Master]
    WHERE CategoryId = @CategoryId
      AND Status = 'Active'
    ORDER BY SubCategoryName
END
GO

-- usp_GetPriorityByCategory: Returns suggested priority
-- ============================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_GetPriorityByCategory')
    DROP PROCEDURE [dbo].[usp_GetPriorityByCategory]
GO

CREATE PROCEDURE [dbo].[usp_GetPriorityByCategory]
    @CategoryId     INT,
    @SubCategoryId  INT = NULL
AS
BEGIN
    SET NOCOUNT ON

    SELECT TOP 1 Priority
    FROM [dbo].[Priority_Category_Linking]
    WHERE CategoryId = @CategoryId
      AND (SubCategoryId = @SubCategoryId OR SubCategoryId IS NULL)
    ORDER BY
        CASE WHEN SubCategoryId = @SubCategoryId THEN 0 ELSE 1 END
END
GO

-- usp_GetEngineers: Returns active engineers for assign dropdown
-- ============================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_GetEngineers')
    DROP PROCEDURE [dbo].[usp_GetEngineers]
GO

CREATE PROCEDURE [dbo].[usp_GetEngineers]
AS
BEGIN
    SET NOCOUNT ON
    SELECT EmpCode, FullName
    FROM [dbo].[User_Master]
    WHERE Role = 'Engineer'
      AND Status = 'Active'
    ORDER BY FullName
END
GO

-- ============================================================
-- COMPLAINT CREATION
-- ============================================================

-- usp_GenerateComplaintId: Generates complaint ID
-- Format: PREFIX-YYYYMMDD-SEQUENCE (e.g., INC-20260508-0001)
-- ============================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_GenerateComplaintId')
    DROP PROCEDURE [dbo].[usp_GenerateComplaintId]
GO

CREATE PROCEDURE [dbo].[usp_GenerateComplaintId]
    @RequestType NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @Today DATE = CAST(GETDATE() AS DATE)
    DECLARE @Prefix VARCHAR(3) = CASE WHEN @RequestType = 'INC' THEN 'INC' ELSE 'SRV' END
    DECLARE @DateStr VARCHAR(8) = FORMAT(GETDATE(), 'yyyyMMdd')
    DECLARE @NewNumber INT
    DECLARE @ComplaintId VARCHAR(20)

    BEGIN TRANSACTION

        -- Update or insert daily sequence
        MERGE [dbo].[Complaint_Sequence] AS target
        USING (SELECT @Today AS SequenceDate, @RequestType AS RequestType) AS source
        ON target.SequenceDate = source.SequenceDate AND target.RequestType = source.RequestType
        WHEN MATCHED THEN
            UPDATE SET LastNumber = LastNumber + 1
        WHEN NOT MATCHED THEN
            INSERT (SequenceDate, RequestType, LastNumber) VALUES (@Today, @RequestType, 1);

        SELECT @NewNumber = LastNumber
        FROM [dbo].[Complaint_Sequence]
        WHERE SequenceDate = @Today AND RequestType = @RequestType

    COMMIT TRANSACTION

    SET @ComplaintId = @Prefix + '-' + @DateStr + '-' + RIGHT('0000' + CAST(@NewNumber AS VARCHAR(4)), 4)

    SELECT @ComplaintId AS ComplaintId
END
GO

-- usp_CreateComplaint: Creates a new complaint
-- ============================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_CreateComplaint')
    DROP PROCEDURE [dbo].[usp_CreateComplaint]
GO

CREATE PROCEDURE [dbo].[usp_CreateComplaint]
    @CreatedBy          VARCHAR(20),
    @Title              VARCHAR(200),
    @Priority           VARCHAR(20),
    @ComplaintTypeId    INT,
    @UnitId             INT,
    @CategoryId         INT,
    @SubCategoryId      INT = NULL,
    @Description        NVARCHAR(1000),
    @CustomerImpactFlag INT = 0,
    @CustomerName       NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @ComplaintId VARCHAR(20)
    DECLARE @RequestType NVARCHAR(20)

    -- Get the RequestType alias from ComplaintType
    SELECT @RequestType = ComplaintTypeAlias
    FROM [dbo].[ComplaintType_Master]
    WHERE ComplaintTypeId = @ComplaintTypeId

    IF @RequestType IS NULL
    BEGIN
        RAISERROR('Invalid ComplaintTypeId', 16, 1)
        RETURN
    END

    -- Validate required fields
    IF LEN(@Title) < 10
    BEGIN
        RAISERROR('Title must be at least 10 characters', 16, 1)
        RETURN
    END

    IF LEN(@Description) < 20
    BEGIN
        RAISERROR('Description must be at least 20 characters', 16, 1)
        RETURN
    END

    BEGIN TRANSACTION

        -- Generate Complaint ID
        DECLARE @IdTable TABLE (ComplaintId VARCHAR(20))
        INSERT INTO @IdTable
        EXEC [dbo].[usp_GenerateComplaintId] @RequestType

        SELECT @ComplaintId = ComplaintId FROM @IdTable

        -- Insert into Complaint_Header
        INSERT INTO [dbo].[Complaint_Header] (
            ComplaintId, CreatedBy, CreatedDate, Title, Priority,
            ComplaintTypeId, UnitId, RequestType, CategoryId, SubCategoryId,
            Description, CustomerImpactFlag, CustomerName, Status, LastUpdate, LastUpdateBy
        ) VALUES (
            @ComplaintId, @CreatedBy, GETDATE(), @Title, @Priority,
            @ComplaintTypeId, @UnitId, @RequestType, @CategoryId, @SubCategoryId,
            @Description, @CustomerImpactFlag, @CustomerName, 'New', GETDATE(), @CreatedBy
        )

        -- Insert initial audit trail entry
        INSERT INTO [dbo].[Complaint_Updates] (
            ComplaintId, UpdateType, UpdateBy, UpdateDate, Description
        ) VALUES (
            @ComplaintId, 'New', @CreatedBy, GETDATE(),
            'Complaint created with Status: New'
        )

    COMMIT TRANSACTION

    -- Return the new complaint
    SELECT
        @ComplaintId AS ComplaintId,
        'New' AS [Status],
        GETDATE() AS CreatedDate
END
GO

-- ============================================================
-- COMPLAINT STATUS UPDATES
-- ============================================================

-- usp_AssignComplaint: Assign complaint to engineer
-- ============================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_AssignComplaint')
    DROP PROCEDURE [dbo].[usp_AssignComplaint]
GO

CREATE PROCEDURE [dbo].[usp_AssignComplaint]
    @ComplaintId    VARCHAR(20),
    @AssignedTo     VARCHAR(20),
    @AssignedBy     VARCHAR(20),
    @AssignType     VARCHAR(20),
    @Note           NVARCHAR(1000) = NULL
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @CurrentStatus VARCHAR(20)
    DECLARE @Description NVARCHAR(1000)

    SELECT @CurrentStatus = [Status]
    FROM [dbo].[Complaint_Header]
    WHERE ComplaintId = @ComplaintId

    IF @CurrentStatus IS NULL
    BEGIN
        RAISERROR('Complaint not found', 16, 1)
        RETURN
    END

    IF @CurrentStatus IN ('Closed')
    BEGIN
        RAISERROR('Cannot assign a closed complaint', 16, 1)
        RETURN
    END

    SET @Description = CASE @AssignType
        WHEN 'SELF-ASSIGN' THEN 'Engineer self-assigned'
        WHEN 'TRANSFER' THEN 'Transferred to new engineer'
        ELSE 'Assigned to engineer'
    END

    IF @Note IS NOT NULL AND @Note != ''
        SET @Description = @Description + ': ' + @Note

    BEGIN TRANSACTION

        UPDATE [dbo].[Complaint_Header]
        SET AssignedTo = @AssignedTo,
            AssignedDate = GETDATE(),
            AssignmentType = @AssignType,
            [Status] = 'Assigned',
            LastUpdate = GETDATE(),
            LastUpdateBy = @AssignedBy
        WHERE ComplaintId = @ComplaintId

        INSERT INTO [dbo].[Complaint_Updates] (
            ComplaintId, UpdateType, UpdateBy, UpdateDate,
            AssignType, AssignedTo, Description
        ) VALUES (
            @ComplaintId, 'Assign', @AssignedBy, GETDATE(),
            @AssignType, @AssignedTo, @Description
        )

    COMMIT TRANSACTION

    SELECT CAST(1 AS BIT) AS Success, 'Complaint assigned successfully' AS Message
END
GO

-- usp_TransferComplaint: Transfer complaint to another engineer/team
-- ============================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_TransferComplaint')
    DROP PROCEDURE [dbo].[usp_TransferComplaint]
GO

CREATE PROCEDURE [dbo].[usp_TransferComplaint]
    @ComplaintId  VARCHAR(20),
    @TransferTo   VARCHAR(20),
    @TransferBy   VARCHAR(20),
    @Reason       NVARCHAR(1000)
AS
BEGIN
    SET NOCOUNT ON

    IF @Reason IS NULL OR LEN(@Reason) = 0
    BEGIN
        RAISERROR('Transfer reason is required', 16, 1)
        RETURN
    END

    EXEC [dbo].[usp_AssignComplaint]
        @ComplaintId = @ComplaintId,
        @AssignedTo = @TransferTo,
        @AssignedBy = @TransferBy,
        @AssignType = 'TRANSFER',
        @Note = @Reason
END
GO

-- usp_AcceptComplaint: Engineer accepts assignment
-- ============================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_AcceptComplaint')
    DROP PROCEDURE [dbo].[usp_AcceptComplaint]
GO

CREATE PROCEDURE [dbo].[usp_AcceptComplaint]
    @ComplaintId  VARCHAR(20),
    @AcceptedBy   VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @CurrentStatus VARCHAR(20)

    SELECT @CurrentStatus = [Status]
    FROM [dbo].[Complaint_Header]
    WHERE ComplaintId = @ComplaintId
      AND AssignedTo = @AcceptedBy

    IF @CurrentStatus IS NULL
    BEGIN
        RAISERROR('Complaint not found or not assigned to you', 16, 1)
        RETURN
    END

    IF @CurrentStatus != 'Assigned'
    BEGIN
        RAISERROR('Complaint must be in Assigned status to accept', 16, 1)
        RETURN
    END

    INSERT INTO [dbo].[Complaint_Updates] (
        ComplaintId, UpdateType, UpdateBy, UpdateDate, Description
    ) VALUES (
        @ComplaintId, 'Update', @AcceptedBy, GETDATE(),
        'Accepted'
    )

    SELECT CAST(1 AS BIT) AS Success, 'Complaint accepted successfully' AS Message
END
GO

-- usp_MarkInProgress: Engineer marks complaint as In Progress
-- ============================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_MarkInProgress')
    DROP PROCEDURE [dbo].[usp_MarkInProgress]
GO

CREATE PROCEDURE [dbo].[usp_MarkInProgress]
    @ComplaintId  VARCHAR(20),
    @UpdatedBy    VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON

    UPDATE [dbo].[Complaint_Header]
    SET [Status] = 'In Progress',
        LastUpdate = GETDATE(),
        LastUpdateBy = @UpdatedBy
    WHERE ComplaintId = @ComplaintId

    INSERT INTO [dbo].[Complaint_Updates] (
        ComplaintId, UpdateType, UpdateBy, UpdateDate, Description
    ) VALUES (
        @ComplaintId, 'Update', @UpdatedBy, GETDATE(),
        'In Progress'
    )

    SELECT CAST(1 AS BIT) AS Success, 'Complaint marked as In Progress' AS Message
END
GO

-- usp_ResolveComplaint: Mark complaint as resolved
-- ============================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_ResolveComplaint')
    DROP PROCEDURE [dbo].[usp_ResolveComplaint]
GO

CREATE PROCEDURE [dbo].[usp_ResolveComplaint]
    @ComplaintId       VARCHAR(20),
    @ResolvedBy        VARCHAR(20),
    @ResolutionSummary NVARCHAR(1000)
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @CurrentStatus VARCHAR(20)

    SELECT @CurrentStatus = [Status]
    FROM [dbo].[Complaint_Header]
    WHERE ComplaintId = @ComplaintId

    IF @CurrentStatus IS NULL
    BEGIN
        RAISERROR('Complaint not found', 16, 1)
        RETURN
    END

    IF @CurrentStatus = 'Closed'
    BEGIN
        RAISERROR('Cannot resolve a closed complaint', 16, 1)
        RETURN
    END

    IF LEN(@ResolutionSummary) < 20
    BEGIN
        RAISERROR('Resolution summary must be at least 20 characters', 16, 1)
        RETURN
    END

    BEGIN TRANSACTION

        UPDATE [dbo].[Complaint_Header]
        SET [Status] = 'Resolved',
            ResolutionSummary = @ResolutionSummary,
            LastUpdate = GETDATE(),
            LastUpdateBy = @ResolvedBy
        WHERE ComplaintId = @ComplaintId

        INSERT INTO [dbo].[Complaint_Updates] (
            ComplaintId, UpdateType, UpdateBy, UpdateDate, Description
        ) VALUES (
            @ComplaintId, 'Resolve', @ResolvedBy, GETDATE(),
            @ResolutionSummary
        )

    COMMIT TRANSACTION

    SELECT CAST(1 AS BIT) AS Success, 'Complaint resolved successfully' AS Message
END
GO

-- usp_CloseComplaint: Close a resolved complaint
-- ============================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_CloseComplaint')
    DROP PROCEDURE [dbo].[usp_CloseComplaint]
GO

CREATE PROCEDURE [dbo].[usp_CloseComplaint]
    @ComplaintId  VARCHAR(20),
    @ClosedBy     VARCHAR(20),
    @Reason       NVARCHAR(1000)
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @CurrentStatus VARCHAR(20)

    SELECT @CurrentStatus = [Status]
    FROM [dbo].[Complaint_Header]
    WHERE ComplaintId = @ComplaintId

    IF @CurrentStatus IS NULL
    BEGIN
        RAISERROR('Complaint not found', 16, 1)
        RETURN
    END

    IF @CurrentStatus NOT IN ('Resolved')
    BEGIN
        RAISERROR('Only resolved complaints can be closed', 16, 1)
        RETURN
    END

    BEGIN TRANSACTION

        UPDATE [dbo].[Complaint_Header]
        SET [Status] = 'Closed',
            ClosureReason = @Reason,
            LastUpdate = GETDATE(),
            LastUpdateBy = @ClosedBy
        WHERE ComplaintId = @ComplaintId

        INSERT INTO [dbo].[Complaint_Updates] (
            ComplaintId, UpdateType, UpdateBy, UpdateDate, Description
        ) VALUES (
            @ComplaintId, 'Close', @ClosedBy, GETDATE(),
            @Reason
        )

    COMMIT TRANSACTION

    SELECT CAST(1 AS BIT) AS Success, 'Complaint closed successfully' AS Message
END
GO

-- usp_ReopenComplaint: Reopen a resolved or closed complaint
-- ============================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_ReopenComplaint')
    DROP PROCEDURE [dbo].[usp_ReopenComplaint]
GO

CREATE PROCEDURE [dbo].[usp_ReopenComplaint]
    @ComplaintId  VARCHAR(20),
    @ReopenedBy   VARCHAR(20),
    @Reason       NVARCHAR(1000)
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @CurrentStatus VARCHAR(20)

    SELECT @CurrentStatus = [Status]
    FROM [dbo].[Complaint_Header]
    WHERE ComplaintId = @ComplaintId

    IF @CurrentStatus IS NULL
    BEGIN
        RAISERROR('Complaint not found', 16, 1)
        RETURN
    END

    IF @CurrentStatus NOT IN ('Resolved', 'Closed')
    BEGIN
        RAISERROR('Only resolved or closed complaints can be reopened', 16, 1)
        RETURN
    END

    BEGIN TRANSACTION

        UPDATE [dbo].[Complaint_Header]
        SET [Status] = 'Reopened',
            LastUpdate = GETDATE(),
            LastUpdateBy = @ReopenedBy
        WHERE ComplaintId = @ComplaintId

        INSERT INTO [dbo].[Complaint_Updates] (
            ComplaintId, UpdateType, UpdateBy, UpdateDate, Description
        ) VALUES (
            @ComplaintId, 'Reopen', @ReopenedBy, GETDATE(),
            @Reason
        )

    COMMIT TRANSACTION

    SELECT CAST(1 AS BIT) AS Success, 'Complaint reopened successfully' AS Message
END
GO

-- ============================================================
-- HOLD / RESUME WORKFLOW
-- ============================================================

-- usp_HoldComplaint: Place complaint on hold
-- ============================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_HoldComplaint')
    DROP PROCEDURE [dbo].[usp_HoldComplaint]
GO

CREATE PROCEDURE [dbo].[usp_HoldComplaint]
    @ComplaintId  VARCHAR(20),
    @HoldReason   NVARCHAR(500),
    @HeldBy       VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON

    UPDATE [dbo].[Complaint_Header]
    SET [Status] = 'Hold',
        HoldReason = @HoldReason,
        LastUpdate = GETDATE(),
        LastUpdateBy = @HeldBy
    WHERE ComplaintId = @ComplaintId

    INSERT INTO [dbo].[Complaint_Updates] (
        ComplaintId, UpdateType, UpdateBy, UpdateDate, Description
    ) VALUES (
        @ComplaintId, 'Update', @HeldBy, GETDATE(),
        'Hold: ' + @HoldReason
    )

    SELECT CAST(1 AS BIT) AS Success, 'Complaint placed on hold' AS Message
END
GO

-- usp_ResumeComplaint: Resume complaint from hold (back to Assigned)
-- ============================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_ResumeComplaint')
    DROP PROCEDURE [dbo].[usp_ResumeComplaint]
GO

CREATE PROCEDURE [dbo].[usp_ResumeComplaint]
    @ComplaintId  VARCHAR(20),
    @ResumeNotes  NVARCHAR(500) = NULL,
    @ResumedBy    VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON

    UPDATE [dbo].[Complaint_Header]
    SET [Status] = 'Assigned',
        HoldReason = NULL,
        LastUpdate = GETDATE(),
        LastUpdateBy = @ResumedBy
    WHERE ComplaintId = @ComplaintId

    DECLARE @Desc NVARCHAR(1000) = 'Resumed from hold'
    IF @ResumeNotes IS NOT NULL AND @ResumeNotes != ''
        SET @Desc = @Desc + ': ' + @ResumeNotes

    INSERT INTO [dbo].[Complaint_Updates] (
        ComplaintId, UpdateType, UpdateBy, UpdateDate, Description
    ) VALUES (
        @ComplaintId, 'Update', @ResumedBy, GETDATE(), @Desc
    )

    SELECT CAST(1 AS BIT) AS Success, 'Complaint resumed from hold' AS Message
END
GO

-- ============================================================
-- WORK NOTES
-- ============================================================

-- usp_AddWorkNote: Add an internal work note / comment
-- ============================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_AddWorkNote')
    DROP PROCEDURE [dbo].[usp_AddWorkNote]
GO

CREATE PROCEDURE [dbo].[usp_AddWorkNote]
    @ComplaintId  VARCHAR(20),
    @AddedBy      VARCHAR(20),
    @NoteText     NVARCHAR(1000)
AS
BEGIN
    SET NOCOUNT ON

    IF @NoteText IS NULL OR LEN(@NoteText) = 0
    BEGIN
        RAISERROR('Note text cannot be empty', 16, 1)
        RETURN
    END

    INSERT INTO [dbo].[Complaint_Updates] (
        ComplaintId, UpdateType, UpdateBy, UpdateDate, Description
    ) VALUES (
        @ComplaintId, 'Update', @AddedBy, GETDATE(),
        @NoteText
    )

    SELECT CAST(1 AS BIT) AS Success, 'Work note added successfully' AS Message,
           SCOPE_IDENTITY() AS UpdateId
END
GO

-- ============================================================
-- COMPLAINT RETRIEVAL
-- ============================================================

-- usp_GetComplaints: Paginated, filtered complaint listing
-- ============================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_GetComplaints')
    DROP PROCEDURE [dbo].[usp_GetComplaints]
GO

CREATE PROCEDURE [dbo].[usp_GetComplaints]
    @EmpCode        VARCHAR(20),
    @Role           VARCHAR(20),
    @StatusFilter   VARCHAR(50) = NULL,
    @PriorityFilter VARCHAR(20) = NULL,
    @RequestType    VARCHAR(20) = NULL,
    @SearchQuery    NVARCHAR(200) = NULL,
    @PageNumber     INT = 1,
    @PageSize       INT = 20
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize

    DECLARE @Results TABLE (
        ComplaintId VARCHAR(20),
        Title VARCHAR(200),
        Priority VARCHAR(20),
        [Status] VARCHAR(20),
        RequestType NVARCHAR(20),
        UnitName NVARCHAR(100),
        CategoryName NVARCHAR(100),
        AssignedToName NVARCHAR(200),
        CreatedByName NVARCHAR(200),
        CreatedDate DATETIME,
        LastUpdate DATETIME,
        TotalCount INT
    )

    ;WITH FilteredComplaints AS (
        SELECT
            h.ComplaintId,
            h.Title,
            h.Priority,
            h.[Status],
            h.RequestType,
            u.UnitName,
            c.CategoryName,
            a.FullName AS AssignedToName,
            cr.FullName AS CreatedByName,
            h.CreatedDate,
            h.LastUpdate
        FROM [dbo].[Complaint_Header] h
        LEFT JOIN [dbo].[Unit_Master] u ON h.UnitId = u.UnitId
        LEFT JOIN [dbo].[Category_Master] c ON h.CategoryId = c.CategoryId
        LEFT JOIN [dbo].[User_Master] a ON h.AssignedTo = a.EmpCode
        LEFT JOIN [dbo].[User_Master] cr ON h.CreatedBy = cr.EmpCode
        WHERE
            -- Role-based filtering
            (
                @Role IN ('Admin', 'SOC')
                OR (@Role = 'Engineer' AND EXISTS (
                    SELECT 1 FROM [dbo].[User_Unit_Permission] p
                    WHERE p.EmpCode = @EmpCode AND p.UnitId = h.UnitId
                ))
                OR (@Role IN ('Employee', 'Guest') AND h.CreatedBy = @EmpCode)
                OR (@Role = 'Engineer' AND h.AssignedTo = @EmpCode)
            )
            -- Status filter (supports comma-separated values)
            AND (@StatusFilter IS NULL OR @StatusFilter = '' OR h.[Status] IN (SELECT TRIM(value) FROM STRING_SPLIT(@StatusFilter, ',')))
            -- Priority filter
            AND (@PriorityFilter IS NULL OR @PriorityFilter = '' OR h.Priority = @PriorityFilter)
            -- RequestType filter
            AND (@RequestType IS NULL OR @RequestType = '' OR h.RequestType = @RequestType)
            -- Search filter
            AND (
                @SearchQuery IS NULL OR @SearchQuery = ''
                OR h.ComplaintId LIKE '%' + @SearchQuery + '%'
                OR h.Title LIKE '%' + @SearchQuery + '%'
                OR h.Description LIKE '%' + @SearchQuery + '%'
            )
    )
    INSERT INTO @Results
    SELECT *,
        (SELECT COUNT(*) FROM FilteredComplaints) AS TotalCount
    FROM FilteredComplaints
    ORDER BY CreatedDate DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY

    SELECT * FROM @Results ORDER BY CreatedDate DESC
END
GO

-- usp_GetComplaintDetail: Full complaint detail with updates and attachments
-- ============================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_GetComplaintDetail')
    DROP PROCEDURE [dbo].[usp_GetComplaintDetail]
GO

CREATE PROCEDURE [dbo].[usp_GetComplaintDetail]
    @ComplaintId  VARCHAR(20),
    @EmpCode      VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON

    -- Complaint header with all joins
    SELECT
        h.ComplaintId,
        h.Title,
        h.Description,
        h.Priority,
        h.[Status],
        h.RequestType,
        h.CustomerImpactFlag,
        h.CustomerName,
        h.AssignmentType,
        h.HoldReason,
        h.ResolutionSummary,
        h.ClosureReason,
        h.CreatedDate,
        h.AssignedDate,
        h.LastUpdate,
        -- FK lookups
        ct.ComplaintTypeName,
        ct.ComplaintTypeAlias,
        u.UnitName,
        u.UnitAlias,
        c.CategoryName,
        sc.SubCategoryName,
        -- Users
        cr.FullName AS CreatedByName,
        cr.Role AS CreatedByRole,
        a.FullName AS AssignedToName,
        a.Role AS AssignedToRole
    FROM [dbo].[Complaint_Header] h
    LEFT JOIN [dbo].[ComplaintType_Master] ct ON h.ComplaintTypeId = ct.ComplaintTypeId
    LEFT JOIN [dbo].[Unit_Master] u ON h.UnitId = u.UnitId
    LEFT JOIN [dbo].[Category_Master] c ON h.CategoryId = c.CategoryId
    LEFT JOIN [dbo].[Sub_Category_Master] sc ON h.SubCategoryId = sc.SubCategoryId
    LEFT JOIN [dbo].[User_Master] cr ON h.CreatedBy = cr.EmpCode
    LEFT JOIN [dbo].[User_Master] a ON h.AssignedTo = a.EmpCode
    WHERE h.ComplaintId = @ComplaintId

    -- Full timeline (all updates)
    SELECT
        cu.UpdateId,
        cu.UpdateType,
        cu.UpdateBy,
        cu.UpdateDate,
        cu.AssignType,
        cu.AssignedTo,
        cu.Description,
        u.FullName AS UpdateByName,
        u.Role AS UpdateByRole
    FROM [dbo].[Complaint_Updates] cu
    LEFT JOIN [dbo].[User_Master] u ON cu.UpdateBy = u.EmpCode
    WHERE cu.ComplaintId = @ComplaintId
    ORDER BY cu.UpdateDate DESC

    -- Attachments
    SELECT
        ca.AttachmentId,
        ca.FileName,
        ca.FilePath,
        ca.FileSize,
        ca.MimeType,
        ca.UploadedDate,
        u.FullName AS UploadedByName
    FROM [dbo].[Complaint_Attachments] ca
    LEFT JOIN [dbo].[User_Master] u ON ca.UserId = u.EmpCode
    WHERE ca.ComplaintId = @ComplaintId
    ORDER BY ca.UploadedDate DESC
END
GO

-- usp_GetDashboardSummary: Returns summary counts for dashboard
-- ============================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_GetDashboardSummary')
    DROP PROCEDURE [dbo].[usp_GetDashboardSummary]
GO

CREATE PROCEDURE [dbo].[usp_GetDashboardSummary]
    @EmpCode  VARCHAR(20),
    @Role     VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @Total INT, @Open INT, @InProgress INT, @Resolved INT, @Closed INT, @SlaBreach INT

    SELECT
        @Total = COUNT(*),
        @Open = SUM(CASE WHEN [Status] IN ('New', 'Assigned', 'Reopened') THEN 1 ELSE 0 END),
        @InProgress = SUM(CASE WHEN [Status] = 'In Progress' THEN 1 ELSE 0 END),
        @Resolved = SUM(CASE WHEN [Status] = 'Resolved' THEN 1 ELSE 0 END),
        @Closed = SUM(CASE WHEN [Status] = 'Closed' THEN 1 ELSE 0 END),
        @SlaBreach = SUM(CASE
            WHEN [Status] IN ('New', 'Assigned', 'Reopened', 'In Progress')
            AND DATEDIFF(HOUR, CreatedDate, GETDATE()) >
                CASE Priority
                    WHEN 'Critical' THEN 4
                    WHEN 'High' THEN 8
                    WHEN 'Medium' THEN 24
                    WHEN 'Low' THEN 48
                    ELSE 24
                END
            THEN 1 ELSE 0
        END)
    FROM [dbo].[Complaint_Header] h
    WHERE
        (@Role IN ('Admin', 'SOC'))
        OR (@Role = 'Engineer' AND EXISTS (
            SELECT 1 FROM [dbo].[User_Unit_Permission] p
            WHERE p.EmpCode = @EmpCode AND p.UnitId = h.UnitId
        ))
        OR (@Role IN ('Employee', 'Guest') AND h.CreatedBy = @EmpCode)

    SELECT
        ISNULL(@Total, 0) AS TotalComplaints,
        ISNULL(@Open, 0) AS OpenComplaints,
        ISNULL(@InProgress, 0) AS InProgressComplaints,
        ISNULL(@Resolved, 0) AS ResolvedComplaints,
        ISNULL(@Closed, 0) AS ClosedComplaints,
        ISNULL(@SlaBreach, 0) AS SlaBreachCount
END
GO

-- usp_GetUserByEmpCode: Get user details
-- ============================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_GetUserByEmpCode')
    DROP PROCEDURE [dbo].[usp_GetUserByEmpCode]
GO

CREATE PROCEDURE [dbo].[usp_GetUserByEmpCode]
    @EmpCode VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON
    SELECT EmpCode, FullName, Username, LoginType, [Status], Role
    FROM [dbo].[User_Master]
    WHERE EmpCode = @EmpCode
END
GO

-- ============================================================
-- GUEST REGISTRATION
-- ============================================================

-- usp_RegisterGuest: Register a new external guest user
-- Inserts into both User_Master and GuestUser_Master
-- ============================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_RegisterGuest')
    DROP PROCEDURE [dbo].[usp_RegisterGuest]
GO

CREATE PROCEDURE [dbo].[usp_RegisterGuest]
    @FullName       VARCHAR(200),
    @Email          VARCHAR(200),
    @PasswordHash   VARCHAR(200),
    @Mobile         VARCHAR(50) = NULL,
    @Department     VARCHAR(100) = NULL,
    @Designation    VARCHAR(100) = NULL,
    @Location       VARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @EmpCode VARCHAR(50)
    DECLARE @Seq INT

    -- Check for duplicate email
    IF EXISTS (SELECT 1 FROM [dbo].[User_Master] WHERE Username = @Email)
    BEGIN
        SELECT CAST(0 AS BIT) AS Success, 'Email is already registered' AS Message, CAST(NULL AS VARCHAR(50)) AS EmpCode
        RETURN
    END

    -- Generate guest EmpCode: GUE-0001, GUE-0002, etc.
    SELECT @Seq = ISNULL(MAX(CAST(SUBSTRING(EmpCode, 5, LEN(EmpCode)) AS INT)), 0) + 1
    FROM [dbo].[User_Master]
    WHERE EmpCode LIKE 'GUE-%'

    SET @EmpCode = 'GUE-' + RIGHT('0000' + CAST(@Seq AS VARCHAR(4)), 4)

    BEGIN TRANSACTION

        INSERT INTO [dbo].[User_Master] (
            EmpCode, FullName, Username, [Password], Role, LoginType, [Status], CreatedBy, CreatedDate
        ) VALUES (
            @EmpCode, @FullName, @Email, @PasswordHash, 'Guest', 'CUST', 'Active', @EmpCode, GETDATE()
        )

        INSERT INTO [dbo].[GuestUser_Master] (
            GuestEmpCode, FullName, Email, Mobile, Department, Designation, Location, [Status], CreatedDate
        ) VALUES (
            @EmpCode, @FullName, @Email, @Mobile, @Department, @Designation, @Location, 'Active', GETDATE()
        )

    COMMIT TRANSACTION

    SELECT CAST(1 AS BIT) AS Success, 'Registration successful' AS Message, @EmpCode AS EmpCode
END
GO

-- ============================================================
-- usp_CheckSlaBreaches: Finds SLA-breached complaints and queues notifications
-- Thresholds: Critical=4h, High=8h, Medium=24h, Low=48h
-- ============================================================
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'usp_CheckSlaBreaches')
    DROP PROCEDURE [dbo].[usp_CheckSlaBreaches]
GO

CREATE PROCEDURE [dbo].[usp_CheckSlaBreaches]
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @SlaThresholds TABLE (
        Priority VARCHAR(20),
        Hours INT
    )
    INSERT INTO @SlaThresholds VALUES
        ('Critical', 4),
        ('High', 8),
        ('Medium', 24),
        ('Low', 48)

    INSERT INTO [dbo].[Notification_Queue] (
        ComplaintId, RecipientEmpCode, RecipientEmail, Subject, Body, Status, CreatedDate
    )
    SELECT
        h.ComplaintId,
        ISNULL(h.AssignedTo, h.CreatedBy) AS RecipientEmpCode,
        NULL AS RecipientEmail,
        'SLA BREACH: ' + h.ComplaintId + ' - ' + h.Priority + ' priority overdue',
        N'<strong>SLA Breach Notification</strong><br/><br/>'
        + N'Complaint <strong>' + h.ComplaintId + N'</strong> has breached its SLA.<br/>'
        + N'Title: ' + h.Title + N'<br/>'
        + N'Priority: ' + h.Priority + N' (SLA: ' + CAST(t.Hours AS VARCHAR(10)) + N' hours)<br/>'
        + N'Created: ' + FORMAT(h.CreatedDate, 'yyyy-MM-dd HH:mm') + N'<br/>'
        + N'Status: ' + h.[Status] + N'<br/>'
        + N'Please take immediate action.',
        'Pending',
        GETDATE()
    FROM [dbo].[Complaint_Header] h
    INNER JOIN @SlaThresholds t ON h.Priority = t.Priority
    WHERE h.[Status] NOT IN ('Closed', 'Resolved', 'Hold')
      AND DATEDIFF(HOUR, h.CreatedDate, GETDATE()) > t.Hours
      AND NOT EXISTS (
          SELECT 1 FROM [dbo].[Notification_Queue] n
          WHERE n.ComplaintId = h.ComplaintId
            AND n.Subject LIKE 'SLA BREACH:%'
      )

    SELECT @@ROWCOUNT AS BreachesNotified
END
GO

PRINT 'All stored procedures created successfully.'
GO
