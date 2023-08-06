DROP DATABASE IF EXISTS GrabSystemDB;
CREATE DATABASE GrabSystemDB CHARACTER SET utf8mb4;
USE GrabSystemDB;

CREATE TABLE ACCOUNT (
    Id INTEGER PRIMARY KEY,
    Longitude FLOAT,
    Latitude FLOAT,
    Username VARCHAR(50),
    PasswordHash VARCHAR(500),
    PasswordSalt VARCHAR(500),
    UserRole VARCHAR(50),
    RefreshToken VARCHAR(200),
    TokenCreated DATETIME,
    TokenExpires DATETIME
);

CREATE TABLE CUSTOMER (
    AccountId INT PRIMARY KEY,
    UserRank VARCHAR(10),
    FullName VARCHAR(100) CHARACTER SET utf8mb4, -- Set the character set to utf8mb4
    Email VARCHAR(100),
    PhoneNumber VARCHAR(50),
    DateBirth DATE,
    Gender VARCHAR(10) CHARACTER SET utf8mb4, -- Set the character set to utf8mb4
    Avatar VARCHAR(500) CHARACTER SET utf8mb4, -- Set the character set to utf8mb4
    FOREIGN KEY (AccountId) REFERENCES ACCOUNT(Id) ON DELETE CASCADE
);

CREATE TABLE DRIVER (
    AccountId INT PRIMARY KEY,
    DriverRank INT,
    FullName VARCHAR(100) CHARACTER SET utf8mb4, -- Set the character set to utf8mb4
    Email VARCHAR(100),
    PhoneNumber VARCHAR(50),
    DateBirth DATE,
    Gender VARCHAR(10) CHARACTER SET utf8mb4, -- Set the character set to utf8mb4
    Avatar VARCHAR(500) CHARACTER SET utf8mb4, -- Set the character set to utf8mb4
    LicenseDate DATE,
    Rating FLOAT,
    WorkStatus VARCHAR(20) CHECK(WorkStatus IN ('WAITING', 'WORKING', 'INACTIVE')),
    FOREIGN KEY (AccountId) REFERENCES ACCOUNT(Id) ON DELETE CASCADE
);

CREATE TABLE VEHICLE (
    IdVehicle INT PRIMARY KEY,
    IdUser INT,
    NameVehicle VARCHAR(50) CHARACTER SET utf8mb4, -- Set the character set to utf8mb4
    LicensePlate VARCHAR(20),
    Seat INT,
    TypeVehicle INT,
    FOREIGN KEY (IdUser) REFERENCES DRIVER(AccountId) ON DELETE CASCADE
);

CREATE TABLE VEHICLE_TYPE (
    IdType INT PRIMARY KEY,
    NameType VARCHAR(50) CHARACTER SET utf8mb4, -- Set the character set to utf8mb4
    Price INT
);

CREATE TABLE BOOKING (
    IdBooking INT PRIMARY KEY,
    IdCustomer INT,
    IdDriver INT,
    DateBooking DATE,
    StatusBooking VARCHAR(20) CHECK(StatusBooking IN ('WAITING', 'RECEIVED', 'COMPLETED')),
    SrcLong FLOAT,
    SrcLat FLOAT,
    DesLong FLOAT,
    DesLat FLOAT,
    Distance FLOAT,
    SrcAddress VARCHAR(200) CHARACTER SET utf8mb4, -- Set the character set to utf8mb4
    DesAddress VARCHAR(200) CHARACTER SET utf8mb4, -- Set the character set to utf8mb4
    Note VARCHAR(200) CHARACTER SET utf8mb4, -- Set the character set to utf8mb4
    Total INT,
    FOREIGN KEY (IdCustomer) REFERENCES CUSTOMER(AccountId) ON DELETE NO ACTION,
    FOREIGN KEY (IdDriver) REFERENCES DRIVER(AccountId) ON DELETE NO ACTION
);

CREATE TABLE USER_DESTINATION (
    IdLocation INT PRIMARY KEY,
    IdUser INT,
    NameLocation VARCHAR(50) CHARACTER SET utf8mb4, -- Set the character set to utf8mb4
    Longitude FLOAT,
    Latitude FLOAT,
    FOREIGN KEY (IdUser) REFERENCES CUSTOMER(AccountId) ON DELETE CASCADE
);
