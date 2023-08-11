﻿USE MASTER
IF DB_ID('GrabSystemDB') IS NOT NULL
	DROP DATABASE GrabSystemDB
GO
CREATE DATABASE GrabSystemDB
GO
USE GrabSystemDB
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
	DriverRank INT,
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
	IdDriver INT,
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
	DesAddress VARCHAR (200),
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

