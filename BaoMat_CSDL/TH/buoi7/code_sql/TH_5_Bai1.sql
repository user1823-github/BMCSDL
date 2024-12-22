--Bài 1: thực hành tuần 5

USE master
GO

-- Tạo database
CREATE DATABASE EncryptTest
go
USE EncryptTest
GO
CREATE TABLE TestTable (FirstCol INT, SecondCol VARBINARY(256))
go
/* Create Database Master Key */
CREATE MASTER KEY ENCRYPTION
BY PASSWORD = 'SQLAuthority'
GO
/* Create Encryption Certificate */
CREATE CERTIFICATE EncryptTestCert
WITH SUBJECT = 'SQLAuthority'
GO
/* Create Symmetric Key */
CREATE SYMMETRIC KEY TestTableKey
WITH ALGORITHM = TRIPLE_DES ENCRYPTION
BY CERTIFICATE EncryptTestCert
GO
OPEN  SYMMETRIC  KEY  TestTableKey  DECRYPTION  BY  CERTIFICATE 
EncryptTestCert
GO

UPDATE TestTable
SET EncryptSecondCol = ENCRYPTBYKEY(KEY_GUID('TestTableKey'),SecondCol)
GO

INSERT  INTO  TestTable 
values(1,ENCRYPTBYKEY(KEY_GUID('TestTableKey'),'Hello'))
INSERT  INTO  TestTable 
values(2,ENCRYPTBYKEY(KEY_GUID('TestTableKey'),'123456'))
INSERT  INTO  TestTable 
values(3,ENCRYPTBYKEY(KEY_GUID('TestTableKey'),'gogogo'))
go
-- check
SELECT * FROM TestTable
GO
/* Decrypt the data of the SecondCol  */
OPEN  SYMMETRIC  KEY  TestTableKey  DECRYPTION  BY  CERTIFICATE EncryptTestCert


SELECT  CONVERT(VARCHAR(50),DECRYPTBYKEY(SecondCol))  AS 
DecryptSecondCol
FROM TestTable
GO
CLOSE SYMMETRIC KEY TestTableKey
GO

