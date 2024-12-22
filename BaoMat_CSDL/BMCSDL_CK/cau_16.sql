create database test

use test

create table SINHVIEN (
	masv int identity,
	hodem nvarchar(100),
	ten nvarchar(100),
	sodienthoai nvarchar(20),
	diachi nvarchar(50),
	sotaikhoan nvarchar(100)
)

insert into SINHVIEN (hodem, ten, sodienthoai, diachi, sotaikhoan)
values (N'Nguyễn Thành', N'Phát', '091234567', N'Gò Vấp', '01122233')

insert into SINHVIEN (hodem, ten, sodienthoai, diachi, sotaikhoan)
values (N'Trần Ngọc', N'Thái', '09321654', N'Q2', '0223344')

insert into SINHVIEN (hodem, ten, sodienthoai, diachi, sotaikhoan)
values (N'Phạm Thanh', N'Trang', '09456789', N'Q5', '0556677')

select * from SINHVIEN

create table SINHVIEN_MAHOA (
	masv_mahoa varbinary(max),
	hodem_mahoa varbinary(max),
	ten_mahoa varbinary(max),
	sodienthoai_mahoa varbinary(max),
	diachi_mahoa varbinary(max),
	sotaikhoan_mahoa varbinary(max)
)


select * from SINHVIEN_MAHOA

-- Chuyển dữ liệu từ bảng SINHVIEN sang bảng SINHVIEN_MAHOA
insert into SINHVIEN_MAHOA (masv_mahoa, hodem_mahoa, ten_mahoa, sodienthoai_mahoa, diachi_mahoa, sotaikhoan_mahoa)
	SELECT ENCRYPTBYPASSPHRASE('1', cast(masv as varchar(100))), ENCRYPTBYPASSPHRASE('1', hodem), ENCRYPTBYPASSPHRASE('1', ten), 
		   ENCRYPTBYPASSPHRASE('1', sodienthoai),  ENCRYPTBYPASSPHRASE('1', diachi),  ENCRYPTBYPASSPHRASE('1', sotaikhoan)
	FROM SINHVIEN

-- Xem
select convert(varchar(max),DECRYPTBYPASSPHRASE('1', masv_mahoa)) as masv,
	convert(nvarchar(max),DECRYPTBYPASSPHRASE('1', hodem_mahoa)) as hodem, 
	convert(nvarchar(max),DECRYPTBYPASSPHRASE('1', ten_mahoa)) as ten, 
	convert(nvarchar(max),DECRYPTBYPASSPHRASE('1', sodienthoai_mahoa)) as sodienthoai, 
	convert(nvarchar(max),DECRYPTBYPASSPHRASE('1', diachi_mahoa)) as diachi, 
	convert(nvarchar(max),DECRYPTBYPASSPHRASE('1', sotaikhoan_mahoa)) as sotaikhoan
	from SINHVIEN_MAHOA

-- Thêm
insert into SINHVIEN_MAHOA
values (ENCRYPTBYPASSPHRASE('1', '4'), ENCRYPTBYPASSPHRASE('1', N'Thanh Long'), 
	    ENCRYPTBYPASSPHRASE('1', N'Lang'), ENCRYPTBYPASSPHRASE('1', N'09643754'),  
		ENCRYPTBYPASSPHRASE('1',  N'Q7'),  ENCRYPTBYPASSPHRASE('1', N'0322233'))

-- Xóa
delete SINHVIEN_MAHOA
where convert(varchar(max), DECRYPTBYPASSPHRASE('1', masv_mahoa)) = 1

-- Sửa
update SINHVIEN_MAHOA
set ten_mahoa = ENCRYPTBYPASSPHRASE('1', N'Thông')
where CONVERT(nvarchar(max), DECRYPTBYPASSPHRASE('1', ten_mahoa)) = N'Thái'
