-- Thực hành tuần 2
--Bài 3 trang 11:

-- 1.
create database ThuVien
go
use ThuVien

-- 2. Thực hiện các lệnh import hay Select…into các Table từ CSDL QLTV ở BÀI 1 vào
-- CSDL ThuVien	

-- Thêm dữ liệu bảng: NhomSachTV
go
select MaNhom, TenNhom into [ThuVien].[dbo].[NhomSachTV] 
from QLTV.dbo.NhomSach

select * from NhomSachTV

-- Thêm dữ liệu bảng: NhanVienTV
select * into [ThuVien].[dbo].[NhanVienTV] 
from QLTV.dbo.NhanVien

select * from NhanVienTV

-- Thêm dữ liệu bảng: DanhMucSachTV
select * into [ThuVien].[dbo].[DanhMucSachTV] 
from QLTV.dbo.DanhMucSach

select * from DanhMucSachTV

-- Thêm dữ liệu bảng: HoaDonTV
select * into [ThuVien].[dbo].[HoaDonTV] 
from QLTV.dbo.HoaDon

select * from HoaDonTV
 
-- Thêm dữ liệu bảng: ChiTietHDTV
select * into [ThuVien].[dbo].[ChiTietHDTV] 
from QLTV.dbo.ChiTietHD

select * from ChiTietHDTV
--3) Tạo các users Minh, Huy, Le, Linh, và Binh. Password lần lượt là tên username viết
--hoa.
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

-- 4). Tạo các role sau: QLBH, NVKHO, QLNVTV, QLTV, NVBH cho CSDL ThuVien
create role QLTV
create role QLNVTV
create role QLBH
create role NVBH
create role NVKHO

-- 5). Gán các người dùng Minh, Huy, Le, Linh, Bình vào các Role tương ứng theo ma trận
--phân quyền trong BÀI 1.
-- 5.1 Thêm user vào role
go
EXEC sp_addrolemember 'QLTV','Minh'
go
EXEC sp_addrolemember 'QLNVTV','Huy'
go
EXEC sp_addrolemember 'QLBH','Le'
go
EXEC sp_addrolemember 'NVBH','Linh' 
go 
EXEC sp_addrolemember 'NVKHO','Binh'

-- 5.2. Cho role các quyền như ma trận ở bài 1
go
-- Gán quyền cho role QLTV trên table NhomSachTV 
grant select,insert,update, delete on NhomSachTV to QLTV with grant option

-- Gán quyền cho role QLTV trên table NhanVienTV 
grant select,insert,update, delete on NhanVienTV to QLTV with grant option

ALTER AUTHORIZATION ON OBJECT::NhanVienTV TO QLTV;
grant take ownership on NhanVienTV to QLTV with grant option 
GRANT ALTER ON OBJECT::NhanVienTV TO QLTV WITH GRANT OPTION
grant take ownership on NhanVienTV to QLTV

-- Gán quyền cho role QLTV trên table DanhMucSachTV
grant select, insert, update, delete on DanhMucSachTV to QLTV with grant option

-- Gán quyền cho role QLTV trên table HoaDonTV 
grant select, insert, update, delete on HoaDonTV to QLTV with grant option 

-- Gán quyền cho role QLTV trên table ChiTietHDTV
grant select, insert, update, delete on ChiTietHDTV to QLTV with grant option


--5.1 thực hiện được các lệnh cho user Huy
-- Gán quyền cho Minh theo ma trận phân quyền NhomSachTV
grant select on NhomSachTV to QLNVTV 
-- Gán quyền cho Minh theo ma trận phân quyền NhanVienTV
grant select, insert, update, delete on NhanVienTV to QLNVTV 
-- Gán quyền cho Minh theo ma trận phân quyền DanhMucSachTV
grant select on DanhMucSachTV to QLNVTV 


--5.2 thực hiện được các lệnh cho user Le
-- Gán quyền cho Minh theo ma trận phân quyền NhomSachTV
grant select, update on NhomSachTV to QLBH 
-- Gán quyền cho Minh theo ma trận phân quyền NhanVienTV
grant select on NhanVienTV to QLBH 
-- Gán quyền cho Minh theo ma trận phân quyền DanhMucSachTV
grant select, update on DanhMucSachTV to QLBH 
-- Gán quyền cho Minh theo ma trận phân quyền HoaDonTV
grant select on HoaDonTV to QLBH 
-- Gán quyền cho Minh theo ma trận phân quyền ChiTietHDTV
grant select on ChiTietHDTV to QLBH

--6) Lần lượt đăng nhập vào từng Login và thực hiện các lệnh cho từng người dùng. Các
--lệnh sinh viên tự nghĩ và thực hiện đủ các lệnh trong cả hai trường hợp là người dùng
--thực hiện được và không thực hiện được. Giải thích cho từng lệnh.


--7) Tạo một user mới tên Lan với password là Lan123. Gán quyền update cho user này
--trên cột TenSach của bảng Sach. Thực hiện lệnh kiểm tra tương ứng.

-- 7.1 Tạo login
create login Lan with password='Lan123' 
go
create user Lan for login Lan
go

-- 7.2 Gán quyền update cho user này trên cột TenSach của bảng 
grant update on DanhMucSachTV(TenSach) to Lan

select * from DanhMucSachTV

-- 9) Thu hồi quyền của người dùng có tên Lan
revoke update on DanhMucSachTV(TenSach) from Lan

--10) Tạo một user mới tên Lan với password là Lan123. Gán quyền update cho user này
--trên cột TenSach của bảng Sach. Thực hiện lệnh kiểm tra tương ứng. Viết lệnh DENY
--cho người dùng này

deny update on DanhMucSachTV(TenSach) to Lan
