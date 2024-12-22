--BÀI 4
--Câu 1:
--Tạo giám sát về sự thay đổi dữ liệu trong một bảng nào đó 
-- (lưu trong file và đọc từ file ra )

--1. Tạo bảng 
create table NguoiLaoDong (
	maNLD char(10) primary key, 
	hoTen nvarchar(50)
)

--2. Tạo audit sever
use master

CREATE SERVER AUDIT KiemTraTao_Them
TO FILE(FILEPATH='E:\HK6\BaoMat_CSDL\TH\Audit1')
WITH (ON_FAILURE=FAIL_OPERATION, QUEUE_DELAY=0);

--3. Enable
ALTER SERVER AUDIT KiemTraTao_Them WITH (STATE=ON);

--4. Tạo Database audit specificate
use QLBH
CREATE DATABASE AUDIT SPECIFICATION KiemTraTao_Them
FOR SERVER AUDIT KiemTraTao_Them
ADD (SELECT , INSERT ON [dbo].[NguoiLaoDong] BY dbo )
WITH (STATE = ON) ;
GO

--5. Kiểm tra (Test)
select * from NguoiLaoDong
Insert into NguoiLaoDong(maNLD,hoTen) values ('NLD5000','Hoai-Yen')
Insert into NguoiLaoDong(maNLD,hoTen) values ('NLD6000','Hoai-Yen sua cua user')

--6. Đọc file
SELECT * FROM sys.dm_server_audit_status
SELECT * FROM sys.fn_get_audit_file('E:\HK6\BaoMat_CSDL\TH\Audit1\*', NULL, NULL);
SELECT * FROM sys.dm_server_audit_status

--Câu 2: Tạo giám sát về sự thay đổi của bảng [Order Detail] trong cơ sở dữ liệu 
-- Northwind khi thực hiện các lệnh Insert, Update, Delete, Select.
USE [master]
GO

/****** Object:  Audit [sql_northwind]    Script Date: 3/14/2024 12:48:44 AM ******/
CREATE SERVER AUDIT [sql_northwind]
TO FILE 
(	FILEPATH = N'E:\HK6\BaoMat_CSDL\TH\audit_northwind\'
	,MAXSIZE = 20 MB
	,MAX_ROLLOVER_FILES = 2147483647
	,RESERVE_DISK_SPACE = OFF
) WITH (QUEUE_DELAY = 1000, ON_FAILURE = CONTINUE, AUDIT_GUID = '1838f52c-45ae-4eec-bfe1-ae58033b5065')
ALTER SERVER AUDIT [sql_northwind] WITH (STATE = ON)
GO

--
USE [Northwind]
GO

CREATE DATABASE AUDIT SPECIFICATION [or_detail_auditing]
FOR SERVER AUDIT [sql_northwind]
ADD (DELETE ON OBJECT::[dbo].[Order Details] BY [dbo]),
ADD (INSERT ON OBJECT::[dbo].[Order Details] BY [dbo]),
ADD (SELECT ON OBJECT::[dbo].[Order Details] BY [dbo]),
ADD (UPDATE ON OBJECT::[dbo].[Order Details] BY [dbo])
WITH (STATE = ON)
GO


use Northwind
-- Dám sát lệnh: select
select * from [Order Details]

-- Dám sát lệnh: insert
insert into [Order Details](OrderID, ProductID, UnitPrice, Quantity, Discount)
values (10251, 23, 12.03, 20, 0.12)
-- Dám sát lệnh: update
update [Order Details]
set UnitPrice=120.25
where OrderID=10248

-- Dám sát lệnh: delete
delete [Order Details]
where OrderID=10480

select * from sys.fn_get_audit_file
(
	'E:\HK6\BaoMat_CSDL\TH\audit_northwind\*.sqlaudit', default, default
)

--Câu 3:
--1) Tạo bảng ACCOUNTS thuộc schema của user ACCMASTER
go

create schema ACCMASTER
go
CREATE TABLE ACCMASTER.ACCOUNTS (
    AccountID INT PRIMARY KEY identity(1,1),
    AccountName NVARCHAR(50),
    Balance DECIMAL(18, 2)
);

insert into ACCMASTER.ACCOUNTS
	values ('Alex', 10000)
insert into ACCMASTER.ACCOUNTS
	values ('Bill', 15000)
insert into ACCMASTER.ACCOUNTS
	values ('Charlie', 20000)
insert into ACCMASTER.ACCOUNTS
	values ('David', 25000)

select * from ACCMASTER.Accounts

-- tạo user và login 
use QLBH

