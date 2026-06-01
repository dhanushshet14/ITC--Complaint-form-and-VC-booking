-- ============================================================
-- ITC Complaint Management System - Database Schema
-- Database: EnterpriseHRDB (existing DB used by current app)
-- ============================================================

-- Ensure we're in the right database
IF DB_ID('EnterpriseHRDB') IS NULL
BEGIN
    CREATE DATABASE [EnterpriseHRDB]
END
GO

USE [EnterpriseHRDB]
GO

-- ============================================================
-- 1. User_Master - All authenticated system users
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[User_Master]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[User_Master] (
        [UserId]      INT           IDENTITY(1,1) NOT NULL,
        [EmpCode]     VARCHAR(20)   NOT NULL,
        [FullName]    NVARCHAR(200) NOT NULL,
        [Username]    VARCHAR(100)  NOT NULL,
        [Password]    VARCHAR(200)  NULL,
        [LoginType]   VARCHAR(20)   NOT NULL DEFAULT 'LDAP',
        [Status]      VARCHAR(20)   NOT NULL DEFAULT 'Active',
        [Role]        VARCHAR(20)   NOT NULL DEFAULT 'Employee',
        [FailedAttempts] INT       NOT NULL DEFAULT 0,
        [LastLoginDate] DATETIME    NULL,
        [CreatedBy]   VARCHAR(20)   NOT NULL,
        [CreatedDate] DATETIME      NOT NULL DEFAULT GETDATE(),
        [UpdatedBy]   VARCHAR(20)   NULL,
        [UpdatedDate] DATETIME      NULL,
        CONSTRAINT [PK_User_Master] PRIMARY KEY CLUSTERED ([EmpCode]),
        CONSTRAINT [UQ_User_Master_Username] UNIQUE ([Username]),
        CONSTRAINT [UQ_User_Master_UserId] UNIQUE ([UserId]),
        CONSTRAINT [CK_User_Master_LoginType] CHECK ([LoginType] IN ('LDAP', 'CUST')),
        CONSTRAINT [CK_User_Master_Status] CHECK ([Status] IN ('Active', 'Inactive', 'Locked')),
        CONSTRAINT [CK_User_Master_Role] CHECK ([Role] IN ('Admin', 'SOC', 'Engineer', 'Employee', 'Guest'))
    )
END
GO

-- ============================================================
-- 2. GuestUser_Master - Temporary/external users
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GuestUser_Master]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[GuestUser_Master] (
        [GuestEmpCode]  VARCHAR(50)   NOT NULL,
        [FullName]      VARCHAR(200)  NOT NULL,
        [Email]         VARCHAR(200)  NOT NULL,
        [Mobile]        VARCHAR(50)   NULL,
        [UnitId]        INT           NULL,
        [Department]    VARCHAR(100)  NULL,
        [Designation]   VARCHAR(100)  NULL,
        [Location]      VARCHAR(100)  NULL,
        [Extension]     VARCHAR(20)   NULL,
        [Status]        VARCHAR(10)   NOT NULL DEFAULT 'Active',
        [CreatedDate]   DATETIME      NOT NULL DEFAULT GETDATE(),
        [DomainUsername] VARCHAR(100) NULL,
        CONSTRAINT [PK_GuestUser_Master] PRIMARY KEY CLUSTERED ([GuestEmpCode]),
        CONSTRAINT [UQ_GuestUser_Master_Email] UNIQUE ([Email])
    )
END
GO

-- ============================================================
-- 3. ComplaintType_Master - Incident / Service lookup
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ComplaintType_Master]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[ComplaintType_Master] (
        [ComplaintTypeId]   INT           IDENTITY(1,1) NOT NULL,
        [ComplaintTypeName] NVARCHAR(100) NOT NULL,
        [ComplaintTypeAlias] NVARCHAR(100) NOT NULL,
        [Status]            VARCHAR(20)   NOT NULL DEFAULT 'Active',
        [CreatedBy]         VARCHAR(20)   NOT NULL,
        [CreatedDate]       DATETIME      NOT NULL DEFAULT GETDATE(),
        [UpdatedBy]         VARCHAR(20)   NULL,
        [UpdatedDate]       DATETIME      NULL,
        CONSTRAINT [PK_ComplaintType_Master] PRIMARY KEY CLUSTERED ([ComplaintTypeId]),
        CONSTRAINT [UQ_ComplaintType_Master_Name] UNIQUE ([ComplaintTypeName])
    )
END
GO

