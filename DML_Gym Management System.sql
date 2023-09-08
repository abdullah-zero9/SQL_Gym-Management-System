/*
								  SQL Project: Gym Management System (GMS)
											  Name: Abdullah
										   Trainee ID: 1271691
										Batch ID: ESAD-CS/PNTL-M/53/01

 ----------------------------------------------------------------------------------------------------

Contents In Order: 
			=> Part 01: INSERT DATA USING INSERT INTO KEYWORD
			=> Part 02: INSERT DATA THROUGH STORED PROCEDURE
					 => INSERT DATA THROUGH STORED PROCEDURE WITH AN OUTPUT PARAMETER 
					 => INSERT DATA USING SEQUENCE VALUE
			=> Part 03: UPDATE DELETE DATA THROUGH STORED PROCEDURE
					 =>  UPDATE DATA THROUGH STORED PROCEDURE
					 =>  DELETE DATA THROUGH STORED PROCEDURE
					 =>  STORED PROCEDURE WITH TRY CATCH AND RAISE ERROR
			=> Part 04: INSERT UPDATE DELETE DATA THROUGH VIEW
					  =>  INSERT DATA through view
					  =>  UPDATE DATA through view
					  =>  DELETE DATA through view
			=> Part 05: RETREIVE DATA USING FUNCTION(SCALAR, SIMPLE TABLE VALUED, MULTISTATEMENT TABLE VALUED)
			=> Part 06: TEST TRIGGER (FOR/AFTER TRIGGER ON TABLE, INSTEAD OF TRIGGER ON TABLE & VIEW)
			=> Part 07: QUERY
	
*/

/*
==============================  Part 01  ==============================
					Insert Data Using INSERT INTO Keyword
==========================================================================
*/
USE GMS
GO
INSERT INTO city VALUES
('Dhaka'),
('chittagong'),
('Gazipur'),
('Narayanganj')
GO
SELECT * FROM city
GO
INSERT INTO country VALUES
('Bangladesh'),
('India'),
('Pakistan'),
('Japan'),
('Qatar')
GO
SELECT * FROM country
GO
INSERT INTO gender VALUES
('Male'),
('Female'),
('others')
GO
SELECT * FROM gender
GO
-------------Insert data by specifying column name-----------------
INSERT INTO Gym (gym_name, [address], countryId, cityId, gym_type, gym_website) VALUES ('MuscleFuel Fitness Center','Shonir Akhra',1,1,'Unisex','MuscleFuel.com')
----------------Insert data by column sequence-----------------
INSERT INTO Gym VALUES ('PowerFlex','Shonir Akhra',1,1,'Man','PowerFlex.com')
GO
SELECT * FROM Gym
GO
/*
------------------------------  Part 02  ------------------------------
					Insert Data Through Stored Procedure
--------------------------------------------------------------------------
*/
EXEC spInsertMember 
'mem-001','Noman','Donia','male',1,1,01521431067,1110203216001,'tendo@gmail.com',NULL,26,'70 KG','5.5 ft', 97.2,'kishor'
EXEC spInsertMember
'mem-002','mahfuz','Donia','male',2,2,01421431067,1110203216002,'mah@gmail.com',NULL,26,'71 KG','5.5 ft', 97.2,'kishor'
EXEC spInsertMember
'mem-003','saleh','Donia','male',3,3,01721431067,1110203216003,'sah@gmail.com',NULL,26,'72 KG','5.5 ft', 97.2,'kishor'
GO
select * from spInsertMember
GO
---------------- Insert Data Through Stored Procedure With An Output Parameter --------------
DECLARE @tr_Id INT
EXEC spInsertInstructor 
'tr-001','waleed','Donia',1,1,01717895632,'nuru@gmail.com',1110203216007,'morning','yes','MuscleFuel Fitness Center'
EXEC spInsertInstructor 
'tr-002','khalid','Donia',2,2,01717895672,'guru@gmail.com',1110203216005,'evening','yes','MuscleFuel Fitness Center',
@tr_Id OUTPUT
PRINT 'new trainer ID : '+ str(@tr_Id)
GO

