-- login user: Phat password = '123456'

use cryptdb

-- lệnh thực hiện được: chỉ cho phép user này select trên cột (hodem, ten và phongban)
select convert(nvarchar(max), decryptbypassphrase('mans', hodem)) as hodem,
	   convert(nvarchar(max), decryptbypassphrase('mans', ten)) as ten,
	   convert(nvarchar(max), decryptbypassphrase('mans', phongban)) as phongban
	   from nhansu

-- lệnh không thực hiện được:
select id,
	   convert(nvarchar(max), decryptbypassphrase('mans', hodem)) as hodem,
	   convert(nvarchar(max), decryptbypassphrase('mans', ten)) as ten,
	   convert(nvarchar(max), decryptbypassphrase('mans', phongban)) as phongban
	   from nhansu