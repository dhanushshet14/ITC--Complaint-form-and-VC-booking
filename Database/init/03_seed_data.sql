-- ============================================================
-- ITC Complaint Management System - Seed Data
-- ============================================================
USE [EnterpriseHRDB]
GO

-- ============================================================
-- Sample User (for use as CreatedBy in seed data)
-- ============================================================
IF NOT EXISTS (SELECT * FROM [dbo].[User_Master] WHERE EmpCode = 'ADMIN001')
BEGIN
    INSERT INTO [dbo].[User_Master] (EmpCode, FullName, Username, [Password], LoginType, [Status], Role, CreatedBy, CreatedDate)
    VALUES ('ADMIN001', 'System Administrator', 'admin', '$2a$12$10jK20p23D7q6ofo3460EuB0EVE8Qdi6PgVAHUxRWqzzW/DkB/8lK', 'CUST', 'Active', 'Admin', 'ADMIN001', GETDATE())
END
GO

-- ============================================================
-- 1. Complaint Type Master
-- ============================================================
IF NOT EXISTS (SELECT * FROM [dbo].[ComplaintType_Master])
BEGIN
    SET IDENTITY_INSERT [dbo].[ComplaintType_Master] ON

    INSERT INTO [dbo].[ComplaintType_Master] (ComplaintTypeId, ComplaintTypeName, ComplaintTypeAlias, [Status], CreatedBy, CreatedDate)
    VALUES (1, 'Incident', 'INC', 'Active', 'ADMIN001', GETDATE()),
           (2, 'Service', 'SRV', 'Active', 'ADMIN001', GETDATE())

    SET IDENTITY_INSERT [dbo].[ComplaintType_Master] OFF
END
GO

-- ============================================================
-- 2. Unit Master (22 Units)
-- ============================================================
IF NOT EXISTS (SELECT * FROM [dbo].[Unit_Master])
BEGIN
    INSERT INTO [dbo].[Unit_Master] (UnitName, UnitAlias, [Status], CreatedBy, CreatedDate)
    VALUES ('Manipal Fintech',          'MFT',  'Active', 'ADMIN001', GETDATE()),
           ('MBS-Gurgaon',              'MBS-G', 'Active', 'ADMIN001', GETDATE()),
           ('MBS-Manipal',              'MBS-M', 'Active', 'ADMIN001', GETDATE()),
           ('MCT-InTouch',              'MCT',  'Active', 'ADMIN001', GETDATE()),
           ('MDS-Bangalore',            'MDS-B', 'Active', 'ADMIN001', GETDATE()),
           ('MDS-Kumta',                'MDS-K', 'Active', 'ADMIN001', GETDATE()),
           ('MDS-Manipal',              'MDS-M', 'Active', 'ADMIN001', GETDATE()),
           ('MMNL-Bangalore',           'MMNL-B','Active', 'ADMIN001', GETDATE()),
           ('MMNL-Delhi',               'MMNL-D','Active', 'ADMIN001', GETDATE()),
           ('MMNL-Editorial-Manipal',   'MMNL-E','Active', 'ADMIN001', GETDATE()),
           ('MMNL-Hubli',               'MMNL-H','Active', 'ADMIN001', GETDATE()),
           ('MMNL-Mangalore',           'MMNL-M','Active', 'ADMIN001', GETDATE()),
           ('MMNL-Mumbai',              'MMNL-Mu','Active', 'ADMIN001', GETDATE()),
           ('MMNL-Udupi',               'MMNL-U','Active', 'ADMIN001', GETDATE()),
           ('MPi-Manipal',              'MPi-M', 'Active', 'ADMIN001', GETDATE()),
           ('MPi-Mumbai',               'MPi-Mu','Active', 'ADMIN001', GETDATE()),
           ('MPi-Noida',                'MPi-N', 'Active', 'ADMIN001', GETDATE()),
           ('MTL - Noida',              'MTL-N', 'Active', 'ADMIN001', GETDATE()),
           ('MTL-Bangalore',            'MTL-B', 'Active', 'ADMIN001', GETDATE()),
           ('MTL-Chennai',              'MTL-C', 'Active', 'ADMIN001', GETDATE()),
           ('MTL-Coimbatore',           'MTL-Co','Active', 'ADMIN001', GETDATE()),
           ('UNIT-3 - HO (UDAYAVANI)',  'UNIT3', 'Active', 'ADMIN001', GETDATE())
END
GO

