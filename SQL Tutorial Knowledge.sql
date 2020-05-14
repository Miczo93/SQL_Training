Create Database Testing 
Alter Database Testing Modify Name = TestingTest
Alter Database TestingTest Modify Name = Testing
Drop Database Testing

--zmiana srodowiska
Use [Testing] 
Go

Create Table tblGender(
ID int NOT NULL Primary Key,
Gender nvarchar(50) NOT NULL)

--klucz obcy
Alter table tblPerson add constraint FWGenderID_Person 
Foreign Key (GenderID) references tblGender(ID)

--insetowanie
Insert into tblPerson (ID, Name, Email) Values (4,'Rich','r@r.com')
Insert into tblPerson (ID, Name, Email) Values (5,'Mike','m@m.com')

--default
Alter table tblPerson
ADD CONSTRAINT DFtblPerson_GenderID
DEFAULT 3 FOR GenderID

ALTER TABLE tblPerson
DROP CONSTRAINT DFtblPerson_GenderID

--where Insert update specification
Delete from tblGender Where ID = 2

-----------alter table-----------
Alter Table  tblPerson 
ADD Age int

Insert into tblPerson Values (8,'Rich','r@r.com',1,-1000)
Delete from tblPerson where ID = 8

-----------constrain------------
Alter Table tblPerson
ADD CONSTRAINT CK_Person_Age CHECK (AGE>0 AND AGE<150)

--identinty Automatic added, seed start, increment, cannot be explisit
Insert into tblPerson1 Values ('James')
Delete from tblPerson1 Where Name = 'James'

--identity insert possible
SET IDENTITY_INSERT tblPerson1 ON 
Insert into tblPerson1 (ID, Name) Values (1,'James')
--reset counter
DBCC CHECKIDENT('tblPerson1', RESEED, 0)

--ostatnie id dodane
Create Table Test1(
ID int identity(1,1), Value nvarchar(20))

Create Table Test2(
ID int identity(1,1), Value nvarchar(20))

Insert into Test1 Values ('X')
Select * from Test1
Select * from Test2
Select SCOPE_IDENTITY() --same scope
Select @@IDENTITY --any scope
Select IDENT_CURRENT('Test2') --table


Create Trigger TrForInsert on Test1 for INSERT
as
Begin
 Insert into Test2 Values('YYYU')
End

--unique
Alter Table tblPerson
Add constraint UQ_Person_Email unique(Email)

Insert into tblPerson Values (9,'abc', 'a@b.com',1,20)

-----------select------------------

USE [Testing]
GO

SELECT [ID]
      ,[Name]
      ,[Email]
      ,[GenderID]
      ,[Age]
  FROM [dbo].[tblPerson]
GO

Select DISTINCT GenderID from tblPerson
Select DISTINCT GenderID, Name from tblPerson
Select * from tblPerson Where Name = 'Mike'
Select * from tblPerson Where Name <> 'Mike' --!=
Select * from tblPerson Where Name IN  ('Mike','Mary')
Select * from tblPerson Where Age BETWEEN 20 AND 50
Select * from tblPerson Where Name LIKE 'M%'
Select * from tblPerson Where Email NOT LIKE '%@%' --something
Select * from tblPerson Where Email LIKE '_@_.com' --_single car
Select * from tblPerson Where Name LIKE '[AMJ]%' --with AMJ
Select * from tblPerson Where Name LIKE '[^AMJ]%' --not with AMJ
Select * from tblPerson order by Name
Select * from tblPerson order by Name DESC, Age ASC
Select top 5 Name,Age from tblPerson order by Name
Select top 1 percent Name,Age from tblPerson order by Name

--------------group by----------------------
Create Table tblEmployee(
ID int identity(1,1), Name nvarchar(50), GenderID int, Salary int, City nvarchar(50))

Alter table tblEmployee add constraint FWGenderID_Employee 
Foreign Key (GenderID) references tblGender(ID)

Insert into tblEmployee Values('Steve', 1, 2000, 'New York')
Insert into tblEmployee Values('Steve', 1, 3500, 'London')
Insert into tblEmployee Values('Ann', 2, 3200, 'London')
Insert into tblEmployee Values('Mary', 2, 4000, 'Chicago')
Insert into tblEmployee Values('Arnold', 1, 1800, 'Washington')
Insert into tblEmployee Values('Kate', 2, 3600, 'Washington')
Insert into tblEmployee Values('Bob', 1, 4500, 'Chicago')
Insert into tblEmployee Values('Sally', 2, 3000, 'New York')
Insert into tblEmployee Values('Martin', 1, 2200, 'New York')
Insert into tblEmployee Values('Kelly', 2, 3000, 'London')
Insert into tblEmployee Values('Misha', 2, 2900, 'London')
Insert into tblEmployee Values('Martin', 1, 1500, 'Washington')

Select * from tblEmployee

Select SUM(Salary) AS 'Sum of salary' from tblEmployee
Select Min(Salary) AS 'Minimal salary' from tblEmployee

Select City, SUM(Salary) AS 'Sum of salary' from tblEmployee
Group By City

Select City, GenderID,SUM(Salary) AS 'Sum of salary' from tblEmployee
Group By City, GenderID
Order By City

Select City, GenderID,SUM(Salary) AS 'Sum of salary', COUNT(ID) AS 'Total Employees' from tblEmployee
Group By City, GenderID
Order By City


--before group (update also), not agrage (sum, etc)
Select City, GenderID,SUM(Salary) AS 'Sum of salary', COUNT(ID) AS 'Total Employees' from tblEmployee
Where GenderID = 1
Group By City, GenderID
Order By City

--after group, only not showing (only select), accepts agrage
Select City, GenderID,SUM(Salary) AS 'Sum of salary', COUNT(ID) AS 'Total Employees' from tblEmployee
Group By City, GenderID
Having GenderID = 1
Order By City

Select City, GenderID,SUM(Salary) AS 'Sum of salary', COUNT(ID) AS 'Total Employees' from tblEmployee
Where SUM(Salary) > 4000
Group By City, GenderID
Order By City

Select City, GenderID,SUM(Salary) AS 'Sum of salary', COUNT(ID) AS 'Total Employees' from tblEmployee
Group By City, GenderID
Having SUM(Salary) > 4000
Order By City

---------------------Join--------------------------

Alter Table  tblEmployee
ADD DeptID int

Create Table tblDepartment(
ID int identity(1,1), DeptName nvarchar(50), Location nvarchar(50))

Alter table tblEmployee add constraint FWDeptID_Employee 
Foreign Key (DeptId) references tblDepartment(ID)

--inner
Select Name, Gender, Salary, DeptName
from tblEmployee
Join tblDepartment
On tblEmployee.DeptID = tblDepartment.ID
Join tblGender
On tblEmployee.GenderID=tblGender.ID

--maching rules
Select Name, Gender, Salary, DeptName
from tblEmployee
INNER Join tblDepartment
On tblEmployee.DeptID = tblDepartment.ID
Join tblGender
On tblEmployee.GenderID=tblGender.ID

--maching and not matching from left
Select Name, Gender, Salary, DeptName
from tblEmployee
LEFT OUTER Join tblDepartment
On tblEmployee.DeptID = tblDepartment.ID
Join tblGender
On tblEmployee.GenderID=tblGender.ID

--maching and not matching from right
Select Name, Salary, DeptName
from tblEmployee
RIGHT OUTER Join tblDepartment
On tblEmployee.DeptID = tblDepartment.ID

--maching, not matching
Select Name, Salary, DeptName
from tblEmployee
FULL OUTER Join tblDepartment
On tblEmployee.DeptID = tblDepartment.ID

--all with all
Select Name, Salary, DeptName
from tblEmployee
CROSS Join tblDepartment

--non matching ONLY left
Select Name, Gender, Salary, DeptName
from tblEmployee
LEFT OUTER Join tblDepartment
On tblEmployee.DeptID = tblDepartment.ID
Join tblGender
On tblEmployee.GenderID=tblGender.ID
WHERE tblEmployee.DeptID IS NULL

--non matching right
Select Name, Gender, Salary, DeptName
from tblEmployee
Right Join tblDepartment
On tblEmployee.DeptID = tblDepartment.ID
Join tblGender
On tblEmployee.GenderID=tblGender.ID
WHERE tblEmployee.DeptID IS NULL

--non matching full
Select Name, Gender, Salary, DeptName
from tblEmployee
FULL Join tblDepartment
On tblEmployee.DeptID = tblDepartment.ID
Join tblGender
On tblEmployee.GenderID=tblGender.ID
WHERE tblEmployee.DeptID IS NULL
OR tblDepartment.ID IS NULL


--self join
Create Table tblManagers(
ID int identity(1,1), Name nvarchar(50), ManagerID int)

