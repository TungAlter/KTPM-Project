GO
USE GrabSystemDB

CREATE OR ALTER PROCEDURE USP_GetNextColumnId(
	@tablename SYSNAME,
	@columnname SYSNAME
)
AS
	DECLARE @IntVariable INT = 0;  
	DECLARE @SQLString NVARCHAR(MAX);  
	DECLARE @ParmDefinition NVARCHAR(500);
  
	SET @SQLString = 
		N'with cte as (select ' + @columnname + ' id, lead(' + @columnname + ') over (order by ' + @columnname + ') nextid from ' + @tablename + ')
		select @gapstartOUT = MIN(id) from cte
		where id < nextid - 1';
	SET @ParmDefinition = N'@gapstartOUT INTEGER OUTPUT';  
  
	EXECUTE sp_executesql @SQLString, @ParmDefinition, @gapstartOUT = @IntVariable OUTPUT;  

	IF (@IntVariable IS NULL)
	BEGIN
		DECLARE @SQL NVARCHAR(MAX);
		SET @SQL = N'select @IdOUT = count(' + @columnname + ') from ' + @tablename + '';
		SET @ParmDefinition = N'@IdOUT INTEGER OUTPUT';
		EXEC sp_executesql @SQL, @ParmDefinition, @IdOUT = @IntVariable OUTPUT;

		RETURN @IntVariable + 1;
	END

	RETURN @IntVariable + 1; 

---------------------------- CRUD ACCOUNT ----------------------------
-- CREATE

CREATE OR ALTER PROCEDURE USP_AddAccount

    @Username VARCHAR(50),
    @PasswordHash VARCHAR(500),
    @PasswordSalt VARCHAR(500),
    @UserRole VARCHAR(50),
    @RefreshToken VARCHAR(200),
    @TokenCreated DATETIME,
    @TokenExpires DATETIME
AS
	BEGIN TRY
		DECLARE @Id INT
		EXEC @Id = dbo.USP_GetNextColumnId 'ACCOUNT', 'Id'

		INSERT INTO ACCOUNT VALUES (@Id, 0.0, 0.0, @Username, @PasswordHash, @PasswordSalt, @UserRole, @RefreshToken, @TokenCreated, @TokenExpires)
		RETURN @Id
	END TRY

	BEGIN CATCH
		PRINT N'Account insertion error'
		RETURN -1
	END CATCH
GO
-- READ
CREATE OR ALTER PROC USP_GetAllAccount
AS
	SELECT * FROM ACCOUNT
GO
--EXEC USP_FindDriver 2.1,3.2
---- TÌM TÀI XẾ
--CREATE OR ALTER PROCEDURE USP_FindDriver -- // 
--	@longi FLOAT,
--	@Lati FLOAT
--AS
--BEGIN
--	DECLARE @Id INT,
--			@Id1 INT
--	SELECT TOP 1 @Id = AccountId FROM DRIVER WHERE WorkStatus = 'WAITING';
--	RESET @Id1 = @Id OUTPUT
--END
--GO

CREATE OR ALTER PROC USP_GetAccountByUsername
	@Username VARCHAR(50)
AS
	SELECT * FROM ACCOUNT where Username like @Username
GO


CREATE OR ALTER PROC USP_GetAccountById
	@Id INT
AS
	IF (@Id = -1)
	BEGIN
		SELECT null;
	END

	SELECT * FROM ACCOUNT where Id = @Id;
GO
-- UPDATE
GO
CREATE OR ALTER PROC USP_UpdateAccount
	@Id INTEGER,
	@Username VARCHAR(50),
	@PasswordHash VARCHAR(500),
	@PasswordSalt VARCHAR(500)
	--@UserRole VARCHAR(50),
 --   @RefreshToken VARCHAR(200),
 --   @TokenCreated DATETIME,
 --   @TokenExpires DATETIME
AS
	BEGIN TRY
		IF NOT EXISTS (SELECT * FROM ACCOUNT WHERE Id = @Id)
		BEGIN
			PRINT N'Account Id not existed'
			RETURN 1
		END

		UPDATE ACCOUNT 
		SET
			Username = @Username,
			PasswordHash = @PasswordHash,
			PasswordSalt = @PasswordSalt
		WHERE Id = @Id
		RETURN 0
	END TRY

	BEGIN CATCH
		PRINT N'Account update error'
		RETURN 1
	END CATCH
