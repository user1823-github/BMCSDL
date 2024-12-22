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

select ID, 
	CONVERT (nvarchar(50), DecryptByPassPhrase('1', MANS)) as MANS,
	CONVERT (nvarchar(100), DecryptByPassPhrase('2', 'HỌ ĐỆM')) as HỌ ĐỆM,
	CONVERT (nvarchar(50), DecryptByPassPhrase('3', 'TÊN')) as TÊN,
	CONVERT (varchar(50), DecryptByPassPhrase('4', ID_PHONGBAN)) as ID_PHONGBAN
from NHANSU

select * from [dbo].[PHONGBAN]

--Tạo login
create login E with password='123456'
create login F with password='123456'

--Tạo user
create user E for login E
create user F for login F

--Phân quyền
grant select, insert, delete, update on NHANSU to E
grant select, insert, delete, update on PHONGBAN to E
grant select, insert, update on PHONGBAN to F

-- Tạo VIEW
CREATE VIEW v_nhanvien_ketoan 
AS
SELECT *
FROM NHANSU
WHERE ID_PHONGBAN = 2;

select * from v_nhanvien_ketoan

-- Phân quyền cho ông C
GRANT SELECT ON v_nhanvien_ketoan TO F;

-- giải thích
VIEW v_nhanvien_ketoan chỉ hiển thị thông tin nhân sự thuộc phòng Kế toán 
(IDPHONGBAN = 2). Ông C chỉ được cấp quyền SELECT trên VIEW này, do đó 
ông chỉ có thể xem thông tin nhân sự phòng Kế toán.

--CÂU2

USE quanlycongviec_db;

ALTER TABLE NHANSU
ADD MANS_MAHOA varbinary(max)
ALTER TABLE NHANSU
ADD TEN_MAHOA varbinary(max)
ALTER TABLE NHANSU
ADD HODEM_MAHOA varbinary(max)



select * from NHANSU

UPDATE NHANSU
SET MANS_MAHOA = CONVERT(VARCHAR(50), CAST(MANS AS VARBINARY(16)), 2),
    HO_DEM_MAHOA = CONVERT(VARCHAR(50), CAST(HO_DEM AS VARBINARY(16)), 2),
    TEN_MAHOA = CONVERT(VARCHAR(50), CAST(TEN AS VARBINARY(16)), 2);

ALTER TABLE NHANSU
DROP COLUMN MANS,
DROP COLUMN HO_DEM,
DROP COLUMN TEN;

ALTER TABLE NHANSU
RENAME COLUMN MANS_MAHOA TO MANS,
RENAME COLUMN HO_DEM_MAHOA TO HO_DEM,
RENAME COLUMN TEN_MAHOA TO TEN;
