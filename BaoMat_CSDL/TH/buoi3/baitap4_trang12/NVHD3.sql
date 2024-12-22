-- NVHD3
use AdventureWorks2008R2
--- Xem thông tin các bảng Purchasing.PurchaseOrderHeader 
--Purchasing.PurchaseOrderDetail, Purchasing.WorkOrder
select * from Purchasing.PurchaseOrderHeader
select * from Purchasing.PurchaseOrderDetail
select * from Purchasing.WorkOrder

--- Chèn vào các bảng Purchasing.PurchaseOrderHeader 
--Purchasing.PurchaseOrderDetail, Purchasing.WorkOrder, mỗi bảng 1 record 
--với dữ liệu tùy ý, chú ý các ràng buộc khóa ngoại
insert into Purchasing.PurchaseOrderHeader([RevisionNumber],[EmployeeID],[VendorID], [ShipMethodID])
values(2, 3, 1580, 2)


insert into Purchasing.PurchaseOrderDetail([PurchaseOrderID], [UnitPrice],[DueDate], [OrderQty], 
[ProductID], [ReceivedQty], [RejectedQty])
values(1, 2000, '2023-05-31 00:00:00.000', 4, 1, 3.00, 0.00)

--- Xóa một record bất kỳ trong mỗi bảng sau Purchasing.PurchaseOrderHeader 
--Purchasing.PurchaseOrderDetail, Purchasing.WorkOrder.
delete Purchasing.PurchaseOrderHeader
where [PurchaseOrderID]=1

delete Purchasing.PurchaseOrderDetail
where [PurchaseOrderID]=2

--- Nếu thực hiện lệnh Update cho 3 bảng Purchasing.PurchaseOrderHeader 
--Purchasing.PurchaseOrderDetail, Purchasing.WorkOrder có thực hiện được 
--không? Giải thích và cho ví dụ minh họa trong cả 2 trường hợp được hoặc không 
--được.
-- được
update Purchasing.PurchaseOrderHeader 
set Status=2

update Purchasing.PurchaseOrderDetail 
set [UnitPrice]=20.000

-- Không được
update Purchasing.PurchaseOrderHeader 
set Status=2
where [PurchaseOrderID]=1

update Purchasing.PurchaseOrderDetail 
set [UnitPrice]=20.000
where [PurchaseOrderID]=3