-- ============================================================
-- 3. Category Master
-- ============================================================
IF NOT EXISTS (SELECT * FROM [dbo].[Category_Master])
BEGIN
    -- Incident Categories (RequestType = 'INC')
    INSERT INTO [dbo].[Category_Master] (CategoryName, CategoryAlias, RequestType, [Status], CreatedBy, CreatedDate)
    VALUES ('Network Issues',       'NET',   'INC', 'Active', 'ADMIN001', GETDATE()),
           ('Outlook/Mail Issues',  'OUTL',  'INC', 'Active', 'ADMIN001', GETDATE()),
           ('Printer Issues',       'PRNT',  'INC', 'Active', 'ADMIN001', GETDATE()),
           ('Software Issues',      'SW',    'INC', 'Active', 'ADMIN001', GETDATE()),
           ('System/Laptop Issues', 'SYS',   'INC', 'Active', 'ADMIN001', GETDATE()),
           ('Others',               'OTH',   'INC', 'Active', 'ADMIN001', GETDATE())

    -- Service Categories (RequestType = 'SRV')
    INSERT INTO [dbo].[Category_Master] (CategoryName, CategoryAlias, RequestType, [Status], CreatedBy, CreatedDate)
    VALUES ('CD Request',                   'CD',    'SRV', 'Active', 'ADMIN001', GETDATE()),
           ('Colour Print Request',         'CPR',   'SRV', 'Active', 'ADMIN001', GETDATE()),
           ('Need Anydesk',                 'AD',    'SRV', 'Active', 'ADMIN001', GETDATE()),
           ('SAP Installation',             'SAP',   'SRV', 'Active', 'ADMIN001', GETDATE()),
           ('Share Folder Access',          'SFA',   'SRV', 'Active', 'ADMIN001', GETDATE()),
           ('Site Access',                  'SA',    'SRV', 'Active', 'ADMIN001', GETDATE()),
           ('Skype Installation',           'SKP',   'SRV', 'Active', 'ADMIN001', GETDATE()),
           ('Tally Software Installation',  'TSI',   'SRV', 'Active', 'ADMIN001', GETDATE()),
           ('Updating Saral TDS Software',  'STS',   'SRV', 'Active', 'ADMIN001', GETDATE()),
           ('User Activation',              'UA',    'SRV', 'Active', 'ADMIN001', GETDATE()),
           ('User Deactivation',            'UD',    'SRV', 'Active', 'ADMIN001', GETDATE()),
           ('Video Download',               'VD',    'SRV', 'Active', 'ADMIN001', GETDATE()),
           ('VPN Installation',             'VPN',   'SRV', 'Active', 'ADMIN001', GETDATE()),
           ('Zoom Installation',            'ZI',    'SRV', 'Active', 'ADMIN001', GETDATE()),
           ('Others',                       'OTH_S', 'SRV', 'Active', 'ADMIN001', GETDATE())
END
GO

