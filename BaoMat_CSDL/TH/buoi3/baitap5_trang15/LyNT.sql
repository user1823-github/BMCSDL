-- user: LyNT: pass = 'Abc12345'
use QuanLyNhanSu
--1) Thêm vào bảng nhân viên dòng dữ liệu (‘A01’, ‘Nguyễn Anh Linh’,
--‘1/2/88’,’TPHCM’)
select * from NhanVien

insert into NhanVien
	values ('A01', 'Nguyễn Anh Linh', '1/2/88', 'TPHCM')


use QuanLyNhanSu
create table NhanVien (
	MaNv varchar(20) primary key,
	TenNv nvarchar(100),
	NgaySinh varchar(10),
	NoiSinh nvarchar(50)
)

--Bảng LuongNV
create table LuongNV (
	MaNv varchar(20) primary key,
	NamThang varchar(7),
	Luong float
)

--2) Xem thông tin bảng nhân viên
select * from NhanVien

--3) Sửa dữ liệu nơi sinh cho nhân viên này thành Hà Nội
update NhanVien
set NoiSinh= N'Hà Nội'
where NoiSinh='TPHCM'

--4) Xóa nhân viên này khỏi bảng nhân viên
delete NhanVien
where MaNv='A01'

