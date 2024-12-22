-- 6
-- Đăng nhập vào từng login: user Linh
use ThuVien
go 
-- Lệnh thực hiện được cho login Linh
select * from NhomSachTV

-- Lệnh thực hiện không được cho login Linh
insert into HoaDonTV 
values ('H004', '2024-14-01', 'NV002')  
	 
-- 8 Thực hiện lệnh kiểm tra tương ứng
select * from NhomSachTV
