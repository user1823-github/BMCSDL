-- username: Nhanvien1

-- Sử dụng CSDL AdventureWorks2008
USE AdventureWorks2008R2;

-- Tạo Database Role NVHoaDon
CREATE ROLE NVHoaDon;

-- Cấp quyền chèn, cập nhật dữ liệu trong bảng Purchasing.PurchaseOrderHeader
GRANT INSERT, UPDATE ON Purchasing.PurchaseOrderHeader TO NVHoaDon;

-- Cấp quyền chèn, cập nhật dữ liệu trong bảng Purchasing.PurchaseOrderDetail
GRANT INSERT, UPDATE ON Purchasing.PurchaseOrderDetail TO NVHoaDon;

-- Cấp quyền xem (Select) trên bảng Purchasing.WorkOrder trong CSDL ko có table này
GRANT SELECT ON Purchasing.WorkOrder TO NVHoaDon;

--5. Tạo 3 login dạng SQL Server Authentication, có tên lần lượt là NVHD1, NVHD2, 
--NVHD3. Các Login này chỉ thuộc duy nhất DataBase Role là NVHoaDon đã tạo ở trên. 
--Đăng nhập vào từng login NVHD1, NVHD2, NVHD3, ứng với mỗi login thực hiện các 
--công việc sau
create login NVHD1 with password = 'NVHD1'
create login NVHD2 with password = 'NVHD2'
create login NVHD3 with password = 'NVHD3'

create user NVHD1 for login NVHD1
create user NVHD2 for login NVHD2
create user NVHD3 for login NVHD3

--6. Tạo 3 login dạng SQL Server Authentication, có tên lần lược là QLKho1, QLKho2, 
--QLKho3. 
create login QLKho1 with password = 'QLKho1'
create login QLKho2 with password = 'QLKho2'
create login QLKho3 with password = 'QLKho3'

create user QLKho1 for login QLKho1
create user QLKho2 for login QLKho2
create user QLKho3 for login QLKho3

--Các login này có cùng một quyền hạn là được phép chèn, xóa dữ liệu trên bảng 
--Production.Product; 
grant insert, delete on Production.Product to QLKho1
grant insert, delete on Production.Product to QLKho2
grant insert, delete on Production.Product to QLKho3

-- Cập nhật duy nhất cột ListPrice trong bảng Production.Product.
grant update on Production.Product(ListPrice) to QLKho1
grant update on Production.Product(ListPrice) to QLKho2
grant update on Production.Product(ListPrice) to QLKho3

--Chỉ được phép xem (Select) trên bảng Production.WorkOrder. Cho ví dụ kiểm tra các 
--trường hợp đã cấp quyền cho mỗi login thông qua các lệnh insert, update, delete, select
grant select on Production.WorkOrder to QLKho1
grant select on Production.WorkOrder to QLKho2
grant select on Production.WorkOrder to QLKho3

--7. Bạn chọn một giải pháp đơn giản nhất để cho phép các login đã tạo ở trên được phép xem 
--thông tin trong bảng HumanResources.Employee.
grant select on HumanResources.Employee to NVHD1
grant select on HumanResources.Employee to NVHD2
grant select on HumanResources.Employee to NVHD3

grant select on HumanResources.Employee to QLKho1
grant select on HumanResources.Employee to QLKho2
grant select on HumanResources.Employee to QLKho3

--8. Tạo hai login thuộc dạng SQL Server Autehtication, có tên lần lược là PTUD1, PTUD2.
create login PTUD1 with password = 'PTUD1'
create login PTUD2 with password = 'PTUD2'

create user PTUD1 for login PTUD1
create user PTUD2 for login PTUD2

--a, b) Với login PTUD1 có các quyền như sau:
--- Được phép tạo các đối tượng của database
use [AdventureWorks2008R2]
alter role db_owner add member PTUD1
alter role db_owner add member PTUD2
--- Được phép truy xuất và hiệu chỉnh các đối tượng database
grant select, insert, update, delete to PTUD1
grant select, insert, update, delete to PTUD2

