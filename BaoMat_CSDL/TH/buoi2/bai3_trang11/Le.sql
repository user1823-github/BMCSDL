-- Đăng nhập vào từng login: user Le
use ThuVien

go 
-- Lệnh thực hiện được cho login Le
select * from ChiTietHDTV

-- Lệnh thực hiện không được cho login Le
insert into HoaDonTV 
	values ('H003', '2024-17-01', 'NV001')  
	 
-- 9 kiểm tra: update cho Lê 
update DanhMucSach
set DonGia=25000
where MaNhom='N001'