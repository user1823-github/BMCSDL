-- relication
create database nguyenthanhphat

use nguyenthanhphat

create table PhongBan (
	mapb int identity(1,1) primary key,
	tenpb nvarchar(50),
	soluong int
)

CREATE TABLE NhanVien (
    manv int identity(1,1) primary key,
    hoten nvarchar(50),
    gioitinh bit,
    mapb int,
    CONSTRAINT fk_PhongBan_NhanVien FOREIGN KEY (mapb) REFERENCES PhongBan(mapb)
)

insert into PhongBan (tenpb, soluong)
values(N'Hành chính', 3), (N'Nhân sự', 7), 
	  (N'Kế toán', 2), (N'Phát triển', 16)

select * from PhongBan

insert into NhanVien(hoten, gioitinh, mapb)
values(N'Nguyễn Thành Phát', 1, 2), (N'Nguyễn Văn A', 0, 4), 
	  (N'Trần Văn C', 1, 3), (N'Mai Thị D', 0, 1)

select * from NhanVien

-- check
use nguyenthanhphat

select * from PhongBan
select * from NhanVien

--=============================================================
-- Test cho "snapshot publication"
-- Login instance1: Thử insert 1 dữ liệu
use nguyenthanhphat
insert into NhanVien(hoten, gioitinh, mapb)
values('Text snapshot', 0, 3)

insert into PhongBan (tenpb, soluong)
values(N'Text pb snopshot', 10)

-- Login instance2: Xem dữ liệu thử đã đồng bộ qua chưa
use nguyenthanhphat

select * from NhanVien
select * from PhongBan

--===========================================================
-- Test cho "transaction publication"
-- kiểm tra bên instance1
use nguyenthanhphat
select * from NhanVien
select * from PhongBan	

update NhanVien
set hoten='Text transaction'
where gioitinh=0

update PhongBan
set tenpb='Text transaction phòng ban'
where mapb=1

-- check
select * from NhanVien
select * from PhongBan	

-- Login instance2:
use transacnguyenthanhphat

select * from NhanVien
select * from PhongBan	


-- Login vào instance1: kiểm tra bên instance1
use nguyenthanhphat
select * from NhanVien

select * from PhongBan

insert into NhanVien(hoten, gioitinh, mapb)
values('Text snapshot', 0, 3)

insert into PhongBan (tenpb, soluong)
values(N'Text pb snopshot', 10)

-- Login instance2: Xem dữ liệu thử đã đồng bộ qua chưa
use transacnguyenthanhphat

select * from NhanVien
select * from PhongBan


--===========================================================
-- Test cho "peer-to-peer publication"
-- kiểm tra bên instance1
use nguyenthanhphat
select * from NhanVien
select * from PhongBan	

delete PhongBan
where mapb=5

-- check
select * from PhongBan	

-- Login instance2:
use nguyenthanhphat

select * from NhanVien
select * from PhongBan	


-- Login vào instance1: kiểm tra bên instance1
use nguyenthanhphat
select * from NhanVien

select * from PhongBan

insert into NhanVien(hoten, gioitinh, mapb)
values('Text snapshot', 0, 3)

insert into PhongBan (tenpb, soluong)
values(N'Text pb snopshot', 10)

-- Login instance2: Xem dữ liệu thử đã đồng bộ qua chưa
use transacnguyenthanhphat

select * from NhanVien
select * from PhongBan


DBCC CHECKIDENT ('[NhanVien]', RESEED, 4747030) 









