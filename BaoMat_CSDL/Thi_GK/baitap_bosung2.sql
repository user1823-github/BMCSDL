use AdventureWorks2012

-- a). Tại bảng Person.Address thêm cột AddressLine1_mahoa (varbinary(MAX).
alter table Person.Address
add AddressLine1_mahoa varbinary(max)

-- check
select * from Person.Address
 
-- b). Chuyển đổi dữ liệu từ cột AddressLine1 được lưu mã hóa vào 
-- cột AddressLine1_mahoa với khóa (key) tự chọn.
update Person.Address
set AddressLine1_mahoa = ENCRYPTBYPASSPHRASE('addressmahoa', AddressLine1);

-- check giải mã
select AddressLine1, convert(nvarchar(max), DECRYPTBYPASSPHRASE('addressmahoa', AddressLine1_mahoa)) 
as AddressLine1_mahoa_banro from Person.Address
 
-- check chưa mã hóa
select AddressLine1, AddressLine1_mahoa from Person.Address

 -- c). Hiển thị cột AddressLine1 và bản rõ AddressLine1_mahoa có AddressLine1_mahoa like 'Pacific'
select AddressLine1, convert(nvarchar(max), DECRYPTBYPASSPHRASE('addressmahoa', AddressLine1_mahoa)) 
as AddressLine1_mahoa_banro from Person.Address
where convert(nvarchar(max), DECRYPTBYPASSPHRASE('addressmahoa', AddressLine1_mahoa)) like N'%Pacific%'

select AddressLine1, AddressLine1_mahoa from Person.Address
where AddressLine1 like N'%Pacific%'

-- d)	Cập nhật chữ ‘Pacific’ thành ‘Pacific new’ cho cột AddressLine1_mahoa.
go
update Person.Address
set AddressLine1_mahoa = ENCRYPTBYPASSPHRASE('addressmahoa', N'Pacific new') 
where convert(nvarchar(150), DECRYPTBYPASSPHRASE('addressmahoa', AddressLine1_mahoa)) like N'%Pacific%'

-- check
select AddressLine1, convert(nvarchar(150), DECRYPTBYPASSPHRASE('addressmahoa', AddressLine1_mahoa)) 
as AddressLine1_mahoa_banro from Person.Address
where convert(nvarchar(150), DECRYPTBYPASSPHRASE('addressmahoa', AddressLine1_mahoa)) like N'%Pacific%'