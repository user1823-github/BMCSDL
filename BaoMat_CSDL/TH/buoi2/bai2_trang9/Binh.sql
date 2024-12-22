-- Đăng nhập vào từng login: user Binh
use QLTV
go 
-- Lệnh thực hiện được cho login Binh
select * from DanhMucSach
	where MaSach='S112'

-- Lệnh thực hiện không được cho login Binh
delete ChiTietHD

-- 10a. Kiểm tra update, delete cho Binh trên NhomSach
update NhomSach
set TenSach = N'Tắt Đèn'
where MaSach='S111'

delete NhomSach

-- 10b. Kiểm tra update, delete cho Binh trên DanhMucSach
update DanhMucSach
set TacGia = N'Phi Long'
where MaSach='S112'

delete DanhMucSach

