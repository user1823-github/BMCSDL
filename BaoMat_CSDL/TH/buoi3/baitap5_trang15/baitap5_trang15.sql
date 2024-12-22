-- 1.1
-- 1.1 Tạo login tên admin1, mật khẩu Abc12345
use master
create login admin1 with password = 'Abc12345'

--1.2 Tạo user thuộc cơ sở dữ liệu master (Databases System Databases master)
create user phatmaster for login admin1

--1.3 Cấp quyền tạo cơ sở dữ liệu, tạo bảng và quyền tạo login cho admin1
grant create database, create table to phatmaster

revoke create database, create table to phatmaster

--2.3 Tạo login chứng thực SQL Server (SQL Server Authencation)
create login LyNT with password = 'Abc12345'
create login HungNT with password = 'Abc12345'

--2.4 Tạo user
create user LyNT for login LyNT
create user HungNT for login HungNT

--2.5 Cấp quyền
use QuanLyNhanSu 
-- gán cho LyNT
grant insert, delete on NhanVien to LyNT
grant insert, delete on LuongNV to LyNT

-- gán cho HungNT
grant select on NhanVien(MaNV, TenNV) to HungNT 
grant update on NhanVien to HungNT 

--5) Thêm quyền cập nhật dữ liệu cho bảng LuongNV cho user HungNT. Sau đó thực hiện
--lại các lệnh trên. Nhận xét.
grant update on LuongNV to HungNT