--username = phatbai4, pass = '123456'

use AdventureWorks2008R2
-- Dùng câu lệnh SELECT … FROM… để xem các mẫu tin trong bảng
-- Production.Product, bạn xem được không? Tại sao?
select * from Production.Product

--b. Hiệu chỉnh login ở trên, cho phép login thuộc database Roles tên là db_DataReader
--trong CSDL AdventureWorks2008
--Kiểm tra:
--- Dùng câu lệnh SELECT … FROM… để xem các mẫu tin trong bảng
--Production.Product, bạn xem được không? Tại sao?
--- Dùng câu lệnh INSERT … VALUES để chèn một mẫu tin mới vào bảng
--Production.Product, bạn có chèn được không? Tại sao? Muốn chèn được bạn phải
--làm gì? Thực hiện thử xem sao.
insert into Production.Product([Name], [ProductNumber],[ListPrice],[DaysToManufacture],[SafetyStockLevel],[ReorderPoint],[StandardCost],[SellStartDate])
values (N'Pencil','AR-5382', 15.000, 1, 100, 375, 25.123, '2024-01-24 00:00:00.000')

-- check
select * from Production.Product
where ProductNumber='AR-5382'

--c. Tương tự như vậy, lần lược tìm hiểu các database Roles còn lại.