-- ============================================================
-- 4. Sub Category Master
-- ============================================================
IF NOT EXISTS (SELECT * FROM [dbo].[Sub_Category_Master])
BEGIN
    -- Helper: get CategoryId by name
    DECLARE @NetCat INT, @OutlCat INT, @PrntCat INT, @SWCat INT, @SysCat INT, @OthCat_Inc INT

    SELECT @NetCat = CategoryId FROM [dbo].[Category_Master] WHERE CategoryName = 'Network Issues'
    SELECT @OutlCat = CategoryId FROM [dbo].[Category_Master] WHERE CategoryName = 'Outlook/Mail Issues'
    SELECT @PrntCat = CategoryId FROM [dbo].[Category_Master] WHERE CategoryName = 'Printer Issues'
    SELECT @SWCat   = CategoryId FROM [dbo].[Category_Master] WHERE CategoryName = 'Software Issues'
    SELECT @SysCat  = CategoryId FROM [dbo].[Category_Master] WHERE CategoryName = 'System/Laptop Issues'
    SELECT @OthCat_Inc = CategoryId FROM [dbo].[Category_Master] WHERE CategoryName = 'Others' AND RequestType = 'INC'

    -- Network Issues Subcategories
    INSERT INTO [dbo].[Sub_Category_Master] (SubCategoryName, SubCategoryAlias, CategoryId, [Status], CreatedBy, CreatedDate)
    VALUES ('Data Transfer',                'DATA_TRANS',  @NetCat, 'Active', 'ADMIN001', GETDATE()),
           ('Internet Issue',               'INT_ISS',     @NetCat, 'Active', 'ADMIN001', GETDATE()),
           ('Network Connection Issue',     'NET_CONN',    @NetCat, 'Active', 'ADMIN001', GETDATE()),
           ('Network Down',                 'NET_DOWN',    @NetCat, 'Active', 'ADMIN001', GETDATE()),
           ('Share Folder Access Issue',    'SFA_ISS',     @NetCat, 'Active', 'ADMIN001', GETDATE()),
           ('VPN Issue',                    'VPN_ISS',     @NetCat, 'Active', 'ADMIN001', GETDATE()),
           ('Others',                       'OTH_NET',     @NetCat, 'Active', 'ADMIN001', GETDATE())

    -- Outlook/Mail Issues Subcategories
    INSERT INTO [dbo].[Sub_Category_Master] (SubCategoryName, SubCategoryAlias, CategoryId, [Status], CreatedBy, CreatedDate)
    VALUES ('File Attachment Issue',        'FILE_ATT',    @OutlCat, 'Active', 'ADMIN001', GETDATE()),
           ('Incoming/Outgoing Mail Issues', 'IO_MAIL',     @OutlCat, 'Active', 'ADMIN001', GETDATE()),
           ('Outlook Opening Problem',       'OUTL_OPEN',   @OutlCat, 'Active', 'ADMIN001', GETDATE()),
           ('PST Issue',                     'PST_ISS',     @OutlCat, 'Active', 'ADMIN001', GETDATE()),
           ('Synchronisation Issue',         'SYNC_ISS',    @OutlCat, 'Active', 'ADMIN001', GETDATE()),
           ('Others',                        'OTH_OUTL',    @OutlCat, 'Active', 'ADMIN001', GETDATE())

    -- Printer Issues Subcategories
    INSERT INTO [dbo].[Sub_Category_Master] (SubCategoryName, SubCategoryAlias, CategoryId, [Status], CreatedBy, CreatedDate)
    VALUES ('Paper Jam',                    'PAPER_JAM',   @PrntCat, 'Active', 'ADMIN001', GETDATE()),
           ('Printer Down',                 'PRNT_DOWN',   @PrntCat, 'Active', 'ADMIN001', GETDATE()),
           ('Printer Error',                'PRNT_ERR',    @PrntCat, 'Active', 'ADMIN001', GETDATE()),
           ('Scanner Issue',                'SCAN_ISS',    @PrntCat, 'Active', 'ADMIN001', GETDATE()),
           ('Others',                       'OTH_PRNT',    @PrntCat, 'Active', 'ADMIN001', GETDATE())

    -- Software Issues Subcategories
    INSERT INTO [dbo].[Sub_Category_Master] (SubCategoryName, SubCategoryAlias, CategoryId, [Status], CreatedBy, CreatedDate)
    VALUES ('Adobe Software Issue',         'ADOBE_ISS',   @SWCat,  'Active', 'ADMIN001', GETDATE()),
           ('Excel/PowerPoint/Word Issue',  'OFFICE_ISS',  @SWCat,  'Active', 'ADMIN001', GETDATE()),
           ('Issue in Browser',             'BROWSER_ISS', @SWCat,  'Active', 'ADMIN001', GETDATE()),
           ('Office Activation Issue',      'OFF_ACT',     @SWCat,  'Active', 'ADMIN001', GETDATE()),
           ('Tally Application Issue',      'TALLY_ISS',   @SWCat,  'Active', 'ADMIN001', GETDATE()),
           ('Others',                       'OTH_SW',      @SWCat,  'Active', 'ADMIN001', GETDATE())

    -- System/Laptop Issues Subcategories
    INSERT INTO [dbo].[Sub_Category_Master] (SubCategoryName, SubCategoryAlias, CategoryId, [Status], CreatedBy, CreatedDate)
    VALUES ('Disk is Full',                 'DISK_FULL',   @SysCat, 'Active', 'ADMIN001', GETDATE()),
           ('Keyboard Not Working',         'KB_NOT_WK',   @SysCat, 'Active', 'ADMIN001', GETDATE()),
           ('Login Issue',                  'LOGIN_ISS',   @SysCat, 'Active', 'ADMIN001', GETDATE()),
           ('Monitor/Display Issue',        'MON_DISP',    @SysCat, 'Active', 'ADMIN001', GETDATE()),
           ('Mouse Not Working',            'MOUSE_NOT',   @SysCat, 'Active', 'ADMIN001', GETDATE()),
           ('System Down',                  'SYS_DOWN',    @SysCat, 'Active', 'ADMIN001', GETDATE()),
           ('System is Slow',               'SYS_SLOW',    @SysCat, 'Active', 'ADMIN001', GETDATE()),
           ('Others',                       'OTH_SYS',     @SysCat, 'Active', 'ADMIN001', GETDATE())

    -- "Others" (Incident) Subcategories
    INSERT INTO [dbo].[Sub_Category_Master] (SubCategoryName, SubCategoryAlias, CategoryId, [Status], CreatedBy, CreatedDate)
    VALUES ('Others',                       'OTH_INC',     @OthCat_Inc, 'Active', 'ADMIN001', GETDATE())
