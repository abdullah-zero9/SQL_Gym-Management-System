/*
								  SQL Project: Gym Management System (GMS)
											  Name: Abdullah
										   Trainee ID: 1271691
										Batch ID: ESAD-CS/PNTL-M/53/01

 ------------------------------------------------------------------------------------------------------

Contents In Order: DDL
	=> Part01: Create A Database
	=> Part02: Create Tables with Column Definition Related to The Project
	=> Part03: Alter, Drop and Modify Tables & Columns
	=> Part04: Create Clustered & NonClustered Index 
	=> Part05: Create Sequence & Alter Sequence
	=> Part06: Create A View & Alter View
	=> Part07: Create Stored Procedure & Alter Stored Procedure
	=> Part08: Create Function (Scalar, Simple Table Valued, Multi-statement Table Valued) & Alter Function
	=> Part09: Create Trigger (For/After Trigger)
	=> Part10: Create Trigger (Instead of Trigger)

---------------------------------------------- Part01 -------------------------------------------
						Check Database Existence & Create Database with Attributes
-----------------------------------------------------------------------------------------------------
*/

USE master
GO

IF DB_ID('GMS') IS NOT NULL
DROP DATABASE GMS
GO

CREATE DATABASE GMS
ON
(
	name = 'GMS_data',
	filename = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\GMS_data.mdf',
	size = 20MB,
	maxsize = 500MB,
	filegrowth = 5%
)
LOG ON
(
	name = 'GMS_log',
	filename = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\GMS_log.ldf',
	size = 5MB,
	maxsize = 150MB,
	filegrowth = 2MB
)
GO
USE GMS
GO
/*
------------------------------ Part02 ------------------------------
		          Create Tables with Column Definition 
-------------------------------------------------------------------------
---------- Table with IDENTITY, PRIMARY KEY & nullability CONSTRAINT ----------
*/

--USE SCHEMA
CREATE TABLE city
(
	cityid INT IDENTITY PRIMARY KEY,
	cityname CHAR(15) NOT NULL,
)
GO
CREATE TABLE country
(
	countryId INT IDENTITY PRIMARY KEY,
	countryName CHAR(15) NOT NULL
)
GO
CREATE TABLE Gender 
(
	gen_Id INT IDENTITY PRIMARY KEY,
	gen_name VARCHAR(15) UNIQUE NOT NULL
)
GO
create table Gym --gym information
(
	gym_id UNIQUEIDENTIFIER PRIMARY KEY,
	gym_name NVARCHAR (100) NOT NULL,
	[address] NVARCHAR(70) NOT NULL,
	countryId INT REFERENCES country(countryId),
	cityId INT REFERENCES city(cityId),
	gym_type VARCHAR (10) DEFAULT 'Man',
	gym_website VARCHAR(30) NULL
)
GO
CREATE TABLE supply --gym equipment supllier & mechanic
(
	eqSupplier_ID VARCHAR(10) PRIMARY KEY,
	eqSupplier_name VARCHAR(30) NULL,
	eqSupplier_phone CHAR(11),
	eqMechanic_phone CHAR(11),
	Comment VARCHAR(20) NULL
)
GO

