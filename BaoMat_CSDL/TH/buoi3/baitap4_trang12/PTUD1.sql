-- PTUD1 password = 'PTUD1'
use AdventureWorks2008R2

-- 1) Tạo Table UngDung(MaUD int primary key, TenUD nvarchar(30))
create table UngDung(
	MaUD int primary key,
	TenUD nvarchar(30)
)

-- 2) Thêm cột TacGia nvarchar(30) vào bảng UngDung
alter table UngDung
add TacGia nvarchar(30)

-- 3) Tăng độ rộng cho cột TenUD lên 50 ký tự
alter table UngDung
alter column TenUD nvarchar(50)

-- 4) Thêm vào UngDung 2 record có dữ liệu tùy ý
insert into UngDung
values('1', 'VSCode', N'Thành Phát')
insert into UngDung
values('2', 'MySql', N'Lan Anh')

-- check
select * from UngDung

-- 5) Tạo thủ tục cho phép xem thông tin của một ứng dụng bất kỳ
go
create proc search_UngDung(@id int)
as begin
	select * from UngDung
	where MaUD=@id
end

-- check
exec search_UngDung 1

-- 6) Xóa dữ liệu có trong bảng UngDung
delete UngDung
where MaUD=1

--7) Chạy thủ tục đã tạo ở câu e
exec search_UngDung 1

--8) Xóa thủ tục câu e
drop proc search_UngDung

