/* =====================================================
   DATA CLEANING SCRIPT
   Database: Sales Analytics
   Author: Kritika Chaurasia
   Purpose: Prepare clean, analysis-ready tables
   ===================================================== */

-- =====================================================
-- CUSTOMERS TABLE
-- =====================================================

-- Inspect structure (MySQL-specific)
-- DESC Customers;

-- Identify invalid customer keys
SELECT * 
FROM Customers
WHERE CustomerKey IS NULL;

-- Disable safe updates (MySQL only)
SET SQL_SAFE_UPDATES = 0;

-- Remove rows with missing primary key (invalid records)
DELETE FROM Customers
WHERE CustomerKey IS NULL;

-- Standardize Gender values
UPDATE Customers
SET Gender = 'Female'
WHERE Gender IN ('F', 'female', 'FEMALE');

UPDATE Customers
SET Gender = 'Male'
WHERE Gender IN ('M', 'male', 'MALE');

-- Convert valid Birthday strings to DATE
UPDATE Customers
SET Birthday = STR_TO_DATE(Birthday, '%m/%d/%Y')
WHERE Birthday REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$';

-- Nullify invalid Birthday values (do NOT delete customers)
UPDATE Customers
SET Birthday = NULL
WHERE Birthday IS NOT NULL
  AND Birthday NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';

-- Remove future birth dates
UPDATE Customers
SET Birthday = NULL
WHERE Birthday > CURRENT_DATE;

-- Ensure correct datatype
ALTER TABLE Customers
MODIFY Birthday DATE;

-- Trim text fields
UPDATE Customers
SET City = TRIM(City),
    State = TRIM(State),
    Country = TRIM(Country),
    Continent = TRIM(Continent);

-- Add derived Age column for analysis
ALTER TABLE Customers
ADD Age INT;

UPDATE Customers
SET Age = TIMESTAMPDIFF(YEAR, Birthday, CURRENT_DATE);


-- =====================================================
-- STORES TABLE
-- =====================================================

-- Identify duplicate store keys
SELECT StoreKey, COUNT(*) AS cnt
FROM Stores
GROUP BY StoreKey
HAVING COUNT(*) > 1;

-- Remove invalid store size values
DELETE FROM Stores
WHERE `Square Meters` <= 0
   OR `Square Meters` IS NULL;

-- Trim location fields
UPDATE Stores
SET Country = TRIM(Country),
    State = TRIM(State);

-- Convert valid Open Date strings
UPDATE Stores
SET `Open Date` = STR_TO_DATE(`Open Date`, '%m/%d/%Y')
WHERE `Open Date` REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$';

-- Nullify invalid Open Dates
UPDATE Stores
SET `Open Date` = NULL
WHERE `Open Date` IS NOT NULL
  AND `Open Date` NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';

-- Enforce DATE datatype
ALTER TABLE Stores
MODIFY `Open Date` DATE;


-- =====================================================
-- PRODUCTS TABLE
-- =====================================================

-- Remove products with invalid pricing
DELETE FROM Products
WHERE `Unit Price USD` <= 0
   OR `Unit Cost USD` < 0;

-- Trim product attributes
UPDATE Products
SET `Product Name` = TRIM(`Product Name`),
    Brand = TRIM(Brand),
    Color = TRIM(Color),
    Category = TRIM(Category),
    Subcategory = TRIM(Subcategory);


-- =====================================================
-- SALES TABLE
-- =====================================================

-- Remove invalid sales quantities
DELETE FROM Sales
WHERE Quantity <= 0;

-- Remove rows with missing order date
DELETE FROM Sales
WHERE `Order Date` IS NULL;

-- Convert valid date strings
UPDATE Sales
SET `Order Date` = STR_TO_DATE(`Order Date`, '%m/%d/%Y'),
    `Delivery Date` = STR_TO_DATE(`Delivery Date`, '%m/%d/%Y')
WHERE `Order Date` REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
  AND `Delivery Date` REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$';

-- Nullify invalid dates
UPDATE Sales
SET `Order Date` = NULL
WHERE `Order Date` IS NOT NULL
  AND `Order Date` NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';

UPDATE Sales
SET `Delivery Date` = NULL
WHERE `Delivery Date` IS NOT NULL
  AND `Delivery Date` NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';

-- Enforce DATE datatypes
ALTER TABLE Sales
MODIFY `Order Date` DATE,
MODIFY `Delivery Date` DATE;

-- Remove logically incorrect deliveries
DELETE FROM Sales
WHERE `Delivery Date` < `Order Date`;

-- Remove orphan records (referential integrity)
DELETE FROM Sales
WHERE CustomerKey NOT IN (SELECT CustomerKey FROM Customers)
   OR ProductKey NOT IN (SELECT ProductKey FROM Products)
   OR StoreKey NOT IN (SELECT StoreKey FROM Stores);


-- =====================================================
-- EXCHANGE RATES TABLE
-- =====================================================

-- Remove invalid exchange rates
DELETE FROM Exchange_Rates
WHERE Exchange <= 0
   OR Exchange IS NULL;

-- Standardize currency codes
UPDATE Exchange_Rates
SET Currency = UPPER(TRIM(Currency));

-- Convert valid date strings
UPDATE Exchange_Rates
SET Date = STR_TO_DATE(Date, '%m/%d/%Y')
WHERE Date REGEXP '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$';

-- Nullify invalid dates
UPDATE Exchange_Rates
SET Date = NULL
WHERE Date IS NOT NULL
  AND Date NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';

-- Enforce DATE datatype
ALTER TABLE Exchange_Rates
MODIFY Date DATE;
