-- Name Manager
use QLTV
go
update Sach 
set Name=N'Văn'
where ID=1
go

update Sach
set ID=3
where Name=N'Văn'
