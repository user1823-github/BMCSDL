--Dang nhap bang login Le thuc hien các lệnh sau của role Supervisor 
use QLTV

-- select
go
select * from Sach
go

-- update
update Sach
set Name=N'Giải tích'
where ID = 1
go

select * from Sach

-- delete
delete from Sach where ID=1 
go
select * from Sach