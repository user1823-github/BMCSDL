
--2.4 Tạo 1 trigger giám sát khi người dùng thay đổi đơn giá của bảng sản phẩm. Viết lệnh kiểm tra giám sát vừa thực hiện. Dữ liệu giám sát gổm Masp, TenSp, DonGiaCu, DonGiaMoi, câu lệnh thực hiện, ai thực hiện
Create trigger AUDIT_CAPNHAT_BATTHUONG2 on SanPham for
Update,insert as 
Begin	
Declare @dongiacu int, @dongiamoi int	
Select @dongiamoi = DonGia from inserted	
Select @dongiacu = DonGia from deleted	
if(@dongiamoi >=  @dongiacu)	
	Begin insert into Audit_Update_DonGia(MaSP,TenSP,dongiacu,dongiamoi)		
	Select i.MaSP, i.TenSP, d.DonGia, i.Dongia		
	from inserted i join deleted d		
	on i.MaSP = d.masp	
	End
End

Select * from SanPham
update SanPham set DonGia = DonGia + 5 where MaSP= 3
Select * from Audit_Update_DonGia
--Bài 2.5 Sửa lại Trigger của câu 4 chỉ giám sát khi thay đổi giá mới lớn hơn hay bằng 30% giá cũ, Kiểm tra giám sát vừa thực hiện. Dữ liệu giám sát gổm Masp, TenSp, DonGiaCu, DonGiaMoi, câu lệnh thực hiện, ai thực hiện.
drop trigger AUDIT_CAPNHAT_BATTHUONG2

Create trigger AUDIT_CAPNHAT_BATTHUONG2 on SanPham for
Update,insert as 
Begin	
Declare @dongiacu int, @dongiamoi int	
Select @dongiamoi = DonGia from inserted	
Select @dongiacu = DonGia from deleted	
If(@dongiamoi >=  @dongiacu*0.3)	
	Begin insert into Audit_Update_DonGia(MaSP,TenSP,dongiacu,dongiamoi)		
	Select i.MaSP, i.TenSP, d.DonGia, i.Dongia		
	from inserted i join deleted d		
	on i.MaSP = d.masp	
	End
End


Select * from SanPham
Update SanPham set DonGia = DonGia + 1000 where MaSP= 3
--delete from SanPham where MaSP = 8
Select * from Audit_Update_DonGia



-- 2.6 Tạo login với tên HAI

Create login Hai with password ='HAI'
Create user Hai for login Hai

Grant Select, Insert, Update, Delete on SanPham to Hai

--2.7 Drop table Audit_giam_sat

CREATE TABLE Audit_giam_sat(
	LogEntryID INTEGER IDENTITY PRIMARY KEY,
	EventTime DATETIME DEFAULT GETDATE(),
	UserName SYSNAME DEFAULT SUSER_NAME(),
	EventName VARCHAR(10),
	MaSP int,
	TenSP nvarchar(25),
	DonGiaCu int check (DonGiaCu >= 0),
	DonGiaMoi int check (DonGiaMoi >= 0) NULL,
	SLTK int default (0)
)

Drop trigger Update_Insert_SP
CREATE TRIGGER Update_Insert_SP
ON SanPham
FOR INSERT
AS
If ( EXISTS (Select* FROM inserted)) 
Begin
	INSERT INTO Audit_giam_sat(EventName,MaSP, TenSP, DonGiaCu,DonGiaMoi, SLTK)
	Select 'INSERT', i.MaSP, i.TenSP, i.DonGia, null, i.SLTK
	FROM inserted AS i 
End

Select * from SanPham
insert into SanPham values(N'Cóc',10000,500)
Select * from Audit_giam_sat 
--2.8
CREATE TRIGGER Update_Delete_SP
ON SanPham
FOR DELETE, UPDATE
AS
if ( EXISTS (Select* FROM inserted)) 
Begin
	INSERT INTO Audit_giam_sat(EventName, MaSP, TenSP, DonGiaCu, DonGiaMoi, SLTK)
	Select 'UPDATE', i.MaSP, i.TenSP, d.DonGia, i.DonGia, i.SLTK
	FROM inserted AS i JOIN deleted AS d ON i.MaSP= d.MaSP
End
ELSE
Begin 
	INSERT INTO Audit_giam_sat (EventName, MaSP, TenSP, DonGiaCu, DonGiaMoi, SLTK)
	Select 'DELETE', d.MaSP, d. TenSP, d.DonGia, null, d.SLTK
	FROM deleted AS d
End

UPDATE SanPham 
SET DonGia = 30000
WHERE MaSP = 2

Insert into SanPham values(N'cam',10000,500)
Delete from SanPham where MaSP = 17
Select * FROM SanPham 
Select * FROM Audit_giam_sat


