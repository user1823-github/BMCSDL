-- instance 2

restore log nguyenthanhphat
from disk='E:\HK6\BaoMat_CSDL\TH\buoi10\backup_database\nguyenthanhphat.trn'

-- check
use nguyenthanhphat

select * from PhongBan

