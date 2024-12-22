create database cryptdb

use cryptdb

create table nhansu (
	id int primary key identity not null,
	mans varbinary(max),
	hodem varbinary(max),
	ten varbinary(max),
	phongban varbinary(max)
)

drop table nhansu
-- a). insert
insert into nhansu 
	values (ENCRYPTBYPASSPHRASE('mans', N'NS01'), ENCRYPTBYPASSPHRASE('mans', N'Nguyễn An'), ENCRYPTBYPASSPHRASE('mans', N'Bình'), 
	ENCRYPTBYPASSPHRASE('mans', '1'))
insert into nhansu 
	values (ENCRYPTBYPASSPHRASE('mans', N'NS02'), ENCRYPTBYPASSPHRASE('mans', N'Trần Văn'), ENCRYPTBYPASSPHRASE('mans', N'Phát'), 
	ENCRYPTBYPASSPHRASE('mans', '1'))
insert into nhansu 
	values (ENCRYPTBYPASSPHRASE('mans', N'NS03'), ENCRYPTBYPASSPHRASE('mans', N'Đinh Hải'), ENCRYPTBYPASSPHRASE('mans', N'An'), 
	ENCRYPTBYPASSPHRASE('mans', '2'))

select * from nhansu
-- b). select 
select convert(nvarchar(max),DECRYPTBYPASSPHRASE('mans', mans)) as mans, 
	   convert(nvarchar(max),DECRYPTBYPASSPHRASE('mans', hodem)) as hodem,
	   convert(nvarchar(max),DECRYPTBYPASSPHRASE('mans', ten)) as ten,
	   convert(nvarchar(max),DECRYPTBYPASSPHRASE('mans', phongban)) as phongban
	   from nhansu


-- c). delete
delete nhansu
where convert(nvarchar(max), DECRYPTBYPASSPHRASE('mans', mans)) = 'NS01'

-- check
select convert(nvarchar(max),DECRYPTBYPASSPHRASE('mans', mans)) as mans, 
	   convert(nvarchar(max),DECRYPTBYPASSPHRASE('mans', hodem)) as hodem,
	   convert(nvarchar(max),DECRYPTBYPASSPHRASE('mans', ten)) as ten,
	   convert(nvarchar(max),DECRYPTBYPASSPHRASE('mans', phongban)) as phongban
	   from nhansu

-- d). update 
update nhansu 
set ten= ENCRYPTBYPASSPHRASE('mans', N'Ánh')
where convert(nvarchar(max),DECRYPTBYPASSPHRASE('mans', ten) )= 'An'

-- check
select convert(nvarchar(max),DECRYPTBYPASSPHRASE('mans', mans)) as mans, 
	   convert(nvarchar(max),DECRYPTBYPASSPHRASE('mans', hodem)) as hodem,
	   convert(nvarchar(max),DECRYPTBYPASSPHRASE('mans', ten)) as ten,
	   convert(nvarchar(max),DECRYPTBYPASSPHRASE('mans', phongban)) as phongban
	   from nhansu

	 
-- e). Tạo procedure insert_nhansu
create proc insert_nhansu (@key nvarchar(max), @mans nvarchar(max), @hodem nvarchar(max), @ten nvarchar(max), @phongban nvarchar(max))
as
begin
	insert into nhansu(mans, hodem, ten, phongban)
	values (ENCRYPTBYPASSPHRASE(@key, @mans), ENCRYPTBYPASSPHRASE(@key, @hodem),
	ENCRYPTBYPASSPHRASE(@key, @ten), ENCRYPTBYPASSPHRASE(@key, @phongban))
end

drop proc insert_nhansu

-- Gọi stored procedure với các biến
exec insert_nhansu 'mans', N'NS04', N'Nguyễn Thành', N'Phát', N'1'
 

-- check
select convert(nvarchar(max),DECRYPTBYPASSPHRASE('mans', mans)) as mans, 
	   convert(nvarchar(max),DECRYPTBYPASSPHRASE('mans', hodem)) as hodem,
	   convert(nvarchar(max),DECRYPTBYPASSPHRASE('mans', ten)) as ten,
	   convert(nvarchar(max),DECRYPTBYPASSPHRASE('mans', phongban)) as phongban
	   from nhansu
	     
-- f). Tạo procedure search_nhansu 
go
create proc search_nhansu (@ten nvarchar(max))
as 
	select id, convert(varchar(max),DECRYPTBYPASSPHRASE('mans', mans)) as mans, 
	convert(nvarchar(max),DECRYPTBYPASSPHRASE('mans', hodem)) as hodem,
	convert(nvarchar(max),DECRYPTBYPASSPHRASE('mans', ten)) as ten, phongban
	from nhansu
	where convert(nvarchar(max), DECRYPTBYPASSPHRASE('mans', ten)) = @ten 

declare @tenSearch nvarchar(max)
set @tenSearch = N'Phát'

-- Thực thi
exec search_nhansu @ten = @tenSearch 

exec search_nhansu N'Phát'

-- Bài tập bổ sung: tiếp theo

-- 1. Tạo 1 user mật khẩu 123456
create login Phat with password = '123456'
create user Phat for login Phat

-- 2. Gán quyền chỉ cho user này select trên cột hodem và ten và phongban
grant select on nhansu(hodem, ten, phongban) to Phat 
