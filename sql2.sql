CREATE DATABASE eval_q2;
USE eval_q2;

CREATE TABLE Customer(
	cust_id INT NOT NULL PRIMARY KEY,
	cust_name VARCHAR(20) NOT NULL,
);

CREATE TABLE OrderDetails(
	OrderId INT NOT NULL PRIMARY KEY,
	OrderDate DATE,
	OrderPrice MONEY,
	OrderQuantity INT,
	cust_id INT NOT NULL,
	CONSTRAINT custid_fk
		FOREIGN KEY (cust_id)
		REFERENCES Customer(cust_id)
);

CREATE TABLE ManufacturerDetails(
	Manufr_id INT NOT NULL PRIMARY KEY,
	Manufr_name VARCHAR(20)
);

CREATE TABLE ProductDetails(
	Product_id INT NOT NULL PRIMARY KEY,
	OrderId INT NOT NULL,
	Manufacture_Date DATE,
	Product_Name VARCHAR(20),
	Manufr_id INT NOT NULL,
	CONSTRAINT order_fk
		FOREIGN KEY (OrderId)
		REFERENCES OrderDetails(OrderId),
	CONSTRAINT manufr_fk
		FOREIGN KEY (Manufr_id)
		REFERENCES ManufacturerDetails(Manufr_id)
);

--Insert data
INSERT INTO Customer VALUES
    (1, 'Jayesh'),
    (2, 'Abhilash'),
    (3, 'Lily'),
    (4, 'Aswathy');

INSERT INTO ManufacturerDetails VALUES
	(1, 'Samsung'),
	(2, 'Sony'),
	(3, 'Mi'),
	(4, 'Boat');

INSERT INTO OrderDetails VALUES
    (1, '2020/12/22', 270, 2, 1),
    (2, '2019/08/10', 280, 4, 2),
    (3, '2019/07/13', 600, 5, 3),
    (4, '2020/07/15', 520, 1, 1),
    (5, '2020/12/22', 1200, 4, 4),
    (6, '2019/10/02', 720, 3, 1),
    (7, '2020/11/03', 3000, 2, 3),
    (8, '2020/12/22', 1100, 4, 4),
    (9, '2019/12/29', 5500, 2, 1);

INSERT INTO ProductDetails VALUES
    (145, 2, '2019/12/23', 'MobilePhone', 1),
    (147, 6, '2019/08/15', 'MobilePhone', 3),
    (435, 5, '2018/11/04', 'MobilePhone', 1),
    (783, 1, '2017/11/03', 'LED TV', 2),
    (784, 4, '2019/11/28', 'LED TV', 2),
    (123, 2, '2019/10/03', 'Laptop', 2),
    (267, 5, '2019/11/03', 'Headphone', 4),
    (333, 9, '2017/12/12', 'Laptop', 1),
    (344, 3, '2018/11/03', 'Laptop', 1),
    (233, 3, '2019/11/30', 'PowerBank', 2),
    (567, 6, '2019/09/03', 'PowerBank', 2);


--1) Total number of orders placed in each year.
SELECT YEAR(OrderDate) AS Year, COUNT(OrderId) AS 'Total number of orders'
FROM OrderDetails
GROUP BY YEAR(OrderDate);

--2) Total number of orders placed in each year by Jayesh.
SELECT COUNT(*) AS 'Total number of orders placed in each year by Jayesh'
FROM OrderDetails
JOIN Customer ON Customer.cust_id = OrderDetails.cust_id
WHERE cust_name = 'Jayesh';

--3) Products which are ordered in the same year of its manufacturing year.
SELECT *
FROM ProductDetails
JOIN OrderDetails ON OrderDetails.OrderId = ProductDetails.OrderId
WHERE YEAR(OrderDetails.OrderDate) = YEAR(ProductDetails.Manufacture_Date);

--4) Products which is ordered in the same year of its manufacturing year where the Manufacturer is ‘Samsung’.
SELECT *
FROM ProductDetails
JOIN OrderDetails ON OrderDetails.OrderId = ProductDetails.OrderId
JOIN ManufacturerDetails ON ManufacturerDetails.Manufr_id = ProductDetails.Manufr_id
WHERE YEAR(OrderDetails.OrderDate) = YEAR(ProductDetails.Manufacture_Date)
	AND ManufacturerDetails.Manufr_name = 'Samsung';

--5) Total number of products ordered every year.
SELECT YEAR(OrderDate) AS Year, SUM(OrderQuantity) AS 'Total number of products ordered'
FROM OrderDetails
GROUP BY YEAR(OrderDate);

--6) Display the total number of products ordered every year made by sony.
SELECT YEAR(OrderDate) AS Year,
	SUM(OrderQuantity) AS 'trotal number of products ordered every year made by sony'
FROM OrderDetails
JOIN ProductDetails ON ProductDetails.OrderId = OrderDetails.OrderId
JOIN ManufacturerDetails ON ManufacturerDetails.Manufr_id = ProductDetails.Manufr_id
WHERE Manufr_name = 'Sony'
GROUP BY YEAR(OrderDate);

--7) All customers who are ordering mobile phone by samsung.
SELECT Customer.cust_name
FROM OrderDetails
JOIN ProductDetails ON ProductDetails.OrderId = OrderDetails.OrderId
JOIN ManufacturerDetails ON ManufacturerDetails.Manufr_id = ProductDetails.Manufr_id
JOIN Customer ON Customer.cust_id = OrderDetails.cust_id
WHERE ManufacturerDetails.Manufr_name = 'Samsung'
	AND ProductDetails.Product_Name = 'MobilePhone';

--8) Total number of orders got by each Manufacturer every year.
SELECT ManufacturerDetails.Manufr_name,
	YEAR(OrderDetails.OrderDate) AS Year,
	COUNT(*) AS Year
FROM OrderDetails
JOIN ProductDetails ON ProductDetails.OrderId = OrderDetails.OrderId
JOIN ManufacturerDetails ON ManufacturerDetails.Manufr_id = ProductDetails.Manufr_id
GROUP BY ManufacturerDetails.Manufr_name, YEAR(OrderDetails.OrderDate)

--9) All Manufacturers whose products were sold more than 1500 Rs every year.
SELECT Manufr_name, YEAR(OrderDetails.OrderDate)
FROM OrderDetails
JOIN ProductDetails ON ProductDetails.OrderId = OrderDetails.OrderId
JOIN ManufacturerDetails ON ManufacturerDetails.Manufr_id = ProductDetails.Manufr_id
GROUP BY ManufacturerDetails.Manufr_name, YEAR(OrderDetails.OrderDate)
HAVING SUM(OrderPrice) > 1500