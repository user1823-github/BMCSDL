--Thực hiện tạo giám sát sự đăng nhập thông qua window application log theo các lệnh sau

--1. Tạo Audit server (lưu file trong application)
use master
CREATE SERVER AUDIT KiemTraDoiTuong
TO FILE(FILEPATH='E:\HK6\BaoMat_CSDL\TH\AuditFile') 


WITH (ON_FAILURE=FAIL_OPERATION, QUEUE_DELAY=0);

--2. Bật lên (Enable) Audit Server
ALTER SERVER AUDIT KiemTraDoiTuong WITH (STATE=ON);

--3. Tạo Server Specificatetionc
CREATE SERVER AUDIT SPECIFICATION ThucThiKiemTraDoiTuong FOR
SERVER AUDIT KiemTraDoiTuong
add (AUDIT_CHANGE_GROUP)

--4. Bật lên Server Specificatetion
ALTER SERVER AUDIT SPECIFICATION ThucThiKiemTraDoiTuong WITH
(STATE=ON);

--5. Thay đổi đường dẫn
ALTER SERVER AUDIT KiemTraDoiTuong WITH (STATE=OFF);
ALTER SERVER AUDIT KiemTraDoiTuong TO FILE(FILEPATH='E:\HK6\BaoMat_CSDL\TH\Audit_2');
ALTER SERVER AUDIT KiemTraDoiTuong WITH (STATE=ON);

--6. Kiểm tra (Test )
--thử xóa hay tạo audit thì sẽ ghi lại
ALTER SERVER AUDIT table_auditing WITH (STATE=OFF);
drop server audit table_auditing 

--7. Truy cập file
SELECT * FROM sys.server_file_audits
SELECT * FROM sys.fn_get_audit_file('E:\HK6\BaoMat_CSDL\TH\Audit_2\*', NULL, NULL);
SELECT * FROM sys.dm_server_audit_status