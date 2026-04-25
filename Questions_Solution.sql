USE Northwind;
GO

-- checking all the columns are avilable in databse
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE';

-- 1. Total revenue by product category, sorted highes to lowest

-- Revenue by Category
USE Northwind;
GO

SELECT 
    c.CategoryName,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalRevenue
FROM [Order Details] od
INNER JOIN Products p ON od.ProductID = p.ProductID
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
ORDER BY TotalRevenue DESC;


--2. Top 10 customers by lifetime order value, with their most recent order date
USE Northwind;
GO

SELECT TOP 10
    c.CustomerID,
    c.CompanyName AS CustomerName,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS LifetimeOrderValue,
    MAX(o.OrderDate) AS MostRecentOrderDate
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CompanyName
ORDER BY LifetimeOrderValue DESC;

--3.  All orders where shipped date > 7 days after order date, flagged as 'Delayed'.

SELECT 
    OrderID,
    CustomerID,
    OrderDate,
    ShippedDate,
    DATEDIFF(day, OrderDate, ShippedDate) AS DaysToShip,
    CASE 
        WHEN DATEDIFF(day, OrderDate, ShippedDate) > 7 THEN 'Delayed'
        ELSE 'On Time'
    END AS DeliveryStatus
FROM Orders
WHERE ShippedDate IS NOT NULL   -- exclude orders not yet shipped
ORDER BY DaysToShip DESC;

--4.  Make a .sql file with all queries and the stored procedure. Add inline comments explaining your logic. If you prefer SQLite or PostgreSQL, that is fine.
