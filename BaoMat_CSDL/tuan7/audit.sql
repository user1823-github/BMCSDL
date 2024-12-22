create database test2

use test2

-- tạo bảng DDL_Log
CREATE TABLE DDL_Log(
	PostTime datetime,
	DB_User nvarchar (100),
	Event nvarchar (100),
	TSQL nvarchar (2000)
)

-- tạo Trigger

CREATE TRIGGER myDDLTriggerON DATABASEFOR 
DDL_DATABASE_LEVEL_EVENTSAS
DECLARE @data XML
SET @data = EVENTDATA() 
INSERT DDL_Log (PostTime, DB_User, Event, TSQL)
	VALUES(GETDATE(),CONVERT(nvarchar(100), CURRENT_USER),
	@data.value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(100)'),
	@data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(2000)')
);

insert into bangtest(id)
values ('DHHTTT17B')

select * from dbo.DDL_Log

create trigger thedoi1 on [dbo].[bangtest] after insert as
begin
declare @thoigian datetime
declare @taikhoan nvarchar(50)
set @thoigian = GETDATE()
set @taikhoan = SESSION_USER

insert into dbo.[ghi_log] (loai, bang, thoigian, taikhoan)
values ('insert', 'bangtest', @thoigian, @taikhoan)

end

select * from bangtest

select * from ghi_log

select * from sys.fn_get_audit_file
(
	'E:\HK6\BaoMat_CSDL\TH\iuh_auditing\*.sqlaudit',default, default
)