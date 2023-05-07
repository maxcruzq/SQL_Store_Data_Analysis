/**********************************************************************/
/* SQL Queries: Practice your SQL Knowledge (Basuc and Intermediate) */
/**********************************************************************/

/**********************************************************************/
/* Credit to Schema : https://github.com/AndrejPHP/w3schools-database */
/* Credit to Questions : https://github.com/ptyadana/SQL-Data-Analysis-and-Visualization-Projects/blob/master/SQL%20Queries%20-%20Practice%20your%20SQL%20Knowledge/SQL%20Queries%20-%20Practice%20your%20SQL%20Knowledge.mysql.sqle */
/**********************************************************************/
/* Run w3schools.sql to set up database, tables and data*/

/*
----Schema----
Customers (CustomerID, CustomerName, ContactName, Address, City, PostalCode, Country)
Categories (CategoryID,CategoryName, Description)
Employees (EmployeeID, LastName, FirstName, BirthDate, Photo, Notes)
order_details(OrderDetailID, OrderID, ProductID, Quantity)
Orders (OrderID, CustomerID, EmployeeID, OrderDate, ShipperID)
Products(ProductID, ProductName, SupplierID, CategoryID, Unit, Price)
Shippers (ShipperID, ShipperName, Phone)
*/

/**** Basic Level *****/

/*1. Select customer name together with each order the customer made*/
SELECT 
    c.CustomerName, 
    o.OrderID
FROM
    Orders AS o
        INNER JOIN
    Customers AS c ON o.CustomerID = c.CustomerID;

/*2. Select order id together with name of employee who handled the order*/
SELECT 
    o.OrderID, 
    e.LastName, 
    e.FirstName
FROM
    Orders AS o
        INNER JOIN
    Employees AS e ON o.EmployeeID = e.EmployeeID;
    
/*3. Select customers who did not placed any order yet*/
SELECT
	CustomerName
FROM 
	Customers
WHERE CustomerID NOT IN (
							SELECT 
								CustomerID
							FROM Orders);
                            
/*4. Select order id together with the name of products*/
SELECT
	od.OrderID,
    p.ProductName
FROM 
	order_details AS od
		INNER JOIN
	Products AS p ON od.ProductID = p.ProductID;

/*5. Select products that no one bought*/
SELECT
	p.ProductName,
    p.ProductID,
    od.OrderID
FROM
	Products AS p
		LEFT JOIN
	order_details AS od ON p.ProductID = od.ProductID
WHERE od.OrderID IS NULL;

/*6. Select customer together with the products that he bought*/
SELECT
	c.CustomerID,
    c.CustomerName,
    o.OrderID,
    od.ProductID,
    p.ProductName
FROM Customers AS c
		INNER JOIN
	Orders AS o ON c.CustomerID = o.CustomerID
		INNER JOIN
	order_details AS od ON o.OrderID = od.OrderID
		INNER JOIN 
	Products AS p ON od.ProductID = p.ProductID;

/*7. Select product names together with the name of corresponding category*/
SELECT
	p.ProductID,
	p.ProductName,
    ct.CategoryName,
    ct.CategoryID
FROM 
	Products AS p
		INNER JOIN
	Categories as ct ON p.CategoryID = ct.CategoryID;
    
/*8. Select orders together with the name of the shipping company*/
SELECT
	o.OrderID,
    s.ShipperID,
    s.ShipperName
FROM 
	Orders AS o
		LEFT JOIN
	Shippers AS s ON o.ShipperID = s.ShipperID;

/*9. Select customers with id greater than 50 together with each order they made*/
SELECT
	c.CustomerID,
    c.CustomerName,
    o.OrderID
FROM 
	Customers AS c
		INNER JOIN
	Orders as o ON c.CustomerID = o.CustomerID
WHERE c.CustomerID > 50;
    
/*10. Select employees together with orders with order id greater than 10400*/
SELECT
	e.EmployeeID,
    e.LastName,
    e.FirstName,
    o.OrderID
FROM 
	Employees AS e
		LEFT JOIN
	Orders AS o ON e.EmployeeID = o.EmployeeID
WHERE o.OrderID > 10400;

/************ Intermediate Level ************/

/*1. Select the most expensive product*/
SELECT
	ProductID,
    ProductName,
    Price,
    Unit
FROM 
	Products
ORDER BY Price DESC
LIMIT 1;

/*2. Select the second most expensive product*/
WITH Ranks AS (
		SELECT
			RANK() OVER (
				ORDER BY Price DESC
            ) AS Ranking,
            ProductID,
            ProductName,
            Price
		FROM Products
)

SELECT
	Ranking,
    ProductID,
    ProductName,
    Price
FROM Ranks
WHERE Ranking = 2;

/*3. Select name and price of each product, sort the result by price in decreasing order*/
SELECT
	ProductName,
    Price
FROM 
	Products
ORDER BY Price DESC;

/*4. Select 5 most expensive products*/
SELECT
	ProductID,
	ProductName,
    Price
FROM 
	Products
ORDER BY Price DESC
LIMIT 5;

/*5. Select 5 most expensive products without the most expensive (in final 4 products)*/
WITH price_rank AS (
			SELECT 
				RANK() OVER (
					ORDER BY Price DESC) AS Ranking,
				ProductID,
				ProductName,
				Price
				FROM Products
)
SELECT
	*
