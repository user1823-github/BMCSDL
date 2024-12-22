--username, password = 'HAI'
use QLBH

-- Thực hiện
update SanPham  
set DonGia=25000
where MaSP=3

-- check
select * from SanPham

select * from ghi_log

select * from ghi_log2