--c) Ứng với mỗi login thực hiện các lệnh sau:
--1) Tạo Table UngDung(MaUD int primary key, TenUD nvarchar(30))
--2) Thêm cột TacGia nvarchar(30) vào bảng UngDung
--3) Tăng độ rộng cho cột TenUD lên 50 ký tự
--4) Thêm vào UngDung 2 record có dữ liệu tùy ý
--5) Tạo thủ tục cho phép xem thông tin của một ứng dụng bất kỳ
--6) Xóa dữ liệu có trong bảng UngDung
--7) Chạy thủ tục đã tạo ở câu e
--8) Xóa thủ tục câu e
--Bạn hãy đưa ra kết quả và nhận xét sau khi thực thi mỗi lệnh.

--I. TẠO CÁC ROLES, LOGINS, GÁN CÁC QUYỀN BẰNG T_SQL THÔNG QUA CÁC 
--THỦ TỤC HỆ THỐNG. 
--Chú ý sau mỗi câu bạn thực hiện kiểm tra lại các lệnh bạn vừa thực hiện

--1. Tạo một login dạng Windows Authentication có tên là GD1 (vào hệ điều hành Window 
--tạo user GD1 trước khi tạo ).
create login [LAPTOP-UC9S9PR9\GD1] from windows
create user GD1 for login [LAPTOP-UC9S9PR9\GD1]

--2. Tạo hai login dạng SQL Server Authentication tên là PGD1 và PGD2 có password tùy ý
create login PGD1 with password = 'PGD1'
create login PGD2 with password = 'PGD2'

create user PGD1 for login PGD1
create user PGD2 for login PGD2

--3. Bạn hãy tạo một user-defined role với tên là QLSP có các quyền sau: thêm, xóa, sửa trên 
--bảng Production.Product. 
create role QLSP
grant insert, delete, update on Production.Product to QLSP


--Tạo 3 user ứng với 3 login trên, thực hiện thêm 3 user là thành viên của role QLSP.
exec sp_addrolemember 'QLSP', 'GD1'
exec sp_addrolemember 'QLSP', 'PGD1'
exec sp_addrolemember 'QLSP', 'PGD2'

--4. Giả sử bạn muốn cấm 1 cách tường minh quyền thêm, xóa, sửa trên bảng 
--Production.Product đối với user PGD1, cho dù user này là thành viên của role có các 
--quyền trên (quyền thêm, xóa, sửa trên bảng Production.Product) thì user này cũng bị 
--cấm. Các user khác không bị ảnh hưởng. Bạn thực hiện thế nào?
deny insert, delete, update on Production.Product to PGD1

--5. Ở câu 4 bạn đã cấm quyền thêm, xóa, sửa trên bảng Production.Product đối với user 
--PGD1. Bạn muốn khôi phục lại quyền thêm, xóa, sửa trên bảng Production.Product đối 
--với user PGD1. Bạn thực hiện thế nào?
grant insert, delete, update on Production.Product to PGD1

--6. Ở câu 3 bạn đã cấp quyền cho role QLSP: thêm, xóa, sửa trên bảng Production.Product. 
--Bạn muốn cấm quyền thêm, xóa, sửa trên bảng Production.Product đối với role này. Bạn 
--thực hiện thế nào? Các user là thành viên của role QLSP có các quyền gì ở lúc này?
deny insert, delete, update on Production.Product to QLSP

--7. Tạo hai login dạng SQL Server Authentication có tên là NghiepVu1, NghiepVu2. Tạo 2 
--user NghiepVu1, NghiepVu2 ứng với 2 login trên; 
create login NghiepVu1 with password = 'NghiepVu1'
create login NghiepVu2 with password = 'NghiepVu2'

create user NghiepVu1 for login NghiepVu1
create user NghiepVu2 for login NghiepVu2

--2 user này có các quyền sau: xem và hiệu chỉnh cột ListPrice trong bảng Production.Product 
grant select on Production.Product(ListPrice) to NghiepVu1
grant select on Production.Product(ListPrice) to NghiepVu2

--Xem, hiệu chỉnh, xóa dữ liệu trong bảng Production.WorkOrder và Production.Product, 
--chỉ được phép xem (Select) trên bảng Purchasing.WorkOrder.
grant select, update, delete on Production.WorkOrder to NghiepVu1
grant select, update, delete on Production.WorkOrder to NghiepVu2

grant select, update, delete on Production.Product  to NghiepVu1
grant select, update, delete on Production.Product  to NghiepVu2

grant select on Purchasing.WorkOrder to NghiepVu1
grant select on Purchasing.WorkOrder to NghiepVu2