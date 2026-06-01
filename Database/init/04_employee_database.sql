-- ============================================================
-- TMG Employee Data Database — Employee Details Table
-- ============================================================
-- This script creates the TMG_EmployeeData database and
-- TBL_EmployeeDetails table used for regular employee login.
-- ============================================================

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'TMG_EmployeeData')
BEGIN
    CREATE DATABASE [TMG_EmployeeData]
    PRINT 'Created TMG_EmployeeData database'
END
GO

USE [TMG_EmployeeData]
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TBL_EmployeeDetails]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[TBL_EmployeeDetails](
        [EMP_Id] [bigint] NULL,
        [EMP_Empcode] [varchar](20) NULL,
        [EMP_Name] [varchar](200) NULL,
        [EMP_Level] [varchar](10) NULL,
        [EMP_Department] [varchar](100) NULL,
        [EMP_Designation] [varchar](100) NULL,
        [EMP_Location] [varchar](100) NULL,
        [EMP_CompanyName] [varchar](100) NULL,
        [EMP_EmailId] [varchar](200) NULL,
        [EMP_Mobile] [varchar](100) NULL,
        [EMP_ExtensionNo] [varchar](100) NULL,
        [EMP_GroupJoinDate] [datetime] NULL,
        [EMP_DOJ] [datetime] NULL,
        [EMP_DOL] [datetime] NULL,
        [EMP_ReportingTo] [varchar](200) NULL,
        [EMP_ReportingEmpCode] [varchar](20) NULL,
        [EMP_CostCenter] [varchar](100) NULL,
        [EMP_DomainUsername] [varchar](200) NULL,
        [EMP_UniqueId] [bigint] IDENTITY(1,1) NOT NULL,
        [EMP_LastUpdatedTime] [datetime] NULL,
        [EMP_Unit] [varchar](50) NULL,
        [EMP_ImageName] [nvarchar](250) NULL
    )
    PRINT 'Created TBL_EmployeeDetails table'
END
GO