GO

GO
CREATE OR ALTER PROC USP_UpdatePositionAccount
	@Id INTEGER,
	@Long FLOAT,
    @Lat FLOAT
	--@UserRole VARCHAR(50),
 --   @RefreshToken VARCHAR(200),
 --   @TokenCreated DATETIME,
 --   @TokenExpires DATETIME
AS
	BEGIN TRY
		IF NOT EXISTS (SELECT * FROM ACCOUNT WHERE Id = @Id)
		BEGIN
			PRINT N'Account Id not existed'
			RETURN 1
		END

		UPDATE ACCOUNT 
		SET
			Long = @Long,
			Lat = @Lat
		WHERE Id = @Id
		RETURN 0
	END TRY

	BEGIN CATCH
		PRINT N'Account update error'
		RETURN 1
	END CATCH
GO
-- UPDATE Status Driver
CREATE OR ALTER PROC USP_UpdateStatusDriver
	@Id INTEGER,
	@Status VARCHAR(20)
AS
	BEGIN TRY
		IF NOT EXISTS (SELECT * FROM ACCOUNT WHERE Id = @Id)
		BEGIN
			PRINT N'Account Id not existed'
			RETURN 1
		END
		UPDATE DRIVER
		SET
			WorkStatus = @Status
		WHERE AccountId = @Id
		RETURN 0
	END TRY

	BEGIN CATCH
		PRINT N'Account update error'
		RETURN 1
	END CATCH
GO
-- DELETE
GO
CREATE OR ALTER PROC USP_DeleteAccount
	@Id INTEGER
AS
	BEGIN TRY
		

		DELETE FROM ACCOUNT WHERE Id = @Id
		RETURN 0
	END TRY

	BEGIN CATCH
		PRINT N'Account deletion error'
		RETURN 1
	END CATCH
GO
-- CRUD CUSTOMER
-- CREATE
CREATE OR ALTER PROCEDURE USP_AddCustomer
    @AccountId INTEGER,
    @Fullname NVARCHAR(100),
	@Email VARCHAR(100),
	@Phone VARCHAR(50),
	@Birth Date,
    @Gender NVARCHAR(50),
	@Avatar VARCHAR(500)
AS
	IF NOT EXISTS (select * from CUSTOMER c where c.AccountId = @AccountId)
	BEGIN
		BEGIN TRAN
		BEGIN TRY


			INSERT INTO CUSTOMER
			VALUES (@AccountId,'Bronze', @Fullname, @Email, @Phone, @Birth, @Gender, @Avatar);

		END TRY

		BEGIN CATCH
			RAISERROR(N'Thêm KHÁCH HÀNG thất bại', 11, 1);
			ROLLBACK;
			RETURN -1; -- (thất bại)
		END CATCH

		COMMIT TRAN;
		RETURN 1; -- (thành công)
END
GO
-- CRUD BOOKING
--CREATE

CREATE OR ALTER PROCEDURE USP_AddBooking
	@fullname NVARCHAR(200),
	@email VARCHAR(100),
	@phone VARCHAR(50),
	@srcaddr NVARCHAR(200),
	@desaddr NVARCHAR(200)
AS
BEGIN
	BEGIN TRAN
	BEGIN TRY
		DECLARE @BookingId INT
		DECLARE	@total INT
		DECLARE @AccountId INT
		IF NOT EXISTS(SELECT * FROM CUSTOMER WHERE PhoneNumber = @phone)
		BEGIN
			EXEC @AccountId = USP_GetNextColumnId 'ACCOUNT','Id'
			INSERT INTO ACCOUNT VALUES (@AccountId,null,null,null,null,null,null,null,null,null)
			INSERT INTO CUSTOMER VALUES (@AccountId,null,@fullname,@email,@phone,null,null,null)
		END
		ELSE
		BEGIN
			SELECT @AccountId = c.AccountId FROM CUSTOMER c where c.PhoneNumber =@phone
		END
		EXEC @BookingId = USP_GetNextColumnId 'BOOKING', 'IdBooking'
		DECLARE @booking_date DATETIME
		select @booking_date  = GETDATE()
		INSERT INTO BOOKING VALUES (@BookingId, @AccountId, null, @booking_date, 'WAITING', null,null,null,null,0,@srcaddr,@desaddr,N'Không',0);

	END TRY

	BEGIN CATCH
		RAISERROR(N'Thêm đơn đặt xe thất bại', 11, 1);
		ROLLBACK;
		RETURN -1; -- (thất bại)
	END CATCH

	COMMIT TRAN;
	RETURN @BookingId; -- (thành công)
