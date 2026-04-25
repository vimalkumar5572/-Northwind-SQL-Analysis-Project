-- ============================================
-- File: northwind_queries.sql
-- Purpose: Comprehensive analysis queries and stored procedure
-- Database: Northwind (SQL Server)
-- Author: Generated for learning + interview prep
-- ============================================

USE Northwind;
GO

-- ============================================
-- QUERY 1: Total revenue by product category
-- Sorted from highest earning to lowest.
-- ============================================
-- Explanation:
--   - [Order Details] contains line items with UnitPrice, Quantity, Discount
--   - Products table links to Categories via CategoryID
--   - Revenue per line = UnitPrice * Quantity * (1 - Discount)
--   - SUM() aggregates over all orders, grouped by CategoryName
--   - ORDER BY TotalRevenue DESC puts best-selling category first
-- ============================================
SELECT 
    c.CategoryName,
    SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalRevenue
FROM [Order Details] od
INNER JOIN Products p ON od.ProductID = p.ProductID
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
ORDER BY TotalRevenue DESC;
GO

-- ============================================
-- QUERY 2: Top 10 customers by lifetime order value
-- Also shows their most recent order date.
-- ============================================
-- Explanation:
--   - Join Customers → Orders → Order Details
--   - LifetimeValue = SUM(UnitPrice * Quantity * (1-Discount))
--   - MAX(OrderDate) gives most recent purchase date
--   - GROUP BY customer details, keep TOP 10 ordered by value descending
-- ============================================
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
GO

-- ============================================
-- QUERY 3: Delayed orders
-- Orders where ShippedDate > OrderDate + 7 days
-- Flag as 'Delayed' vs 'On Time'
-- ============================================
-- Explanation:
--   - DATEDIFF(day, OrderDate, ShippedDate) calculates shipping delay in days
--   - CASE WHEN > 7 THEN 'Delayed' ELSE 'On Time' END creates flag
--   - Exclude NULL ShippedDate (orders not yet shipped)
--   - Order by DaysToShip DESC to see worst delays first
-- ============================================
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
WHERE ShippedDate IS NOT NULL
ORDER BY DaysToShip DESC;
GO

-- ============================================
-- STORED PROCEDURE: GetTopCustomers
-- Accepts @TopN parameter and returns top N customers by total spend
-- ============================================
-- Explanation:
--   - Parameterized stored procedure makes query reusable
--   - TOP (@TopN) uses variable to limit rows
--   - Same logic as Query 2, but flexible
--   - EXEC GetTopCustomers @TopN = 5 would return top 5
-- ============================================

-- Drop procedure if it already exists (clean slate)
IF OBJECT_ID('GetTopCustomers', 'P') IS NOT NULL
    DROP PROCEDURE GetTopCustomers;
GO

CREATE PROCEDURE GetTopCustomers
    @TopN INT
AS
BEGIN
    -- Prevent row count message from interfering
    SET NOCOUNT ON;

    SELECT TOP (@TopN)
        c.CustomerID,
        c.CompanyName AS CustomerName,
        SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSpend,
        MAX(o.OrderDate) AS LastOrderDate
    FROM Customers c
    INNER JOIN Orders o ON c.CustomerID = o.CustomerID
    INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY c.CustomerID, c.CompanyName
    ORDER BY TotalSpend DESC;
END;
GO

-- ============================================
-- Example: Execute the stored procedure to get top 5 customers
-- Uncomment below to test
-- ============================================
-- EXEC GetTopCustomers @TopN = 5;