FROM 
	price_rank
WHERE Ranking BETWEEN 2 AND 5
ORDER BY Ranking;

/*6. Select name of the cheapest product (only name) without using LIMIT and OFFSET*/
WITH lowest_price AS (
					SELECT 
						RANK() OVER (
							ORDER BY Price 
                        ) AS Ranking,
                        ProductID,
                        ProductName,
                        Price
					FROM Products
)

SELECT
	ProductName
FROM 
	lowest_price
WHERE Ranking = 1;
	
/*7. Select name of the cheapest product (only name) using subquery*/
SELECT
	ProductName
FROM 
	Products
WHERE
	ProductID = (
					SELECT
						ProductID
					FROM 
						Products
					ORDER BY Price
                    LIMIT 1
    );

/*8. Select number of employees with LastName that starts with 'D'*/
SELECT
	COUNT(DISTINCT EmployeeID) AS count
FROM 
	Employees
WHERE LastName LIKE 'D%';

/*Just to check that the result is correct*/
SELECT
	LastName,
    FirstName,
	EmployeeID
FROM 
	Employees
WHERE LastName LIKE 'D%';


/* BONUS : same question for Customer this time */
SELECT
	COUNT(DISTINCT CustomerID)
FROM
	Customers
WHERE 
	SUBSTRING_INDEX(CustomerName, ' ', -1) LIKE 'D%';

/* Just to check that the result is correct */
SELECT
	SUBSTRING_INDEX(CustomerName, ' ', 1) AS FirstName,
	SUBSTRING_INDEX(CustomerName, ' ', -1) AS LastName 
FROM
	Customers
WHERE 
	SUBSTRING_INDEX(CustomerName, ' ', -1) LIKE 'D%';

/*9. Select customer name together with the number of orders made by the corresponding customer 
sort the result by number of orders in decreasing order*/
SELECT
	c.CustomerID,
	c.CustomerName,
    COUNT(o.OrderID) AS NumberOfOrders
FROM 
	Customers AS c
		LEFT JOIN
	Orders as o ON c.CustomerID = o.CustomerID
GROUP BY
	c.CustomerID
ORDER BY
	NumberOfOrders DESC,
    c.CustomerName ASC;

/*10. Add up the price of all products*/
SELECT
	SUM(Price) AS PriceAdd
FROM 
	Products;

/*11. Select orderID together with the total price of  that Order, order the result by total price of order in increasing order*/
SELECT
	od.OrderID,
    SUM(od.Quantity * p.Price) AS TotalPrice
FROM 
	order_details AS od
		LEFT JOIN
	Products AS p ON od.ProductID = p.ProductID
GROUP BY
	od.OrderID
ORDER BY
TotalPrice ASC;

/*12. Select customer who spend the most money*/
SELECT
	c.CustomerID,
    c.CustomerName,
    SUM(od.Quantity * p.Price) AS TotalSpend
FROM 
	Customers AS c
		LEFT JOIN 
	Orders AS o ON c.CustomerID = o.CustomerID
		LEFT JOIN
	order_details AS od ON o.OrderID = od.OrderID
		LEFT JOIN
	Products AS p ON od.ProductID = p.ProductID
GROUP BY
	c.CustomerID
ORDER BY
	TotalSpend DESC
LIMIT 1;
    
/*13. Select customer who spend the most money and lives in Canada*/
SELECT
	c.CustomerID,
    c.CustomerName,
    c.Country,
    SUM(od.Quantity * p.Price) AS TotalSpend
FROM 
	Customers AS c
		LEFT JOIN 
	Orders AS o ON c.CustomerID = o.CustomerID
		LEFT JOIN
	order_details AS od ON o.OrderID = od.OrderID
		LEFT JOIN
	Products AS p ON od.ProductID = p.ProductID
WHERE
	c.Country = 'Canada'
GROUP BY
	c.CustomerID
ORDER BY
	TotalSpend DESC
LIMIT 1;

/*14. Select customer who spend the second most money*/
WITH Ranking AS (
					SELECT
						RANK() OVER (
										ORDER BY SUM(od.Quantity * p.Price) DESC
                                        ) AS RankTotalSpend,
						c.CustomerID,
						c.CustomerName,
						SUM(od.Quantity * p.Price) AS TotalSpend
					FROM 
						Customers AS c
							LEFT JOIN 
						Orders AS o ON c.CustomerID = o.CustomerID
							LEFT JOIN
						order_details AS od ON o.OrderID = od.OrderID
							LEFT JOIN
						Products AS p ON od.ProductID = p.ProductID
					GROUP BY
						c.CustomerID
					ORDER BY
						TotalSpend DESC
)
SELECT 
	RankTotalSpend,
    CustomerID,
    CustomerName,
    TotalSpend
FROM
	Ranking
WHERE 
	RankTotalSpend = 2;

/*15. Select shipper together with the total price of proceed orders*/
SELECT
	s.ShipperID,
    s.ShipperName,
    SUM(od.Quantity * p.Price) AS TotalAmount
FROM
	Shippers AS s
		LEFT JOIN
	Orders AS o ON s.ShipperID = o.ShipperID
		LEFT JOIN
	order_details AS od ON o.OrderID = od.OrderID
		LEFT JOIN
	Products AS p ON p.ProductID =  od.ProductID
GROUP BY
	ShipperID
ORDER BY
	TotalAmount DESC;
