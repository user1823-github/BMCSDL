create database QLBH

use QLBH
create table SanPham (
	MaSP int identity(1,1) primary key,
	TenSP nvarchar(25),
	DonGia int check (DonGia >= 0),
	SLTK int default(0)
)

-- 3 
insert into SanPham(TenSP, DonGia, SLTK)
	values ('Ford', 200000, 5)
insert into SanPham(TenSP, DonGia, SLTK)
	values ('Toyota', 400000, 3)
insert into SanPham(TenSP, DonGia, SLTK)
	values ('Yamaha', 600000, 7)
insert into SanPham(TenSP, DonGia, SLTK)
	values ('Porsche', 800000, 10)
insert into SanPham(TenSP, DonGia, SLTK)
	values ('Mercedes', 900000, 15)

select * from SanPham

-- 4
USE [master]
GO

/****** Object:  Audit [sql_auditing]    Script Date: 3/13/2024 10:40:17 AM ******/

CREATE SERVER AUDIT [qlbh_auditing]
TO FILE 
(	FILEPATH = N'E:\HK6\BaoMat_CSDL\TH\iuh_auditing\'
	,MAXSIZE = 20 MB
	,MAX_ROLLOVER_FILES = 2147483647
	,RESERVE_DISK_SPACE = OFF
)
WITH
(	QUEUE_DELAY = 1000
	,ON_FAILURE = CONTINUE
	,AUDIT_GUID = '2d4efc63-796a-4d41-af6f-300838349fb0'
)
ALTER SERVER AUDIT [qlbh_auditing] WITH (STATE = ON)
GO

-- Tạo giám sát audit trên database QLBH
USE [QLBH]
GO

CREATE DATABASE AUDIT SPECIFICATION [check_tabl_auditing]
FOR SERVER AUDIT [qlbh_auditing]
ADD (INSERT ON OBJECT::[dbo].[SanPham] BY [dbo]),
ADD (SELECT ON OBJECT::[dbo].[SanPham] BY [dbo])
WITH (STATE = ON)
GO


select * from sys.fn_get_audit_file
(
	'E:\HK6\BaoMat_CSDL\TH\iuh_auditing\*.sqlaudit', default, default
)

-- tạo bảng DDL_Log
CREATE TABLE DDL_Log(
	PostTime datetime,
	DB_User nvarchar (100),
	Event nvarchar (100),
	TSQL nvarchar (2000)
) 

