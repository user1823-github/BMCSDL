select * from sys.fn_get_audit_file
(
	'D:\HK6\BaoMat_CSDL\TH\iuh_auditing\*.sqlaudit', default, default
)

use AdventureWorks2012
select * from Person.Person