-- ============================================================
-- 4. Unit_Master - Business units (22 units)
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Unit_Master]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Unit_Master] (
        [UnitId]      INT           IDENTITY(1,1) NOT NULL,
        [UnitName]    NVARCHAR(100) NOT NULL,
        [UnitAlias]   NVARCHAR(100) NOT NULL,
        [Status]      VARCHAR(20)   NOT NULL DEFAULT 'Active',
        [CreatedBy]   VARCHAR(20)   NOT NULL,
        [CreatedDate] DATETIME      NOT NULL DEFAULT GETDATE(),
        [UpdatedBy]   VARCHAR(20)   NULL,
        [UpdatedDate] DATETIME      NULL,
        CONSTRAINT [PK_Unit_Master] PRIMARY KEY CLUSTERED ([UnitId]),
        CONSTRAINT [UQ_Unit_Master_Name] UNIQUE ([UnitName])
    )
END
GO

-- ============================================================
-- 5. Category_Master - Categories linked to RequestType
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Category_Master]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Category_Master] (
        [CategoryId]    INT           IDENTITY(1,1) NOT NULL,
        [CategoryName]  NVARCHAR(100) NOT NULL,
        [CategoryAlias] NVARCHAR(100) NOT NULL,
        [RequestType]   VARCHAR(20)   NOT NULL,
        [Status]        VARCHAR(20)   NOT NULL DEFAULT 'Active',
        [CreatedBy]     VARCHAR(20)   NOT NULL,
        [CreatedDate]   DATETIME      NOT NULL DEFAULT GETDATE(),
        [UpdatedBy]     VARCHAR(20)   NULL,
        [UpdatedDate]   DATETIME      NULL,
        CONSTRAINT [PK_Category_Master] PRIMARY KEY CLUSTERED ([CategoryId]),
        CONSTRAINT [CK_Category_Master_RequestType] CHECK ([RequestType] IN ('INC', 'SRV'))
    )
END
GO

-- ============================================================
-- 6. Sub_Category_Master - Subcategories linked to Category
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sub_Category_Master]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Sub_Category_Master] (
        [SubCategoryId]    INT           IDENTITY(1,1) NOT NULL,
        [SubCategoryName]  NVARCHAR(100) NOT NULL,
        [SubCategoryAlias] NVARCHAR(100) NOT NULL,
        [CategoryId]       INT           NOT NULL,
        [Status]           VARCHAR(20)   NOT NULL DEFAULT 'Active',
        [CreatedBy]        VARCHAR(20)   NOT NULL,
        [CreatedDate]      DATETIME      NOT NULL DEFAULT GETDATE(),
        [UpdatedBy]        VARCHAR(20)   NULL,
        [UpdatedDate]      DATETIME      NULL,
        CONSTRAINT [PK_Sub_Category_Master] PRIMARY KEY CLUSTERED ([SubCategoryId]),
        CONSTRAINT [FK_Sub_Category_Master_Category] FOREIGN KEY ([CategoryId]) REFERENCES [dbo].[Category_Master]([CategoryId])
    )
END
GO

-- ============================================================
-- 7. Priority_Category_Linking - Maps category to default priority
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Priority_Category_Linking]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Priority_Category_Linking] (
        [LinkingId]      INT          IDENTITY(1,1) NOT NULL,
        [CategoryId]     INT          NOT NULL,
        [SubCategoryId]  INT          NULL,
        [Priority]       VARCHAR(20)  NOT NULL,
        CONSTRAINT [PK_Priority_Category_Linking] PRIMARY KEY CLUSTERED ([LinkingId]),
        CONSTRAINT [FK_PCL_Category] FOREIGN KEY ([CategoryId]) REFERENCES [dbo].[Category_Master]([CategoryId]),
        CONSTRAINT [FK_PCL_SubCategory] FOREIGN KEY ([SubCategoryId]) REFERENCES [dbo].[Sub_Category_Master]([SubCategoryId]),
        CONSTRAINT [CK_PCL_Priority] CHECK ([Priority] IN ('Critical', 'High', 'Medium', 'Low'))
    )
END
GO

