CREATE DATABASE eval_q1;
USE eval_q1;

--Create Department Table
CREATE TABLE Department(
	dept_id INT NOT NULL PRIMARY KEY,
	dept_name VARCHAR(20) NOT NULL
);

--Create EmployeeDetails table
CREATE TABLE EmployeeDetails(
	emp_id DECIMAL(3) NOT NULL PRIMARY KEY,
	emp_name VARCHAR(30) NOT NULL,
	pay MONEY,
	dept_id INT NOT NULL,
	CONSTRAINT dept_fk
		FOREIGN KEY (dept_id)
		REFERENCES Department(dept_id)
);

--Insert data into Department
INSERT INTO Department VALUES
	(1, 'IT'),
	(2, 'Sales'),
	(3, 'Marketing'),
	(4, 'HR');

--Insert data into EmployeeDetails
INSERT INTO EmployeeDetails VALUES
	(001, 'Dilip', 3000, 1),
	(002, 'Fahad', 4000, 2),
	(003, 'Lal', 6000, 3),
	(004, 'Nivin', 2000, 1),
	(005, 'Vijay', 9000, 2),
	(006, 'Anu', 5000, 4),
	(007, 'Nimisha', 5000, 2),
	(008, 'Praveena', 8000, 3);

--Display:
--1) Total number of employees
SELECT COUNT(*) FROM EmployeeDetails;

--2) Total amount required to pay all employees
SELECT SUM(pay) FROM EmployeeDetails;

--3) Average, minimum and maximum pay in the organization.
SELECT AVG(pay) AS Average, MIN(pay) AS Minimum, MAX(pay) AS Maximum
FROM EmployeeDetails;

--4) Each Department wise total pay
SELECT Department.dept_name AS Department, SUM(EmployeeDetails.pay) AS 'Total pay'
FROM EmployeeDetails
JOIN Department ON Department.dept_id = EmployeeDetails.dept_id
GROUP BY Department.dept_name;

--5) Average, minimum and maximum pay department-wise.
SELECT 
	Department.dept_name AS Department, 
	AVG(EmployeeDetails.pay) AS Average,
	MIN(EmployeeDetails.pay) AS Minimum,
	MAX(EmployeeDetails.pay) AS Maximum
FROM EmployeeDetails
JOIN Department ON Department.dept_id = EmployeeDetails.dept_id
GROUP BY Department.dept_name;

--6) Employee details who earns the maximum pay.
SELECT 
	EmployeeDetails.emp_id, 
	EmployeeDetails.emp_name, 
	EmployeeDetails.pay,
	Department.dept_name
FROM EmployeeDetails 
JOIN Department ON Department.dept_id = EmployeeDetails.dept_id
WHERE pay = (SELECT MAX(pay) FROM EmployeeDetails);

--7) Employee details who is having a maximum pay in the department.
SELECT emp_id, emp_name, pay, Department.dept_name FROM EmployeeDetails
RIGHT JOIN(
	SELECT dept_id, MAX(pay) AS max_pay
	FROM EmployeeDetails
	GROUP BY dept_id
) AS sub ON EmployeeDetails.pay = sub.max_pay AND EmployeeDetails.dept_id = sub.dept_id
JOIN Department ON EmployeeDetails.dept_id = Department.dept_id



--9) Employee who has more pay than the average pay of his department.
SELECT emp_id, emp_name, pay, Department.dept_name FROM EmployeeDetails
RIGHT JOIN(
	SELECT dept_id, AVG(pay) AS avg_pay
	FROM EmployeeDetails
	GROUP BY dept_id
) AS sub ON EmployeeDetails.pay >= sub.avg_pay AND EmployeeDetails.dept_id = sub.dept_id
JOIN Department ON EmployeeDetails.dept_id = Department.dept_id



--10)Unique departments in the company
SELECT dept_name FROM Department;

--11)Employees In increasing order of pay
SELECT emp_id, emp_name, pay, Department.dept_name FROM EmployeeDetails
JOIN Department ON EmployeeDetails.dept_id = Department.dept_id
ORDER BY pay;

--12)Department In increasing order of pay
SELECT Department.dept_name
FROM EmployeeDetails
JOIN Department ON Department.dept_id = EmployeeDetails.dept_id
GROUP BY Department.dept_name
ORDER BY SUM(pay)