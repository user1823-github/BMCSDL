CREATE DATABASE DEMO
GO
USE DEMO
GO

-- Tạo bảng sản phẩm
CREATE TABLE SanPham (
    ID INT IDENTITY (1, 1) PRIMARY KEY,
    TenSP NVARCHAR(50),
    DonGia INT CHECK (DonGia >= 0)
);

-- Tạo bảng giám sát insert thành công
CREATE TABLE AUDIT_INSERT_SUCCESS (
    LogID INT IDENTITY PRIMARY KEY,
    EventTime DATETIME DEFAULT GETDATE(),
    UserName SYSNAME DEFAULT SUSER_NAME(),
    ID INT,
    TenSP NVARCHAR(50),
    DonGia INT CHECK (DonGia >= 0)
);

-- Tạo bảng giám sát insert thất bại
CREATE TABLE AUDIT_INSERT_FAILURE (
    LogID INT IDENTITY PRIMARY KEY,
    EventTime DATETIME DEFAULT GETDATE(),
    UserName SYSNAME DEFAULT SUSER_NAME(),
    ErrorMessage NVARCHAR(MAX)
);

-- Tạo procedure kiểm tra quyền insert
CREATE PROCEDURE sp_InsertSanPham
    @TenSP NVARCHAR(50),
    @DonGia INT
AS
BEGIN
    BEGIN TRY
        IF @DonGia >= 0
        BEGIN
            INSERT INTO SanPham (TenSP, DonGia)
            VALUES (@TenSP, @DonGia);

            IF @@ROWCOUNT > 0
            BEGIN
                INSERT INTO AUDIT_INSERT_SUCCESS (ID, TenSP, DonGia)
                VALUES (SCOPE_IDENTITY(), @TenSP, @DonGia);
            END;
        END;
        ELSE
        BEGIN
            -- Ghi log cho insert thất bại
            INSERT INTO AUDIT_INSERT_FAILURE (ErrorMessage)
            VALUES ('Invalid syntax for insert');
        END;
    END TRY
    BEGIN CATCH
        -- Ghi log cho các lỗi khác nếu có
        INSERT INTO AUDIT_INSERT_FAILURE (ErrorMessage)
        VALUES (ERROR_MESSAGE());
    END CATCH;
END;

-- Thực hiện hàm insert để kiểm tra quyền
EXEC sp_InsertSanPham @TenSP = N'Áo New', @DonGia = 75;

-- Thực hiện hàm insert với cú pháp sai để kiểm tra insert thất bại
EXEC sp_InsertSanPham @TenSP = N'Áo Error', @DonGia = -5;

-- Xem dữ liệu mới insert vào 
select*from SanPham


-- Xem kết quả trong bảng giám sát insert thành công
SELECT * FROM AUDIT_INSERT_SUCCESS;

-- Xem kết quả trong bảng giám sát insert thất bại
SELECT * FROM AUDIT_INSERT_FAILURE;
