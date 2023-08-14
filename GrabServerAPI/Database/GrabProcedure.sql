INSERT INTO CUSTOMER VALUES (1,'Bronze', N'Nguyễn Lê Duy', 'duyl111@gmail.com','035123456','08-12-2001','Nam','https:/image')
INSERT INTO CUSTOMER VALUES (2,'Bronze', N'Nguyễn', 'duyl111@gmail.com','035123456','08-12-2001','Nam','https:/image')
INSERT INTO CUSTOMER VALUES (3,'Bronze', N'Lê Duy', 'duyl111@gmail.com','035123456','08-12-2001',N'Nữ','https:/image')
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
    @AccountId INTEGER,
    @srclongi FLOAT,
	@srclati FLOAT,
	@deslongi FLOAT,
	@deslati FLOAT,
    @distance FLOAT,
	@srcaddr NVARCHAR(200),
	@desaddr NVARCHAR(200),
    @note NVARCHAR(200)
AS
BEGIN
	BEGIN TRAN
	BEGIN TRY
		DECLARE @BookingId INT
		DECLARE	@total INT

		SET @total = @distance * 2000;
		

		EXEC @BookingId = USP_GetNextColumnId 'BOOKING', 'IdBooking'

		INSERT INTO BOOKING 
		VALUES (@BookingId, @AccountId, null, GETDATE(), 'WAITING', 
		@srclongi,@srclati,@deslongi,@deslati, @distance, @srcaddr,@desaddr, @note, @total);

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
CREATE OR ALTER PROCEDURE USP_GetAllBooking -- // 
	@AccountId INTEGER
AS
BEGIN
	SELECT * FROM BOOKING WHERE IdCustomer = @AccountId;
END
GO
-- UPDATE
-- Tài xế nhận chuyến
CREATE OR ALTER PROCEDURE USP_UpdateReceiveBooking
	@BookingId INTEGER,
    @DriverId INTEGER
AS
BEGIN
    BEGIN TRY
        UPDATE BOOKING
        SET StatusBooking = 'RECEIVED',
			IdDriver =  @DriverId 
		WHERE IdBooking = @BookingId;
    END TRY

    BEGIN CATCH
		RAISERROR(N'Cập nhật trạng thái thất bại.', 11, 1);
        RETURN -1; -- Gán giá trị trả về là -1 (thất bại)
    END CATCH

    RETURN 0;  -- Gán giá trị trả về là 0 (thành công)
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
    END TRY

    BEGIN CATCH
		RAISERROR(N'Cập nhật trạng thái thất bại.', 11, 1);
        RETURN -1; -- Gán giá trị trả về là -1 (thất bại)
    END CATCH

    RETURN 0;  -- Gán giá trị trả về là 0 (thành công)
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