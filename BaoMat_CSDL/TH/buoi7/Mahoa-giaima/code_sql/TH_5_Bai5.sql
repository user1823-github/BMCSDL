--BÀI 5
--Ứng dụng bài toán thực tế
--1) Tạo CSDL QLDA các thông số tùy ý
use master
go


CREATE DATABASE QLDA
ON PRIMARY ( NAME = N'QLDA', 
	FILENAME = N'E:\HK6\BaoMat_CSDL\TH\buoi7\test_b5\EncryptTestt.mdf')
LOG ON ( NAME = N'QLDA_log', 
	FILENAME =N'E:\HK6\BaoMat_CSDL\TH\buoi7\test_b5EncryptTest_logg.ldf')
GO

use QLDA
--2) Tạo các Table sau:
--Phongban(mapb, tenpb,mota)
--NhanVien(Manv, tennv, pass, phai, DienThoai, email, mapb)
--Duan(Mada, TenDa, NgayBD, KinhPhi, MaPB)
--Thamgia(Manv, Mada, NgayTG, MucLuong, CongViec)
--Kiểu dữ liệu sinh viên tự qui định. Yêu cầu tạo đầy đủ các ràng buộc khóa chính và
--khóa ngoại

-- Tạo bảng PhongBan
CREATE TABLE PhongBan (
    mapb INT identity(1,1) PRIMARY KEY,
    tenpb NVARCHAR(100),
    mota NVARCHAR(MAX)
);

-- Tạo bảng NhanVien
CREATE TABLE NhanVien (
    Manv INT identity(1,1) PRIMARY KEY,
    tennv NVARCHAR(100),
    pass NVARCHAR(100), 
    phai bit, 
    DienThoai NVARCHAR(20),
    email NVARCHAR(100),
    mapb INT,
    FOREIGN KEY (mapb) REFERENCES PhongBan(mapb)
);

-- Tạo bảng DuAn
CREATE TABLE DuAn (
    Mada INT identity(1,1) PRIMARY KEY,
    TenDa NVARCHAR(100),
    NgayBD DATETIME,
    KinhPhi int,
    MaPB INT,
    FOREIGN KEY (MaPB) REFERENCES PhongBan(mapb)
);

-- Tạo bảng ThamGia
CREATE TABLE ThamGia (
    Manv INT,
    Mada INT,
    NgayTG DATETIME,
    MucLuong int,
    CongViec NVARCHAR(MAX),
    PRIMARY KEY (Manv, Mada), -- Khóa chính là sự kết hợp của hai khóa ngoại
    FOREIGN KEY (Manv) REFERENCES NhanVien(Manv),
    FOREIGN KEY (Mada) REFERENCES DuAn(Mada)
);

--3) Theo bạn, bạn sẽ mã hóa theo cột nào trong bảng NhanVien? Vì sao? Bạn hãy thực
--hiện mã hóa và giải mã cho cột mà bạn đã chọn theo hai cách dùng password và dùng
--chứng chỉ. Cho biết kết quả sau khi mã hóa và giải mã.

-- Theo em sẽ mã hóa cột (pass, DienThoai, email) vì đây điều là thông tin cá nhân quan trọng
--. Hacker nếu lấy được có thể truy cập các ứng dụng hoặc tạo email giả mạo.

-- Thêm dữ PhongBan
insert into PhongBan (tenpb, mota)
	values (N'Nhân sự', N'phòng nhân sự')
insert into PhongBan (tenpb, mota)
	values (N'Kế toán', N'phòng Kế toán')
insert into PhongBan (tenpb, mota)
	values (N'Marketing', N'phòng Marketing')
insert into PhongBan (tenpb, mota)
	values (N'Quản lý', N'phòng Quản lý')
insert into PhongBan (tenpb, mota)
	values (N'Tài chính', N'phòng Tài chính')

--check
select * from PhongBan

-- Thêm dữ NhanVien
insert into NhanVien (tennv, pass, phai, DienThoai, email, mapb)
	values(N'Thành Phát 1', N'thanhphat1', '1', '123', 'abc', 11)
insert into NhanVien (tennv, pass, phai, DienThoai, email, mapb)
	values(N'Thành Phát 2', N'thanhphat2', '0', '456', 'xyz', 12)
insert into NhanVien (tennv, pass, phai, DienThoai, email, mapb)
	values(N'Thành Phát 3', N'thanhphat3', '1', '876', 'fgs', 13)
insert into NhanVien (tennv, pass, phai, DienThoai, email, mapb)
	values(N'Thành Phát 4', N'thanhphat4', '0', '678', 'dfg', 14)
insert into NhanVien (tennv, pass, phai, DienThoai, email, mapb)
	values(N'Thành Phát 5', N'thanhphat5', '1', '789', 'rty', 15)

--check
select * from NhanVien

alter table NhanVien
add pass_mahoa varbinary(max)

alter table NhanVien
add DienThoai_mahoa varbinary(max)

alter table NhanVien
add email_mahoa varbinary(max)

select * from NhanVien

-- Mã hóa sử dụng mật khẩu
update NhanVien
set pass_mahoa = ENCRYPTBYPASSPHRASE('123', pass)
update NhanVien
set DienThoai_mahoa = ENCRYPTBYPASSPHRASE('123', DienThoai)
update NhanVien
set email_mahoa = ENCRYPTBYPASSPHRASE('123', email)

select CONVERT(nvarchar(max), DECRYPTBYPASSPHRASE('123', pass_mahoa)) as pass,
	CONVERT(nvarchar(max), DECRYPTBYPASSPHRASE('123', DienThoai_mahoa)) as DienThoai,
	CONVERT(nvarchar(max), DECRYPTBYPASSPHRASE('123', email_mahoa)) as email
	from NhanVien