-- Insert Data With Relation
SELECT * FROM membership_info
INSERT INTO membership_info  VALUES
('m-002','ferdous',1,'beginner',1,0.00,2022-09-15,2022-12-15,'waleed')
GO
SELECT * FROM membership_info 
GO
---------------- Insert Data Using Sequence Value --------------
INSERT INTO number_seq VALUES((NEXT VALUE FOR number_seq), NULL)
GO
SELECT * FROM number_seq
GO
/*
------------------------------  Part 03  ------------------------------
			Update/Delete Data Through Stored Procedure
--------------------------------------------------------------------------
*/
-- Stored Procedure For Update Trainee (Update Due)
EXEC spUpdateMember 1,500.00
GO
SELECT * FROM member
GO
---------------------- Delete Data Through Stored Procedure --------------
-- Stored Procedure For Delete gym package
EXEC spDeletePackage 1
GO
SELECT * FROM spDeletePackage
GO
---------------- Stored Procedure With Try Catch And Raise Error --------------
EXEC spRaisError
GO
/*
------------------------------  Part 04  ------------------------------
					Insert-Update-Delete Data Through View
--------------------------------------------------------------------------
*/
---------------- Insert Data Through View --------------
INSERT INTO V_TodayPackageSales (traineeId,courseId, discount) VALUES(11, 5, .05)
GO
SELECT * FROM V_TodayPackageSales
GO
---------------- Update Data Through View --------------
UPDATE V_membership_info
SET mem_name = 'Abdullah al noman'
WHERE mem_Id = 'mem-001'
GO
SELECT * FROM V_membership_info
GO
---------------- Delete Data Through View --------------
DELETE FROM V_membership_info
WHERE traineeId = 4
GO
SELECT * FROM V_membership_info
GO
---------------------------Retreive Data Using Function---------

-- A Scalar Function To Get Monthly Total Net Sales Using Two Parameter @Year & @Month
SELECT dbo.fnCurrentYearSales() AS 'Currrent Year Net Sale'
GO
-------------------Test Trigger
---------------- For/After Trigger On Table --------------
INSERT INTO membership_info (pay_ID, PayAmount) VALUES (2, 800)
GO
SELECT * FROM trPaymentClear
SELECT * FROM membership_info
/*
------------------------------  Part 07  ------------------------------
								  Query
--------------------------------------------------------------------------
*/
----------------  A Select Statement To Get Result Set From A Table --------------
SELECT * FROM member
GO
----------------  A Select Statement To Get Today Sales Information From A View --------------
SELECT * FROM V_TodayPackageSales
GO
----------------  Select Into > Save Result Set To A New Temporary Table --------------
SELECT * INTO #offerPackage
FROM Package
GO
SELECT * FROM #offerPackage
----------------  Implicit Join With Where By Clause, Order By Clause --------------
use GMS
go
SELECT mem_ID,pack_id FROM member,package
WHERE member.pack_id=package.pack_ID
ORDER BY mem_id ASC, pack_id DESC
GO
----------------  Inner Join With Group By Clause --------------
SELECT pack_StartDate,pack_EndDate FROM membership_info mi
INNER JOIN payment py
ON mi.pay_id= py.pay_id
GO
----------------  Outer Join --------------
SELECT * FROM membership_info mi
LEFT JOIN payment py
ON mi.pay_id= py.pay_id
GO
---------------- Cross Join --------------
SELECT * FROM membership_info
CROSS JOIN Gender
GO
----------------  Top Clause With Ties and ORDER BY --------------
SELECT TOP 5 WITH TIES NID_number FROM Member
ORDER BY mem_ID
GO
----------------  Distinct --------------
SELECT DISTINCT cityname FROM city
----------------  Comparison, Logical(And Or Not) & Between Operator --------------
SELECT * FROM Trainer
WHERE gender_name = 'female'
AND NOT cityId = 4
OR cityId = 2
GO
---------------- Like, In, Not In, Operator & Is Null Clause --------------
SELECT * FROM Trainer
WHERE tr_name LIKE 'K%'
AND cityId NOT IN ('2')
AND address IS NULL
GO
---------------- Offset Fetch --------------
SELECT * FROM Member
ORDER BY mem_ID
OFFSET 5 ROWS
GO
-------------Offset 5 Rows And Get Next 5 Rows
SELECT * FROM Member
ORDER BY mem_ID
OFFSET 5 ROWS
FETCH NEXT 5 ROWS ONLY
GO
----------------  Union --------------
SELECT * FROM employee
WHERE gen_name IN ('male')
UNION
SELECT * FROM employee
WHERE gen_name IN ('female')
GO
----------------  Except Intersect --------------
--Except
SELECT * FROM employee
EXCEPT
SELECT * FROM employee
WHERE Emp_Id = 2
GO
--INTERSECT
SELECT * FROM Equipment
WHERE eq_name = 'dumble'
INTERSECT
SELECT * FROM Equipment
WHERE eq_name = 'barble'
GO
---------------- Aggregate Function --------------
SELECT	COUNT(*) 'Total Count',
		SUM(pack_fee) 'Total fee',
		AVG(duration) 'Average',
		MIN(pack_fee) 'MIN FEE',
		(MAX(discount))*100 'MAX Discount %'
