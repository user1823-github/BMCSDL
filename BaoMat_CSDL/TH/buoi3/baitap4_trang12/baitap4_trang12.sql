--BÀI 4 trang 12
--Bạn tạo login chỉ có quyền được cho (không được có quyền cao hơn), 
--tạo xong bạn phải đăng nhập vào SQL Server bằng chính login vừa tạo, 
--thực hiện kiểm tra quyền bằng cách thực hiện các câu lệnh ứng với quyền 
--được phép và các câu lệnh ứng với quyền không được phép.
use AdventureWorks2008R2
create login phatbai4 with password = '123456' 

create user phatbai4 for login phatbai4

drop user phatbai4
drop login phatbai4

--Kiểm tra:
--- Ở SSMS, kiểm tra xem tên login của bạn có nằm trong nhánh Security\Login
--không? kiểm tra xem tên login của bạn có nằm trong nhánh User của CSDL
--AdventureWorks2008 không? Xem thuộc tính (properties) của nó.
--- Kết nối vào SSMS bằng login vừa tạo
--- Trong mục database bạn có thể nhìn thấy được những database nào? Tại sao?
--- Dùng câu lệnh SELECT … FROM… để xem các mẫu tin trong bảng
--Production.Product, bạn xem được không? Tại sao?
--b. Hiệu chỉnh login ở trên, cho phép login thuộc database Roles tên là db_DataReader
--trong CSDL AdventureWorks2008

--2 . Tạo login dạng Windows Authentication
--Bài tập thực hành Bảo Mật Cơ Sở Dữ Liệu Bộ Môn Hệ Thống Thông Tin
--13
--a. Quay về hệ điều hành tạo một local user account hoặc domain user account được 
--phép kết nối đến máy Server của SQL Server. User account này có tên là Nhanvien1.
--b. Cho phép Nhanvien1 trở thành login của SQL Server, login này chỉ thuộc vào 
--database Roles là db_datareader của CSDL là AdventureWorks2008. (Lưu ý: phải 
--chọn Windows Authentication)
--c. Bạn hãy thử kết nối Server thông qua công cụ SSMS bằng login vừa tạo và kiểm tra 
--quyền của login đối với AdventureWorks2008. 
--(Hướng dẫn: đóng hết các ứng dụng đang chạy, log off user hiện kết nối đến máy, log 
--on vào máy bằng user account vừa tạo, kết nối vào SSMS bằng login) 

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

-- Thêm user vào role
EXEC sp_addrolemember 'NVHoaDon','NVHD1'
EXEC sp_addrolemember 'NVHoaDon','NVHD2'
EXEC sp_addrolemember 'NVHoaDon','NVHD3'

--6. Tạo 3 login dạng SQL Server Authentication, có tên lần lược là QLKho1, QLKho2, 
--QLKho3. 
--Các login này có cùng một quyền hạn là được phép chèn, xóa dữ liệu trên bảng 
--Production.Product; 

--cập nhật duy nhất cột ListPrice trong bảng Production.Product. 

--Chỉ được phép xem (Select) trên bảng Production.WorkOrder. Cho ví dụ kiểm tra các 
--trường hợp đã cấp quyền cho mỗi login thông qua các lệnh insert, update, delete, select



CREATE LOGIN [LAPTOP-UC9S9PR9\Nhanvien1] FROM WINDOWS;






