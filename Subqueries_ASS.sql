Use MetroAlt

--1) This involves joining tables, then using a subquery. Return the employee key, last name 
--and first name, position name and hourly rate for those employees receiving the maximum pay rate.
Select EmployeeLastName, EmployeeFirstName, PositionName, EmployeeHourlyPayRate
From dbo.Employee
inner join EmployeePosition
on dbo.Employee.Employeekey=EmployeePosition.EmployeeKey
inner join Position
on position.positionKey=employeePosition.positionKey
Where EmployeeHourlyPayRate=(Select max(EmployeeHourlyPayRate) from EmployeePosition)

--2) Use only subqueries to do this. Return the key, last name and first name of every 
--employee who has the position name “manager.”
/*
Select EmployeeFirstName, EmployeeLastName
From Employee
Where EmployeeKey in
        (Select Employeekey from Employee where employeekey in
      (Select PositionName from Position))
*/

SELECT Employee.EmployeeKey, Employee.EmployeeLastName, Employee.EmployeeFirstName, Position.PositionName
FROM dbo.Employee
JOIN Position
ON Employee.EmployeeKey = Position.PositionKey
WHERE PositionName = 'manager'


--3) This is very difficult. It combines regular aggregate functions, a scalar function, a cast, 
--subqueries and a join. But it produces a useful result. The results should look like this: 
--User Ridership totals for the numbers.
--The Total  is the grand total for all the years. The Percent is Annual Total / Grand Total * 100
SELECT YEAR(BusScheduleAssignmentDate) AS [Year], SUM(Riders) AS [Total Riders],
AVG(Riders) as [Average Riders], (SELECT SUM(Riders) FROM Ridership) as [Grand Total],
(CAST (SUM(Riders)AS decimal(10,2)) / (SELECT SUM(Riders) FROM Ridership)) * 100 as [Percentage of Year Rider] FROM Ridership
JOIN BusScheduleAssignment ON 
BusScheduleAssignment.BusScheduleAssignmentKey = Ridership.BusScheduleAssigmentKey
Group by YEAR(BusScheduleAssignmentDate)

--CTE? with

--4)Create a new table called EmployeeZ. It should have the following structure:
--EmployeeKey int,
--EmployeeLastName nvarchar(255),
--EmployeeFirstName nvarchar(255),
--EmployeeEmail Nvarchar(255)
--Use an insert with a subquery to copy all the employees from 
--the employee table whose last name starts with “Z.”
SELECT * FROM dbo.Employee
CREATE table EmployeeZ
(
EmployeeKey int,
EmployeeLastName nvarchar(255),
EmployeeFirstName nvarchar(255),
EmployeeEmail Nvarchar(255)
)
INSERT INTO EmployeeZ(EmployeeLastName, EmployeeFirstName, EmployeeEmail, EmployeeKey)
Select EmployeeLastName, EmployeeFirstName, EmployeeEmail
FROM dbo.Employee WHERE EmployeeLastName LIKE 'Z%'



--5) This is a correlated subquery. Return the position key, the employee key and the hourly 
--pay rate for those employees who are receiving the highest pay in their positions. 
--Order it by position key.
SELECT Position.PositionKey, Position.PositionName, EmployeePosition.EmployeeHourlyPayRate
FROM dbo.Position
JOIN EmployeePosition
ON Position.PositionKey = EmployeePosition.PositionKey
WHERE EmployeeHourlyPayRate = (SELECT Max(EmployeeHourlyPayRate) FROM EmployeePosition)


