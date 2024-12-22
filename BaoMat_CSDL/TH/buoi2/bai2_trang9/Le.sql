-- Đăng nhập vào từng login: user Le
use QLTV

go 
-- Lệnh thực hiện được cho login Le
select * from DanhMucSach

-- Lệnh thực hiện không được cho login Le
insert into HoaDon 
	values ('H003', '2024-17-01', 'NV001')  
	 
-- 9 kiểm tra: update cho Lê 
update DanhMucSach
set DonGia=25000
where MaNhom='N001'