
BACKUP MASTER KEY TO FILE = 
'E:\HK6\BaoMat_CSDL\TH\buoi7\test_b4\backup\masterkey'
ENCRYPTION BY PASSWORD = 'somekeybackuppassword$$'

--Backing up the certificate and associated private key also uses the BACKUP command. The
--following example backs up the certificate created in Listing 12.1:

BACKUP CERTIFICATE MyCertificate TO FILE 
= 'E:\HK6\BaoMat_CSDL\TH\buoi7\test_b4\backup\MyCertificate\TDE_CERT.cer'
WITH PRIVATE KEY 
( FILE 
= 'E:\HK6\BaoMat_CSDL\TH\buoi7\test_b4\backup\MyCertificatePrivateKey\pkey.key' ,
ENCRYPTION BY PASSWORD = 'somecertbackuppassword$$' )

select * from sys.certificates
select encryption_state, percent_complete, * from sys.dm_database_encryption_keys