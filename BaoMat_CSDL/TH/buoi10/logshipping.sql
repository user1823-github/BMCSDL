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


insert into NhanVien(hoten, gioitinh, mapb)
values(N'Nguyễn Thành Phát', 1, 2), (N'Nguyễn Văn A', 0, 4), 
	  (N'Trần Văn C', 1, 3), (N'Mai Thị D', 0, 1)


-- check
use nguyenthanhphat

select * from PhongBan
select * from NhanVien


backup log nguyenthanhphat
to disk='E:\HK6\BaoMat_CSDL\TH\buoi10\backup_database\nguyenthanhphat.trn'

-- Test

-- check
use nguyenthanhphat

select * from PhongBan

-- insert dữ liệu
insert into PhongBan 
values ('IT', 20)

-- check

select * from PhongBan