-- tạo Trigger
CREATE TRIGGER myDDLTriggerON DATABASE
FOR DDL_DATABASE_LEVEL_EVENTSAS
DECLARE @data XML
SET @data = EVENTDATA()INSERT DDL_Log (
PostTime, DB_User, Event, TSQL)
VALUES(GETDATE(),CONVERT(nvarchar(100), CURRENT_USER),
@data.value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(100)'),
@data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(2000)')) ;
GO

-- Tạo bảng ghi_log
USE [QLBH]
GO

/****** Object:  Table [dbo].[DDL_Log]    Script Date: 3/13/2024 2:53:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DDL_Log](
	[PostTime] [datetime] NULL,
	[DB_User] [nvarchar](100) NULL,
	[Event] [nvarchar](100) NULL,
	[TSQL] [nvarchar](2000) NULL
) ON [PRIMARY]
GO

-- Tạo lệnh theo dõi SELECT trên dbo.SanPham
use QLBH
select * from SanPham
select top 3 * from SanPham

SELECT Subject = server_principal_name + '\' + database_principal_name
,event_time
,action_id
,database_name + '.' + SCHEMA_NAME + '.' + OBJECT_NAME as Object
, statement
from sys.fn_get_audit_file ('E:\HK6\BaoMat_CSDL\TH\iuh_auditing\*', NULL, NULL)

-- Tạo bảng ghi_log
USE [QLBH]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ghi_log](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[lenh] [nvarchar](50) NULL,
	[bang] [nvarchar](50) NULL,
	[thoigian] [nvarchar](50) NULL,
	[taikhoan] [nvarchar](50) NULL,
	[giatri] [nvarchar](50) NULL,
 CONSTRAINT [PK_ghi_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Tạo trigger theo dõi INSERT trên dbo.SanPham
--C1:
CREATE TRIGGER theodoi_insert_qlbh ON [dbo].[SanPham] AFTER INSERT AS
BEGIN
    DECLARE @thoigian DATETIME;
    DECLARE @taikhoan NVARCHAR(50);
    SET @thoigian = GETDATE();
    SET @taikhoan = SESSION_USER;

    INSERT INTO [dbo].[ghi_log] ([lenh], [bang], [giatri], [taikhoan], [thoigian])
    SELECT 'insert', 'SanPham', 
           CAST(i.MaSP AS NVARCHAR(50)) + ', ' + 
           i.TenSP + ', ' + 
           CAST(i.DonGia AS NVARCHAR(50)) + ', ' + 
           CAST(i.SLTK AS NVARCHAR(50)), 
           @taikhoan, @thoigian
    FROM inserted AS i;
END;

--C2:
create trigger theodoi_insert_qlbh on [dbo].[SanPham] after insert as
begin
	declare @thoigian datetime;
	declare @taikhoan nvarchar(50);
	set @thoigian=GETDATE()
	set @taikhoan=SESSION_USER

	insert into [dbo].[ghi_log]([lenh], [bang], [giatri], [taikhoan], [thoigian])
	values ('insert', 'SanPham', 
		(select i.TenSP + ', ' + 
		CAST(i.DonGia AS nvarchar(50)) + ', ' + CAST(i.SLTK AS nvarchar(50))
		from inserted as i
	), 
	@taikhoan, @thoigian) 
end;

select * from DDL_Log
-- Dám sát với lệnh INSERT
insert into SanPham(TenSP, DonGia, SLTK)
	values ('Ferrari', 400000, 3)

select * from SanPham

select * from ghi_log

 
-- 5. Quản trị viên hệ thống thấy rằng “Hành động đơn giá giảm từ 30% trở lên so với giá
--ban đầu là hành động đáng ngờ”. Bạn hãy viết mã lệnh Trigger ghi nhận lại những
--hành động đáng nghi ngờ này.
CREATE TRIGGER trg_dongia_sp ON [dbo].[SanPham] AFTER UPDATE
AS 
BEGIN
    DECLARE @thoigian DATETIME;
    DECLARE @taikhoan NVARCHAR(50);
    DECLARE @maSP INT;
    DECLARE @tenSP NVARCHAR(50);
    DECLARE @gia_ban_dau INT;
    DECLARE @gia_moi INT;

    SET @thoigian = GETDATE();
    SET @taikhoan = SESSION_USER;

    SELECT @maSP = i.MaSP,
           @tenSP = i.TenSP,
           @gia_ban_dau = d.DonGia,
           @gia_moi = i.DonGia
    FROM inserted AS i
    JOIN deleted AS d ON i.MaSP = d.MaSP;

    IF ((@gia_moi >= @gia_ban_dau * 1.3) OR (@gia_moi = @gia_ban_dau * 1.3))
    BEGIN
        INSERT INTO ghi_log (lenh, bang, giatri, taikhoan, thoigian)
        VALUES ('Update don gia', 'SanPham', 
                'Mã:'+ CAST(@maSP AS NVARCHAR(50)) + ',Tên: ' + @tenSP + 
                ',Giá bđ: ' + CAST(@gia_ban_dau AS NVARCHAR(50)) + ',Giá m:' + CAST(@gia_moi AS NVARCHAR(50)), 
                @taikhoan, @thoigian);
    END;
END;

-- check
update SanPham
set DonGia=30
where MaSP=2

select * from ghi_log
select * from SanPham

--6. Quản trị viên hệ thống muốn giám sát hành động cập nhật (update), xoá (delete) dữ
--liệu trong bảng sản phẩm. Bạn hãy viết mã lệnh T-SQL để thực hiện yêu cầu giám sát
--trên
-- Tắt audit
ALTER DATABASE AUDIT SPECIFICATION [check_tabl_auditing]
	WITH (STATE = OFF)
-- Cập nhật audit: bổ sung Update và Delete
ALTER DATABASE AUDIT SPECIFICATION [check_tabl_auditing]
FOR SERVER AUDIT [qlbh_auditing]
ADD (UPDATE ON OBJECT::[dbo].[SanPham] BY [dbo]),
ADD (DELETE ON OBJECT::[dbo].[SanPham] BY [dbo])
WITH (STATE = ON)
GO

--7. Quản trị viên hệ thống thấy rằng:”hành động cập nhật số lượng sản phẩm tăng từ 100
--trở lên là hành động đáng nghi ngờ”. Bạn hãy viết mã lệnh Trigger ghi nhận lại những
--hành động đáng nghi ngờ này.
CREATE TRIGGER trg_soLuong_sp ON [dbo].[SanPham] AFTER UPDATE
AS 
BEGIN
    DECLARE @thoigian DATETIME;
    DECLARE @taikhoan NVARCHAR(50);
    DECLARE @maSP INT;
    DECLARE @tenSP NVARCHAR(50);
    DECLARE @sltk_ban_dau INT;
    DECLARE @sltk_moi INT;

    SET @thoigian = GETDATE();
    SET @taikhoan = SESSION_USER;

    SELECT @maSP = i.MaSP,
           @tenSP = i.TenSP,
           @sltk_ban_dau = d.SLTK,
           @sltk_moi = i.SLTK
    FROM inserted AS i
    JOIN deleted AS d ON i.MaSP = d.MaSP;

    DECLARE @soLuong_tang INT;
    SET @soLuong_tang = @sltk_moi - @sltk_ban_dau;

    IF (@soLuong_tang >= 100)
    BEGIN
        INSERT INTO ghi_log (lenh, bang, giatri, taikhoan, thoigian)
        VALUES ('Update sl', 'SanPham', 
                'Mã SP:' + CAST(@maSP AS NVARCHAR(50)) + ', Tên SP: ' + @tenSP + 
                ', SL ban đầu: ' + CAST(@sltk_ban_dau AS NVARCHAR(50)) + ',SL mới: ' + CAST(@sltk_moi AS NVARCHAR(50)), 
                @taikhoan, @thoigian);
    END;
END; 

-- Thực hiện
update SanPham  
set SLTK=200
where MaSP=1

-- check
select * from ghi_log


 