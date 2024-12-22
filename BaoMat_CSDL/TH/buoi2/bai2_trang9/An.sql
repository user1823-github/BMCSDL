-- Dang nhap bang user AN thuc hien các lệnh sau của role Supervisor
use QLTV

go
select * from Sach
go 

update Sach
set Name=N'Giải tích'
where ID = 1
go
select * from Sach

delete from Sach where ID=1
go
select * from Sach

-- An chay thu quyen dc cap
go
use QLTV
go
insert into Sach values (2,'Hóa')
go
select * from Sach