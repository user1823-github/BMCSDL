--Dang nhap bang login Minh 
	
-- Minh gan quyen cho user #
use QLTV
go 
 
--7.4 thực hiện được các lệnh cho user Linh
-- Gán quyền cho Linh theo ma trận phân quyền NhomSach
grant select on NhomSach to Linh
-- Gán quyền cho Linh theo ma trận phân quyền NhanVien -- chưa xong: mã 112
grant select on NhanVien to Linh 
-- Gán quyền cho Linh theo ma trận phân quyền DanhMucSach
grant select on DanhMucSach to Linh 
-- Gán quyền cho Linh theo ma trận phân quyền HoaDon
grant select,insert,update, delete on HoaDon to Linh 
-- Gán quyền cho Linh theo ma trận phân quyền ChiTietHD
grant select,insert,update, delete on ChiTietHD to Linh

--7.5 thực hiện được các lệnh cho user Binh
-- Gán quyền cho Binh theo ma trận phân quyền NhomSach
grant select,insert,update, delete on NhomSach to Binh
-- Gán quyền cho Binh theo ma trận phân quyền NhanVien -- chưa xong: mã 113
grant select on NhanVien to Binh 
-- Gán quyền cho Binh theo ma trận phân quyền DanhMucSach
grant select,insert,update, delete on DanhMucSach to Binh  


-- Đăng nhập vào từng login: user Minh
-- Lệnh thực hiện được cho login Minh
insert into NhomSach 
	values ('N002', N'Kỹ thuật chăn nuôi')

select * from NhomSach
 
-- Lệnh thực hiện không được cho login Minh
drop table NhomSach

--9. Thu hồi quyền sửa trên bảng DanhMucSach cho người dùng Le. Viết lệnh kiểm tra
--tương ứng.
revoke update on DanhMucSach from Le  

-- 10. Thu hồi quyền sửa và xoá trên bảng NhomSach và DanhMucSach cho người Bình. Viết
--lệnh kiểm tra tương ứng.
revoke update, delete on NhomSach from Binh
revoke update, delete on DanhMucSach from Binh

--11. Viết lệnh từ chối quyền xoá trên bảng NhanVien cho người tên Huy. Viết lệnh kiểm tra
--tương ứng
revoke delete on NhanVien from Huy
