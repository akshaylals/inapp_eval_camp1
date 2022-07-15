CREATE DATABASE eval_q3;
USE eval_q3;

--Create table Department
CREATE TABLE Department(
	deptno INT NOT NULL PRIMARY KEY,
	dname VARCHAR(20),
	loc VARCHAR(20)
);

CREATE TABLE Employee(
	empno INT NOT NULL PRIMARY KEY,
	ename VARCHAR(20),
	job VARCHAR(20),
	mgr INT,
	hiredate DATE,
	sal MONEY,
	commission MONEY,
	deptno INT NOT NULL,
	CONSTRAINT dept_fk
		FOREIGN KEY (deptno)
		REFERENCES Department(deptno)
);


--Insert data into tables
INSERT INTO Department VALUES
    (10, 'ACCOUNTING', 'NEW YORK'),
    (20, 'RESEARCH', 'DALLAS'),
    (30, 'SALES', 'CHICAGO'),
    (40, 'OPERATIONS', 'BOSTON');

INSERT INTO Employee VALUES
    (7839, 'KING', 'PRESIDENT', NULL, '11/17/1981', 5000, NULL, 10),
    (7698, 'BLAKE', 'MANAGER', 7839, '05/01/1981', 2850, NULL, 30),
    (7782, 'CLARK', 'MANAGER', 7839, '06/09/1981', 2450, NULL, 10),
    (7566, 'JONES', 'MANAGER', 7839, '04/02/1981', 2975, NULL, 20),
    (7788, 'SCOTT', 'ANALYST', 7566, '12/09/1982', 3000, NULL, 20),
    (7902, 'FORD', 'ANALYST', 7566, '12/03/1981', 3000, NULL, 20),
    (7369, 'SMITH', 'CLERK', 7902, '12/17/1980', 800,  NULL,20),
    (7499, 'ALLEN', 'SALESMAN', 7698, '02/20/1981', 1600 ,300, 30),
    (7521, 'WARD', 'SALESMAN', 7698, '02/22/1981', 1250 ,500, 30),
    (7654, 'MARTIN', 'SALESMAN', 7698, '09/28/1981', 1250 ,1400, 30),
    (7844, 'TURNER', 'SALESMAN', 7698, '09/08/1981', 1500, NULL, 30),
    (7876, 'ADAMS', 'CLERK', 7788, '01/12/1983', 1100, NULL, 20),
    (7900, 'JAMES', 'CLERK', 7698, '12/03/1981', 950, NULL, 30),
    (7934, 'MILLER', 'CLERK', 7782, '01/23/1982', 1300, NULL, 10);



--1. Report needed: Names of employees who are manager.
--Hint: The names of people who have their own employeeID as the managerID
SELECT ename
FROM Employee
WHERE empno = mgr;


--2. List the name of all employees along with their department name and Annual Income.
--For each row get the output in the form ‘Every Year Mark of Accounts department
--earns amount 450000’. This output has to come under a heading ‘Annual income Report’.
SELECT CONCAT('Every year ', ename, ' of ', Department.dname, ' department earns amount ', sal) AS 'Annual Income Report'
FROM Employee
JOIN Department ON Department.deptno = Employee.deptno;


--3. Report needed: Names of departments and names of employees. Names of departments
--in ascending order. Within the same department, employee name should be in the
--descending order
SELECT Department.dname, Employee.ename
FROM Employee
JOIN Department ON Department.deptno = Employee.deptno
ORDER BY Department.dname ASC, Employee.ename DESC;


--4. Find out employee name and departmentname of employees who either works in a Toy
--or Shoe department.
SELECT Employee.ename, Department.dname
FROM Employee
JOIN Department ON Department.deptno = Employee.deptno
WHERE Department.dname IN ('Toy', 'Shoe');



--5. Report needed: Name concatenated with department, separated by comma and space
--and name column Employee and department.
SELECT CONCAT(Employee.ename, ', ', Department.dname) AS 'Employee and department'
FROM Employee
JOIN Department ON Department.deptno = Employee.deptno


--6. Write a query to display name, job, department number and department name for
--all employees who work in DALLAS.
SELECT ename, job, Department.deptno, Department.dname
FROM Employee
JOIN Department ON Department.deptno = Employee.deptno
WHERE Department.loc = 'DALLAS';

--7. List the names of all employees along with name of managers
SELECT E1.ename AS Employee, E2.ename AS Manager
FROM Employee E1, Employee E2
WHERE E1.mgr = E2.empno;


--8. Display all employee name, manager number and manager name of all employees
--including King who have no manager.
SELECT E1.ename AS Employee, E1.mgr AS 'Manager no.', E2.ename AS Manager
FROM Employee AS E1
LEFT JOIN Employee AS E2 ON E1.mgr = E2.empno


--9. Display employee name, department number and all employees that work in same
--department as a given employee (‘Mathew’). Give each column an appropriate label.
SELECT ename, deptno
FROM Employee
WHERE deptno = (SELECT deptno FROM Employee WHERE ename = 'Mathew');


--10. Create a unique listing of all jobs that are in department 30. Include location
--of department 30 in the output.
SELECT DISTINCT job, Department.loc
FROM Employee
JOIN Department ON Department.deptno = Employee.deptno
WHERE Employee.deptno = 30;
