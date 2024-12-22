-- phatmaster: admin1 pass = 'Abc12345'

create database QuanLyNhanSu
on primary (
	name='QLNS_data1',
	filename='D:\BMCSDL\QLNS_data1.mdf',
	size=100MB,
	maxsize=unlimited,
	filegrowth=50MB
)
log on (
	name='QLNS_log1',
	filename='D:\BMCSDL\QLNS_log1.ldf',
	size=300MB,
	maxsize=unlimited,
	filegrowth=100MB
)

use QuanLyNhanSu

--2.2 Tạo bảng NhanVien và LuongNV thuộc CSDL QuanLyNhanSu
--Bảng NhanVien
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

--BÀI 5.2
--Câu 1: Tạo database tên QuanLyDaoTao
use master

create database QuanLyDaoTao
on primary (
	name='QLDT_data1.mdf',
	filename='D:\BMCSDL\QLDT_data1.mdf',
	size=100MB,
	maxsize=unlimited,
	filegrowth=10MB
)
log on (
	name='QLDT_log1',
	filename='D:\BMCSDL\QLDT_log1.ldf',
	size=300MB,
	maxsize=unlimited,
	filegrowth=30MB
)

use QuanLyDaoTao

-- Lop
create table Lop (
	MaLop varchar(20) primary key,
	TenLop nvarchar(100)	
)

-- SinhVien
create table SinhVien (
	MaSv varchar(20) primary key,
	TenSv nvarchar(100),
	NgaySinh varchar(10),
	NoiSinh nvarchar(50),
	MaLop varchar(20) foreign key references Lop(MaLop)
)

-- MonHoc
create table MonHoc (
	MaMh varchar(20) primary key,
	TenMh nvarchar(100),
	SoGio int
)

-- DiemTP
create table DiemTP (
	MaSv varchar(20),
	MaMh varchar(20),
	Diem float,
	primary key (MaSv, MaMh)
)

--Câu 3: Thiết lập ràng buộc dữ liệu
-- 3.1 SoGio trong bảng MonHoc chỉ từ 25 đến 4
alter table MonHoc
add constraint check_sogio check (SoGio between 25 and 45) 

-- 3.2 Diem trong bảng DiemTP chỉ nằm trong khoảng từ [0-10]
alter table DiemTP
add constraint check_diem check (Diem between 0 and 10)

-- Câu 4: Thêm dữ liệu cho các bảng
-- Lop
insert into Lop 
	values ('CN0201',N'Khóa 2001')
insert into Lop 
	values ('CN0202',N'Khóa 2002')

-- check
select * from Lop

-- SinhVien
insert into SinhVien 
	values ('sv01',N'Nguyễn Văn Hưng','1988-02-12', 'Hồ Chí Minh', 'CN0201')
insert into SinhVien 
	values ('sv02',N'Lê Hùng','1990-03-17', 'Bình Dương', 'CN0201')
insert into SinhVien 
	values ('sv03',N'Lê Hùng','1991-12-02', 'Bình Dương', 'CN0202')

-- check
select * from SinhVien

-- MonHoc
insert into MonHoc 
	values ('THVP',N'Tin học văn phòng', 45)
insert into MonHoc 
	values ('THDC',N'Tin học đại cương', 45)
insert into MonHoc 
	values ('CSDL',N'Cơ sở dữ liệu', 30)

-- check
select * from MonHoc

-- DiemTP
insert into DiemTP 
	values ('sv01','THVP', 8.0)
insert into DiemTP 
	values ('sv01','THDC', 7.0)
insert into DiemTP 
	values ('sv01','CSDL', 6.0)
insert into DiemTP 
	values ('sv02','THVP', 9.0)
insert into DiemTP 
	values ('sv02','THDC', 4.0)
insert into DiemTP 
	values ('sv02','CSDL', 7.0)
insert into DiemTP 
	values ('sv03','THVP', 5.0)
insert into DiemTP 
	values ('sv03','THDC', 5.0)
insert into DiemTP 
	values ('sv03','CSDL', 5.0)

-- check
select * from DiemTP
 
