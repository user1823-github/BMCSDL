--Dang nhap bang login Minh 
	
-- Minh gan quyen cho user #
use ThuVien
go


--5.3 thực hiện được các lệnh cho user Linh
-- Gán quyền cho Linh theo ma trận phân quyền NhomSachTV
grant select on NhomSachTV to NVBH
-- Gán quyền cho Linh theo ma trận phân quyền NhanVienTV
grant select on NhanVienTV to NVBH 
-- Gán quyền cho Linh theo ma trận phân quyền DanhMucSachTV
grant select on DanhMucSachTV to NVBH 
-- Gán quyền cho Linh theo ma trận phân quyền HoaDonTV
grant select,insert, update, delete on HoaDonTV to NVBH 
-- Gán quyền cho Linh theo ma trận phân quyền ChiTietHDTV
grant select,insert, update, delete on ChiTietHDTV to NVBH


--5.4 thực hiện được các lệnh cho user Binh
-- Gán quyền cho Binh theo ma trận phân quyền NhomSachTV
grant select,insert, update, delete on NhomSachTV to NVKho
-- Gán quyền cho Binh theo ma trận phân quyền NhanVien 
grant select on NhanVienTV to NVKho 
-- Gán quyền cho Binh theo ma trận phân quyền DanhMucSachTV
grant select,insert, update, delete on DanhMucSachTV to NVKho  

-- 6 Login 
-- Đăng nhập vào từng login: user Minh
-- Lệnh thực hiện được cho login Minh
insert into NhomSachTV 
	values ('N003', N'Kỹ thuật bón phân')

select * from NhomSachTV
 
-- Lệnh thực hiện không được cho login Minh
drop table NhomSachTV

-- 8) Thu hồi quyền cho Role NVBH. Thực hiện lệnh kiểm tra tương ứng
revoke select on NhomSachTV from NVBH
revoke select on NhanVienTV from NVBH
revoke select on DanhMucSachTV from NVBH
revoke select, insert, update, delete on HoaDonTV from NVBH
revoke select, insert, update, delete on ChiTietHDTV from NVBH