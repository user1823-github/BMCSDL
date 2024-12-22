CREATE DATABASE quanlycongviec_db
USE quanlycongviec_db

--CÂU1
create table PHONGBAN (
	ID int IDENTITY(1,1) primary key,
	[TÊN PHÒNG BAN] nvarchar(100)
)

create table NHANSU (
	ID int identity(1,1) primary key,
	MANS nvarchar(100),
	[HỌ ĐỆM] nvarchar(100),
	[TÊN] nvarchar(100),
	ID_PHONGBAN int,
	foreign key (ID_PHONGBAN) references PHONGBAN(ID)
)


create table nhansu_mahoa (
	id_mahoa varbinary(max) not null,
	mans_mahoa varbinary(max),
	hodem_mahoa varbinary(max),
	ten_mahoa varbinary(max),
	id_phongban_mahoa varbinary(max)
)

insert into nhansu_mahoa(mans_mahoa)
select mans from NHANSU

UPDATE ns1
SET mans_mahoa = ENCRYPTBYPASSPHRASE('mans', ns2.mans)
FROM nhansu_mahoa AS ns1
INNER JOIN [dbo].[NHANSU] AS ns2 ON ns1.id_mahoa = ns2.id;


select * from NHANSU

drop table PHONGBAN
drop table NHANSU

-- Phong ban
insert into PHONGBAN ([Tên Phòng Ban])
values (N'Phòng Tổng hợp')
insert into PHONGBAN ([Tên Phòng Ban])
values (N'Phòng Kế toán')

select * from PHONGBAN
-- Nhan su
insert into NHANSU (MANS, [HỌ ĐỆM], [TÊN], ID_PHONGBAN)
values ('NV01', N'Nguyễn Văn', N'Thái', 1)
insert into NHANSU (MANS, [HỌ ĐỆM], [TÊN], ID_PHONGBAN)
values ('NV02', N'Trần Thị', N'Lê', 1)
insert into NHANSU (MANS, [HỌ ĐỆM], [TÊN], ID_PHONGBAN)
values ('NV03', N'Quách Văn', N'Hải', 2)
insert into NHANSU (MANS, [HỌ ĐỆM], [TÊN], ID_PHONGBAN)
values ('NV04', N'Thái Thị', N'Huệ', 2)

select * from NHANSU

insert into [dbo].[NHANSU]([MANS],[HỌ ĐỆM],[TÊN],[ID_PHONGBAN])
values (EncryptByPassPhrase('1','NV01'),EncryptByPassPhrase('1',N'Nguyễn Văn'),EncryptByPassPhrase('1',N'Thái'),EncryptByPassPhrase('1','1'))
insert into [dbo].[NHANSU]([MANS],[HỌ ĐỆM],[TÊN],[ID_PHONGBAN])
values (EncryptByPassPhrase('2','NV02'),EncryptByPassPhrase('2',N'Trần Thị'),EncryptByPassPhrase('2',N'Lê'),EncryptByPassPhrase('2','1'))
insert into [dbo].[NHANSU]([MANS],[HỌ ĐỆM],[TÊN],[ID_PHONGBAN])
values (EncryptByPassPhrase('3','NV03'),EncryptByPassPhrase('3',N'Quách Văn'),EncryptByPassPhrase('3',N'Hải'),EncryptByPassPhrase('3','2'))
insert into [dbo].[NHANSU]([MANS],[HỌ ĐỆM],[TÊN],[ID_PHONGBAN])
values (EncryptByPassPhrase('4','NV04'),EncryptByPassPhrase('4',N'Thái Thị'),EncryptByPassPhrase('4',N'Huệ'),EncryptByPassPhrase('4','2'))

-- Cau 1:
-- a). 
use quanlycongviec_db

create login B with password='123456'
create login C with password='123456'

create user B for login B
create user C for login C

grant select, insert, delete, update on NHANSU to B
grant select, insert, delete, update on PHONGBAN to B
grant select, insert, update on PHONGBAN to C


-- b).
create view userc_ketoan
as
select * from NHANSU
where ID_PHONGBAN=2

-- Cau 2:
--a). 
-- add column ma hoa
alter table NHANSU
add mans_mahoa varbinary(max)

alter table NHANSU
add hodem_mahoa varbinary(max)

alter table NHANSU
add ten_mahoa varbinary(max)

alter table NHANSU
add TÊN_mahoa varbinary(max)

alter table NHANSU
add [Họ Đệm_mahoa] varbinary(max)

alter table NHANSU
drop column [Họ Đệm_mahoa]

-- remove column
alter table NHANSU
drop column MANS

alter table NHANSU
drop column [HỌ ĐỆM]

alter table NHANSU
drop column [TÊN]

update NHANSU
set mans_mahoa  = encryptbypassphrase('123', MANS)

update NHANSU
set hodem_mahoa = encryptbypassphrase('123', [HỌ ĐỆM])

update NHANSU
set ten_mahoa   = encryptbypassphrase('123', [TÊN])

select * from NHANSU

--b).
insert into NHANSU(mans_mahoa, HọĐệm_mahoa, ten_mahoa)
values (ENCRYPTBYPASSPHRASE('123', '5'), ENCRYPTBYPASSPHRASE('123', N'Thành'),
ENCRYPTBYPASSPHRASE('123', N'Phát'))

select * from NHANSU

-------
create login B with password ='123456'
create user B for login B

create role ABC
grant select on [HumanResources].[Department](Name, GroupName) to ABC
grant select on [HumanResources].[Department](Name, GroupName) to ABC with grant option


create procedure sp_abc
as
begin
	select * from [Sales].[SalesReason]
end

grant execute on sp_abc to ABC with grant option

select * from [HumanResources].[Department]

create view v_nhansu_ketoan
as  
select * from NHANSU

select * from v_nhansu_ketoan