Insert into tblManagers Values('Mike', 3)
Insert into tblManagers Values('Rob', 1)
Insert into tblManagers Values('Todd', NULL)
Insert into tblManagers Values('Ben', 1)
Insert into tblManagers Values('Sam', 1)

Select E.name as Employee, M.Name as Manager
From tblManagers E
Left Join tblManagers M
ON E.ManagerID = M.ID

Select E.name as Employee, M.Name as Manager
From tblManagers E
Right Join tblManagers M
ON E.ManagerID = M.ID

Select E.name as Employee, M.Name as Manager
From tblManagers E
CROSS Join tblManagers M

----------------------null replace--------------------
Select * From tblManagers

SELECT E.Name as Employee, M.Name as Manager
from tblManagers E
Left Join tblManagers M
ON E.ManagerID=M.ID

SELECT ISNULL(NULL,'No Manager') as Manager--IF NULL THEN VALUE
SELECT ISNULL('Manager','No Manager') as Manager

SELECT E.Name as Employee, ISNULL(M.Name,'No Manager') as Manager
from tblManagers E
Left Join tblManagers M
ON E.ManagerID=M.ID

SELECT COALESCE(NULL,'No Manager') as Manager--RETURN FIRST NON NULL
SELECT COALESCE('Manager','No Manager') as Manager

SELECT E.Name as Employee, COALESCE(M.Name,'No Manager') as Manager
from tblManagers E
Left Join tblManagers M
ON E.ManagerID=M.ID

CASE WHEN EXRESSION THEN '' ELSE '' END--IF ELSE

SELECT E.Name as Employee, CASE WHEN M.Name IS NULL THEN 'No Manager' ELSE M.Name END as Manager
from tblManagers E
Left Join tblManagers M
ON E.ManagerID=M.ID


--COALESCE
Create Table tblTest3(
ID int identity(1,1), FirstName nvarchar(50), MiddleName nvarchar(50),
LastName nvarchar(50))

Insert into tblTest3 Values('Sam', NULL,NULL)
Insert into tblTest3 Values(NULL, 'Todd','Teo')
Insert into tblTest3 Values(NULL, NULL,'Sara')
Insert into tblTest3 Values('Ben','Shapiro',NULL)
Insert into tblTest3 Values('James', 'Nick','Nancy')


Select ID, COALESCE(FirstName,MiddleName,LastName) AS NAME --first not null
FROM tblTest3

--UNION
SELECT * from Test1 --musi to samo w 2 selectkach [ten sam typ]
UNION ALL --powtarzanie, szybsze
SELECT * from Test2
ORDER BY ID

SELECT * from Test1
UNION --bez powtórek, wolniejsze bo sort
SELECT * from Test2


