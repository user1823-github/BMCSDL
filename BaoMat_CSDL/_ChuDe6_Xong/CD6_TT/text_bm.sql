
-- Tạo cơ sở dữ liệu
CREATE DATABASE CompanyDB;
USE CompanyDB;

-- Tạo bảng employees
CREATE TABLE employees (
    employeeid INT identity(1,1) PRIMARY KEY,
    name NVARCHAR(100),
    age INT,
	salary INT
)

-- Insert dữ liệu mẫu vào bảng employees
INSERT INTO employees (name, age, salary) VALUES
(N'Thành Phát', 30, 25000)
INSERT INTO employees (name, age, salary) VALUES
(N'Đức Mạnh', 25, 35000)
INSERT INTO employees (name, age, salary) VALUES
(N'Công Thoại', 18, 45000)
INSERT INTO employees (name, age, salary) VALUES
(N'Tuấn Khang', 20, 45000)

-- Tạo bảng ghilog1

--=============================================
-- Tạo Server Audit
USE [master]
GO
 
CREATE SERVER AUDIT [qlcompany_auditing]
TO FILE 
(	FILEPATH = N'E:\HK6\BaoMat_CSDL\company_auditing\'
	,MAXSIZE = 20 MB
	,MAX_ROLLOVER_FILES = 2147483647
	,RESERVE_DISK_SPACE = OFF
) WITH (QUEUE_DELAY = 1000, ON_FAILURE = CONTINUE, 
AUDIT_GUID = 'c021ba0a-cad9-45aa-9b48-df1324c331ef')
ALTER SERVER AUDIT [qlcompany_auditing] WITH (STATE = ON)
GO




-- Tạo audit Database giám sát hành động trên các lệnh: Update, Insert
USE [CompanyDB]
GO

CREATE DATABASE AUDIT SPECIFICATION [monitor_auditing]
FOR SERVER AUDIT [qlcompany_auditing]
ADD (DELETE ON OBJECT::[dbo].[employees] BY [dbo]),
ADD (INSERT ON OBJECT::[dbo].[employees] BY [dbo]),
ADD (UPDATE ON OBJECT::[dbo].[employees] BY [dbo])
WITH (STATE = ON)
GO


-- Tạo bảng ghiLogCompany
CREATE TABLE ghiLogCompany (
	[id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[bang] [nvarchar](50) NULL,
	[thoigian] [nvarchar](50) NULL,
	[salary] int,
	[salary_new] int,
	[lenh] [nvarchar](50) NULL,
	[taikhoan] [nvarchar](50) NULL,
	[truyvan] [nvarchar](500) NULL
)

-- trigger cho update
CREATE TRIGGER tr_salary_emp ON [dbo].[employees] AFTER UPDATE
AS BEGIN
    DECLARE @thoigian DATETIME;
    DECLARE @taikhoan NVARCHAR(50);
    DECLARE @luong_ban_dau INT;
    DECLARE @luong_moi INT;
    DECLARE @updateCommand NVARCHAR(max);

    SET @thoigian = GETDATE();
    SET @taikhoan = SESSION_USER;

    SELECT @luong_ban_dau = d.salary, @luong_moi = i.salary
    FROM inserted AS i
    JOIN deleted AS d ON i.employeeid = d.employeeid;

    SET @updateCommand = (SELECT top 1 statement 
				FROM sys.fn_get_audit_file('E:\HK6\BaoMat_CSDL\company_auditing\*.sqlaudit'
				, default, default)
                WHERE action_id = 'UP'
				ORDER BY event_time DESC)

    INSERT INTO ghiLogCompany(bang, salary, salary_new, lenh, 
	taikhoan, truyvan, thoigian)
    VALUES ('employees', @luong_ban_dau, @luong_moi, 'Update', 
	@taikhoan, @updateCommand, @thoigian);
END;

-- Test: Update
update employees
set salary=35000
where employeeid=4

-- Kiểm tra giám sát các lệnh đã được thực thi
select * from sys.fn_get_audit_file('E:\HK6\BaoMat_CSDL\company_auditing\*.sqlaudit', default, default)

select * from employees

select * from ghiLogCompany

-- trigger cho Insert
CREATE TRIGGER tr_in_salary__emp ON [dbo].[employees] AFTER INSERT
AS BEGIN
    DECLARE @thoigian DATETIME;
    DECLARE @taikhoan NVARCHAR(50);
    DECLARE @luong_ban_dau INT;
    DECLARE @luong_moi INT;
    DECLARE @insertCommand NVARCHAR(max);

    SET @thoigian = GETDATE();
    SET @taikhoan = SESSION_USER;

    SET @insertCommand = (SELECT top 1 statement 
				FROM sys.fn_get_audit_file('E:\HK6\BaoMat_CSDL\company_auditing\*.sqlaudit', 
				default, default)
                WHERE action_id = 'IN'
				ORDER BY event_time DESC)

    INSERT INTO ghiLogCompany(bang, lenh, taikhoan, truyvan, thoigian)
    VALUES ('employees', 'Insert', @taikhoan, @insertCommand, @thoigian);
END;

-- Test: Insert 
INSERT INTO employees (name, age, salary) VALUES
(N'Tuấn Khang', 20, 45000)
-- Kiểm tra giám sát các lệnh đã được thực thi
select * from sys.fn_get_audit_file('E:\HK6\BaoMat_CSDL\company_auditing\*.sqlaudit', default, default)

select * from ghiLogCompany



 