END
GO


--READ
-- Lấy tất cả
CREATE OR ALTER PROCEDURE USP_GetAllBooking -- // 
	@AccountId INTEGER
AS
BEGIN
	SELECT * FROM BOOKING WHERE IdCustomer = @AccountId;
END
GO

-- Lấy 3 Cuốc gần nhất
CREATE OR ALTER PROCEDURE USP_Get3RecentBooking -- // 
AS
BEGIN
	SELECT TOP 3  c.FullName,c.Email,c.PhoneNumber,b.SrcAddress,b.DesAddress , b.DateBooking
	FROM BOOKING b join CUSTOMER c on b.IdCustomer = c.AccountId
	WHERE b.StatusBooking = 'COMPLETED'
	ORDER BY DateBooking ASC;
END
GO

-- Lấy các cuốc mới tạo
CREATE OR ALTER PROCEDURE USP_GetNewBooking -- // 
AS
BEGIN
	SELECT c.FullName,c.Email,c.PhoneNumber,b.SrcAddress,b.DesAddress , b.DateBooking
	FROM BOOKING b join CUSTOMER c on b.IdCustomer = c.AccountId
	WHERE b.StatusBooking = 'WAITING';
END
GO
-- Lấy các cuốc đã được tài xế nhận 
CREATE OR ALTER PROCEDURE USP_GetReceivedBooking -- // 
AS
BEGIN
	SELECT c.FullName CustomerName,c.PhoneNumber Phone,d.FullName DriverName,b.SrcAddress,b.DesAddress , b.SrcLong, b.SrcLat, b.DesLong, b.DesLat, b.Distance, b.Total
	FROM BOOKING b join CUSTOMER c on b.IdCustomer = c.AccountId join DRIVER d on d.AccountId = b.IdDriver
	WHERE b.StatusBooking = 'RECEIVED';
END
GO

-- UPDATE
-- Update tính tiền
CREATE OR ALTER PROCEDURE USP_CaculatingTotal
	@BookingId INTEGER,
	@WeatherInfo INTEGER,
	@isPeak BIT

AS
BEGIN
    BEGIN TRY
		IF NOT EXISTS(SELECT* FROM BOOKING WHERE IdBooking = @BookingId and StatusBooking='RECEIVED')
		BEGIN
			RETURN -1
		END
		Declare @total INT
		Declare @distance FLOAT
		select @distance = b.Distance FROM BOOKING b WHERE b.IdBooking = @BookingId 
		IF(@WeatherInfo = 1) -- trời mát
		BEGIN
			SET @total = @distance * 5000
		END
		ELSE IF(@WeatherInfo = 2) -- trời nắng
		BEGIN
			SET @total = @distance * 5400
		END
		ELSE IF(@WeatherInfo = 3) -- trời mưa
		BEGIN
			SET @total = @distance * 5800
		END
		IF(@isPeak = 1)
		BEGIN
			SET @total = @total + 2000
		END
        UPDATE BOOKING
        SET Total = @total WHERE IdBooking = @BookingId;
    END TRY

    BEGIN CATCH
		RAISERROR(N'Tính tiền không thành công.', 11, 1);
        RETURN -1; -- Gán giá trị trả về là -1 (thất bại)
    END CATCH

    RETURN @total;  -- Gán giá trị trả về là 1 (thành công)
END
GO

-- Update vị trí chuyến đi
CREATE OR ALTER PROCEDURE USP_UpdateLocationBooking
	@BookingId INTEGER,
	@srcLong FLOAT,
	@srcLat FLOAT,
	@desLong FLOAT,
    @desLat FLOAT,
	@Distance FLOAT
