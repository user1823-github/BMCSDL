
--Bài 2:
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

--4. Tạo 1 trigger giám sát khi người dùng thay đổi đơn giá của bảng sản phẩm. Viết lệnh
--kiểm tra giám sát vừa thực hiện. Dữ liệu giám sát gổm Masp, TenSp, DonGiaCu,
--DonGiaMoi, câu lệnh thực hiện, ai thực hiện
-- Tạo audit 
USE [master]
GO

CREATE SERVER AUDIT [qlbh_auditing3]
TO FILE 
(	FILEPATH = N'E:\HK6\BaoMat_CSDL\TH\qlbh_auditing\'
	,MAXSIZE = 20 MB
	,MAX_ROLLOVER_FILES = 2147483647
	,RESERVE_DISK_SPACE = OFF
) WITH (QUEUE_DELAY = 1000, ON_FAILURE = CONTINUE, AUDIT_GUID = '436c7d20-a120-4bdf-a3a7-ee14a350027d')
ALTER SERVER AUDIT [qlbh_auditing3] WITH (STATE = ON)
GO

-- Tạo audit trên database
USE [QLBH]
GO

CREATE DATABASE AUDIT SPECIFICATION [update_auditing]
FOR SERVER AUDIT [qlnh_auditing3]
ADD (UPDATE ON OBJECT::[dbo].[SanPham] BY [db_accessadmin])
WITH (STATE = ON)
GO
 

-- Tạo bảng ghi_log
CREATE TABLE [dbo].[ghi_log](
	[id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Masp] int,
	[TenSp] [nvarchar](50) NULL,
	[DonGiaCu] [nvarchar](50) NULL,
	[DonGiaMoi] [nvarchar](50) NULL,
	[lenh] [nvarchar](50) NULL,
	[bang] [nvarchar](50) NULL,
	[thoigian] [nvarchar](50) NULL,
	[taikhoan] [nvarchar](50) NULL,
	[giatri] [nvarchar](500) NULL
)

go

CREATE TRIGGER trg_dongia_sp ON [dbo].[SanPham] AFTER UPDATE
AS 
BEGIN
    DECLARE @thoigian DATETIME;
    DECLARE @taikhoan NVARCHAR(50);
    DECLARE @maSP INT;
    DECLARE @tenSP NVARCHAR(50);
    DECLARE @gia_ban_dau INT;
    DECLARE @gia_moi INT;
    DECLARE @updateCommand NVARCHAR(max);

    SET @thoigian = GETDATE();
    SET @taikhoan = SESSION_USER;

    SELECT @maSP = i.MaSP,
           @tenSP = i.TenSP,
           @gia_ban_dau = d.DonGia,
           @gia_moi = i.DonGia
    FROM inserted AS i
    JOIN deleted AS d ON i.MaSP = d.MaSP;

    SET @updateCommand = (SELECT top 1 statement 
						  FROM sys.fn_get_audit_file('E:\HK6\BaoMat_CSDL\TH\qlbh_auditing\*.sqlaudit', default, default)
                          WHERE action_id = 'UP'
                          ORDER BY event_time DESC)

    INSERT INTO ghi_log (Masp, TenSp, DonGiaCu, DonGiaMoi, lenh, bang, giatri, taikhoan, thoigian)
    VALUES (@maSP, @tenSP, @gia_ban_dau, @gia_moi, 'Update', 'SanPham', 
            @updateCommand, 
            @taikhoan, @thoigian);
END;

select * from sys.fn_get_audit_file
(
	'E:\HK6\BaoMat_CSDL\TH\qlbh_auditing\*.sqlaudit', default, default
) 
   
-- Thực hiện
update SanPham  
set DonGia=70000
where MaSP=4

-- check
select * from SanPham
select * from ghi_log


drop trigger trg_dongia_sp

--5. Sửa lại Trigger của câu 4 chỉ giám sát khi thay đổi giá mới lớn hơn hay bằng 30% giá
--cũ, Kiểm tra giám sát vừa thực hiện. Dữ liệu giám sát gổm Masp, TenSp, DonGiaCu,
--DonGiaMoi, câu lệnh thực hiện, ai thực hiện

