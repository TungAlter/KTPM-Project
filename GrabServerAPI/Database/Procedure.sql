INSERT INTO CUSTOMER VALUES (1,'Bronze',N'Nguyễn Lê Duy','duy@gmail.com','035444777','2002-12-04',N'Nam','https://img')
INSERT INTO DRIVER VALUES (2,2,N'Nguyễn Thanh','thanh@gmail.com','035444777','2002-12-04',N'Nam','https://img',9.9,'WAITING')
INSERT INTO DRIVER VALUES (3,2,N'Nguyễn Thanh 3','thanh@gmail.com','035444777','2002-12-04',N'Nam','https://img',9.9,'WAITING')
INSERT INTO DRIVER VALUES (4,2,N'Nguyễn Thanh 4','thanh@gmail.com','035444777','2002-12-04',N'Nam','https://img',9.9,'WAITING')
INSERT INTO DRIVER VALUES (5,2,N'Nguyễn Thanh 5','thanh@gmail.com','035444777','2002-12-04',N'Nam','https://img',9.9,'WAITING')
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
---------------------------- CRUD BOOKING ----------------------------
select* from sys.procedures
CREATE OR ALTER PROC USP_GetAllBooking
	@Id INT
AS
	SELECT * FROM BOOKING WHERE IdCustomer = @Id
GO

EXEC USP_FindDriverBooking 6,6
CREATE OR ALTER PROCEDURE USP_FindDriverBooking
	@startLongi FLOAT,
	@startLati FLOAT
AS
BEGIN
	select TOP 1 d.AccountId, dbo.USF_CaculateDistance(@startLongi,@startLati,
	(select a.Long from ACCOUNT a where a.Id = d.AccountId),
	(select a.Lat from ACCOUNT a where a.Id = d.AccountId)) as Distance
	from DRIVER d 
	where d.WorkStatus = 'WAITING' 
	order by Distance ASC
END;
GO

CREATE OR ALTER FUNCTION USF_CaculateDistance(@x_start FLOAT,@y_start FLOAT,@x_end FLOAT,@y_end FLOAT)
RETURNS FLOAT
BEGIN
	declare @Delta FLOAT
	SET @Delta = sqrt((@x_start-@x_end)*(@x_start-@x_end) + (@y_start-@y_end)*(@y_start-@y_end))
    RETURN @Delta
END;
GO


CREATE OR ALTER PROCEDURE USP_AddBooking
    @IdCustomer INTEGER,
    @srclongi FLOAT,
    @srcLati FLOAT,
    @srcAddress NVARCHAR(200),
    @desLongi FLOAT,
    @desLati FLOAT,
	@desAddress NVARCHAR(200),
	@distance FLOAT,
	@note NVARCHAR(200)
AS
	BEGIN TRY
		DECLARE @Id INT
		EXEC @Id = dbo.USP_GetNextColumnId 'BOOKING', 'IdBooking'
		DECLARE @Total INT
		SET @Total = 15000 * @distance;
		DECLARE @DateBooking Datetime
		SET @DateBooking = GETDATE();
		INSERT INTO BOOKING VALUES (@Id, @IdCustomer, 0, @DateBooking, 'WAITING', @srclongi, @srcLati, @desLongi, @desLati, @distance,@srcAddress,@desAddress,@note,@Total)
		RETURN @Id
	END TRY

	BEGIN CATCH
		PRINT N'Booking insertion error'
		RETURN -1
	END CATCH
GO