-- Seed sample employee data
IF NOT EXISTS (SELECT 1 FROM [dbo].[TBL_EmployeeDetails])
BEGIN
    INSERT INTO [dbo].[TBL_EmployeeDetails] (EMP_Id, EMP_Empcode, EMP_Name, EMP_Level, EMP_Department, EMP_Designation, EMP_Location, EMP_CompanyName, EMP_EmailId, EMP_Mobile, EMP_ExtensionNo, EMP_GroupJoinDate, EMP_DOJ, EMP_DOL, EMP_ReportingTo, EMP_ReportingEmpCode, EMP_CostCenter, EMP_DomainUsername, EMP_LastUpdatedTime, EMP_Unit, EMP_ImageName)
    VALUES ('1', '40256', 'B Narahari', '4', 'Corporate Affairs', 'Senior General Manager', 'Manipal', 'Manipal Technologies Limited', 'narahari@manipalgroup.info', '9845243248', NULL, '1986-10-07 00:00:00.000', '1986-10-07 00:00:00.000', NULL, 'Abhay Anant Gupte', '43471', 'Group', 'narahari.b', '2026-02-12 13:21:19.357', NULL, 'https://peopleconnect.manipalgroup.info/Adrenalin//MyPage/MANIPALTEC/40256.png');

    INSERT INTO [dbo].[TBL_EmployeeDetails] (EMP_Id, EMP_Empcode, EMP_Name, EMP_Level, EMP_Department, EMP_Designation, EMP_Location, EMP_CompanyName, EMP_EmailId, EMP_Mobile, EMP_ExtensionNo, EMP_GroupJoinDate, EMP_DOJ, EMP_DOL, EMP_ReportingTo, EMP_ReportingEmpCode, EMP_CostCenter, EMP_DomainUsername, EMP_LastUpdatedTime, EMP_Unit, EMP_ImageName)
    VALUES ('1', '44886', 'Jayaraj K', '7', 'Information Technology - Corp', 'Manager', 'Manipal', 'Manipal Technologies Limited', 'jayaraj@manipalgroup.info', '9902013775', NULL, '2007-02-01 00:00:00.000', '2018-08-01 00:00:00.000', NULL, 'Mahesh S', '44842', 'Group', 'jayaraj', '2026-02-12 13:23:19.573', NULL, 'https://peopleconnect.manipalgroup.info/Adrenalin//MyPage/MANIPALTEC/44886.png');

    INSERT INTO [dbo].[TBL_EmployeeDetails] (EMP_Id, EMP_Empcode, EMP_Name, EMP_Level, EMP_Department, EMP_Designation, EMP_Location, EMP_CompanyName, EMP_EmailId, EMP_Mobile, EMP_ExtensionNo, EMP_GroupJoinDate, EMP_DOJ, EMP_DOL, EMP_ReportingTo, EMP_ReportingEmpCode, EMP_CostCenter, EMP_DomainUsername, EMP_LastUpdatedTime, EMP_Unit, EMP_ImageName)
    VALUES ('1', '45421', 'Raghavendra Nayak', '7', 'Information Technology - Corp', 'Manager', 'Manipal', 'Manipal Technologies Limited', 'raghavendra.nayak@manipalgroup.info', '9535401353', NULL, '2011-09-02 00:00:00.000', '2022-02-01 00:00:00.000', NULL, 'Arun Bhaskar', '46234', 'SBU MTL PMS', 'raghavendra.nayak', '2026-02-12 13:23:43.637', 'UNIT-3 - HO (UDAYAVANI)', 'https://peopleconnect.manipalgroup.info/Adrenalin//MyPage/MANIPALTEC/45421.png');

    INSERT INTO [dbo].[TBL_EmployeeDetails] (EMP_Id, EMP_Empcode, EMP_Name, EMP_Level, EMP_Department, EMP_Designation, EMP_Location, EMP_CompanyName, EMP_EmailId, EMP_Mobile, EMP_ExtensionNo, EMP_GroupJoinDate, EMP_DOJ, EMP_DOL, EMP_ReportingTo, EMP_ReportingEmpCode, EMP_CostCenter, EMP_DomainUsername, EMP_LastUpdatedTime, EMP_Unit, EMP_ImageName)
    VALUES ('1', '56806', 'Sudarshan B R', 'FTC - W', 'Quality & Process', 'QC Operator', 'Manipal', 'Manipal Payment and Identity Solutions Limited', '56806.dummy@manipalgroup.info', NULL, NULL, '2025-01-01 00:00:00.000', '2025-01-01 00:00:00.000', NULL, 'Yogeesh Manipal', '55718', 'SBU MPi', '56806', '2026-02-12 13:28:32.743', NULL, 'https://peopleconnect.manipalgroup.info/Adrenalin//MyPage/MANIPALTEC/56806.png');

    INSERT INTO [dbo].[TBL_EmployeeDetails] (EMP_Id, EMP_Empcode, EMP_Name, EMP_Level, EMP_Department, EMP_Designation, EMP_Location, EMP_CompanyName, EMP_EmailId, EMP_Mobile, EMP_ExtensionNo, EMP_GroupJoinDate, EMP_DOJ, EMP_DOL, EMP_ReportingTo, EMP_ReportingEmpCode, EMP_CostCenter, EMP_DomainUsername, EMP_LastUpdatedTime, EMP_Unit, EMP_ImageName)
    VALUES ('1', '202023', 'Manpreet Kaur', '10', 'Sales', 'Senior Sales Manager', 'Ambala', 'Manipal Fintech Private Limited', '202023.dummy@manipalfintech.com', '8059537027', NULL, '2025-08-18 00:00:00.000', '2025-08-18 00:00:00.000', NULL, 'Udesh Kumar', '201762', 'SBU MFPL', '202023', '2026-02-12 13:18:30.267', NULL, 'https://peopleconnect.manipalgroup.info/Adrenalin//MyPage/MANIPALTEC/202023.png');

    PRINT 'Seeded 5 employee records into TBL_EmployeeDetails'
END
GO
