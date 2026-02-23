/* =====================================================
   BUSINESS QUESTIONS
   Project: Sales Analytics
   ===================================================== */

-- 1. Total Revenue, Cost, and Profit
SELECT
    SUM(Quantity * `Unit Price USD`) AS Total_Revenue,
    SUM(Quantity * `Unit Cost USD`) AS Total_Cost,
    SUM(Quantity * (`Unit Price USD` - `Unit Cost USD`)) AS Total_Profit
FROM Sales s
JOIN Products p ON s.ProductKey = p.ProductKey;


-- 2. Revenue and Profit by Year
SELECT
    YEAR(`Order Date`) AS Year,
    SUM(Quantity * `Unit Price USD`) AS Revenue,
    SUM(Quantity * (`Unit Price USD` - `Unit Cost USD`)) AS Profit
FROM Sales s
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY YEAR(`Order Date`)
ORDER BY Year;


-- 3. Top 10 Products by Revenue
SELECT
    p.`Product Name`,
    SUM(s.Quantity * p.`Unit Price USD`) AS Revenue
FROM Sales s
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY p.`Product Name`
ORDER BY Revenue DESC
LIMIT 10;


-- 4. Revenue by Category
SELECT
    p.Category,
    SUM(s.Quantity * p.`Unit Price USD`) AS Revenue
FROM Sales s
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY p.Category
ORDER BY Revenue DESC;


-- 5. Profit Margin by Category
SELECT
    p.Category,
    ROUND(
        SUM(s.Quantity * (p.`Unit Price USD` - p.`Unit Cost USD`))
        / SUM(s.Quantity * p.`Unit Price USD`) * 100, 2
    ) AS Profit_Margin_Percent
FROM Sales s
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY p.Category
ORDER BY Profit_Margin_Percent DESC;


-- 6. Revenue by Country
SELECT
    c.Country,
    SUM(s.Quantity * p.`Unit Price USD`) AS Revenue
FROM Sales s
JOIN Customers c ON s.CustomerKey = c.CustomerKey
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY c.Country
ORDER BY Revenue DESC;


-- 7. Online vs In-Store Sales
SELECT
    st.StoreType,
    SUM(s.Quantity * p.`Unit Price USD`) AS Revenue
FROM Sales s
JOIN Stores st ON s.StoreKey = st.StoreKey
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY st.StoreType;


-- 8. Average Order Value (AOV)
SELECT
    ROUND(
        SUM(s.Quantity * p.`Unit Price USD`) / COUNT(DISTINCT s.OrderNumber),
        2
    ) AS Avg_Order_Value
FROM Sales s
JOIN Products p ON s.ProductKey = p.ProductKey;
