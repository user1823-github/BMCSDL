use QLBH

-- Câu 4:
--3) Đăng nhập vào tài khoản user TenBan. Thực hiện chuỗi hành động sau
--1. Tạo một bảng KHACHHANG (MaKH int, TenKH nvarchar(40), Pass nchar(10))
create table [Employees].KHACHHANG (
	MaKH int identity(1,1) primary key, 
	TenKH nvarchar(40), 
	Pass nchar(10)
)

--2. Nhập vào 1 dòng dữ liệu bất kỳ.
insert into KHACHHANG 
	values (N'Thành Phát', 'p123456')

select * from KHACHHANG
--3. Update giá trị vừa insert vào.
update KHACHHANG
set Pass='12345p'
where MaKH=1

select * from KHACHHANG

--4. Xem tất cả dữ liệu của bảng KHACHHANG.
select * from KHACHHANG

--5. Xóa tất cả dữ liệu trong bảng KHACHHANG.
delete KHACHHANG

select * from KHACHHANG
--6. Xóa bảng KHACHHANG.
drop table KHACHHANG