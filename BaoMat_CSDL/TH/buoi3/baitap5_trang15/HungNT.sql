-- user: HungNT: pass = 'Abc12345'
use QuanLyNhanSu

--1.1) Thêm vào bảng nhân viên dòng dữ liệu (‘A01’, ‘Nguyễn Anh Linh’,
--‘1/2/88’,’TPHCM’)
insert into NhanVien
	values ('A01', N'Nguyễn Anh Linh', '1/2/88', 'TPHCM')


--2.1) Xem thông tin bảng nhân viên
select MaNV, TenNv from NhanVien

--3.1) Sửa dữ liệu nơi sinh cho nhân viên này thành Hà Nội
update NhanVien
set NoiSinh= N'Hà Nội'
where MaNv='A01'

-- check
select MaNV, TenNv from NhanVien

--4.1) Xóa nhân viên này khỏi bảng nhân viên
delete NhanVien
where MaNv='A01'

-- 5). Thêm quyền update bảng LuongNV cho user HungNT
update LuongNV
set NoiSinh= N'Hà Nội'
where MaNv='A01'


--1.2) Thêm vào bảng LuongNV dòng dữ liệu (‘A01’, ‘Nguyễn Anh Linh’,
--‘1/2/88’,’TPHCM’)
insert into LuongNV
	values ('A01', '12', 1200000)


--2.2) Xem thông tin bảng LuongNV
select * from LuongNV

--3.2) Sửa dữ liệu nơi sinh cho nhân viên này thành Hà Nội
update LuongNV
set Luong = 1500000
where MaNv='A01'

-- check
select MaNV, TenNv from LuongNV

--4.2) Xóa nhân viên này khỏi bảng nhân viên
delete LuongNV
where MaNv='A01'

--Bảng LuongNV
create table LuongNV (
	MaNv varchar(20) primary key,
	NamThang varchar(7),
	Luong float
)
