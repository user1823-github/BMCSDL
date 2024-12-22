create database cryptdb_demotrenlop
use [cryptdb_demotrenlop]
----
insert into [dbo].[sinhvien]([masv],[hodem],[ten],[phongban])
values (EncryptByPassPhrase('123',N'NS01'),
EncryptByPassPhrase('123',N'Nguyễn An'),
EncryptByPassPhrase('123',N'Bình'),
EncryptByPassPhrase('123','1'))
insert into [dbo].[sinhvien]([masv],[hodem],[ten],[phongban])
values (EncryptByPassPhrase('123',N'NS02'),
EncryptByPassPhrase('123',N'Trần Văn'),
EncryptByPassPhrase('123',N'Phát'),
EncryptByPassPhrase('123','1'))
insert into [dbo].[sinhvien]([masv],[hodem],[ten],[phongban])
values (EncryptByPassPhrase('123',N'NS03'),
EncryptByPassPhrase('123',N'Đinh Hải'),
EncryptByPassPhrase('123',N'An'),
EncryptByPassPhrase('123','2'))
---
select * from [dbo].[sinhvien]
---
select CONVERT(nvarchar(max),DecryptByPassPhrase('123',[masv])),
CONVERT(nvarchar(max),DecryptByPassPhrase('123',[hodem])),
CONVERT(nvarchar(max),DecryptByPassPhrase('123',[ten])),
CONVERT(nvarchar(max),DecryptByPassPhrase('123',[phongban]))
from [dbo].[sinhvien]
---
delete from [dbo].[sinhvien]
where CONVERT(nvarchar(max),DecryptByPassPhrase('123',[masv]))='NS01'

update [dbo].[sinhvien]
set [ten]=EncryptByPassPhrase('123',N'Ánh')
where CONVERT(nvarchar(max),DecryptByPassPhrase('123',[ten]))='An'
---
Hai câu store thuộc môn học trước nên các em tự lo.
