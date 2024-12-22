--Dang nhap bang login Minh thuc hien lenh select , insert, update cua role DataEntry
use QLTV

-- select
go
select * from Sach
go
   
-- insert
insert into Sach values (1,'Toán')
go
select * from Sach
go

-- update
update Sach
set Name=N'Hình học'
where ID = 1
go
select * from Sach

go
delete from Sach where ID=1

	
-- Minh gan quyen cho user #
go
use QLTV
go
grant insert on Sach to An

--b. Gán tất cả các quyền mà Minh có cho Binh. Binh có quyền INSERT và
-- UPDATE trên bảng Sach không?
go
grant select,insert,update on Sach to Binh

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