AS
BEGIN
    BEGIN TRY
		IF NOT EXISTS(SELECT* FROM BOOKING WHERE IdBooking=@BookingId and StatusBooking ='WAITING')
		BEGIN
			RETURN -1
		END
		Declare @d FLOAT
		select @d = Distance FROM BOOKING WHERE IdBooking=@BookingId
		IF(@d != 0)
		BEGIN
			RETURN -1
		END
        UPDATE BOOKING
        SET SrcLong=@srcLong, SrcLat=@srcLat, DesLong=@desLong, DesLat=@desLat,Distance=@Distance
		WHERE IdBooking = @BookingId;
    END TRY

    BEGIN CATCH
		RAISERROR(N'Cập nhật vị trí thất bại.', 11, 1);
        RETURN -1; -- Gán giá trị trả về là -1 (thất bại)
    END CATCH

    RETURN 1;  -- Gán giá trị trả về là 1 (thành công)
END
GO

-- Tìm tài xế nhận chuyến
CREATE OR ALTER PROCEDURE USP_FindDriverForBooking
	@BookingId INTEGER
AS
BEGIN
    BEGIN TRY
		Declare @IdDriver INT
		IF NOT EXISTS(select TOP 1 d.AccountId FROM DRIVER d where d.WorkStatus='WAITING') 
		BEGIN
		RETURN -1;
		END
		ELSE
		BEGIN
			Declare @d FLOAT
			select @d = Distance FROM BOOKING WHERE IdBooking=@BookingId
			IF(@d = 0)
			BEGIN
				RETURN -1
			END
			select TOP 1 @IdDriver = d.AccountId FROM DRIVER d where d.WorkStatus='WAITING'
			UPDATE DRIVER SET WorkStatus = 'WORKING' WHERE AccountId = @IdDriver;
		    UPDATE BOOKING
			SET StatusBooking = 'RECEIVED', IdDriver = @IdDriver
			WHERE IdBooking = @BookingId;
			RETURN 1;
		END
    END TRY
    BEGIN CATCH
		RAISERROR(N'Tìm tài xế thất bại.', 11, 1);
        RETURN -1; -- Gán giá trị trả về là -1 (thất bại)
    END CATCH

    RETURN 0;  -- Gán giá trị trả về là 1 (thành công)
END
GO
-- Lấy Id Tài xế của BOOKING
CREATE OR ALTER FUNCTION USF_GetIdDriverBooking(@BookingId INT)
RETURNS INT
AS
BEGIN
	DECLARE @Id INT;
	SELECT @Id = IdDriver 
	FROM BOOKING 
	WHERE IdBooking = @BookingId
	RETURN @Id;
END
GO
	-- Tài xế hoàn thành chuyến đi
CREATE OR ALTER PROCEDURE USP_UpdateCompleteBooking
	@BookingId INT
AS
BEGIN
    BEGIN TRY
        UPDATE BOOKING
        SET StatusBooking = 'COMPLETED'
		WHERE IdBooking = @BookingId;
		DECLARE @idDriver INT
		SET @idDriver = dbo.USF_GetIdDriverBooking(@BookingId)
		UPDATE DRIVER 
		SET WorkStatus = 'WAITING'
		WHERE AccountId = @idDriver
    END TRY

    BEGIN CATCH
		RAISERROR(N'Cập nhật trạng thái thất bại.', 11, 1);
        RETURN -1; -- Gán giá trị trả về là -1 (thất bại)
    END CATCH

    RETURN 1;  -- Gán giá trị trả về là 0 (thành công)
END
GO
	-- DELETE
CREATE OR ALTER PROCEDURE USP_DeleteBooking
    @BookingId INT
AS
BEGIN
    BEGIN TRANSACTION;

	BEGIN TRY
		-- Xóa đơn đặt chỗ
		DELETE FROM BOOKING
		WHERE IdBooking = @BookingId;
	END TRY

	BEGIN CATCH
		RAISERROR(N'Không thể xóa Booking.', 11, 1)
		ROLLBACK;
		RETURN -1;
	END CATCH

    COMMIT;
	RETURN 0;
END;
GO