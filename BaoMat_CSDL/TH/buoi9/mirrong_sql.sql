-- instance 1
backup log nguyenthanhphat 
to disk='E:\HK6\BaoMat_CSDL\TH\buoi9\backup\nguyenthanhphat.trn'


-- test insert data từ instance 1
use nguyenthanhphat

select * from PhongBan

insert into PhongBan(tenpb, soluong)
values ('ABC', 13)