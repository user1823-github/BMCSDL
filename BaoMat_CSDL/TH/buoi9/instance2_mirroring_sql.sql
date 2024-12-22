-- instance 2
restore log nguyenthanhphat 
from disk='E:\HK6\BaoMat_CSDL\TH\buoi9\backup\nguyenthanhphat.trn'
with norecovery


ALTER DATABASE nguyenthanhphat SET PARTNER = 'TCP://LAPTOP-UC9S9PR9:5023'

use nguyenthanhphat

select * from PhongBan