END
GO

-- ============================================================
-- 5. Priority Category Linking
-- ============================================================
IF NOT EXISTS (SELECT * FROM [dbo].[Priority_Category_Linking])
BEGIN
    DECLARE @CategoryId INT, @SubCatId INT

    -- Network Issues -> High
    SELECT @CategoryId = CategoryId FROM [dbo].[Category_Master] WHERE CategoryName = 'Network Issues'
    INSERT INTO [dbo].[Priority_Category_Linking] (CategoryId, SubCategoryId, Priority)
    VALUES (@CategoryId, NULL, 'High')

    -- Outlook/Mail Issues -> Medium
    SELECT @CategoryId = CategoryId FROM [dbo].[Category_Master] WHERE CategoryName = 'Outlook/Mail Issues'
    INSERT INTO [dbo].[Priority_Category_Linking] (CategoryId, SubCategoryId, Priority)
    VALUES (@CategoryId, NULL, 'Medium')

    -- Printer Issues -> Medium
    SELECT @CategoryId = CategoryId FROM [dbo].[Category_Master] WHERE CategoryName = 'Printer Issues'
    INSERT INTO [dbo].[Priority_Category_Linking] (CategoryId, SubCategoryId, Priority)
    VALUES (@CategoryId, NULL, 'Medium')

    -- Software Issues -> Medium
    SELECT @CategoryId = CategoryId FROM [dbo].[Category_Master] WHERE CategoryName = 'Software Issues'
    INSERT INTO [dbo].[Priority_Category_Linking] (CategoryId, SubCategoryId, Priority)
    VALUES (@CategoryId, NULL, 'Medium')

    -- System/Laptop Issues -> High
    SELECT @CategoryId = CategoryId FROM [dbo].[Category_Master] WHERE CategoryName = 'System/Laptop Issues'
    INSERT INTO [dbo].[Priority_Category_Linking] (CategoryId, SubCategoryId, Priority)
    VALUES (@CategoryId, NULL, 'High')

    -- System Down -> Critical
    SELECT @CategoryId = CategoryId FROM [dbo].[Category_Master] WHERE CategoryName = 'System/Laptop Issues'
    SELECT @SubCatId = SubCategoryId FROM [dbo].[Sub_Category_Master] WHERE SubCategoryName = 'System Down'
    INSERT INTO [dbo].[Priority_Category_Linking] (CategoryId, SubCategoryId, Priority)
    VALUES (@CategoryId, @SubCatId, 'Critical')

    -- Network Down -> Critical
    SELECT @CategoryId = CategoryId FROM [dbo].[Category_Master] WHERE CategoryName = 'Network Issues'
    SELECT @SubCatId = SubCategoryId FROM [dbo].[Sub_Category_Master] WHERE SubCategoryName = 'Network Down'
    INSERT INTO [dbo].[Priority_Category_Linking] (CategoryId, SubCategoryId, Priority)
    VALUES (@CategoryId, @SubCatId, 'Critical')

    -- Others (Incident) -> Low
    SELECT @CategoryId = CategoryId FROM [dbo].[Category_Master] WHERE CategoryName = 'Others' AND RequestType = 'INC'
    INSERT INTO [dbo].[Priority_Category_Linking] (CategoryId, SubCategoryId, Priority)
    VALUES (@CategoryId, NULL, 'Low')

    -- Service categories -> Medium (default for all services)
    INSERT INTO [dbo].[Priority_Category_Linking] (CategoryId, SubCategoryId, Priority)
    SELECT CategoryId, NULL, 'Medium'
    FROM [dbo].[Category_Master]
    WHERE RequestType = 'SRV'
      AND CategoryId NOT IN (SELECT CategoryId FROM [dbo].[Priority_Category_Linking] WHERE CategoryId IS NOT NULL)
END
GO

-- ============================================================
-- Migration: Add ReadFlag to Notification_Queue (in-app notifications)
-- ============================================================
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Notification_Queue]') AND name = 'ReadFlag')
BEGIN
    ALTER TABLE [dbo].[Notification_Queue] ADD [ReadFlag] BIT NOT NULL DEFAULT 0
    PRINT 'Added ReadFlag column to Notification_Queue'
END
GO

PRINT 'All seed data inserted successfully.'
GO