-- Tạo bảng ghi_log
CREATE TABLE [dbo].[ghi_log2](
	[id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[Masp] int,
	[TenSp] [nvarchar](50) NULL,
	[DonGiaCu] [nvarchar](50) NULL,
	[DonGiaMoi] [nvarchar](50) NULL,
	[lenh] [nvarchar](50) NULL,
	[bang] [nvarchar](50) NULL,
	[thoigian] [nvarchar](50) NULL,
	[taikhoan] [nvarchar](50) NULL,
	[giatri] [nvarchar](500) NULL
)


CREATE TRIGGER trg_dongia30_sp ON [dbo].[SanPham] AFTER UPDATE
AS 
BEGIN
    DECLARE @thoigian DATETIME;
    DECLARE @taikhoan NVARCHAR(50);
    DECLARE @maSP INT;
    DECLARE @tenSP NVARCHAR(50);
    DECLARE @gia_ban_dau INT;
    DECLARE @gia_moi INT;
    DECLARE @updateCommand NVARCHAR(max);

    SET @thoigian = GETDATE();
    SET @taikhoan = SESSION_USER;

    SELECT @maSP = i.MaSP,
           @tenSP = i.TenSP,
           @gia_ban_dau = d.DonGia,
           @gia_moi = i.DonGia
    FROM inserted AS i
    JOIN deleted AS d ON i.MaSP = d.MaSP;
	 
    SET @updateCommand = (SELECT top 1 statement 
						  FROM sys.fn_get_audit_file('E:\HK6\BaoMat_CSDL\TH\qlbh_auditing\*.sqlaudit', default, default)
                          WHERE action_id = 'UP'
                          ORDER BY event_time DESC)

    
    BEGIN
		INSERT INTO ghi_log2 (Masp, TenSp, DonGiaCu, DonGiaMoi, lenh, bang, giatri, taikhoan, thoigian)
		VALUES (@maSP, @tenSP, @gia_ban_dau, @gia_moi, 'Update', 'SanPham', 
				@updateCommand, 
				@taikhoan, @thoigian);
	END;
END;

-- Thực hiện
update SanPham  
set DonGia=900000
where MaSP=1

-- check
select * from SanPham
select * from ghi_log2

drop trigger trg_dongia30_sp

--6. Tạo Login Hai pass =HAI. Tạo người dùng tên HAI. Cấp quyền cho người dùng này
--được phép xem, thêm, xoá, sửa. Đăng nhập vào login HAI, thực hiện lệnh Update thay
--đổi Dongia theo trường hợp câu 4, câu 5. Cho biết kết quả giám sát.
create login HAI with password='HAI' 
create user HAI for login HAI

grant select, insert, delete, update on SanPham to HAI


ALTER DATABASE AUDIT SPECIFICATION [update_auditing]
FOR SERVER AUDIT [qlbh_auditing3]
WITH (STATE = OFF);
GO

ALTER DATABASE AUDIT SPECIFICATION [update_auditing]
FOR SERVER AUDIT [qlbh_auditing3]
ADD (UPDATE ON OBJECT::[dbo].[SanPham] BY [HAI])
WITH (STATE = ON)
GO
USE master;
GRANT VIEW SERVER STATE TO HAI;

--7. Viết lệnh tạo 1 trigger giám sát cho các lệnh thêm trên bảng SanPham. Việc giám sát
--sẽ gồm ngày giờ thực hiện lệnh, lệnh gì, ai thực hiện, dữ liệu mới thêm là gì.
-- Tạo bảng ghi_log3
CREATE TABLE [dbo].[ghi_log3](
	[id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[bang] [nvarchar](50) NULL,
	[thoigian] [nvarchar](50) NULL,
	[lenh] [nvarchar](50) NULL,
	[taikhoan] [nvarchar](50) NULL,
	[giatri] [nvarchar](500) NULL
)

CREATE TRIGGER trg_insert_sp ON [dbo].[SanPham] AFTER INSERT
AS 
BEGIN
	DECLARE @thoigian DATETIME;
    DECLARE @taikhoan NVARCHAR(50);
    DECLARE @maSP INT;
    DECLARE @tenSP NVARCHAR(50);
    DECLARE @dongia INT;
   DECLARE @SLTK INT;

    SET @thoigian = GETDATE();
    SET @taikhoan = SESSION_USER;

	SELECT @maSP = i.MaSP,
           @tenSP = i.TenSP,
           @dongia = i.DonGia,
		   @SLTK = i.SLTK
    FROM inserted AS i

    INSERT INTO ghi_log3 (bang, thoigian, lenh, taikhoan, giatri)
    VALUES ('SanPham', @thoigian, 'Update', @taikhoan, 'Mã:'+ CAST(@maSP AS NVARCHAR(50)) + ',Tên: ' + @tenSP + 
                ',Đơn giá: ' + CAST(@dongia AS NVARCHAR(50)) + ',SLTK:' + CAST(@SLTK AS NVARCHAR(50)));
END;


insert into SanPham([TenSP], [DonGia], [SLTK])
	values ('Mes', 64000, 7)

-- check
select * from ghi_log3


drop trigger trg_insert_sp

E:\HK6\BaoMat_CSDL\TH\qlbh_auditing4

--8. Viết lệnh tạo 1 trigger giám sát cho các lệnh xoá trên bảng SanPham. Việc giám sát sẽ
--gồm ngày giờ thực hiện lệnh, lệnh gì, ai thực hiện, dữ liệu bị xoá là gì.
CREATE TABLE [dbo].[ghi_log4](
	[id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[bang] [nvarchar](50) NULL,
	[thoigian] [nvarchar](50) NULL,
	[lenh] [nvarchar](50) NULL,
	[taikhoan] [nvarchar](50) NULL,
	[giatri] [nvarchar](500) NULL
)

CREATE TRIGGER trg_delete_sp ON [dbo].[SanPham] AFTER DELETE
AS BEGIN
	DECLARE @thoigian DATETIME;
    DECLARE @taikhoan NVARCHAR(50);
    DECLARE @maSP INT;
    DECLARE @tenSP NVARCHAR(50);
    DECLARE @dongia INT;
	DECLARE @SLTK INT;

    SET @thoigian = GETDATE();
    SET @taikhoan = SESSION_USER;

	SELECT @maSP = d.MaSP,
           @tenSP = d.TenSP,
           @dongia = d.DonGia,
		   @SLTK = d.SLTK
    FROM deleted AS d

    INSERT INTO ghi_log4 (bang, thoigian, lenh, taikhoan, giatri)
    VALUES ('SanPham', @thoigian, 'DELETE', @taikhoan, 'Mã:'+ CAST(@maSP AS NVARCHAR(50)) + ',Tên: ' + @tenSP + 
                ',Đơn giá: ' + CAST(@dongia AS NVARCHAR(50)) + ',SLTK:' + CAST(@SLTK AS NVARCHAR(50)));
END;

delete SanPham
where MaSP=4

-- check
select * from ghi_log4

select * from SanPham
--9. Viết lệnh tạo 1 trigger giám sát cho các lệnh xem trên bảng SanPham. Việc giám sát
--sẽ gồm ngày giờ thực hiện lệnh, câu lệnh, ai thực hiện, dữ liệu xem là gì.
CREATE TABLE [dbo].[ghi_log5](
	[id] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[bang] [nvarchar](50) NULL,
	[thoigian] [nvarchar](50) NULL,
	[lenh] [nvarchar](50) NULL,
	[taikhoan] [nvarchar](50) NULL,
	[giatri] [nvarchar](500) NULL
)

CREATE TRIGGER trg_all_sp ON [dbo].[SanPham] AFTER INSERT, UPDATE, DELETE
AS 
BEGIN
    DECLARE @thoigian DATETIME;
    DECLARE @taikhoan NVARCHAR(50);
    DECLARE @maSP INT;
    DECLARE @tenSP NVARCHAR(50);
    DECLARE @gia_ban_dau INT;
    DECLARE @gia_moi INT;
    DECLARE @allCommand NVARCHAR(max);

    SET @thoigian = GETDATE();
    SET @taikhoan = SESSION_USER;

    SELECT @maSP = i.MaSP,
           @tenSP = i.TenSP,
           @gia_ban_dau = d.DonGia,
           @gia_moi = i.DonGia
    FROM inserted AS i
    JOIN deleted AS d ON i.MaSP = d.MaSP;
	 
    SET @allCommand = (SELECT top 1 statement 
						  FROM sys.fn_get_audit_file('E:\HK6\BaoMat_CSDL\TH\qlbh_auditing4\*.sqlaudit', default, default)
                          WHERE action_id = 'SL'
                          ORDER BY event_time DESC)

    BEGIN
	INSERT INTO ghi_log5 (bang, thoigian, lenh, taikhoan, giatri)
    VALUES ('SanPham', @thoigian, 'INSERT', @taikhoan, @allCommand)

	END;
END;

update SanPham
set SLTK=6
where MaSP=5

insert into SanPham([TenSP], [DonGia], [SLTK])
	values ('Mes', 64000, 8)

delete SanPham
where MaSP=7

-- check
select * from  ghi_log5

--10. Đăng nhập vào login HAI, thực hiện lệnh Thêm, Xoá, Xem. Cho biết kết quả giám sát