-- ============================================================
-- 8. Complaint_Header - Primary complaint record
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Complaint_Header]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Complaint_Header] (
        [ComplaintId]        VARCHAR(20)    NOT NULL,
        [CreatedBy]          VARCHAR(20)    NOT NULL,
        [CreatedDate]        DATETIME       NOT NULL DEFAULT GETDATE(),
        [Title]              VARCHAR(200)   NOT NULL,
        [Priority]           VARCHAR(20)    NOT NULL,
        [ComplaintTypeId]    INT            NOT NULL,
        [UnitId]             INT            NOT NULL,
        [RequestType]        NVARCHAR(20)   NOT NULL,
        [CategoryId]         INT            NOT NULL,
        [SubCategoryId]      INT            NULL,
        [Description]        NVARCHAR(1000) NOT NULL,
        [CustomerImpactFlag] INT            NOT NULL DEFAULT 0,
        [CustomerName]       NVARCHAR(100)  NULL,
        [AssignedTo]         VARCHAR(20)    NULL,
        [AssignedDate]       DATETIME       NULL,
        [AssignmentType]     VARCHAR(20)    NULL,
        [Status]             VARCHAR(20)    NOT NULL DEFAULT 'New',
        [HoldReason]         NVARCHAR(500)  NULL,
        [ResolutionSummary]  NVARCHAR(1000) NULL,
        [ClosureReason]      NVARCHAR(1000) NULL,
        [LastUpdate]         DATETIME       NOT NULL DEFAULT GETDATE(),
        [LastUpdateBy]       VARCHAR(20)    NULL,
        CONSTRAINT [PK_Complaint_Header] PRIMARY KEY CLUSTERED ([ComplaintId]),
        CONSTRAINT [FK_CH_ComplaintType] FOREIGN KEY ([ComplaintTypeId]) REFERENCES [dbo].[ComplaintType_Master]([ComplaintTypeId]),
        CONSTRAINT [FK_CH_Unit] FOREIGN KEY ([UnitId]) REFERENCES [dbo].[Unit_Master]([UnitId]),
        CONSTRAINT [FK_CH_Category] FOREIGN KEY ([CategoryId]) REFERENCES [dbo].[Category_Master]([CategoryId]),
        CONSTRAINT [FK_CH_SubCategory] FOREIGN KEY ([SubCategoryId]) REFERENCES [dbo].[Sub_Category_Master]([SubCategoryId]),
        CONSTRAINT [FK_CH_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[User_Master]([EmpCode]),
        CONSTRAINT [FK_CH_AssignedTo] FOREIGN KEY ([AssignedTo]) REFERENCES [dbo].[User_Master]([EmpCode]),
        CONSTRAINT [CK_CH_Priority] CHECK ([Priority] IN ('Critical', 'High', 'Medium', 'Low')),
        CONSTRAINT [CK_CH_Status] CHECK ([Status] IN ('New', 'Assigned', 'In Progress', 'Resolved', 'Closed', 'Reopened', 'Hold')),
        CONSTRAINT [CK_CH_AssignmentType] CHECK ([AssignmentType] IN ('ASSIGN', 'SELF-ASSIGN', 'TRANSFER')),
        CONSTRAINT [CK_CH_CustomerImpactFlag] CHECK ([CustomerImpactFlag] IN (0, 1))
    )
END
GO

-- Index for faster complaint lookups
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Complaint_Header_Status')
    CREATE INDEX IX_Complaint_Header_Status ON [dbo].[Complaint_Header]([Status])
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Complaint_Header_CreatedBy')
    CREATE INDEX IX_Complaint_Header_CreatedBy ON [dbo].[Complaint_Header]([CreatedBy])
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Complaint_Header_AssignedTo')
    CREATE INDEX IX_Complaint_Header_AssignedTo ON [dbo].[Complaint_Header]([AssignedTo])
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Complaint_Header_CreatedDate')
    CREATE INDEX IX_Complaint_Header_CreatedDate ON [dbo].[Complaint_Header]([CreatedDate] DESC)
GO

-- ============================================================
-- 9. Complaint_Updates - Full audit trail (append-only)
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Complaint_Updates]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Complaint_Updates] (
        [UpdateId]      BIGINT         IDENTITY(1,1) NOT NULL,
        [ComplaintId]   VARCHAR(20)    NOT NULL,
        [UpdateType]    VARCHAR(20)    NOT NULL,
        [UpdateBy]      VARCHAR(20)    NOT NULL,
        [UpdateDate]    DATETIME       NOT NULL DEFAULT GETDATE(),
        [AssignType]    VARCHAR(20)    NULL,
        [AssignedTo]    VARCHAR(20)    NULL,
        [Description]   NVARCHAR(1000) NULL,
        CONSTRAINT [PK_Complaint_Updates] PRIMARY KEY CLUSTERED ([UpdateId]),
        CONSTRAINT [FK_CU_Complaint] FOREIGN KEY ([ComplaintId]) REFERENCES [dbo].[Complaint_Header]([ComplaintId]),
        CONSTRAINT [FK_CU_UpdateBy] FOREIGN KEY ([UpdateBy]) REFERENCES [dbo].[User_Master]([EmpCode]),
        CONSTRAINT [CK_CU_UpdateType] CHECK ([UpdateType] IN ('New', 'Assign', 'Update', 'Resolve', 'Close', 'Reopen')),
        CONSTRAINT [CK_CU_AssignType] CHECK ([AssignType] IS NULL OR [AssignType] IN ('SELF-ASSIGN', 'TRANSFER', 'ASSIGN'))
    )
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Complaint_Updates_ComplaintId')
    CREATE INDEX IX_Complaint_Updates_ComplaintId ON [dbo].[Complaint_Updates]([ComplaintId], [UpdateDate] DESC)
