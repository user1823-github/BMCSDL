-- Binh

use QLTV
go
select * from Sach
go 

insert into Sach values (4,N'Lý')
go
select * from Sach
go


update Sach
set Name='Sinh'
where ID= 4
go
select * from Sach