create login textsche with password = '123456'
create user textsche for login textsche

-- gán quyền select cho user này trên bảng ACCMASTER.ACCOUNTS
grant select on ACCMASTER.ACCOUNTS to textsche

-- Tạo audit dám sát lệnh select trên bảng ACCMASTER.ACCOUNTS
use master
CREATE SERVER AUDIT [sql_qlbh_sche]
TO FILE 
(	FILEPATH = N'E:\HK6\BaoMat_CSDL\TH\buoi6\account_schema'
	,MAXSIZE = 20 MB
	,MAX_ROLLOVER_FILES = 2147483647
	,RESERVE_DISK_SPACE = OFF
) WITH (QUEUE_DELAY = 1000, ON_FAILURE = CONTINUE)

ALTER SERVER AUDIT [sql_qlbh_sche] WITH (STATE = ON)
GO

--
USE [QLBH]
GO

CREATE DATABASE AUDIT SPECIFICATION [sche_account_auditing]
FOR SERVER AUDIT [sql_qlbh_sche]
ADD (SELECT ON [ACCMASTER].[ACCOUNTS] BY [textsche])
WITH (STATE = ON)
GO

select * from sys.fn_get_audit_file
(
	'E:\HK6\BaoMat_CSDL\TH\buoi6\account_schema\*.sqlaudit', default, default
)

-- Câu 4:
--1) Tạo user mới với username là TenBan. Phân quyền create table và create procedure
--cho user vừa mới tạo.
use QLBH
create schema Employees
create login TenBan with password='123456'
create user TenBan for login TenBan with default_schema = Employees

-- phân quyền
USE QLBH;

ALTER AUTHORIZATION ON SCHEMA::Employees TO TenBan;
GRANT CREATE TABLE TO TenBan;
GRANT CREATE PROCEDURE TO TenBan;

--2) Thực hiện giám sát các hành vi xem, thêm, sửa, xóa dòng trên bất kì bảng 
--nào của user TenBan.

-- Tạo audit dám sát lệnh select, insert, update, delete
use master
CREATE SERVER AUDIT [sql_qlbh_TenBan]
TO FILE 
(	FILEPATH = N'E:\HK6\BaoMat_CSDL\TH\buoi6\tenban_auditing'
	,MAXSIZE = 20 MB
	,MAX_ROLLOVER_FILES = 2147483647
	,RESERVE_DISK_SPACE = OFF
) WITH (QUEUE_DELAY = 1000, ON_FAILURE = CONTINUE)

ALTER SERVER AUDIT [sql_qlbh_TenBan] WITH (STATE = ON)
GO

--
USE [QLBH]
GO

CREATE DATABASE AUDIT SPECIFICATION [qlbh_TenBan_auditing]
FOR SERVER AUDIT [sql_qlbh_TenBan]
ADD (SELECT ON DATABASE::[QLBH] BY [TenBan]),
ADD (INSERT ON DATABASE::[QLBH] BY [TenBan]),
ADD (UPDATE ON DATABASE::[QLBH] BY [TenBan]),
ADD (DELETE ON DATABASE::[QLBH] BY [TenBan])
WITH (STATE = ON)
GO

--Câu 4:
--1) Tạo user mới với username là TenBan. Phân quyền create table và create procedure
--cho user vừa mới tạo.
--2) Thực hiện giám sát các hành vi xem, thêm, sửa, xóa dòng trên bất kì bảng nào của user
--TenBan.
--3) Đăng nhập vào tài khoản user TenBan. Thực hiện chuỗi hành động sau
--1. Tạo một bảng KHACHHANG (MaKH int, TenKH nvarchar(40), Pass nchar(10))
--2. Nhập vào 1 dòng dữ liệu bất kỳ.
--3. Update giá trị vừa insert vào.
--4. Xem tất cả dữ liệu của bảng KHACHHANG.
--5. Xóa tất cả dữ liệu trong bảng KHACHHANG.
--6. Xóa bảng KHACHHANG.

-- Bên file tenban.sql

--4) Đăng nhập vào user system, kiểm tra những hành vi nào được giám sát lại. Hành vi
--tạo bảng và xóa bảng của user TenBan có bị giám sát không? Nếu có hãy giải thích lý
--do, nếu không hãy tạo câu lệnh giám sát hành vi tạo bảng và xóa bảng của user TenBan.
select * from sys.fn_get_audit_file
(
	'E:\HK6\BaoMat_CSDL\TH\buoi6\tenban_auditing\*.sqlaudit', default, default
)

SELECT * FROM sys.server_audit_specifications;