FROM package
GO
---------------- Aggregate Function With Group By & Having Clause --------------
SELECT SUM(pack_fee) 'NET SALES' FROM package
GROUP BY pack_ID
HAVING SUM(pack_fee) > 50000
GO
---------------- Rollup & Cube Operator --------------
--Rollup
SELECT SUM(pack_fee) 'total' FROM package
GROUP BY ROLLUP(pack_ID)
ORDER BY pack_ID
GO
-- Cube
SELECT SUM(pack_fee) 'total' FROM package
GROUP BY CUBE(pack_ID)
ORDER BY pack_ID
GO
---------------- Grouping Sets --------------
SELECT SUM(pack_fee) 'total' FROM package
GROUP BY GROUPING SETS (pack_ID)
ORDER BY pack_ID
GO
---------------- Sub-Queries--------------
SELECT mem_name, email, [address] FROM Member
WHERE email NOT IN (SELECT email FROM Trainer)
ORDER BY mem_ID
GO
----------------  Exists --------------
SELECT tr_name, tr_mobile FROM Trainer
WHERE NOT EXISTS 
			(SELECT * FROM Member
				WHERE Member.cityId=trainer.cityId)
GO
---------------- CTE --------------
WITH CTE AS
(
SELECT pack_StartDate,pack_EndDate FROM membership_info mi
INNER JOIN payment py
ON mi.pay_id= py.pay_id
)
GO
---------------- Merge --------------
MERGE supply AS SOURCE
USING Equipment AS TARGET
ON SOURCE.eqSupplier_ID = TARGET.eqSupplier_ID
WHEN MATCHED THEN
				UPDATE SET
				eqSupplier_ID = SOURCE.eqSupplier_ID,
				comment = SOURCE.comment;
GO
---------------- Built In Function --------------
-- Get Current Date And Time
SELECT GETDATE()
GO
-- Convert Data Using Try_Convert()
SELECT TRY_CONVERT(FLOAT, 'Abdullah', 1) AS ReturnNull
GO
-- Convert Data Using Cast()
SELECT CAST(500 AS decimal(17,2)) AS DecimalNumber
GO
-- Convert Data Using Convert()
DECLARE @TimeRightNow DATETIME = GETDATE()
SELECT CONVERT(VARCHAR, @TimeRightNow, 108) AS Convert_Time
GO
-- Get A Month Name
SELECT DATENAME(MONTH, GETDATE()) AS 'Month'
GO
-- Get Difference Of Dates
SELECT DATEDIFF(DAY, '1996-06-18', '2022-12-18') AS DAYinYear
GO
-- Get String Length
SELECT emp_Id, LEN([emp_name]) 'Name Length' FROM employee
GO
---------------- Case --------------
SELECT Employee_salary.salary,
	CASE 
		WHEN (salary < 5000) THEN 'minimum'
		WHEN (salary > 5000) THEN 'Good'
END AS 'Status'
FROM Employee_salary
---------------- Goto --------------
DECLARE @value INT
SET @value = 0

WHILE @value <= 10
	BEGIN
	   IF @value = 2
		  GOTO printMsg
	   SET @value = @value + 1

	   	IF @value = 9
		  GOTO printMsg2
	   SET @value = @value + 1
	END
printMsg:
   PRINT 'Crossed Value 2'
printMsg2:
   PRINT 'Crossed Value 9'
GO
---------------- System Stored Procedure(Sp_Helptext) To Get Unencrypted Stored Procedure Script  --------------
EXEC sp_helptext spInsertMember
GO
----------------  While --------------
	DECLARE @counter int
	SET @counter = 0

	WHILE @counter < 20

	BEGIN
	  SET @counter = @counter + 1
	  INSERT INTO supply(eqSupplier_ID, comment) VALUES((NEXT VALUE FOR [dbo].seqNum), NULL)
	END
	SELECT * FROM supply
GO
----------------Ranking Function --------------
SELECT 
RANK() OVER(ORDER BY mem_Id) AS 'Rank',
DENSE_RANK() OVER(ORDER BY pack_id) AS 'Dense_Rank',
NTILE(3) OVER(ORDER BY pay_id) AS 'NTILE',
mem_Id,
pack_id, 
pay_id
FROM membership_info
GO
---------------- Try Catch --------------
BEGIN TRY
	DELETE FROM package 
	PRINT 'SUCCESSFULLY DELETED'
END TRY

BEGIN CATCH
		DECLARE @Error VARCHAR(200) = 'Error' + CONVERT(varchar, ERROR_NUMBER(), 1) + ' : ' + ERROR_MESSAGE()
		PRINT (@Error)
END CATCH
GO
---------------- IIF --------------
SELECT Employee_salary.salary,
IIF((salary > 5000), 'Great Salary', 'Lower Salary') AS 'Status'
FROM Employee_salary 

----------------Waitfor --------------
PRINT 'Dear Sir'
WAITFOR DELAY '00:00:03'
PRINT 'As-salamu Alaikum Oya Rahmatullah'
GO