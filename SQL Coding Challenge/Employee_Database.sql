create database Employee;
use Employee;

--creating employee table
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Position VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10, 2),
    Location VARCHAR(50)
);

--inserting data values in employee table
INSERT INTO Employee (EmployeeID, FirstName, LastName, Position, Department, Salary, Location) 
VALUES
(101, 'Amit', 'Sharma', 'Software Engineer', 'IT', 60000.00, 'Mumbai'),
(102, 'Priya', 'Singh', 'Data Analyst', 'Analytics', 55000.00, 'Delhi'),
(103, 'Rohan', 'Patel', 'Project Manager', 'Operations', 75000.00, 'Bangalore'),
(104, 'Sonal', 'Gupta', 'HR Specialist', 'HR', 50000.00, 'Chennai'),
(105, 'Vikram', 'Reddy', 'Accountant', 'Finance', 48000.00, 'Hyderabad'),
(106, 'Anita', 'Nair', 'Marketing Exec', 'Marketing', 53000.00, 'Kolkata'),
(107, 'Rajesh', 'Chauhan', 'DevOps Engineer', 'IT', 68000.00, 'Pune'),
(108, 'Kavita', 'Mehta', 'Sales Manager', 'Sales', 72000.00, 'Jaipur'),
(109, 'Arjun', 'Verma', 'Content Writer', 'Marketing', 45000.00, 'Ahmedabad'),
(110, 'Pooja', 'Desai', 'Data Scientist', 'Analytics', 70000.00, 'Surat');

select *from Employee;


-- creating a table departmentbudget
CREATE TABLE DepartmentBudget (
    Department VARCHAR(50),
    Budget DECIMAL(10, 2)
);

--inserting data values into it
INSERT INTO DepartmentBudget (Department, Budget) 
VALUES
('IT', 150000.00),
('Analytics', 100000.00),
('Operations', 120000.00),
('HR', 80000.00),
('Finance', 60000.00),
('Marketing', 110000.00),
('Sales', 95000.00);

select *from DepartmentBudget;


--Display each employee’s name, department, salary, and the department budge.
SELECT e.FirstName, e.LastName, e.Department, e.Salary, d.Budget
FROM Employee e
INNER JOIN DepartmentBudget d ON e.Department = d.Department;


--List employees whose salary is greater than the average salary of all employees 
--in their department (using a subquery).
SELECT EmployeeID, FirstName, LastName, Department, Salary
FROM Employee e
WHERE Salary > (SELECT AVG(Salary) FROM Employee WHERE Department = e.Department);


--Find departments where the total salary of employees is less than the department 
--budget (using a JOIN and GROUP BY).
SELECT e.Department, d.Budget, SUM(e.Salary) AS TotalSalaries
FROM Employee e
INNER JOIN DepartmentBudget d ON e.Department = d.Department
GROUP BY e.Department, d.Budget
HAVING SUM(e.Salary) < d.Budget;


--Show employees with salaries higher than the average salary of all employees (using a subquery).
SELECT EmployeeID, FirstName, LastName, Department, Salary
FROM Employee
WHERE Salary > (SELECT AVG(Salary) FROM Employee);


--Display each department’s name and the number of employees in it (using a subquery to get the count).
SELECT d.Department, (SELECT COUNT(*) FROM Employee e 
WHERE e.Department = d.Department) AS EmployeeCount
FROM DepartmentBudget d;


--Calculate the total salary expense by department.
SELECT Department, SUM(Salary) AS TotalSalary
FROM Employee
GROUP BY Department;


--Find departments with a total salary expense greater than 70,000.
SELECT Department, SUM(Salary) AS TotalSalary
FROM Employee
GROUP BY Department
HAVING SUM(Salary) > 70000;


--Count the number of employees in each department.
SELECT Department, COUNT(EmployeeID) AS EmployeeCount
FROM Employee
GROUP BY Department;


--Find departments with more than 2 employees.
SELECT Department, COUNT(EmployeeID) AS EmployeeCount
FROM Employee
GROUP BY Department
HAVING COUNT(EmployeeID) > 2;


--Find the average salary for each department and display only those with an average salary above 50,000.
SELECT Department, AVG(Salary) AS AverageSalary
FROM Employee
GROUP BY Department
HAVING AVG(Salary) > 50000;
