--BÀI 3: Thực hiện mã hóa và giải mã theo các lệnh sau, bạn hãy giải thích ý nghĩa, chức năng của từng lệnh đã thực hiện. 
--1)  Mã hóa mức cột:
USE AdventureWorks2008R2; 
GO 
--If there is no master key, create one now.
IF  NOT  EXISTS  (SELECT  *  FROM  sys.symmetric_keys  WHERE  symmetric_key_id  = 
101)  CREATE  MASTER  KEY  ENCRYPTION  BY  PASSWORD  = 
'Th15i$aS7riN&ofR@nD0m!T3%t'
GO

--Mã hóa cột sử dụng mật khẩu - Encrypting Columns Using a Passphrase 
select top 5 * from Sales.CreditCard 
go 


USE AdventureWorks2008R2; 
GO 
select  CreditCardID,  CardType,  CardNumber_encrypt  =  CONVERT(varbinary(256), 
CardNumber),  ExpMonth,  ExpYear,  ModifiedDate  into  Sales.CreditCard_encrypt  
from Sales.CreditCard where 1 = 2 

declare @passphrase varchar(128) 
set @passphrase = 'unencrypted credit card numbers are bad, um-kay'
insert Sales.CreditCard_encrypt ( CardType, CardNumber_encrypt, ExpMonth, ExpYear, ModifiedDate)
select  top  5  CardType,  CardNumber_encrypt  =  EncryptByPassPhrase(@passphrase, 
CardNumber), ExpMonth, ExpYear, ModifiedDate from Sales.CreditCard  

select * from Sales.CreditCard_encrypt 
go 

declare @passphrase varchar(128) 
set @passphrase = 'unencrypted credit card numbers are bad, um-kay' 
select  CreditCardID,  CardType,  CardNumber  =  convert(nvarchar(25), 
DecryptByPassPhrase(@passphrase,  CardNumber_encrypt)),  ExpMonth,  ExpYear,
ModifiedDate from Sales.CreditCard_encrypt 
GO
-- The first step is to create the certificate with the CREATE CERTIFICATE command: 
USE AdventureWorks2008R2; 
CREATE CERTIFICATE BillingDept01 WITH SUBJECT = 'Credit Card Billing' 
GO
USE AdventureWorks2008R2; 

CREATE  SYMMETRIC  KEY  BillingKey2010  WITH  ALGORITHM  =  AES_256 
ENCRYPTION BY CERTIFICATE BillingDept01; 
GO
USE AdventureWorks2008R2; 
Truncate table Sales.CreditCard_encrypt 
USE AdventureWorks2008R2;
-- First, decrypt the key using the BillingDept01 certificate 
OPEN  SYMMETRIC  KEY  BillingKey2010  DECRYPTION  BY  CERTIFICATE BillingDept01 
-- Now, insert the rows using the symmetric key 
-- encrypted by the certificate 
insert  Sales.CreditCard_encrypt  (  CardType,  CardNumber_encrypt,  ExpMonth,  ExpYear, 
ModifiedDate ) 
select  top  5  CardType,  CardNumber_encrypt  = 
EncryptByKey(KEY_GUID('BillingKey2010'),  CardNumber),  ExpMonth,  ExpYear, 
ModifiedDate from Sales.CreditCard 

select * from Sales.CreditCard_encrypt 
go

--Giải mã
USE AdventureWorks2008R2; 
OPEN  SYMMETRIC  KEY  BillingKey2010  DECRYPTION  BY  CERTIFICATE 
BillingDept01  Select  CardType,  CardNumber  =  convert(nvarchar(25), 
DecryptByKey(CardNumber_encrypt)),  ExpMonth,  ExpYear,  ModifiedDate  from 
Sales.CreditCard_encrypt

CLOSE SYMMETRIC KEY BillingKey2010 
select  name,  pvt_key_encryption_type,  issuer_name,  subject,  expiry_date  = 
CAST(expiry_date as DATE), start_date = CAST(start_date as DATE) from sys.certificates 
go 

select name, key_length, key_algorithm, algorithm_desc, create_date = CAST(create_date as 
DATE), modify_date = CAST(create_date as DATE), key_guid from sys.symmetric_keys 
go 

--If the usage of the key and certificate are no longer needed, they should be dropped from 
-- the database: 
DROP SYMMETRIC KEY BillingKey2010 
DROP CERTIFICATE BillingDept01
--2)  Mã hóa dữ liệu trong suốt Implementing Transparent Data Encryption

USE master; 
GO 
--Create the master key which is stored in the master database 
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'mystrongpassword$$'; 
GO 
-- Create a certificate that is also stored in the master -- database. This certificate will be used 
-- to encrypt a user database 
CREATE CERTIFICATE MyCertificate with SUBJECT = 'Certificate stored in Master Db' 
GO 
-- Create a Database Encryption Key (DEK) that is based 
-- on the previously created certificate 
-- The DEK is stored in the user database 
USE AdventureWorks2008R2 
GO 
CREATE DATABASE ENCRYPTION KEY WITH ALGORITHM = AES_256 
ENCRYPTION BY SERVER CERTIFICATE MyCertificate 
GO 

CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE MyServerCert;
--Turn the encryption on for the AdventureWorks2008R2 
ALTER DATABASE AdventureWorks2008R2 SET ENCRYPTION ON 
GO 
--Xem quá trình mã hóa
SELECT  DBName  =  DB_NAME(database_id),  encryption_state  FROM sys.dm_database_encryption_keys

select * from sys.certificates