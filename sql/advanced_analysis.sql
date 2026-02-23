-- ============================================
-- ADVANCED SALES ANALYSIS
-- ============================================
-- This file contains business-driven SQL analysis
-- after data cleaning and validation.
-- ============================================


-- 1. Monthly Revenue Trend
-- Helps understand seasonality and growth
SELECT
    YEAR(`Order Date`) AS Year,
    MONTH(`Order Date`) AS Month,
    SUM(s.Quantity * p.`Unit Price USD`) AS Revenue
FROM Sales s
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY YEAR(`Order Date`), MONTH(`Order Date`)
ORDER BY Year, Month;


-- 2. Top 5 Customers by Revenue
-- Identifies high-value customers
SELECT
    c.CustomerKey,
    CONCAT(c.FirstName, ' ', c.LastName) AS Customer_Name,
    SUM(s.Quantity * p.`Unit Price USD`) AS Revenue
FROM Sales s
JOIN Customers c ON s.CustomerKey = c.CustomerKey
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY c.CustomerKey, Customer_Name
ORDER BY Revenue DESC
LIMIT 5;


-- 3. Product-wise Profit Analysis
-- Measures product profitability
SELECT
    p.`Product Name`,
    SUM(s.Quantity * (p.`Unit Price USD` - p.`Unit Cost USD`)) AS Profit
FROM Sales s
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY p.`Product Name`
ORDER BY Profit DESC;


-- 4. Store-wise Revenue Performance
-- Compares performance across stores and countries
SELECT
    st.StoreKey,
    st.Country,
    SUM(s.Quantity * p.`Unit Price USD`) AS Revenue
FROM Sales s
JOIN Stores st ON s.StoreKey = st.StoreKey
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY st.StoreKey, st.Country
ORDER BY Revenue DESC;


-- 5. Customer Order Frequency
-- Identifies repeat customers
SELECT
    CustomerKey,
    COUNT(DISTINCT OrderNumber) AS Total_Orders
FROM Sales
GROUP BY CustomerKey
ORDER BY Total_Orders DESC;


-- 6. Average Delivery Time
-- Operational efficiency metric
SELECT
    AVG(DATEDIFF(`Delivery Date`, `Order Date`)) AS Avg_Delivery_Days
FROM Sales
WHERE `Delivery Date` IS NOT NULL;


-- 7. Category Contribution to Revenue
-- Identifies top-performing product categories
SELECT
    p.Category,
    SUM(s.Quantity * p.`Unit Price USD`) AS Revenue
FROM Sales s
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY p.Category
ORDER BY Revenue DESC;

