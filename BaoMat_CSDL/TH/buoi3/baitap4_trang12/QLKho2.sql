-- QLKho2
-- Cho ví dụ kiểm tra các trường hợp đã cấp quyền cho mỗi login thông qua các lệnh insert, update, delete, select
use AdventureWorks2008R2

--6a). lệnh select
select * from Production.WorkOrder

--6b). lệnh insert
insert into Production.Product(Name, ProductNumber, SafetyStockLevel, ReorderPoint, 
StandardCost, ListPrice, DaysToManufacture,SellStartDate)
values ('Banh kem', 'AR-5383', 200, 650, 1.00, 34.99, 1, '2024-07-01 00:00:00.000')


--6c). lệnh update
update Production.Product
set ListPrice = 12000

--6d). lệnh delete
delete Production.Product
where ProductID=1
