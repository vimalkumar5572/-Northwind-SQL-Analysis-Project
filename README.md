# -Northwind-SQL-Analysis-Project
 This project demonstrates **SQL proficiency** using the classic Northwind database.
 
## 📌 Features

- ✅ Revenue analysis by product category (highest to lowest)
- ✅ Top 10 customers by lifetime order value + most recent order date
- ✅ Identify delayed orders (shipped > 7 days after order date)
- ✅ Stored procedure `GetTopCustomers` with parameter `@TopN`

## 🗄️ Database

- Microsoft SQL Server (Northwind)
- Can be adapted to PostgreSQL / SQLite

## 📂 Files

| File | Description |
|------|-------------|
| `northwind_queries.sql` | Main file – 3 analytical queries + 1 stored procedure |
| `northwind_setup.sql` | Optional – creates Northwind database (from official script) |

## 🚀 How to Run

1. Install **SQL Server** and **SSMS** (or any SQL editor)
2. Restore / create **Northwind** database  
   (Use `northwind_setup.sql` if needed)
3. Open `northwind_queries.sql` in SSMS
4. Execute entire script (F5)

## 📊 Sample Output

### Query 1 – Revenue by Category

| CategoryName     | TotalRevenue |
|------------------|--------------|
| Beverages        | 267,868.73   |
| Dairy Products   | 234,507.98   |
| Confections      | 167,357.33   |

### Query 2 – Top 10 Customers

| CustomerID | CustomerName       | LifetimeOrderValue | MostRecentOrderDate |
|------------|--------------------|--------------------|---------------------|
| SAVE-A     | Save-a-lot Markets | 187,500.00         | 1998-05-06          |

### Query 3 – Delayed Orders

| OrderID | DaysToShip | DeliveryStatus |
|---------|------------|----------------|
| 11011   | 14         | Delayed        |

## 🧠 Stored Procedure Example

```sql
EXEC GetTopCustomers @TopN = 5;
