# SQL_Store_Data_Analysis

## Overview
MySQL project that answer real business question of a store dataset, available from w3school website

## Schema
* Customers (CustomerID, CustomerName, ContactName, Address, City, PostalCode, Country)
* Categories (CategoryID,CategoryName, Description)
* Employees (EmployeeID, LastName, FirstName, BirthDate, Photo, Notes)
* order_details(OrderDetailID, OrderID, ProductID, Quantity)
* Orders (OrderID, CustomerID, EmployeeID, OrderDate, ShipperID)
* Products(ProductID, ProductName, SupplierID, CategoryID, Unit, Price)
* Shippers (ShipperID, ShipperName, Phone)

## Real Business Questions
### Basic Level
1. Customer name together with each order the customer made
2. Order id together with name of employee who handled the order
3. Customers who did not placed any order yet
4. Order id together with the name of products
5. Products that no one bought
6. Customer together with the products that he bought
7. Product names together with the name of corresponding category
8. Orders together with the name of the shipping company
9. Customers with id greater than 50 together with each order they made
10. Employees together with orders with order id greater than 10400

### Intermediate Level
1. The most expensive product
2. The second most expensive product
3. Name and price of each product, sort the result by price in decreasing order
4. 5 most expensive products
5. 5 most expensive products without the most expensive (in final 4 products)
6. Name of the cheapest product (only name) without using LIMIT and OFFSET
7. Name of the cheapest product (only name) using subquery
8. Number of employees with LastName that starts with 'D'
9. Customer name together with the number of orders made by the corresponding customer 
sort the result by number of orders in decreasing order
10. Add up the price of all products
11. OrderID together with the total price of  that Order, order the result by total price of order in increasing order
12. Customer who spend the most money
13. Customer who spend the most money and lives in Canada
14. Customer who spend the second most money
15. Shipper together with the total price of proceed orders