GO

-- ============================================================
-- 10. Complaint_Attachments - File attachments
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Complaint_Attachments]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Complaint_Attachments] (
        [AttachmentId]  INT          IDENTITY(1,1) NOT NULL,
        [ComplaintId]   VARCHAR(20) NOT NULL,
        [FileName]      VARCHAR(200) NOT NULL,
        [FilePath]      VARCHAR(200) NOT NULL,
        [FileSize]      BIGINT       NULL,
        [MimeType]      VARCHAR(100) NULL,
        [UpdateId]      BIGINT       NULL,
        [UserId]        VARCHAR(20)  NOT NULL,
        [UploadedDate]  DATETIME     NOT NULL DEFAULT GETDATE(),
        CONSTRAINT [PK_Complaint_Attachments] PRIMARY KEY CLUSTERED ([AttachmentId]),
        CONSTRAINT [FK_CA_Complaint] FOREIGN KEY ([ComplaintId]) REFERENCES [dbo].[Complaint_Header]([ComplaintId]),
        CONSTRAINT [FK_CA_Update] FOREIGN KEY ([UpdateId]) REFERENCES [dbo].[Complaint_Updates]([UpdateId]),
        CONSTRAINT [FK_CA_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[User_Master]([EmpCode])
    )
END
GO

-- ============================================================
-- 11. User_Unit_Permission - Unit access permissions
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[User_Unit_Permission]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[User_Unit_Permission] (
        [EmpCode]      VARCHAR(20) NOT NULL,
        [UnitId]       INT         NOT NULL,
        [Role]         VARCHAR(20) NOT NULL DEFAULT 'View',
        [AssignedBy]   VARCHAR(20) NOT NULL,
        [AssignedDate] DATETIME    NOT NULL DEFAULT GETDATE(),
        CONSTRAINT [PK_User_Unit_Permission] PRIMARY KEY CLUSTERED ([EmpCode], [UnitId]),
        CONSTRAINT [FK_UUP_User] FOREIGN KEY ([EmpCode]) REFERENCES [dbo].[User_Master]([EmpCode]),
        CONSTRAINT [FK_UUP_Unit] FOREIGN KEY ([UnitId]) REFERENCES [dbo].[Unit_Master]([UnitId]),
        CONSTRAINT [CK_UUP_Role] CHECK ([Role] IN ('View', 'Manage'))
    )
END
GO

-- ============================================================
-- 12. Complaint Sequence (for ID generation)
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Complaint_Sequence]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Complaint_Sequence] (
        [SequenceDate] DATE   NOT NULL,
        [RequestType]  VARCHAR(10) NOT NULL,
        [LastNumber]   INT    NOT NULL DEFAULT 0,
        CONSTRAINT [PK_Complaint_Sequence] PRIMARY KEY CLUSTERED ([SequenceDate], [RequestType])
    )
END
GO

-- ============================================================
-- 13. Notification_Queue - Pending email notifications
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Notification_Queue]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Notification_Queue] (
        [NotificationId]  BIGINT         IDENTITY(1,1) NOT NULL,
        [ComplaintId]     VARCHAR(20)    NULL,
        [RecipientEmpCode] VARCHAR(20)   NOT NULL,
        [RecipientEmail]  VARCHAR(200)   NULL,
        [Subject]         NVARCHAR(200)  NOT NULL,
        [Body]            NVARCHAR(MAX)  NOT NULL,
        [Status]          VARCHAR(20)    NOT NULL DEFAULT 'Pending',
        [SentDate]        DATETIME       NULL,
        [ErrorMessage]    NVARCHAR(500)  NULL,
        [CreatedDate]     DATETIME       NOT NULL DEFAULT GETDATE(),
        [ReadFlag]        BIT            NOT NULL DEFAULT 0,
        CONSTRAINT [PK_Notification_Queue] PRIMARY KEY CLUSTERED ([NotificationId]),
        CONSTRAINT [CK_NQ_Status] CHECK ([Status] IN ('Pending', 'Sent', 'Failed'))
    )
END
GO

PRINT 'All CMS tables created successfully.'
GO