---------------- Table With Primary Key & Foreign Key, Unique Identifier & Default Constraint --------------
CREATE TABLE Users --gym owner's information
(
	Us_ID VARCHAR(10) PRIMARY KEY, 
	admin_name VARCHAR(30) NOT NULL, --owneer/manager
	email VARCHAR(20) UNIQUE NOT NULL,
	us_name VARCHAR(20),  --for log-in
	[password] VARCHAR(8), --for log-in
	gym_id UNIQUEIDENTIFIER REFERENCES Gym (gym_id)
)
GO
CREATE TABLE Employee --Trainers & others Employee information
(
	Emp_Id VARCHAR(10) PRIMARY KEY,
	Emp_name NVARCHAR(50) NOT NULL,
	Emp_role VARCHAR(20) NOT NULL,
	[address] VARCHAR(70) NOT NULL,
	Emp_mobile CHAR(11) NOT NULL,
	[shift] VARCHAR(10),
	gen_name VARCHAR(15) REFERENCES gender(gen_name)
)
GO
CREATE TABLE Equipment --gym inventory table
(
	eq_ID VARCHAR(10) PRIMARY KEY,
	eq_name NVARCHAR(30) NOT NULL,
	quantity INT,
	eq_catagory VARCHAR(30),
	eq_status VARCHAR(30) DEFAULT 'usable',
	date_of_buy DATE,
	eqSupplier_ID VARCHAR(10) REFERENCES supply (eqSupplier_ID),
	comment VARCHAR(20) NULL
)
GO
CREATE TABLE gym_products
(
	product_Id INT PRIMARY KEY,
	product_name VARCHAR(20) NOT NULL
)
GO
--------------Table with CHECK CONSTRAINT & set CONSTRAINT Name--------------
CREATE TABLE Trainer --gym instructor information
(
	tr_Id VARCHAR(10) PRIMARY KEY,
	tr_name NVARCHAR(50) UNIQUE NOT NULL,
	[address] NVARCHAR(70) NOT NULL,
	countryId INT REFERENCES country(countryId),
	cityId INT REFERENCES city(cityId),
	tr_mobile CHAR (11) UNIQUE CHECK('phone' LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	email VARCHAR(40) UNIQUE CONSTRAINT emailCheck CHECK (email LIKE '%@%' ),
	NID_number CHAR(13) UNIQUE CHECK('nid' LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	[shift] VARCHAR(10),
	[availability] VARCHAR(3) DEFAULT 'Yes', 
	gender_name VARCHAR(15) REFERENCES Gender(gen_name),
	gym_id UNIQUEIDENTIFIER REFERENCES Gym (gym_id)
)
GO
CREATE TABLE Package -- gym package for member
(
	pack_ID VARCHAR(10) PRIMARY KEY,
	pack_name VARCHAR(20) UNIQUE NOT NULL,
	duration VARCHAR(20),
	pack_fee MONEY UNIQUE,
	discount FLOAT DEFAULT 0.10,
	pack_Goal VARCHAR(20),
	tr_id VARCHAR(10) REFERENCES Trainer (tr_id) -- trainer, who assign for this package
)
GO
CREATE TABLE Member --gym member information
(
	mem_ID VARCHAR(10) PRIMARY KEY,
	mem_name NVARCHAR(50) NOT NULL,
	[address] NVARCHAR(70) NOT NULL,
	cityId INT REFERENCES city(cityId),
	countryId INT REFERENCES country(countryId),
	gender_name VARCHAR(15) REFERENCES Gender(gen_name),
	mem_mobile CHAR (11) UNIQUE CHECK(mem_mobile LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	email VARCHAR(40) UNIQUE CONSTRAINT ck_emailCheck CHECK (email LIKE '%@%' ),
	NID_number CHAR(13) ,
	photo VARBINARY(MAX) NULL,
	reference VARCHAR(70) DEFAULT 'N/A',
	age INT NULL,
	[weight] VARCHAR(10),
	height VARCHAR(10),
	body_mass_index FLOAT,
	tr_id VARCHAR(10) REFERENCES Trainer (tr_id),
	pack_name VARCHAR(20) REFERENCES package (pack_name)
)
GO
CREATE TABLE payment --member payment information
(
	pay_Id VARCHAR(10) PRIMARY KEY,
	package_name VARCHAR(20) UNIQUE NOT NULL,
	pack_fee MONEY REFERENCES Package (pack_fee),
	PayAmount MONEY DEFAULT NULL,
	PackageSalesDate DATE,
	mem_id VARCHAR(10) REFERENCES member (mem_id),
	pack_ID VARCHAR(10) REFERENCES Package (pack_ID)
)
GO
CREATE TABLE Employee_salary
(
	ES_ID VARCHAR(20) PRIMARY KEY,
	salary money,
	salary_date DATE,
	tr_ID VARCHAR(10) REFERENCES Trainer (tr_ID),
	Emp_ID VARCHAR(10) REFERENCES Employee (Emp_ID)
)
GO
CREATE TABLE Attendence --attendence of everyone will be count with PunchCard press
(
	punch_Date DATE,
	punch_IN_time TIME,
	punch_out_time TIME,
	mem_ID VARCHAR(10) REFERENCES member (mem_ID),
	tr_ID VARCHAR(10)REFERENCES trainer (tr_ID),
	Emp_ID VARCHAR(10) REFERENCES Employee (Emp_ID)
)
GO
-----------------------CREATE SCHEMA----------------
CREATE SCHEMA gym
GO
--------------Create Table Using New Schema and Composite PRIMARY KEY----------
CREATE TABLE gym.membership_info --brife information of member
(
	mem_ID VARCHAR(10) REFERENCES member (mem_ID),
	pack_ID VARCHAR(10) REFERENCES package (pack_ID),
	pack_name VARCHAR(20) REFERENCES package (pack_name),
	pay_id VARCHAR(10) REFERENCES payment (pay_id),
	pack_StartDate DATE,
	pack_EndDate DATE,
	tr_name NVARCHAR(50) REFERENCES trainer (tr_name),
	PRIMARY KEY (pack_name,tr_name)
)
GO
/*
------------------------------ Part03 ------------------------------
		          Alter, Drop And Modify Tables & Columns
--------------------------------------------------------------------------
*/
---------------- Alter Table Schema--------------
ALTER SCHEMA dbo TRANSFER gym.membership_info
GO
---------------- Update Column Definition --------------
ALTER TABLE membership_info
ALTER COLUMN pack_StartDate DATE NOT NULL
GO
---------------- Add Column With Default Constraint --------------
ALTER TABLE payment
ADD DuePayment MONEY DEFAULT 0.00
GO
---------------- Add Check Constraint With Defining Name --------------
ALTER TABLE Member
ADD CONSTRAINT CK_nidValidate CHECK(nid_number LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
GO
---------------- Drop Column --------------
ALTER TABLE gym_products
DROP COLUMN product_name
GO
-------------- Drop Table --------------
IF OBJECT_ID('gym_products') IS NOT NULL
DROP TABLE gym_products
GO
---------------- Drop Schema --------------
DROP SCHEMA gym
GO
/*
------------------------------  Part04  ------------------------------
		          Create Clustered And Nonclustered Index
--------------------------------------------------------------------------
*/
-- Clustered Index
CREATE CLUSTERED INDEX IX_punch_Date
ON Attendence
(
	punch_Date
)
GO
-- NonClustered Index
CREATE UNIQUE NONCLUSTERED INDEX IX_trainer 
ON trainer
(
	nid_number,
	tr_mobile
)
GO
/*
------------------------------  Part05  ------------------------------
							 Create Sequence
--------------------------------------------------------------------------
*/
CREATE SEQUENCE number_seq
	AS INT
	START WITH 1
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 200
	CYCLE
	CACHE 5
GO
---------------- Alter Sequence --------------
ALTER SEQUENCE number_seq
	MAXVALUE 200
	CYCLE
	CACHE 4
GO
/*
------------------------------  Part06  ------------------------------
							  Create A View
--------------------------------------------------------------------------
*/
CREATE VIEW V_membership_info
AS
SELECT mem_id,pack_name,tr_name FROM membership_info
GO
--create a view for today gym package sales information WITH ENCRYPTION, SCHEMABINDING & WITH CHECK OPTION

CREATE VIEW V_TodayPackageSales
WITH SCHEMABINDING, ENCRYPTION
AS 
SELECT mem_id, pack_name, pay_id, pack_StartDate FROM dbo.membership_info
WHERE CONVERT(DATE, pack_startDate) = CONVERT(DATE, GETDATE())
WITH CHECK OPTION
GO
---------------- Alter View --------------
ALTER VIEW V_membership_info
AS
SELECT mem_id, pack_name, pack_EndDate FROM membership_info
GO
/*
------------------------------  Part07  ------------------------------
							 Stored Procedure
--------------------------------------------------------------------------
*/
---------------- Stored Procedure For Insert Data Using Parameter --------------
CREATE PROCEDURE spInsertMember		@mem_id VARCHAR(10),
									@mem_name NVARCHAR(50),
									@address NVARCHAR(70),
									@gender_name VARCHAR(10),
									@cityId INT,
									@countryId INT,
									@mem_mobile CHAR (11),
									@NID_number CHAR(13),
									@email VARCHAR(40),
									@photo VARBINARY(MAX),
									@age int,
									@weight VARCHAR(10),
									@height VARCHAR(10),
									@body_mass_index float,
									@reference VARCHAR(70)
AS
BEGIN
	INSERT INTO Member(mem_id, mem_name,[address], gender_name, cityId, countryId, mem_mobile,NID_number, email, photo, age, [weight], height, body_mass_index, reference) 
	VALUES(@mem_id, @mem_name, @address, @gender_name, @cityId, @countryId, @mem_mobile, @NID_number, @email, @photo, @age, @weight, @height, @body_mass_index, @reference)
END
GO
---------------- Stored Procedure For Insert Data With Output Parameter --------------
CREATE PROCEDURE spInsertInstructor	@tr_id VARCHAR(10),
									@tr_name NVARCHAR(50) ,
									@address NVARCHAR(70),
									@countryId INT,
									@cityId INT ,
									@tr_mobile CHAR (11),
									@email VARCHAR(40),
									@NID_number CHAR(13),
									@shift VARCHAR(10),
									@availability VARCHAR(3),
									@gym_name NVARCHAR (100),
									@Id INT 
									OUTPUT
AS
BEGIN
	INSERT INTO Trainer (tr_id,tr_name, [address], countryId, cityId, tr_mobile, email, NID_number, [shift], [availability]) 
	VALUES(@tr_id, @tr_name, @address, @countryId, @cityId, @tr_mobile, @email, @NID_number, @shift, @availability)
	SELECT @Id = IDENT_CURRENT('instructor')
END
GO
---------------- Stored Procedure For Update Data --------------
CREATE PROCEDURE spUpdateMemberPayment	@mem_Id INT,
										@PayAmount MONEY
AS
BEGIN
	UPDATE payment
	SET
	PayAmount = @PayAmount
	WHERE mem_Id = @mem_Id
END
GO
---------------- Stored Procedure For Delete Table Data --------------
CREATE PROCEDURE spDeletePackage @pack_Id INT
AS
BEGIN
	DELETE FROM package
	WHERE pack_Id = @pack_Id
END
GO
---------------- Try Catch In A Stored Procedure & Raiserror With Error Number And Error Message --------------
CREATE PROCEDURE spRaisError
AS
BEGIN
	BEGIN TRY
		DELETE FROM equipment
	END TRY
	BEGIN CATCH
		DECLARE @Error VARCHAR(200) = 'Error' + CONVERT(varchar, ERROR_NUMBER(), 1) + ' : ' + ERROR_MESSAGE()
		RAISERROR(@Error, 1, 1)
	END CATCH
END
GO
---------------- Alter Stored Procedure --------------
ALTER PROCEDURE spUpdateMemberPayment	
									@mem_Id VARCHAR(10),
									@PayAmount MONEY,
									@pack_name VARCHAR(20)
AS
BEGIN
	UPDATE member
	SET
	pack_name = @pack_name
	WHERE mem_Id = @mem_Id
END
GO
/*
------------------------------  Part08  ------------------------------
								 Function
--------------------------------------------------------------------------
*/

---------------- A Scalar Function --------------
CREATE FUNCTION fn_thisYearSales()
RETURNS MONEY
AS
BEGIN
	DECLARE @totalPackageSales MONEY

	SELECT @totalPackageSales = SUM((PayAmount))
	FROM payment
	WHERE YEAR(payment.PackageSalesDate) = YEAR(GETDATE())
	RETURN @totalPackageSales
END
GO
---------------- A Simple Table Valued Function --------------
CREATE FUNCTION fn_MonthlyPackageSales
									(@year INT, 
									 @month INT)
RETURNS TABLE
AS
RETURN
(
	SELECT 
			SUM(pack_fee) AS 'Net Sales',
			SUM(PayAmount) AS 'Total Sales'
	FROM payment
WHERE 
	YEAR(payment.PackageSalesDate) = @year AND 
	MONTH(payment.PackageSalesDate) = @month
)
GO

---------------- A Multistatement Table Valued Function --------------
CREATE FUNCTION fn_MonthlyPackageSale
										(@year INT, 
										 @month INT)
RETURNS @sales TABLE
(
	pay_Id INT,
	package_name VARCHAR(20),
	PackageSalesDate DATE,
	PayAmount MONEY
)
AS
BEGIN	
	INSERT INTO @sales
	SELECT
	payment.pay_Id INT,
	payment.package_name,
	payment.PackageSalesDate,
	payment.PayAmount
	FROM payment
	INNER JOIN member ON member.mem_Id = payment.mem_Id 
	INNER JOIN package ON package.pack_Id = payment.pack_Id
WHERE 
	YEAR(payment.PackageSalesDate) = @year AND 
	MONTH(payment.PackageSalesDate) = @month
	RETURN
END
GO

---------------- Alter Function --------------
ALTER FUNCTION fn_MonthlyPackageSales
									(@year INT, 
									 @month INT)
RETURNS TABLE
AS
RETURN
(
	SELECT 
			SUM(pack_fee) AS 'Total Sales',
			SUM(PayAmount) AS 'Net Sales'
	FROM payment
WHERE 
	YEAR(payment.PackageSalesDate) = @year AND 
	MONTH(payment.PackageSalesDate) = @month
)
GO
/*
------------------------------  Part09  ------------------------------
							For/After Trigger
--------------------------------------------------------------------------
*/
-- Creating trigger for payment table and update in membership_info table
CREATE TRIGGER trPaymentClear
ON Payment
FOR INSERT
AS
BEGIN
	DECLARE @pid INT
	DECLARE @soldToMember MONEY

	SELECT
	@pid = pay_ID,
	@soldToMember = inserted.pack_fee
	FROM inserted

	UPDATE membership_info
	SET pack_fee = pack_fee + @soldToMember
	WHERE pay_ID = @pid
	PRINT 'package sold to new member'
END
GO
---------------- An After/For Trigger For Insert, Update, Delete --------------
--Creating trigger for payment table and update in membership_info table
CREATE TRIGGER trPaymentClears
ON payment
FOR INSERT, UPDATE, DELETE
AS
	BEGIN
		DECLARE @pid INT
		DECLARE @soldToMember MONEY
				-- Check if this trigger is executed only for updated
		IF (EXISTS(SELECT * FROM INSERTED) AND EXISTS(SELECT * FROM DELETED))
					BEGIN
						UPDATE membership_info
						SET pack_fee = pack_fee + @soldToMember
						WHERE Package.pack_ID = membership_info.pack_ID
						PRINT 'membership updated '
					END
--Check if this trigger is for only for inserted
		ELSE IF (EXISTS(SELECT * FROM INSERTED) AND NOT EXISTS(SELECT * FROM DELETED))
					BEGIN
						SELECT
						@pid = pay_ID,
						@soldToMember = inserted.PayAmount
						FROM inserted

						UPDATE membership_info
						SET pack_fee = pack_fee + @soldToMember
						WHERE Package.pack_ID = membership_info.pack_ID
						PRINT 'membership updated '
					END
-- Check if this trigger is executed only for deleted
				ELSE IF (EXISTS(SELECT * FROM DELETED) AND NOT EXISTS(SELECT * FROM INSERTED))
					BEGIN
						SELECT
						@pid = pay_ID,
						@soldToMember = inserted.PayAmount
						FROM inserted

						UPDATE membership_info
						SET pack_fee = pack_fee - @soldToMember
						WHERE Package.pack_ID = membership_info.pack_ID
						PRINT 'membership updated '
					END
-- If not match any condition then rollback the transaction
				ELSE ROLLBACK TRANSACTION
		END
GO
-- 
/*
------------------------------  Part10  ------------------------------
							Instead Of Trigger
--------------------------------------------------------------------------
*/
---------------- An Instead Of Trigger On View --------------
CREATE TRIGGER trViewInsteadInsert
ON V_membership_info
INSTEAD OF INSERT
AS
BEGIN
	INSERT INTO payment(pay_Id, PayAmount)
	SELECT i.pay_Id, i.PayAmount FROM inserted i
END
GO

---------------- Alter Trigger --------------
ALTER TRIGGER trViewInsteadInsert
ON V_membership_info
INSTEAD OF INSERT
AS
BEGIN
	INSERT INTO membership_info(mem_name, mem_ID, pay_id)
	SELECT i.mem_name, i.mem_ID , i.pay_id FROM inserted i
END
GO