-----------------------STORED PROCEDURE-----------------------
--Excecution plan vs every change new excecution plan adhog
--less traffic
--maintability
--security
--sql injection secure SELECT .... (...'; DELETE FROM ... --)
CREATE PROCEDURE spGetEmployee
AS
BEGIN
Select Name, City from tblEmployee
END

spGetEmployee

--WITH PARAMETERS
CREATE PROCEDURE spGetEmployeeByID
@Dep int
AS
BEGIN
Select Name, City, DeptID from tblEmployee WHERE DeptID=@Dep
END

spGetEmployeeByID 1
spGetEmployeeByID @Dep = 2

sp_helptext spGetEmployeeByID --info
sp_help spGetEmployeeByID --more info
sp_depends tblEmployee --info co ma zwiazanego

ALTER PROCEDURE spGetEmployeeByID 
@Dep int
WITH ENCRYPTION --brak dostepu do info
AS
BEGIN
Select Name, City, DeptID from tblEmployee WHERE DeptID=@Dep
END

--WITH OUTPUT PARAMETER
CREATE PROCEDURE spGetEmployeeCountByID
@Dep int,
@EmployeeCount int output
AS
BEGIN
 Select @EmployeeCount = COUNT (*) from tblEmployee WHERE DeptID=@Dep
END

Declare @EmployeeCount int
Execute spGetEmployeeCountByID 1, @EmployeeCount Output
Print @EmployeeCount

--PROCEDURE WITH OUTPUT PARAMETER VS WITH RETURN VALUE

CREATE PROCEDURE spGetEmployeeCount1
@EmployeeCount int output
AS
BEGIN
 Select @EmployeeCount = COUNT (*) from tblEmployee
END

Declare @EmployeeCount int
Execute spGetEmployeeCount1 @EmployeeCount Output
Print @EmployeeCount

CREATE PROCEDURE spGetEmployeeCount2 --only int, better not use
AS
BEGIN
 Return (Select COUNT (*) from tblEmployee)
END

Declare @EmployeeCount int
Execute @EmployeeCount = spGetEmployeeCount2
Print @EmployeeCount

--OUTPUT VS RETURN
--Returns? anything vs int
--How many? as many vs one
--how use? return values vs success/fail

-----------------------String Functions-----------------
Select ASCII('A') --ascii code return number
SELECT CHAR(5) --return ascii code

Declare @Start int
Set @Start =65
While(@Start<=90)
BEGIN
Print CHAR(@Start)
Set @Start = @Start +1
END

SELECT LTRIM('     Hello            ') --remove white spaces left
SELECT RTRIM('     Hello            ') --remove white spaces right

Select RTRIM(LTRIM(Name)) AS NAME from tblEmployee

SELECT LOWER('TO BEDZIE Z MALYCH')
SELECT UPPER('to bedzie z duzych')
SELECT REVERSE(Name) AS NAME from tblEmployee
SELECT Name, LEN(Name) AS [Total Characters] from tblEmployee


Create Table tblEmails(
ID int identity(1,1), FirstName nvarchar(50),LastName nvarchar(50),
Email nvarchar(50))

Insert into tblEmails Values('Sam', 'Sony','Sam@aaa.com')
Insert into tblEmails Values('Ram', 'Barber','Ram@aaa.com')
Insert into tblEmails Values('Sara', 'Sanosky','Sara@ccc.com')
Insert into tblEmails Values('Tood', 'Gartner','Todd@bbb.com')
Insert into tblEmails Values('John', 'Cena','John@aaa.com')
Insert into tblEmails Values('Sana', 'Leni','Sana@ccc.com')
Insert into tblEmails Values('James', 'Bond','James@bbb.com')
Insert into tblEmails Values('Rob', 'Hunter','Rob@ccc.com')
Insert into tblEmails Values('Steve', 'Wilson','Steve@aaa.com')
Insert into tblEmails Values('Pam', 'Broker','Pam@bbb.com')

SELECT LEFT('ABCDEFGH',4)--ABCD
SELECT RIGHT('ABCDEFGH',4)--EFGH
SELECT CHARINDEX('@', 'John@aaa.com')--5
SELECT CHARINDEX('@', 'John@a@a.com',6)--7 ze starting loc
SELECT SUBSTRING('John@aaa.com',5,2)--@a

--wyswietl wszystkie domeny
Select SUBSTRING(Email, CHARINDEX('@', Email) + 1,
LEN(Email) - CHARINDEX('@', Email)) as EmailDomain
from tblEmails

--licz wszystkie domeny
Select SUBSTRING(Email, CHARINDEX('@', Email) + 1,
LEN(Email) - CHARINDEX('@', Email)) as EmailDomain,
COUNT(Email) as Total
from tblEmails
Group By SUBSTRING(Email, CHARINDEX('@', Email) + 1,
LEN(Email) - CHARINDEX('@', Email))

SELECT REPLICATE('STRING', 3)
SELECT SPACE(3)

SELECT FirstName + SPACE(5) + LastName as FullName
From tblEmails

--PATINDEX mozna uzywac wildcardow (%^ etc), zwraca 0 jak nie ma (charindex nie mo¿na%^)
Select Email, PATINDEX('%@aaa.com', Email) as IndexPierwszegoWystapienia
from tblEmails
Where PATINDEX('%@aaa.com', Email) >0

Select Email, REPLACE(Email, '.com', '.pl') as NewMail
from tblEmails

Select FirstName, LastName,Email,
STUFF(Email,2,3, '***')as NewEmail
from tblEmails

-----------DATE-----------------

CREATE TABLE [tblDateTime]
(
 [c_time] [time](7) NULL, --bez daty
 [c_date] [date] NULL, --bez godziny
 [c_smalldatetime] [smalldatetime] NULL, --bez sekund
 [c_datetime] [datetime] NULL, --dokladny
 [c_datetime2] [datetime2](7) NULL, --dokladniejszy
 [c_datetimeoffset] [datetimeoffset](7) NULL --dokladniejszy + utc diffrence
)
INSERT INTO tblDateTime VALUES (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE())

Select * from tblDateTime

SELECT ISDATE('NOTDATE')--0
SELECT ISDATE(GETDATE())--1
SELECT ISDATE('2019-10-24 13:02:05.126')--1
SELECT ISDATE('2019-10-24 13:02:05.1265555')--0 Bo datetime2

SELECT DAY(GETDATE())--DZIEN DZIS
SELECT MONTH(GETDATE())--MIESIAC DZIS
SELECT YEAR(GETDATE())--ROK DZIS

SELECT DATENAME(DAY, '2019-10-24 13:02:05.126') -- 24
SELECT DATENAME(WEEKDAY, '2019-10-24 13:02:05.126') -- THURSDAY
SELECT DATENAME(MONTH, '2019-10-24 13:02:05.126') -- OCTOBER

Create Table tblEmpBirth(
ID int identity(1,1), Name nvarchar(50),DateOfBirth [datetime], Gender nvarchar(50))

Insert into tblEmpBirth Values('Sam', '1990-12-30 00:00:00.000', 'male')
Insert into tblEmpBirth Values('Pam', '1992-09-01 11:03:25.126', 'female')
Insert into tblEmpBirth Values('John', '1999-08-22 12:09:15.526', 'male')
Insert into tblEmpBirth Values('Sara', '1998-11-29 14:05:35.926', 'female')
Insert into tblEmpBirth Values('Arthur', '1999-08-22 15:11:15.526', 'male')
Insert into tblEmpBirth Values('Steve', '1998-11-29 19:27:35.926', 'male')
Insert into tblEmpBirth Values('Samuel', '1999-08-22 22:11:15.526', 'female')

Select Name, DateOfBirth, DateName(WEEKDAY,DateOfBirth) as [Day], 
            Month(DateOfBirth) as MonthNumber, 
            DateName(MONTH, DateOfBirth) as [MonthName],
            Year(DateOfBirth) as [Year]
From   tblEmpBirth

SELECT DATEPART(WEEKDAY, '2019-10-24 13:02:05.126') -- 5
SELECT DATENAME(WEEKDAY, '2019-10-24 13:02:05.126') -- THURSDAY

SELECT DATEADD(DAY,20, '2019-10-24 13:02:05.126') --doda 20 dni

SELECT DATEDIFF(MONTH, '11/30/2015','01/31/2016') --2
SELECT DATEDIFF(DAY, '11/30/2015','01/31/2016') --62

CREATE FUNCTION FunLiczWiekDokladnie(@DOB DATETIME)
RETURNS NVARCHAR(50)
AS
BEGIN

DECLARE @tempdate DATETIME, @years INT, @months INT, @days INT
SELECT @tempdate = @DOB

SELECT @years = DATEDIFF(YEAR, @tempdate, GETDATE()) - CASE WHEN (MONTH(@DOB) > MONTH(GETDATE())) OR (MONTH(@DOB) = MONTH(GETDATE()) AND DAY(@DOB) > DAY(GETDATE())) THEN 1 ELSE 0 END
SELECT @tempdate = DATEADD(YEAR, @years, @tempdate)

SELECT @months = DATEDIFF(MONTH, @tempdate, GETDATE()) - CASE WHEN DAY(@DOB) > DAY(GETDATE()) THEN 1 ELSE 0 END
SELECT @tempdate = DATEADD(MONTH, @months, @tempdate)

SELECT @days = DATEDIFF(DAY, @tempdate, GETDATE())

DECLARE @Age NVARCHAR(50)
SET @Age = Cast(@years AS  NVARCHAR(4)) + ' Years ' + Cast(@months AS  NVARCHAR(2))+ ' Months ' +  Cast(@days AS  NVARCHAR(2))+ ' Days Old'
RETURN @Age

End

Select dbo.FunLiczWiekDokladnie('11/30/2015')

SELECT Name, DateOfBirth, dbo.FunLiczWiekDokladnie(DateOfBirth) AS [Dokladny wiek]
FROM tblEmpBirth

---------------------CAST VS CONVERT--------------------------

--CAST, LENGHT OPTIONAL, ASCI STANDARD
SELECT ID, Name, DateOfBirth, CAST(DateOfBirth as nvarchar(50))as CastDate
FROM tblEmpBirth

--CONVERT, STYLE OPTIONAL[ONLY IN STRINGS], SQL EXCLUSIVE
SELECT ID, Name, DateOfBirth, CONVERT(nvarchar, DateOfBirth, 103)as CastDate
FROM tblEmpBirth

SELECT ID, NAME, NAME + ' - '+ CAST(id as nvarchar) AS [Name ID] 
FROM tblEmpBirth

--Wszyscy urodzeni 1 dnia
SELECT Cast(DateOfBirth as DATE) as [Day Of Birth], COUNT(Id) as Total
FROM tblEmpBirth
Group BY Cast(DateOfBirth as DATE)

------------MATH--------------

SELECT ABS(-101.5) -- 101.5 absolute value

SELECT CEILING(15.2) -- 16 Zaokraglenie do góry
SELECT CEILING(-15.2) -- -15

SELECT FLOOR(15.2) -- 15 Zaokraglenie do do³u
SELECT FLOOR(-15.2) -- -16

SELECT POWER(2,3) -- 8 potega x stopnia
SELECT SQUARE(9) -- 81
SELECT SQRT(81) -- 9

SELECT RAND() -- random between 0 and 1
SELECT RAND(1) -- z tym samym seedem ten sam wynik
SELECT FLOOR(RAND()*100) --0 do 100 int

--10 random numbers
Declare @Counter INT
SET @Counter = 1
While (@Counter  <= 10)
Begin
Print FLOOR(RAND()*1000)
SET @Counter= @Counter+1
END

Select ROUND(850.556, 2) --850.56
Select ROUND(850.556, 2, 1) --850.55, 3 parameter ignore
Select ROUND(850.556, 1) --850.6
Select ROUND(850.556, 1,1) --850.5
Select ROUND(850.556,-2) -- 900
Select ROUND(850.556,-1) --850

------------Funcions--------------------

--Can be used in select
--must return something
--cannot return: text, ntext, image, cursor, timestamp


--scalar function (single value)
Create FUNCTION FunLiczWiekDokladnie2(@DOB DATE)
RETURNS INT
AS
BEGIN
DECLARE @Age INT

SET @AGE = DATEDIFF(YEAR, @DOB, GETDATE())-
	CASE
		WHEN (MONTH(@DOB)> MONTH(GETDATE())) OR
			(MONTH(@DOB)= MONTH(GETDATE())) AND DAY(@DOB) > DAY(GETDATE())	
		THEN 1
		ELSE 0
	END
RETURN @Age
END

Select dbo.FunLiczWiekDokladnie2('11/30/2000')

SELECT NAME, DATEOFBIRTH, dbo.FunLiczWiekDokladnie2(DATEOFBIRTH) as Age 
from tblEmpBirth
Where dbo.FunLiczWiekDokladnie2(DATEOFBIRTH) >20

Sp_helptext FunLiczWiekDokladnie2


Create PROC ProcLiczWiekDokladnie2
@DOB DATE
AS
BEGIN
DECLARE @Age INT

SET @AGE = DATEDIFF(YEAR, @DOB, GETDATE())-
	CASE
		WHEN (MONTH(@DOB)> MONTH(GETDATE())) OR
			(MONTH(@DOB)= MONTH(GETDATE())) AND DAY(@DOB) > DAY(GETDATE())	
		THEN 1
		ELSE 0
	END
SELECT @Age
END

--PROCEDURE NIE MOZNA U¯YWAÆ W SELECT
EXECUTE ProcLiczWiekDokladnie2 '11/30/2000'

--inline table function (returns table)

--NO BEGIN AND END
Create FUNCTION EmployeeByGener(@Gender nvarchar(50))
RETURNS TABLE
AS
RETURN (Select Id, Name, DateOfBirth, Gender
FROM  tblEmpBirth
Where Gender = @Gender)


SELECT * FROM dbo.EmployeeByGener ('Male')
SELECT * FROM dbo.EmployeeByGener ('Female') 
WHERE Name = 'Pam'

--MULTISTATMENT

-------inline table-----
--simpler
--nie ma begin end
--can update tables

CREATE FUNCTION EmployeeWithDOBSingle()
RETURNS TABLE
AS
RETURN (Select ID, Name, Cast(DateOfBirth as Date) as DOB 
from tblEmpBirth)

------multistatemanet table-----
--opisujemy table co zwracam 
--moze miec begin end
--cannot update tables

CREATE FUNCTION EmployeeWithDOBMulti()
Returns @Table Table (Id int, Name nvarchar(20), DOB Date)
as
Begin
	Insert into @Table
	Select ID, Name, Cast(DateOfBirth as Date) as DOB from tblEmpBirth

	Return
End

Select * from EmployeeWithDOBSingle()
Select * from EmployeeWithDOBMulti()

Update EmployeeWithDOBSingle() set Name = 'Sam' Where ID = 1
Update EmployeeWithDOBMulti() set Name = 'Sam' Where ID = 1 --NO

------------Extra Functions Content----------------
--Deterministic? always the same value on the same input (np. count, power)
--Nondeterministic? returns diffrent values on the same input (np. getdate)


--SCHEMABINDING
Alter Function GetNameByIdFun(@id int)
Returns nvarchar(30) 
WITH SCHEMABINDING 
--dbo.tblEmployee jest zablokowane przed usunieciem bo jest polaczone z tym
--nie mozna tez zmodyfikowac name i id w tym przypadku
--With Encryption -- cannot see sp_helptext
as
begin
 Return (Select Name from dbo.tblEmployee Where Id=@id)
End

Select dbo.GetNameByIdFun(1)

--------------------------------Temporary Tables---------------------------------
--sa usuwane jak zamknie sie connection
--temp table jezeli zostanie stworzona w stored procedure zostaje usunieta po niej

--local temp (#)
--mozna te same nazwy w tempach w roznych connectionach (bo random numbers)
--widocznie lokalnie
--host then usunieta
Create Table #TempTableTest(Id int, Name nvarchar(20))

Insert into #TempTableTest Values(1, 'Mike')
Insert into #TempTableTest Values(2, 'John')
Insert into #TempTableTest Values(3, 'Todd')

Select * from #TempTableTest

--wyszukaj temptable, like bo nazwa jest inna przez random numbers
Select name from tempdb..sysobjects
where name like '#TempTableTest%'

--global temp (##)
--bez random numbersach
--widocznie globalnie
--last connection then usunieta
Create Table ##TempTableTest(Id int, Name nvarchar(20))

----------------------------indexy----------------------------

--non cluster
Create Index Index_tblEmployee_Salary
ON tblEmployee (Salary ASC)

sp_Helpindex tblEmployee

drop index tblEmployee.Index_tblEmployee_Salary

--cluster
Create Clustered Index Index_tblEmployee_Salary_Gender
ON tblEmployee (Salary ASC, Gender DESC)

--cluster index vs non cluster
--1 vs multi
--g³ówne u³o¿enie (g³ównie id, ale mo¿e byæ co innego) vs custom u³o¿enie
--zapisane w bazie vs zapisane dodatkowo
--fastert bc refers to index

--unique index

--jak primary key to automatycznie zrobil sie index unique
CREATE TABLE [tblEmployeeUnique]
(
 [Id] int Primary Key,
 [FirstName] nvarchar(50),
 [LastName] nvarchar(50),
 [Salary] int,
 [Gender] nvarchar(10),
 [City] nvarchar(50)
)

sp_helpindex tblEmployeeUnique
--usuwanie reczne

Insert into tblEmployeeUnique Values(1,'Mike', 'Sandoz',4500,'Male','New York')
Insert into tblEmployeeUnique Values(1,'John', 'Menco',2500,'Male','London')

select * from tblEmployeeUnique

ALTER TABLE [tblEmployeeUnique]
ADD CONSTRAINT Unique_tblEmployeeUnique_City
UNIQUE CLUSTERED (City) --can be without CLUSTERED

--WHERE, UPDATE, DELETE, ORDER, GROUP BY szybciej znajdzie
--DELETE, UPDATE, ADD wolniej wykona po trzeba dodac/zmienic tez tam


---------------------------VIEWS----------------------------

--virtual table
--easier then select...
--better security
--hide details, show only agregate

Create View ViewEmployeeByDepartment
as
Select tblEmployee.ID, Name, Salary, DeptName
from tblEmployee
join tblDepartment
on tblEmployee.DeptID = tblDepartment.ID

Select * from ViewEmployeeByDepartment Where Salary > 2500
Select * from ViewEmployeeByDepartment Where DeptName = 'HR'

sp_helptext ViewEmployeeByDepartment

Create View ViewEmployeeByDepartmentIT
as
Select tblEmployee.ID, Name, Salary, DeptName
from tblEmployee
join tblDepartment
on tblEmployee.DeptID = tblDepartment.ID
Where tblDepartment.DeptName = 'IT'

Select * from ViewEmployeeByDepartmentIT

Create View ViewCountEmployeeAllDept
as
Select DeptName, COUNT(tblDepartment.ID) as TotalEmployees
from tblEmployee
join tblDepartment
on tblEmployee.DeptID = tblDepartment.ID
GROUP BY DeptName

Select * from ViewCountEmployeeAllDept

Update ViewEmployeeByDepartment Set Name = 'Arnold J' Where Id= 5 --dziala dla danych z 1 table'a
Update ViewEmployeeByDepartment Set Name = 'Arnold J' Where DeptName='IT' --nie dziala
Delete from ViewEmployeeByDepartment where ID = 16
Insert into ViewEmployeeByDepartment values (16,'Oven', 1,5000, 'New York', 2) --dla view ktory operuje na 1 table

--Indexed views

Create Table tblProduct(
 ProductId int primary key,
 Name nvarchar(20),
 UnitPrice int
)

Create Table tblProductSales(
 ProductId int,
 QuantitySold int
)

Insert into tblProduct Values(1, 'Books', 20)
Insert into tblProduct Values(2, 'Pens', 14)
Insert into tblProduct Values(3, 'Pencils', 11)
Insert into tblProduct Values(4, 'Clips', 10)

Insert into tblProductSales values(1, 10)
Insert into tblProductSales values(3, 23)
Insert into tblProductSales values(4, 21)
Insert into tblProductSales values(2, 12)
Insert into tblProductSales values(1, 13)
Insert into tblProductSales values(3, 12)
Insert into tblProductSales values(4, 13)
Insert into tblProductSales values(1, 11)
Insert into tblProductSales values(2, 12)
Insert into tblProductSales values(1, 14)

Create view ViewTotalSalesByProduct
with SchemaBinding --rules
as
Select Name, 
SUM(ISNULL((QuantitySold * UnitPrice), 0)) as TotalSales, --always isnull if possible
COUNT_BIG(*) as TotalTransactions --not count
from dbo.tblProductSales
join dbo.tblProduct
on dbo.tblProduct.ProductId = dbo.tblProductSales.ProductId
group by Name

Select * from ViewTotalSalesByProduct

--use when not to much of delete/insert/update, saves time from counting
--now when select this view, returns the data from index
Create Unique Clustered Index IndexViewTotalSalesByProduct
on ViewTotalSalesByProduct(Name)

--No parameters, use table value functions
--rules and defaluts cannot
--order by is invalid
--doesnt work on temporary tables

------------------------------trigger--------------------------------------
CREATE TABLE tblEmployeeAudit
(
  Id int identity(1,1) primary key,
  AuditData nvarchar(1000)
)

---------------on insert------------
CREATE TRIGGER Trigger_Employee_Insert_Audit
ON tblEmployee
FOR INSERT
AS
BEGIN
 Declare @Id int
 Select @Id = ID from inserted --inserted to co wstawiamy
 
 insert into tblEmployeeAudit 
 values('New employee with Id  = ' + Cast(@Id as nvarchar(5)) + ' is added at ' + cast(Getdate() as nvarchar(20)))
END

Insert into tblEmployee Values('Andy', 1,5000,'Berlin',2)
Select * from tblEmployeeAudit 

--------------on delete--------------
CREATE TRIGGER Trigger_Employee_Delete_Audit
ON tblEmployee
FOR DELETE
AS
BEGIN
 Declare @Id int
 Select @Id = ID from deleted --to co usuwamy
 
 insert into tblEmployeeAudit 
 values('An existing employee with Id  = ' + Cast(@Id as nvarchar(5)) + ' is deleted at ' + Cast(Getdate() as nvarchar(20)))
END

Delete from tblEmployee where iD=17
Select * from tblEmployeeAudit 

--------------on update----------------
Create trigger Trigger_Employee_Update_Audit
on tblEmployee
for Update
as
Begin
 Select * from deleted --stare wartosci
 Select * from inserted  --nowe wartosci
End

Alter trigger Trigger_Employee_Update_Audit
on tblEmployee
for Update
as
Begin
      -- stare/nowe dane
      Declare @Id int
      Declare @OldName nvarchar(20), @NewName nvarchar(20)
      Declare @OldSalary int, @NewSalary int
      Declare @OldGender int, @NewGender int
      Declare @OldDeptId int, @NewDeptId int
	  Declare @OldCity nvarchar(20), @NewCity nvarchar(20)
      Declare @AuditString nvarchar(1000) -- audyt
      
      -- wszystkie nowe do tempa
      Select *
      into #TempTable
      from inserted
      While(Exists(Select ID from #TempTable)) -- przeszukaj tempa
      Begin
            
            Set @AuditString = '' --wyczysc
           
            -- pojedynczo dlatego top 1
            Select Top 1 @Id = ID, @NewName = Name, 
            @NewGender = GenderID, @NewSalary = Salary,
            @NewDeptId = DeptID, @NewCity = City
            from #TempTable
           
            -- stare dane przypisanie
            Select @OldName = Name, @OldGender = GenderID, 
            @OldSalary = Salary, @OldDeptId = DeptID, @OldCity = City
            from deleted where ID = @Id
   
		    --budowanie stringu       
            Set @AuditString = 'Employee with Id = ' + Cast(@Id as nvarchar(4)) + ' changed'
            if(@OldName <> @NewName)
                  Set @AuditString = @AuditString + ' NAME from ' + @OldName + ' to ' + @NewName
            if(@OldGender <> @NewGender)
                  Set @AuditString = @AuditString + ' GENDERID from ' +Cast(@OldGender as nvarchar(10)) + ' to ' + Cast(@NewGender as nvarchar(10)) 
            if(@OldSalary <> @NewSalary)
                  Set @AuditString = @AuditString + ' SALARY from ' + Cast(@OldSalary as nvarchar(10))+ ' to ' + Cast(@NewSalary as nvarchar(10))   
			if(@OldDeptId <> @NewDeptId)
                  Set @AuditString = @AuditString + ' DepartmentId from ' + Cast(@OldDeptId as nvarchar(10))+ ' to ' + Cast(@NewDeptId as nvarchar(10))
            if(@OldCity <> @NewCity)
                  Set @AuditString = @AuditString + ' CITY from ' + @OldCity + ' to ' + @NewCity
            insert into tblEmployeeAudit values(@AuditString)
            Delete from #TempTable where ID = @Id-- usun i idz dalej
      End
End

Update  tblEmployee set Name = 'James', Salary = 5400, City = 'Berlin'
 where ID=15
 Select * from tblEmployeeAudit 
 Update  tblEmployee set Name = 'Sam', Salary = 2500, City = 'London'
 where ID=15
 --loop wyzej jest po to jakby where ID IN (1,2,3,4)

Create view ViewEmployeeDept
as
Select Name, GenderID, Salary, City, DeptName
from tblEmployee 
join tblDepartment
on tblEmployee.DeptID = tblDepartment.ID

Select * from ViewEmployeeDept

------------------------INSTEAD OF INSERT-----------------
Create trigger Trigger_EmployeeWithDept_InsteadInsert
on ViewEmployeeDept
Instead Of Insert
as
Begin
 Declare @DeptId int
 
--Czy podany Dept istnieje
 Select @DeptId = tblDepartment.ID 
 from tblDepartment 
 join inserted
 on inserted.DeptName = tblDepartment.DeptName
 
--Jak nie to blad
 if(@DeptId is null)
 Begin
  Raiserror('Zla nazwa Dept', 16, 1)
  return
 End
 
 --Jak wszystko ok
 Insert into tblEmployee(Name,GenderID, Salary ,City, DeptID)
 Select Name, GenderID, Salary ,City, @DeptId --musza byc we view
 from inserted
End

Insert into ViewEmployeeDept values ('Samsung', 1, 3600, 'HongKong', 'FAFAAF')--nie ma takiego dept
Insert into ViewEmployeeDept values ('Samsung', 1, 3600, 'HongKong', 'HR')

---------------------INSTEAD OF UPDATE----------------

Create view ViewEmployeeDept2
as
Select tblEmployee.ID, Name, DeptName
from tblEmployee 
join tblDepartment
on tblEmployee.DeptID = tblDepartment.ID

Update ViewEmployeeDept2 set Name='John', DeptName ='Payroll' where ID = 2 --nie mozna bo multitable

Select * from ViewEmployeeDept2

Create Trigger Trigger_EmployeeWithDept_InsteadUpdate
on ViewEmployeeDept2
instead of update
as
Begin
 if(Update(ID))--jak ID
 Begin
  Raiserror('Nie mozna zmienic ID!', 16, 1)
  Return
 End
 if(Update(DeptName)) --jak DeptName
 Begin
  Declare @DeptId int
  Select @DeptId = tblDepartment.ID
  from tblDepartment
  join inserted
  on inserted.DeptName = tblDepartment.DeptName
  if(@DeptId is NULL )
  Begin
   Raiserror('Zla nazwa Dept', 16, 1)
   Return
  End
  Update tblEmployee set DeptID = @DeptId
  from inserted
  join tblEmployee
  on tblEmployee.ID = inserted.ID
 End
 if(Update(Name)) --jak Name
 Begin
  Update tblEmployee set Name = inserted.Name
  from inserted
  join tblEmployee
  on tblEmployee.Id = inserted.ID
 End
End

Update ViewEmployeeDept2 set Name='John', DeptName ='IT' where ID = 15 --juz mozna
Select * from ViewEmployeeDept2

---------------------Insted of Delete---------------
Create Trigger Trigger_EmployeeWithDept_InsteadDelete
on ViewEmployeeDept2
instead of delete
as
Begin
 Delete tblEmployee 
 from tblEmployee
 join deleted
 on tblEmployee.Id = deleted.Id
 
 --Subquery
 --Delete from tblEmployee 
 --where Id in (Select Id from deleted)
End
Delete from ViewEmployeeDept2 where ID =19 --dziala

------------------------------Common Table Expressions-------------------------
--Show dept where Empolyee >3


--View Method stay in db, not needed
Create view ViewCountEmp
as
Select DeptName, DeptID, COUNT(*) as TotalEmployees
from tblEmployee
join tblDepartment
on tblEmployee.DeptID = tblDepartment.ID
group by DeptName, DeptID

Select DeptName, TotalEmployees 
from  ViewCountEmp
where  TotalEmployees >= 3

--Temp Temple, need to dispose in one session
Select DeptName, DeptID, COUNT(*) as TotalEmployees
into #TempCountEmp
from tblEmployee
join tblDepartment
on tblEmployee.DeptID = tblDepartment.ID
group by DeptName, DeptID

Select DeptName, TotalEmployees 
from  #TempCountEmp
where  TotalEmployees >= 3

Drop Table #TempCountEmp

--Table Variable Method, stored as Temp, destroyed after use
Declare @tblCountEmp table
(DeptName nvarchar(20),DeptID int, TotalEmployees int)
Insert @tblCountEmp
Select DeptName, DeptID, COUNT(*) as TotalEmployees
from tblEmployee
join tblDepartment
on tblEmployee.DeptID = tblDepartment.ID
group by DeptName, DeptID

Select DeptName, TotalEmployees
From @tblCountEmp
where  TotalEmployees >= 3

--Derived Table, only in current query
Select DeptName, TotalEmployees
from 
 (
  Select DeptName, DeptID, COUNT(*) as TotalEmployees
  from tblEmployee
  join tblDepartment
  on tblEmployee.DeptID = tblDepartment.ID
  group by DeptName, DeptID
 ) 
as EmployeeCount
where TotalEmployees >= 3

--Common Table Expression (Used in next query)
With CTEEmployeeCount(DeptName, DepartmentId, TotalEmployees)
as
(
 Select DeptName, DeptID, COUNT(*) as TotalEmployees
 from tblEmployee
 join tblDepartment
 on tblEmployee.DeptID = tblDepartment.ID
 group by DeptName, DeptID
)
Select DeptName, TotalEmployees
from CTEEmployeeCount
where TotalEmployees >= 3

With CTESimple(DeptId, Total)--rename totalemployee to total, 2 var need select 2 etc
as
(
Select DeptID, COUNT(*) as TotalEmployees--totalemployee
from tblEmployee
group by DeptID
)
Select DeptName,Total
from  tblDepartment
join CTESimple
ON  tblDepartment.ID=CTESimple.DeptId
order by Total

--MulitCTE
With CTESplit1(DepartmentName, Total)
as
(
 Select DeptName, COUNT(*) as TotalEmployees
 from tblEmployee
 join tblDepartment 
 on tblEmployee.DeptID = tblDepartment.ID
 where DeptName IN ('Payroll','IT')
 group by DeptName
),
CTESplit2(DepartmentName, Total)
as
(
 Select DeptName, COUNT(*) as TotalEmployees
 from tblEmployee
 join tblDepartment 
 on tblEmployee.DeptID = tblDepartment.ID
 group by DeptName 
)
Select * from CTESplit1 
UNION
Select * from CTESplit2

--Update with CTE
With CTEUpdate1
as
(
 Select Id, Name, City from tblEmployee
)
--Select * from CTEUpdate1
--Update on CTE 1 base table
Update CTEUpdate1 Set City = 'Brooklyn' where ID = 10
Select* from tblEmployee

With CTEUpdate2
as
(
 Select tblEmployee.Id, Name, City
  from tblEmployee
  join tblDepartment
  ON tblDepartment.ID=tblEmployee.DeptID
)
--Update on CTE 2 base table (still 1 table update)
Update CTEUpdate2 Set City = 'Vatican' where ID = 10
Select* from tblEmployee

--Update on CTE 2 base (2 table update) CAN'T

--Recursive CTE
Insert into tblManagers Values('Pam', 2)
Insert into tblManagers Values('Tom', 3)
Insert into tblManagers Values('Steve', 7)
Insert into tblManagers Values('Zack', 2)

--JOIN
Select Employee.Name as [Employee Name],
IsNull(Manager.Name, 'Super Boss') as [Manager Name]
from tblManagers Employee
left join tblManagers Manager
on Employee.ManagerID = Manager.ID


--CTE
With
  ManagersCTE (EmployeeId, Name, ManagerId, [Level])
  as
  (
    Select ID, Name, ManagerId, 1
    from tblManagers
    where ManagerId is null --temu co nie ma bossa nad soba daj no name column 1
   
    union all-- polacz z

    Select tblManagers.ID, tblManagers.Name, 
    tblManagers.ManagerId, ManagersCTE.[Level] + 1 --lv tego co jest wyzej
    from tblManagers
    join ManagersCTE
    on tblManagers.ManagerID = ManagersCTE.EmployeeId --z tad wiem lv managera
  )
--Select * from ManagersCTE
Select EmpCTE.Name as Employee, Isnull(MgrCTE.Name, 'Super Boss') as Manager, 
EmpCTE.[Level] 
from ManagersCTE EmpCTE
left join ManagersCTE MgrCTE
on EmpCTE.ManagerId = MgrCTE.EmployeeId

--------------------------NORMALIZATION------------------------------
--Redudency, disk space, data inconsistency, insert, update, delete can be slow
----First Normal Form
--Atomic(no multiple values in 1 column like cos, cos, cos)
--No repeating columns (like emp1, emp2, emp3 => better split)
--Identity on Primary Key
----Second Normal Form
--All before
--Redudant data to separtae table
--Relation with Foreign keys
----Third Normal Form
--All before
--Columns fully dependent on primary key


--------------------------PIVOT----------------------------------
Create Table tblProductsSale
(
 Id int primary key,
 SalesAgent nvarchar(50),
 SalesCountry nvarchar(50),
 SalesAmount int
)

Insert into tblProductsSale values(1, 'Tom', 'UK', 200)
Insert into tblProductsSale values(2, 'John', 'US', 180)
Insert into tblProductsSale values(3, 'John', 'UK', 260)
Insert into tblProductsSale values(4, 'David', 'India', 450)
Insert into tblProductsSale values(5, 'Tom', 'India', 350)
Insert into tblProductsSale values(6, 'David', 'US', 200)
Insert into tblProductsSale values(7, 'Tom', 'US', 130)
Insert into tblProductsSale values(8, 'John', 'India', 540)
Insert into tblProductsSale values(9, 'John', 'UK', 120)
Insert into tblProductsSale values(10, 'David', 'UK', 220)
Insert into tblProductsSale values(11, 'John', 'UK', 420)
Insert into tblProductsSale values(12, 'David', 'US', 320)
Insert into tblProductsSale values(13, 'Tom', 'US', 340)
Insert into tblProductsSale values(14, 'Tom', 'UK', 660)
Insert into tblProductsSale values(15, 'John', 'India', 430)
Insert into tblProductsSale values(16, 'David', 'India', 230)
Insert into tblProductsSale values(17, 'David', 'India', 280)
Insert into tblProductsSale values(18, 'Tom', 'UK', 480)
Insert into tblProductsSale values(19, 'John', 'US', 360)
Insert into tblProductsSale values(20, 'David', 'UK', 140)


Select * from tblProductsSale

Select SalesCountry, SalesAgent, SUM(SalesAmount) as Total
from tblProductsSale
group by SalesCountry, SalesAgent
order by SalesCountry, SalesAgent

--Pivot with 
Select SalesAgent, India, US, UK
from
(
   Select SalesAgent, SalesCountry, SalesAmount from tblProductsSale
) as SourceTable
Pivot
(
 Sum(SalesAmount) for SalesCountry in (India, US, UK)
) as PivotTable

-----------------------------ERRORS------------------------------------

Create Table tblProductErrors
(
 ProductId int NOT NULL primary key,
 Name nvarchar(50),
 UnitPrice int,
 QtyAvailable int
)

Create Table tblProductSalesErrors
(
 ProductSalesId int primary key,
 ProductId int,
 QuantitySold int
)
Insert into tblProductErrors values(1, 'Laptops', 2340, 100)
Insert into tblProductErrors values(2, 'Desktops', 3467, 50)

--bez error
Create Procedure spSellProductErrorsOk
@ProductId int,
@IleSprzedac int
as
Begin
 -- sprawdzamy czy ilosc sie zgadza z tym co mamy
 Declare @IleJest int
 Select @IleJest = QtyAvailable from tblProductErrors where ProductId = @ProductId
 -- za malo
 if(@IleJest < @IleSprzedac)
   Begin
  Raiserror('Za ma³o w magazynie',16,1) --16, user moze to naprawic podajac prawidlowa liczbe
  --1, error state od 1 do 127 przy raiserror
   End
  --ok
 Else
   Begin
    Begin Tran
  Update tblProductErrors set QtyAvailable = (QtyAvailable - @IleSprzedac)
  where ProductId = @ProductId
  
  Declare @MaxProductSalesId int
  Select @MaxProductSalesId = Case 
  When MAX(ProductSalesId) IS NULL Then 0 --jesli jest pusta to 0
  else MAX(ProductSalesId) 
  end from tblProductSalesErrors
  -- dodaj 1 do ID
  Set @MaxProductSalesId = @MaxProductSalesId + 1
  Insert into tblProductSalesErrors values(@MaxProductSalesId, @ProductId, @IleSprzedac)
    Commit Tran
   End
End

Select * from tblProductErrors
Select * from tblProductSalesErrors

Execute spSellProductErrorsOk 1, 10

--@@Error
Create Procedure spSellProductErrors
@ProductId int,
@IleSprzedac int
as
Begin
 Declare @IleJest int
 Select @IleJest = QtyAvailable from tblProductErrors where ProductId = @ProductId
 if(@IleJest < @IleSprzedac)
   Begin
  Raiserror('Za ma³o w magazynie',16,1)
   End
  --ok
 Else
   Begin
    Begin Tran
  Update tblProductErrors set QtyAvailable = (QtyAvailable - @IleSprzedac)
  where ProductId = @ProductId
  
  Declare @MaxProductSalesId int
  Select @MaxProductSalesId = Case 
  When MAX(ProductSalesId) IS NULL Then 0 --jesli jest pusta to 0
  else MAX(ProductSalesId) 
  end from tblProductSalesErrors
  --Set @MaxProductSalesId = @MaxProductSalesId + 1
  Insert into tblProductSalesErrors values(@MaxProductSalesId, @ProductId, @IleSprzedac)
 if(@@ERROR <> 0)
  Begin
   Rollback Tran
   Print 'Rolled Back Transaction'
  End
  Else
  Begin
   Commit Tran 
   Print 'Committed Transaction'
  End
   End
End

Execute spSellProductErrors 1, 10

--Error
Insert into tblProductErrors values(2, 'Mobile Phone', 1500, 100)
if(@@ERROR <> 0)
 Print 'Error Occurred'
Else
 Print 'No Errors'

--No Error, po pamieta ostatnia funkcje
Insert into tblProductErrors values(2, 'Mobile Phone', 1500, 100)
Select * from tblProductErrors
if(@@ERROR <> 0)
 Print 'Error Occurred'
Else
 Print 'No Errors'

--Error, bo zapamietalismy go
Declare @Error int
Insert into tblProductErrors values(2, 'Mobile Phone', 1500, 100)
Set @Error = @@ERROR
Select * from tblProductErrors
if(@Error <> 0)
 Print 'Error Occurred'
Else
 Print 'No Errors'

 --TRY CATCH (NIE MOZNA U¯YWAÆ W FUNKCJACH USEROWYCH!)
 Create Procedure spSellProductErrorsTryCatch
@ProductId int,
@IleSprzedac int
as
Begin
 Declare @IleJest int
 Select @IleJest = QtyAvailable from tblProductErrors where ProductId = @ProductId
 if(@IleJest < @IleSprzedac)
   Begin
  Raiserror('Za ma³o w magazynie',16,1)
   End
  --ok
 Else
   Begin
   Begin Try
    Begin Tran
  Update tblProductErrors set QtyAvailable = (QtyAvailable - @IleSprzedac)
  where ProductId = @ProductId
  
  Declare @MaxProductSalesId int
  Select @MaxProductSalesId = Case 
  When MAX(ProductSalesId) IS NULL Then 0 --jesli jest pusta to 0
  else MAX(ProductSalesId) 
  end from tblProductSalesErrors
  --Set @MaxProductSalesId = @MaxProductSalesId + 1
  Insert into tblProductSalesErrors values(@MaxProductSalesId, @ProductId, @IleSprzedac)
  Commit Transaction
    End Try
    Begin Catch 
  Rollback Transaction
  Select --Informacje o bledzie
   ERROR_NUMBER() as ErrorNumber,
   ERROR_MESSAGE() as ErrorMessage,
   ERROR_PROCEDURE() as ErrorProcedure,
   ERROR_STATE() as ErrorState,
   ERROR_SEVERITY() as ErrorSeverity,
   ERROR_LINE() as ErrorLine
    End Catch 
   End
End

Execute spSellProductErrorsTryCatch 1, 10

----------------------------TRANSACTIONS-----------------------------------
--Jak jest w begin trans to jest zablokowane wszystko co zmieniamy(nie cala tabela)
--jak cos (nawet 1) nie poszlo ok w transakcji to ja cofamy ca³kowicie
Create Procedure spTransactionFail
as
Begin
Begin Try
Begin Tran
Update tblProductErrors set Name = 'Laptop 2'
where ProductId = 1
Update tblProductErrors set ProductId = 1
where ProductId = 2
  Commit Transaction
  Print 'Transaction Commited'
 End Try
 Begin Catch
  Rollback Transaction
    Print 'Transaction Rolled Back'
 End Catch
End

Execute spTransactionFail
Select * from tblProductErrors

--ACID--
--A - Atomic - albo sie wykona cale, ale wogole
--C - Consistent - nic nie moze zniknac
--I - Isolated - nie interwencuje w inne transkacje
--D - Durable - jak cos pojdzie nie tak (power outrage) to cofa do poprzedniego

--concurrent transactions

BEGIN TRY
    BEGIN TRANSACTION
         UPDATE tblProductErrors SET UnitPrice = UnitPrice - 100 WHERE ProductId = 1
		 -- UPDATE tblProductErrors SET UnitPrice = UnitPrice + 100 WHERE ProductId = '2' --failed trasation
         UPDATE tblProductErrors SET UnitPrice = UnitPrice + 100 WHERE ProductId = 2
    COMMIT TRANSACTION
    PRINT 'Transaction Committed'
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
    PRINT 'Transaction Rolled back'
END CATCH

-------DIRTY READ------------
--read bez zmiany i commitu
--update czegos, read czegos, rollback tego pierwszego
--Read Commited czeka na commit, i blokuje inne ready
Set transaction isolation level read committed --default
Waitfor Delay '00:00:10' --symuluj delay
-------LOST UPDATE------------
--1 czyta, 2 czyta, 1 update, 2 update i 2 update sie nie zgadza
--problem w read committed i read uncommitted
Set transaction isolation level repeatable read --fix
------------NON REPEATABLE READ---------------
--1 czyta, 2 update, 1 czyta
Set transaction isolation level repeatable read --fix, readed data i prevented from update
--------------PHANTOM READ-------------------
--1 czyta z where, 2 insert, 1 czyta z where
Set transaction isolation level serializable --fix, readed data is prevented from insert
--------------SNAPSHOT ISOLATION LEVEL----------------
--Isolation VS serializable -- serializable lock vs not locking
Alter database SampleDB SET ALLOW_SNAPSHOT_ISOLATION ON --pozwala na Isolation
Set transaction isolation level snapshot -- dziala na kopii daty, w tempdb, blocked when update until complete and then gives error
------------READ COMMITED SNAPSHOT ISOLATION LEVEL----------------
--read commited - cant read when update
Alter database SampleDB SET READ_COMMITTED_SNAPSHOT ON--pozwala na snapshot
Set transaction isolation level snapshot --tak samo jak read commited
-------------SNAPSHOT vs READ COMMITTED SNAPSHOT----------------
--Update conflict / not
--without changes to the application / changes may be required
--distributed transaction / cant
--transaction level read consistency/ tatement-level read consistency



--------------------------Subquery--------------------------------
Create Table tblProductsSub
(
 [Id] int identity primary key,
 [Name] nvarchar(50),
 [Description] nvarchar(250)
)

Create Table tblProductSalesSub
(
 Id int primary key identity,
 ProductId int foreign key references tblProductsSub(Id),
 UnitPrice int,
 QuantitySold int
)

Insert into tblProductsSub values ('TV', '52 inch black color LCD TV')
Insert into tblProductsSub values ('Laptop', 'Very thin black color acer laptop')
Insert into tblProductsSub values ('Desktop', 'HP high performance desktop')

Insert into tblProductSalesSub values(3, 450, 5)
Insert into tblProductSalesSub values(2, 250, 7)
Insert into tblProductSalesSub values(3, 450, 4)
Insert into tblProductSalesSub values(3, 450, 9)

Select * from tblProductsSub
Select * from tblProductSalesSub


--wszystko co nie zostalo sprzedane 
Select [Id], [Name], [Description]
from tblProductsSub
where Id not in (Select Distinct ProductId from tblProductSalesSub) 
--subquery w nawiasie (noncorrelated, mo¿na wykonaæ subquery samodzielnie)

--to samo tylko joinem
Select tblProductsSub.[Id], [Name], [Description]
from tblProductsSub
left join tblProductSalesSub
on tblProductsSub.Id = tblProductSalesSub.ProductId
where tblProductSalesSub.ProductId IS NULL

--suma ile czego sie sprzedalo
Select [Name],
(Select SUM(QuantitySold) from tblProductSalesSub where ProductId = tblProductsSub.Id) as TotalQuantity
from tblProductsSub
order by Name
--subquery correlated, nie mozna wykonac samodzielnie bo potrzebuje tblProductsSub

--to samo joinem
Select [Name], SUM(QuantitySold) as TotalQuantity
from tblProductsSub
left join tblProductSalesSub
on tblProductsSub.Id = tblProductSalesSub.ProductId
group by [Name]
order by Name

----------------------Random data performence---------------------------------

--usun jezeli istnieje
If (Exists (select * 
            from information_schema.tables --spis wszystkich table
            where table_name = 'tblProductSalesPerf'))
Begin
 Drop Table tblProductSalesPerf
End

If (Exists (select * 
            from information_schema.tables 
            where table_name = 'tblProductsPerf'))
Begin
 Drop Table tblProductsPerf
End

--stworz tabele
Create Table tblProductsPerf
(
 [Id] int identity primary key,
 [Name] nvarchar(50),
 [Description] nvarchar(250)
)

Create Table tblProductSalesPerf
(
 Id int primary key identity,
 ProductId int foreign key references tblProductsPerf(Id),
 UnitPrice int,
 QuantitySold int
)

--Random data
Declare @Id int
Set @Id = 1

While(@Id <= 1000)--tyle danych
Begin
 Insert into tblProductsPerf values('Product - ' + CAST(@Id as nvarchar(20)), 
 'Product - ' + CAST(@Id as nvarchar(20)) + ' Description')
 Print @Id
 Set @Id = @Id + 1
End

--druga tabela

declare @RandomProductId int
declare @RandomUnitPrice int
declare @RandomQuantitySold int

--max i min w random
declare @UpperLimitForProductId int
declare @LowerLimitForProductId int
declare @UpperLimitForUnitPrice int
declare @LowerLimitForUnitPrice int
declare @UpperLimitForQuantitySold int
declare @LowerLimitForQuantitySold int
set @LowerLimitForProductId = 1
set @UpperLimitForProductId = 1000
set @LowerLimitForUnitPrice = 1
set @UpperLimitForUnitPrice = 100
set @LowerLimitForQuantitySold = 1
set @UpperLimitForQuantitySold = 10


Declare @Counter int
Set @Counter = 1
While(@Counter <= 1500)
Begin
 select @RandomProductId = Round(((@UpperLimitForProductId - @LowerLimitForProductId) * Rand() + @LowerLimitForProductId), 0) --round bo to float
 select @RandomUnitPrice = Round(((@UpperLimitForUnitPrice - @LowerLimitForUnitPrice) * Rand() + @LowerLimitForUnitPrice), 0)
 select @RandomQuantitySold = Round(((@UpperLimitForQuantitySold - @LowerLimitForQuantitySold) * Rand() + @LowerLimitForQuantitySold), 0)
 
 Insert into tblProductsalesPerf
 values(@RandomProductId, @RandomUnitPrice, @RandomQuantitySold)

 Print @Counter
 Set @Counter = @Counter + 1
End

Select * from tblProductsPerf
Select * from tblProductSalesPerf order by ProductId

---------------------------subqueries vs join----------------------

CHECKPOINT; 
GO 
DBCC DROPCLEANBUFFERS; -- Clear query cache
Go
DBCC FREEPROCCACHE; -- Clear execution plan cache
GO

--supquery
Select Id, Name, [Description]
from tblProductsPerf
where Not Exists(Select * from tblProductSales where ProductId = tblProductsPerf.Id)

--join
Select tblProductsPerf.Id, Name, [Description]
from tblProductsPerf
left join tblProductSalesPerf
on tblProductsPerf.Id = tblProductSalesPerf.ProductId
where tblProductSalesPerf.ProductId IS NULL 

--join jest szybsze niz supquery(w praktyce takie same), sprowadza sie do execution planu bo to to samo

-------------------Cursors-------------------
--wskaznik na row
--wolne, bo bada kazdy

Select * from tblProductsPerf
Select * from tblProductSalesPerf

Declare @ProductID int
Declare @Name nvarchar(30)

Declare ProductCursor CURSOR FOR 
Select Id,Name from tblProductsPerf where ID <=1000

Open ProductCursor --otworz

Fetch Next from ProductCursor INTO @ProductID, @Name

While(@@FETCH_STATUS = 0)--status 0 czyli jest jeszcze w cursorze
Begin
print 'Id =' + Cast(@ProductID as Nvarchar(10))+ 'Name =' +@Name
Fetch Next from ProductCursor into @ProductID, @Name
End

Close ProductCursor --zamknij
Deallocate ProductCursor --zwolnij

--cursor co jesli name 55 to cena tyle, 65 to 65, 99% to cena 1000
Declare @ProductId int
Declare ProductIdCursor CURSOR FOR 
Select ProductId from tblProductSalesPerf

Open ProductIdCursor

Fetch Next from ProductIdCursor into @ProductId

While(@@FETCH_STATUS = 0)
Begin
 Declare @ProductName nvarchar(50)
 Select @ProductName = Name from tblProductsPerf where Id = @ProductId

 if(@ProductName = 'Product - 55')
 Begin
  Update tblProductSalesPerf set UnitPrice = 55 where ProductId = @ProductId
 End
 else if(@ProductName = 'Product - 65')
 Begin
  Update tblProductSalesPerf set UnitPrice = 65 where ProductId = @ProductId
 End
 else if(@ProductName like 'Product - 99%')
 Begin
  Update tblProductSalesPerf set UnitPrice = 1000 where ProductId = @ProductId
 End
 Fetch Next from ProductIdCursor into @ProductId 
End

CLOSE ProductIdCursor 
DEALLOCATE ProductIdCursor

--sprwadzenie
Select  Name, UnitPrice 
from tblProductsPerf join
tblProductSalesPerf on tblProductsPerf.Id = tblProductSalesPerf.ProductId
where (Name='Product - 55' or Name='Product - 65' or Name like 'Product - 99%')

--Joins in place of cursors
--szybszy bo filtruje wherem

Update tblProductSalesPerf
set UnitPrice = 
 Case --gdy name taki, gdy name taki
  When Name = 'Product - 55' Then 155 
  When Name = 'Product - 65' Then 165
  When Name like 'Product - 99%' Then 10001
 End     
from tblProductSalesPerf
join tblProductsPerf
on tblProductsPerf.Id = tblProductSalesPerf.ProductId
Where Name = 'Product - 55' or Name = 'Product - 65' or 
Name like 'Product - 99%'

---------------------WSZYSTKIE TABLE------------------

Select * from SYSOBJECTS where XTYPE='U' --tylko table
Select Distinct XTYPE from SYSOBJECTS --co jest dostepne w testing
Select * from  SYS.TABLES --table
Select * from SYS.views --views, etc
Select * from INFORMATION_SCHEMA.TABLES --table i views
Select * from INFORMATION_SCHEMA.ROUTINES --procedury

--https://docs.microsoft.com/en-us/sql/relational-databases/system-compatibility-views/sys-sysobjects-transact-sql?redirectedfrom=MSDN&view=sql-server-ver15
--IT - Internal table
--P - Stored procedure
--PK - PRIMARY KEY constraint
--S - System table 
--SQ - Service queue
--U - User table
--V - View

--------------------RERUNABLE SCRIPTS--------------

Use [Testing]
If not exists (select * from information_schema.tables where table_name = 'Test3')
Begin
 Create table Test3
 (
  ID int identity primary key,
  Name nvarchar(100),
  Gender nvarchar(10),
  DateOfBirth DateTime
 )
 Print 'Table Test3 successfully created'
End
Else
Begin
 Print 'Table Test3 already exists'
End

Use [Testing]
IF OBJECT_ID('Test3') IS NULL --object_id ma kazda tabela
Begin
--create table
   Print 'Table Test3 created'
End
Else
Begin
   Print 'Table Test3 already exists'
End

Use [Testing]
IF OBJECT_ID('Test3') IS NOT NULL
Begin
 Drop Table Test3
End
Create table Test3
(
 ID int identity primary key,
 Name nvarchar(100),
 Gender nvarchar(10),
 DateOfBirth DateTime
)

Use [Testing]
if not exists(Select * from INFORMATION_SCHEMA.COLUMNS where COLUMN_NAME='EmailAddress' and TABLE_NAME = 'Test3' and TABLE_SCHEMA='dbo') 
Begin
 ALTER TABLE Test3
 ADD EmailAddress nvarchar(50)
End
Else
BEgin
 Print 'Column EmailAddress already exists'
End

------------------OPTIONAL PARAMETERS----------------

--table
CREATE TABLE tblEmployeeOptionalPar
(
 Id int IDENTITY PRIMARY KEY,
 Name nvarchar(50),
 Email nvarchar(50),
 Age int,
 Gender nvarchar(50),
 HireDate date,
)

Insert into tblEmployeeOptionalPar values
('Sara Nan','Sara.Nan@test.com',35,'Female','1999-04-04')
Insert into tblEmployeeOptionalPar values
('James Histo','James.Histo@test.com',33,'Male','2008-07-13')
Insert into tblEmployeeOptionalPar values
('Mary Jane','Mary.Jane@test.com',28,'Female','2005-11-11')
Insert into tblEmployeeOptionalPar values
('Paul Sensit','Paul.Sensit@test.com',29,'Male','2007-10-23')

Create Proc spSearchEmployees
@Name nvarchar(50) = NULL, --=cos oznacza ze nie manditory, default
@Email nvarchar(50) = NULL,
@Age int = NULL,
@Gender nvarchar(50) = NULL
as
Begin
 Select * from tblEmployeeOptionalPar where
 (Name = @Name OR @Name IS NULL) AND
 (Email = @Email OR @Email IS NULL) AND
 (Age = @Age OR @Age IS NULL) AND
 (Gender = @Gender OR @Gender IS NULL) 
End

Execute spSearchEmployees -- This command will return all the rows
Execute spSearchEmployees @Gender = 'Male' -- Retruns only Male employees
Execute spSearchEmployees @Gender = 'Male', @Age = 29 -- Retruns Male employees whose age is 29

-------------------MERGE--------------------

Create table StudentSource
(
     ID int primary key,
     Name nvarchar(20)
)
GO

Create table StudentTarget
(
     ID int primary key,
     Name nvarchar(20)
)
GO

Insert into StudentSource values (1, 'Mike')
Insert into StudentSource values (2, 'Sara')
GO

Insert into StudentTarget values (1, 'Mike M')
Insert into StudentTarget values (3, 'John')
GO

--usun w target to czego nie ma w source i insertuj  to czego nie ma
MERGE StudentTarget AS T
USING StudentSource AS S
ON T.ID = S.ID
WHEN MATCHED THEN
     UPDATE SET T.NAME = S.NAME
WHEN NOT MATCHED BY TARGET THEN
     INSERT (ID, NAME) VALUES(S.ID, S.NAME)
WHEN NOT MATCHED BY SOURCE THEN
     DELETE;--srednik musi byc


truncate table StudentTarget --clear
truncate table StudentSource

--insertuj do taregetu to czego nie ma w sourcie
MERGE StudentTarget AS T
USING StudentSource AS S
ON T.ID = S.ID
WHEN MATCHED THEN
     UPDATE SET T.NAME = S.NAME
WHEN NOT MATCHED BY TARGET THEN
     INSERT (ID, NAME) VALUES(S.ID, S.NAME);

select * from StudentSource
select * from StudentTarget