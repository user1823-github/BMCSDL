-- Thực hành tuần 2
--Bài 2 trang 9:
--4. Tạo cơ sở dữ liệu QLTV tham số tùy ý. Trong CSDL QLTV có các bảng dữ liệu sau:
create database QLTV
go
use QLTV 

go
create table NhomSach (
	MaNhom char(5) primary key,
	TenNhom nvarchar(25)
)
-- Tạo bảng NhanVien
create table NhanVien (
	MaNV char(5) primary key,
	HoLot nvarchar(25),
	TenNV nvarchar(10), 
	Phai nvarchar(3), 
	NgaySinh Smalldatetime, 
	DiaChi nvarchar(40)
)

-- Tạo bảng DanhMucSach
create table DanhMucSach (
	MaSach char(5) primary key, 
	TenSach nvarchar(40), 
	TacGia nvarchar(20),
	MaNhom char(5) foreign key references NhomSach(MaNhom), 
	DonGia Numeric(5), 
	SoLuongTon numeric(5)
)

-- Tạo bảng HoaDon
create table HoaDon (
	MaHD char(5) primary key, 
	NgayBan SmallDatetime, 
	MaNV char(5) foreign key references NhanVien(MaNV)
)

-- Tạo bảng ChiTietHD
create table ChiTietHD (
	MaHD char(5) primary key, 
	MaSach char(5) foreign key references DanhMucSach(MaSach), 
	SoLuong numeric(5)
)

-- Thêm dữ liệu bảng NhomSach
insert into NhomSach 
	values ('N001', N'Kỹ thuật trồng trọt')

select * from NhomSach  

-- Thêm dữ liệu bảng DanhMucSach
insert into DanhMucSach 
	values ('S111', N'Đèn không hắt bóng', N'Cao Xuân Hạo', 'N001', '55000', '45')
insert into DanhMucSach 
	values ('S112', N'Kỹ thuật trồng hoa phong lan', N'Nguyễn Lân Hùng', 'N001', '45000', '35')
insert into DanhMucSach 
	values ('S113', N'Kỹ thuật chăm sóc hoa mai', N'Lê Xuân A', 'N001', '35000', '15')
insert into DanhMucSach 
	values ('S114', N'Kỹ thuật chăm sóc cây cam', N'Trần Ha', 'N001', '24000', '15')

select * from DanhMucSach   
 
-- Thêm dữ liệu bảng NhanVien
insert into NhanVien 
	values ('NV001', N'Nguyễn', N'Thành Phát', N'Nam', '2002-05-17', N'Thành phố Hồ Chí Minh')
insert into NhanVien 
	values ('NV002', N'Phạm', N'Lan Anh', N'Nữ', '2002-03-20', N'Hà Nội')

select * from NhanVien

-- Thêm dữ liệu bảng HoaDon
insert into HoaDon 
	values ('H001', '2023-10-23', 'NV002')
insert into HoaDon 
	values ('H002', '2023-07-05', 'NV001')

select * from HoaDon 

-- Thêm dữ liệu bảng ChiTietHD
insert into ChiTietHD 
	values ('H001', 'S113', 4)
insert into ChiTietHD 
	values ('H002', 'S111', 7)
 
select * from ChiTietHD 

--5 Tạo các logins:
create login Minh with password='MINH'
go
create user Minh for login Minh
go

create login Huy with password='HUY'
go
create user Huy for login Huy
go

create login Le with password='LE'
go
create user Le for login Le
go

create login Linh with password='LINH'
go
create user Linh for login Linh
go

create login Binh with password='BINH'
go
create user Binh for login Binh

--7. Viết các lệnh phân quyền cho Minh, Huy, Le, Linh, Bình theo ma trận phân quyền trên.
--Chú ý Minh là sở hữu table NhanVien. Bạn viết lệnh phân quyền cho phép Minh tạo và
--7.1 thực hiện được các lệnh cho user Minh

-- Gán quyền cho Minh theo ma trận phân quyền NhomSach
grant select, insert, update, delete on NhomSach to Minh with grant option

-- Thay đổi quyền sở hữu của bảng NhanVien cho user Minh  --- chưa xong: mã 111 
ALTER AUTHORIZATION ON OBJECT::NhanVien TO Minh;
grant take ownership on NhanVien to Minh with grant option
ALTER AUTHORIZATION ON dbo.NhanVien TO Minh with grant option
GRANT ALTER ON OBJECT::NhanVien TO Minh WITH GRANT OPTION;

grant ownership on NhanVien to role Minh
grant ownership on ALL TABLES IN SCHEMA mydb.public TO ROLE analyst COPY CURRENT GRANTS;

--7.2 thực hiện được các lệnh cho user Huy
-- Gán quyền cho Minh theo ma trận phân quyền NhomSach
grant select on NhomSach to Huy 
-- Gán quyền cho Minh theo ma trận phân quyền NhanVien
grant select, insert, update, delete on NhanVien to Huy 
-- Gán quyền cho Minh theo ma trận phân quyền DanhMucSach
grant select, insert, update, delete on DanhMucSach to Huy 


--7.3 thực hiện được các lệnh cho user Le
-- Gán quyền cho Minh theo ma trận phân quyền NhomSach
grant select, update on NhomSach to Le 
-- Gán quyền cho Minh theo ma trận phân quyền NhanVien
grant select on NhanVien to Le 
-- Gán quyền cho Minh theo ma trận phân quyền DanhMucSach
grant select, update on DanhMucSach to Le 
-- Gán quyền cho Minh theo ma trận phân quyền HoaDon
grant select on HoaDon to Le 
-- Gán quyền cho Minh theo ma trận phân quyền ChiTietHD
grant select on ChiTietHD to Le

-- Kiểm tra login và user trong SQL Server

-- Gán quyền cho Minh theo ma trận phân quyền DanhMucSach
grant select, insert, update, delete on DanhMucSach to Minh with grant option
-- Gán quyền cho Minh theo ma trận phân quyền HoaDon
grant select, insert, update, delete on HoaDon to Minh with grant option
-- Gán quyền cho Minh theo ma trận phân quyền ChiTietHD
grant select, insert, update, delete on ChiTietHD to Minh with grant option


-- 9 Thu hồi quyền update của Le

revoke update on DanhMucSach from Le  