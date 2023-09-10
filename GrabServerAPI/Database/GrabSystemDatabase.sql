USE GrabSystemDB
GO

-- drop constraints
DECLARE @DropConstraints NVARCHAR(max) = '';
SELECT @DropConstraints += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.'
                        +  QUOTENAME(OBJECT_NAME(parent_object_id)) + ' ' + 'DROP CONSTRAINT' + QUOTENAME(name) + ';' + CHAR(13)
FROM sys.foreign_keys
--SET @DropConstraints = SUBSTRING(@DropConstraints, 1 , LEN(@DropConstraints)-1)
EXECUTE sp_executesql @DropConstraints;
GO

-- drop tables
DECLARE @DropTables NVARCHAR(max) = '';
SELECT @DropTables += 'DROP TABLE ' + QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) + ';' + CHAR(13)
FROM INFORMATION_SCHEMA.TABLES WHERE QUOTENAME(TABLE_SCHEMA) != '[sys]' AND QUOTENAME(TABLE_CATALOG) != '[master]'
--SET @DropTables = SUBSTRING(@DropTables, 1 , LEN(@DropTables)-1)
EXECUTE sp_executesql @DropTables;
GO

CREATE TABLE ACCOUNT (
	Id INTEGER,
	Long FLOAT,
    Lat FLOAT,
    Username VARCHAR(50),
    PasswordHash VARCHAR(500),
    PasswordSalt VARCHAR(500),
    UserRole VARCHAR(50),
    RefreshToken VARCHAR(200),
    TokenCreated DATETIME,
    TokenExpires DATETIME
	
    PRIMARY KEY (Id)
)

CREATE TABLE CUSTOMER (
	AccountId INT,
	UserRank VARCHAR(10),
	FullName NVARCHAR(100),
	Email VARCHAR(100),
	PhoneNumber VARCHAR(50),
	DateBirth DATE,
	Gender NVARCHAR(10),
	Avatar VARCHAR(500)

	PRIMARY KEY(AccountId)
)

CREATE TABLE DRIVER (
	AccountId INT,
	DriverRank VARCHAR(10),
	FullName NVARCHAR(100),
	Email VARCHAR(100),
	PhoneNumber VARCHAR(50),
	DateBirth DATE,
	Gender NVARCHAR(10),
	Avatar VARCHAR(500),
	Rating FLOAT,
	WorkStatus VARCHAR(20) CHECK(WorkStatus IN ('WAITING','WORKING', 'INACTIVE'))

	PRIMARY KEY(AccountId)
)

CREATE TABLE VEHICLE (
	IdVehicle INT,
	IdUser INT,
	NameVehicle NVARCHAR(50),
	LicensePlate VARCHAR(20),
	Seat INT,
	TypeVehicle INT

	PRIMARY KEY(IdVehicle)
)

CREATE TABLE VEHICLE_TYPE (
	IdType INT,
	NameType NVARCHAR(50),
	Price INT,

	PRIMARY KEY(IdType)
)

CREATE TABLE BOOKING (
	IdBooking INT,
	IdCustomer INT,
	IdDriver INT,
	DateBooking DATETIME,
	StatusBooking VARCHAR(20) CHECK(StatusBooking IN ('WAITING','RECEIVED', 'COMPLETED')),
	SrcLong FLOAT,
	SrcLat FLOAT,
	DesLong FLOAT,
	DesLat FLOAT,
	Distance FLOAT,
	SrcAddress NVARCHAR(200),
	DesAddress NVARCHAR (200),
	Note NVARCHAR(200),
	Total INT

	PRIMARY KEY(IdBooking)
)

CREATE TABLE USER_DESTINATION (
	IdLocation INT,
	IdUser INT,
	NameLocation NVARCHAR(50),
	Long FLOAT,
	Lat FLOAT

	PRIMARY KEY(IdLocation)
)
------------------------ KHÓA NGOẠI ----------------------------

-- Table CUSTOMER
ALTER TABLE CUSTOMER
ADD
	CONSTRAINT FK_CUSTOMER_ACCOUNT
	FOREIGN KEY(AccountId)
	REFERENCES ACCOUNT
	ON DELETE CASCADE 

-- Table DRIVER
ALTER TABLE DRIVER
ADD
	CONSTRAINT FK_DRIVER_ACCOUNT
	FOREIGN KEY(AccountId)
	REFERENCES ACCOUNT
	ON DELETE CASCADE

-- Table Booking
ALTER TABLE BOOKING
ADD
	CONSTRAINT FK_BOOKING_DRIVER
	FOREIGN KEY(IdDriver)
	REFERENCES DRIVER
	ON DELETE NO ACTION,

	CONSTRAINT FK_BOOKING_CUSTOMER
	FOREIGN KEY(IdCustomer)
	REFERENCES CUSTOMER
	ON DELETE NO ACTION

-- Table USER_DESTINATION
ALTER TABLE USER_DESTINATION
ADD
	CONSTRAINT FK_USER_DES_CUSTOMER
	FOREIGN KEY(IdUser)
	REFERENCES CUSTOMER
	ON DELETE CASCADE

-- Table VEHICLE
ALTER TABLE VEHICLE
ADD
	CONSTRAINT FK_VEHICLE_DRIVER
	FOREIGN KEY(IdUser)
	REFERENCES DRIVER
	ON DELETE CASCADE,

	CONSTRAINT FK_VEHICLE_VEH_TYPE
	FOREIGN KEY(TypeVehicle)
	REFERENCES VEHICLE_TYPE


-- Tạo 7 Account trên SWAGGER UI để có Id Thêm tài xế và khách hàng
-- Customer Data
INSERT INTO CUSTOMER VALUES(1,'Bronze',N'Khách Hàng 1','customer1@gmail.com','0358889999','2002-11-25',N'Nam','https://image..')
INSERT INTO CUSTOMER VALUES(2,'Bronze',N'Khách Hàng 2','customer2@gmail.com','0351236789','2000-10-19',N'Nữ','https://image..')
-- Driver Data
INSERT INTO DRIVER VALUES(3,'Bronze',N'Tài xế 1','driver1@gmail.com','0123456789','2000-08-19',N'Nam','https://image..',5.9,'WAITING')
INSERT INTO DRIVER VALUES(4,'Bronze',N'Tài xế 2','driver1@gmail.com','0123456789','2000-08-19',N'Nam','https://image..',5.9,'WAITING')
INSERT INTO DRIVER VALUES(5,'Bronze',N'Tài xế 3','driver1@gmail.com','0123456789','2000-08-19',N'Nam','https://image..',5.9,'WAITING')
INSERT INTO DRIVER VALUES(6,'Bronze',N'Tài xế 4','driver1@gmail.com','0123456789','2000-08-19',N'Nam','https://image..',5.9,'WAITING')
INSERT INTO DRIVER VALUES(7,'Bronze',N'Tài xế 5','driver1@gmail.com','0123456789','2000-08-19',N'Nam','https://image..',5.9,'WAITING')