CREATE TABLE PhongBan (
    mapb INT PRIMARY KEY,
    tenpb NVARCHAR(100),
    mota NVARCHAR(MAX)
);
CREATE TABLE NhanVien (
    Manv INT identity(1,1) PRIMARY KEY,
    tennv NVARCHAR(100),
    pass NVARCHAR(100), 
    phai bit, 
    DienThoai NVARCHAR(20),
    email NVARCHAR(100),
    mapb INT,
    FOREIGN KEY (mapb) REFERENCES PhongBan(mapb)
);

-- Mã hóa bằng chứng chỉ

-- The first step is to create the certificate with the CREATE CERTIFICATE command: 
USE QLDA; 

--If there is no master key, create one now.
IF  NOT  EXISTS  (SELECT  *  FROM  sys.symmetric_keys  WHERE  symmetric_key_id  = 
101)  CREATE  MASTER  KEY  ENCRYPTION  BY  PASSWORD  = 
'Th15i$aS7riN&ofR@nD0m!T3%t'
GO

-- check
SELECT  *  FROM  sys.symmetric_keys

CREATE CERTIFICATE NhanVien01 WITH SUBJECT = 'NhanVienCer' 
GO

-- check
select * from sys.certificates

USE QLDA; 

CREATE  SYMMETRIC  KEY  NhanVienKeySym  WITH  ALGORITHM  =  AES_256 
ENCRYPTION BY CERTIFICATE NhanVien01; 
GO

-- check
SELECT  *  FROM  sys.symmetric_keys

select  Manv, tennv, 
	pass_encrypt  =  CONVERT(varbinary(256), 
	pass), phai, DienThoai_encrypt  =  CONVERT(varbinary(256), DienThoai),
	email_encrypt  =  CONVERT(varbinary(256), email),  mapb  into  NhanVien_encrypt  
from NhanVien where 1 = 2

select * from NhanVien_encrypt

USE QLDA; 
Truncate table NhanVien_encrypt
USE QLDA; 
-- First, decrypt the key using the BillingDept01 certificate 
OPEN  SYMMETRIC  KEY  NhanVienKeySym  DECRYPTION  BY  CERTIFICATE NhanVien01 
-- Now, insert the rows using the symmetric key 
-- encrypted by the certificate 
insert NhanVien_encrypt (tennv, 
	pass_encrypt, phai, DienThoai_encrypt, email_encrypt, mapb) 
	select top 5 tennv,  
		pass_encrypt = EncryptByKey(KEY_GUID('NhanVienKeySym'), pass),
		phai, DienThoai_encrypt = EncryptByKey(KEY_GUID('NhanVienKeySym'), DienThoai),
		email_encrypt = EncryptByKey(KEY_GUID('NhanVienKeySym'), email), mapb 
		from NhanVien

-- check
select * from NhanVien_encrypt
go

--Giải mã
USE QLDA; 
OPEN  SYMMETRIC  KEY  NhanVienKeySym  DECRYPTION  BY  CERTIFICATE 
NhanVien01  Select tennv, 
pass = convert(nvarchar(25), DecryptByKey(pass_encrypt)), phai, 
DienThoai = convert(nvarchar(25), DecryptByKey(DienThoai_encrypt)),  
email = convert(nvarchar(25), DecryptByKey(email_encrypt)), mapb  
from NhanVien_encrypt
 
CLOSE SYMMETRIC KEY NhanVienKeySym 
select  name,  pvt_key_encryption_type,  issuer_name,  subject,  expiry_date  = 
CAST(expiry_date as DATE), start_date = CAST(start_date as DATE) from sys.certificates 
go 

select name, key_length, key_algorithm, algorithm_desc, create_date = CAST(create_date as 
DATE), modify_date = CAST(create_date as DATE), key_guid from sys.symmetric_keys 
go 

--If the usage of the key and certificate are no longer needed, they should be dropped from 
-- the database: 
DROP SYMMETRIC KEY NhanVienKeySym 
DROP CERTIFICATE NhanVien01

-- check
SELECT  *  FROM  sys.symmetric_keys

--4) Thực hiện mã hóa và giải mã dữ liệu trong suốt cho cơ sở dữ liệu QLDA

USE master; 
GO 

--Create the master key which is stored in the master database 
IF  NOT  EXISTS  (SELECT  *  FROM  sys.symmetric_keys  WHERE  symmetric_key_id  = 
101)  CREATE  MASTER  KEY  ENCRYPTION  BY  PASSWORD  = 
'Th15i$aS7riN&ofR@nD0m!T3%t'
GO

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'mystrongpassword$$'; 

drop master key 
GO 

-- check
SELECT * FROM  sys.symmetric_keys

-- Create a certificate that is also stored in the master -- database. This certificate will be used 
-- to encrypt a user database 
CREATE CERTIFICATE MyqldaCer with SUBJECT = 'Certificate stored in Master Db' 
GO 
-- check
SELECT * FROM  sys.symmetric_keys

-- Create a Database Encryption Key (DEK) that is based on the
-- previously created certificate The DEK is stored in the user database 
USE QLDA 
GO 
CREATE DATABASE ENCRYPTION KEY WITH ALGORITHM = AES_256 
ENCRYPTION BY SERVER CERTIFICATE MyqldaCer 
GO 

--Turn the encryption on for the QLDA 
ALTER DATABASE QLDA SET ENCRYPTION ON
GO 
--Xem quá trình mã hóa
SELECT  DBName = DB_NAME(database_id), encryption_state FROM sys.dm_database_encryption_keys

select * from sys.certificates