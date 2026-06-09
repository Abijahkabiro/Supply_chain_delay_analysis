--To check all the columns in the table
SELECT COLUMN_NAME,DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'DataCoSupplyChainDataset'
ORDER BY ORDINAL_POSITION;
--Check the first 3 rows of the selected columns 
SELECT TOP 3
    Order_Id,
    Order_Item_Id,
    Customer_Id,
    Product_Name,
    Order_Item_Quantity,
    Shipping_Mode,
    Delivery_Status,
    Days_for_shipping_real,
    Days_for_shipment_scheduled
FROM DataCoSupplyChainDataset;
-- Check 1:How many rows do we have in total?(row count)
SELECT COUNT(*) AS Total_Rows
FROM DataCoSupplyChainDataset;
--Check 2: Are there orders that appear more than once?(check duplicate orders)
SELECT Order_Id, COUNT(*) AS Count
FROM DataCoSupplyChainDataset
GROUP BY Order_Id
HAVING COUNT(*) > 1
ORDER BY Count DESC;
--Check 3: Which of our important columns have missing values?(Check null Values in Key Columns)
SELECT
    SUM(CASE WHEN order_date_DateOrders       IS NULL THEN 1 ELSE 0 END) AS Null_OrderDate,
    SUM(CASE WHEN shipping_date_DateOrders    IS NULL THEN 1 ELSE 0 END) AS Null_ShipDate,
    SUM(CASE WHEN Days_for_shipping_real      IS NULL THEN 1 ELSE 0 END) AS Null_RealDays,
    SUM(CASE WHEN Days_for_shipment_scheduled IS NULL THEN 1 ELSE 0 END) AS Null_SchedDays,
    SUM(CASE WHEN Shipping_Mode               IS NULL THEN 1 ELSE 0 END) AS Null_ShipMode,
    SUM(CASE WHEN Category_Name               IS NULL THEN 1 ELSE 0 END) AS Null_Category,
    SUM(CASE WHEN Order_Region                IS NULL THEN 1 ELSE 0 END) AS Null_Region,
    SUM(CASE WHEN Delivery_Status             IS NULL THEN 1 ELSE 0 END) AS Null_DeliveryStatus,
    SUM(CASE WHEN Order_Profit_Per_Order      IS NULL THEN 1 ELSE 0 END) AS Null_Profit
FROM DataCoSupplyChainDataset;
--Check 4: Do our categories have consistent naming? Any typos or extra spaces?(Distinct Values in Categorical Columns)
SELECT DISTINCT Shipping_Mode FROM DataCoSupplyChainDataset;
SELECT DISTINCT Delivery_Status FROM DataCoSupplyChainDataset;
SELECT DISTINCT Customer_Segment FROM DataCoSupplyChainDataset;
SELECT DISTINCT Market FROM DataCoSupplyChainDataset;
SELECT DISTINCT Order_Status FROM DataCoSupplyChainDataset;
--Check 5: What time period does our data cover?( Date Range)
--MIN(order_date_DateOrders) → finds the earliest order datetime
--MAX(order_date_DateOrders) → finds the latest order datetime
--CAST(... AS DATE) → extracts only the date
--CONVERT(..., 108) → extracts only the time in HH:MM:SS format
SELECT
    CAST(MIN(order_date_DateOrders) AS DATE) AS Earliest_order_date,
    CONVERT(VARCHAR, MIN(order_date_DateOrders), 108) AS Earliest_order_time,

    CAST(MAX(order_date_DateOrders) AS DATE) AS Latest_order_date,
    CONVERT(VARCHAR, MAX(order_date_DateOrders), 108) AS Latest_order_time
FROM DataCoSupplyChainDataset;
--Check 6: Are there any negative or zero values where there shouldn't be?(Check Impossible Values in Numeric Columns)
SELECT
    SUM(CASE WHEN Days_for_shipping_real      <= 0 THEN 1 ELSE 0 END) AS Bad_RealDays,
    SUM(CASE WHEN Days_for_shipment_scheduled <= 0 THEN 1 ELSE 0 END) AS Bad_SchedDays,
    SUM(CASE WHEN Sales                       <= 0 THEN 1 ELSE 0 END) AS Bad_Sales,
    SUM(CASE WHEN Order_Item_Quantity         <= 0 THEN 1 ELSE 0 END) AS Bad_Quantity
FROM DataCoSupplyChainDataset;

--Check 7: Check for hidden spaces in our most used categorical column
SELECT DISTINCT
    Shipping_Mode,
    LEN(Shipping_Mode)        AS Length,
    LEN(TRIM(Shipping_Mode))  AS Trimmed_Length
FROM DataCoSupplyChainDataset;
--Check 8: What do the zero-day rows look like?
SELECT TOP 10
    Order_Id,
    Shipping_Mode,
    Delivery_Status,
    Days_for_shipping_real,
    Days_for_shipment_scheduled,
    Order_Status
FROM DataCoSupplyChainDataset
WHERE Days_for_shipping_real = 0
   OR Days_for_shipment_scheduled = 0;
-- Are zero-day rows concentrated in a specific status?
SELECT 
    Delivery_Status,
    Order_Status,
    COUNT(*) AS Row_Count
FROM DataCoSupplyChainDataset
WHERE Days_for_shipping_real = 0
   OR Days_for_shipment_scheduled = 0
GROUP BY Delivery_Status, Order_Status
ORDER BY Row_Count DESC;
-- Check 9: Fix incorrect data types 

ALTER TABLE DataCoSupplyChainDataset
ALTER COLUMN Days_for_shipping_real INT; 

ALTER TABLE DataCoSupplyChainDataset
ALTER COLUMN Days_for_shipment_scheduled INT; 

ALTER TABLE DataCoSupplyChainDataset
ALTER COLUMN Order_Item_Quantity INT; 

ALTER TABLE DataCoSupplyChainDataset
ALTER COLUMN Category_Id INT; 

ALTER TABLE DataCoSupplyChainDataset
ALTER COLUMN Department_Id INT; 

ALTER TABLE DataCoSupplyChainDataset
ALTER COLUMN Product_Category_Id INT; 

ALTER TABLE DataCoSupplyChainDataset
ALTER COLUMN Product_Status INT;

--To check unique Orders
SELECT
    COUNT(*)                 AS Total_Rows,
    COUNT(DISTINCT Order_Id) AS Unique_Orders,
    COUNT(*) / COUNT(DISTINCT Order_Id) AS Avg_Items_Per_Order
FROM DataCoSupplyChainDataset;
-- Q1: What is our overall on-time delivery rate?
-- Business question: Are we delivering on time more often than not?

SELECT
    COUNT(*) AS Total_Rows, --Counts all order rows after removing bad data
    SUM(CASE WHEN Days_for_shipping_real <= Days_for_shipment_scheduled 
        THEN 1 ELSE 0 END) AS OnTime_Rows, --To check how many orders arrived on time or early
    SUM(CASE WHEN Days_for_shipping_real > Days_for_shipment_scheduled 
        THEN 1 ELSE 0 END) AS Late_Rows, --To check how many orders arrived late
    CAST(100.0 * 
        SUM(CASE WHEN Days_for_shipping_real <= Days_for_shipment_scheduled 
            THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS OnTime_Rate_Pct, --Gives percentage of on-time deliveries (OnTime Orders / Total Orders) * 100
    CAST(100.0 * 
        SUM(CASE WHEN Days_for_shipping_real > Days_for_shipment_scheduled 
            THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS Late_Rate_Pct --Gives percentage of late deliveries (Late Orders / Total Orders) * 100
FROM DataCoSupplyChainDataset
WHERE Days_for_shipping_real > 0 -- Ignore bad rows where actual shipping days are zero or negative
  AND Days_for_shipment_scheduled > 0; -- Ignore bad rows where scheduled shipping days are zero or negative

-- Q2: Which shipping mode has the highest delay rate?
-- Business question: Are certain shipping options systematically worse than others?

SELECT
    Shipping_Mode,
    COUNT(*)  AS Total_Orders, --Counts all order rows per shipping mode
    SUM(CASE WHEN Days_for_shipping_real > Days_for_shipment_scheduled 
        THEN 1 ELSE 0 END) AS Late_Orders, --To check how many orders arrived late per mode
    SUM(CASE WHEN Days_for_shipping_real <= Days_for_shipment_scheduled 
        THEN 1 ELSE 0 END) AS OnTime_Orders, --To check how many orders arrived on time or early
    CAST(100.0 * 
        SUM(CASE WHEN Days_for_shipping_real > Days_for_shipment_scheduled 
            THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS Late_Rate_Pct, --Gives percentage of late deliveries per mode (Late Orders / Total Orders) * 100
    CAST(AVG(CAST(Days_for_shipping_real - Days_for_shipment_scheduled 
        AS FLOAT)) AS DECIMAL(5,2)) AS Avg_Delay_Days --Average number of days late per shipping mode
FROM DataCoSupplyChainDataset
WHERE Days_for_shipping_real > 0 -- Ignore bad rows where actual shipping days are zero or negative
  AND Days_for_shipment_scheduled > 0 -- Ignore bad rows where scheduled shipping days are zero or negative
GROUP BY Shipping_Mode --Group results by each shipping mode
ORDER BY Late_Rate_Pct DESC; --Show worst performing mode first

-- Check why same Day missing from Q2 results
-- Check what values Same Day orders have in the day columns

SELECT
    Shipping_Mode, --The shipping method used for the order
    Days_for_shipping_real, --Actual number of days taken to deliver
    Days_for_shipment_scheduled, --Number of days the system promised for delivery
    COUNT(*) AS Row_Count --Count how many rows have each combination of values
FROM DataCoSupplyChainDataset
WHERE Shipping_Mode = 'Same Day' --Filter to Same Day orders only to isolate the issue
GROUP BY Shipping_Mode, Days_for_shipping_real, Days_for_shipment_scheduled --Group by all three columns to see every unique combination
ORDER BY Row_Count DESC; --Show the most common combination first

-- Q3: Which regions have the worst delivery performance?
-- Business question: Are certain geographic regions experiencing more delays than others?

SELECT
    Order_Region, --The geographic region where the order was placed
    COUNT(*) AS Total_Orders, --Counts all order rows per region
    SUM(CASE WHEN Days_for_shipping_real > Days_for_shipment_scheduled
        THEN 1 ELSE 0 END) AS Late_Orders, --To check how many orders arrived late per region
    SUM(CASE WHEN Days_for_shipping_real <= Days_for_shipment_scheduled
        THEN 1 ELSE 0 END) AS OnTime_Orders, --To check how many orders arrived on time or early per region
    CAST(100.0 *
        SUM(CASE WHEN Days_for_shipping_real > Days_for_shipment_scheduled
            THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS Late_Rate_Pct, --Gives percentage of late deliveries per region (Late Orders / Total Orders) * 100
    CAST(AVG(CAST(Days_for_shipping_real - Days_for_shipment_scheduled
        AS FLOAT)) AS DECIMAL(5,2)) AS Avg_Delay_Days --Average number of days late per region
FROM DataCoSupplyChainDataset
WHERE Days_for_shipping_real > 0 -- Ignore bad rows where actual shipping days are zero or negative
  AND Days_for_shipment_scheduled > 0 -- Ignore bad rows where scheduled shipping days are zero or negative
GROUP BY Order_Region --Group results by each region
ORDER BY Late_Rate_Pct DESC; --Show worst performing region first
-- Q4: Which product categories are most affected by delays?
-- Business question: Are certain product types more likely to arrive late than others?
SELECT
    Category_Name, --The product category name
    COUNT(*) AS Total_Orders, --Counts all order rows per category
    SUM(CASE WHEN Days_for_shipping_real > Days_for_shipment_scheduled
        THEN 1 ELSE 0 END) AS Late_Orders, --To check how many orders arrived late per category
    SUM(CASE WHEN Days_for_shipping_real <= Days_for_shipment_scheduled
        THEN 1 ELSE 0 END) AS OnTime_Orders, --To check how many orders arrived on time or early
    CAST(100.0 *
        SUM(CASE WHEN Days_for_shipping_real > Days_for_shipment_scheduled
            THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS Late_Rate_Pct, --Gives percentage of late deliveries per category (Late Orders / Total Orders) * 100
    CAST(AVG(CAST(Days_for_shipping_real - Days_for_shipment_scheduled
        AS FLOAT)) AS DECIMAL(5,2)) AS Avg_Delay_Days --Average number of days late per category
FROM DataCoSupplyChainDataset
WHERE Days_for_shipping_real > 0 -- Ignore bad rows where actual shipping days are zero or negative
  AND Days_for_shipment_scheduled > 0 -- Ignore bad rows where scheduled shipping days are zero or negative
GROUP BY Category_Name --Group results by each product category
ORDER BY Late_Rate_Pct DESC; --Show most delayed category first
-- Q5: What is the profit impact of late deliveries?
-- Business question: How much profit is the business losing due to late deliveries?

SELECT
    SUM(CASE WHEN Days_for_shipping_real > Days_for_shipment_scheduled
        THEN Order_Profit_Per_Order ELSE 0 END) AS Late_Delivery_Profit, --Total profit generated from late orders
    SUM(CASE WHEN Days_for_shipping_real <= Days_for_shipment_scheduled
        THEN Order_Profit_Per_Order ELSE 0 END) AS OnTime_Delivery_Profit, --Total profit generated from on-time orders
    SUM(Order_Profit_Per_Order) AS Total_Profit, --Total profit across all orders
    CAST(100.0 *
        SUM(CASE WHEN Days_for_shipping_real > Days_for_shipment_scheduled
            THEN Order_Profit_Per_Order ELSE 0 END) /
        NULLIF(SUM(Order_Profit_Per_Order), 0)
        AS DECIMAL(5,1)) AS Late_Profit_Pct, --Percentage of total profit coming from late orders
    COUNT(*) AS Total_Rows, --Total rows analysed after cleaning filter
    SUM(CASE WHEN Days_for_shipping_real > Days_for_shipment_scheduled
        THEN 1 ELSE 0 END) AS Late_Orders, --Count of late order rows
    CAST(AVG(CASE WHEN Days_for_shipping_real > Days_for_shipment_scheduled
        THEN Order_Profit_Per_Order END)
        AS DECIMAL(10,2)) AS Avg_Profit_Per_Late_Order --Average profit per late order row
FROM DataCoSupplyChainDataset
WHERE Days_for_shipping_real > 0 -- Ignore bad rows where actual shipping days are zero or negative
  AND Days_for_shipment_scheduled > 0; -- Ignore bad rows where scheduled shipping days are zero or negative

  -- Q6: Which routes are the biggest repeat offenders?
-- Business question: Which specific region and shipping mode combinations have the highest delay rates?

SELECT
    Order_Region, --The geographic region of the order
    Shipping_Mode, --The shipping method used
    COUNT(*) AS Total_Orders, --Total order rows for this region and mode combination
    SUM(CASE WHEN Days_for_shipping_real > Days_for_shipment_scheduled
        THEN 1 ELSE 0 END) AS Late_Orders, --Count of late orders for this route
    SUM(CASE WHEN Days_for_shipping_real <= Days_for_shipment_scheduled
        THEN 1 ELSE 0 END) AS OnTime_Orders, --Count of on-time orders for this route
    CAST(100.0 *
        SUM(CASE WHEN Days_for_shipping_real > Days_for_shipment_scheduled
            THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS Late_Rate_Pct, --Gives percentage of late deliveries for this route
    CAST(AVG(CAST(Days_for_shipping_real - Days_for_shipment_scheduled
        AS FLOAT)) AS DECIMAL(5,2)) AS Avg_Delay_Days --Average delay days for this route
FROM DataCoSupplyChainDataset
WHERE Days_for_shipping_real > 0 -- Ignore bad rows where actual shipping days are zero or negative
  AND Days_for_shipment_scheduled > 0 -- Ignore bad rows where scheduled shipping days are zero or negative
GROUP BY Order_Region, Shipping_Mode --Group by region and shipping mode combination
HAVING COUNT(*) >= 100 --Only include routes with at least 100 orders to ensure statistical reliability
ORDER BY Late_Rate_Pct DESC; --Show worst performing route first

-- Q7: Is there a delay pattern by month?
-- Business question: Are delays worse in certain months or seasons?

SELECT
    YEAR(order_date_DateOrders) AS Order_Year, --The year the order was placed
    MONTH(order_date_DateOrders) AS Order_Month, --The month the order was placed
    DATENAME(MONTH, order_date_DateOrders) AS Month_Name, --The name of the month for easier reading
    COUNT(*) AS Total_Orders, --Total order rows for that month
    SUM(CASE WHEN Days_for_shipping_real > Days_for_shipment_scheduled
        THEN 1 ELSE 0 END) AS Late_Orders, --Count of late orders in that month
    SUM(CASE WHEN Days_for_shipping_real <= Days_for_shipment_scheduled
        THEN 1 ELSE 0 END) AS OnTime_Orders, --Count of on-time orders in that month
    CAST(100.0 *
        SUM(CASE WHEN Days_for_shipping_real > Days_for_shipment_scheduled
            THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS Late_Rate_Pct, --Gives percentage of late deliveries per month
    CAST(AVG(CAST(Days_for_shipping_real - Days_for_shipment_scheduled
        AS FLOAT)) AS DECIMAL(5,2)) AS Avg_Delay_Days --Average delay days per month
FROM DataCoSupplyChainDataset
WHERE Days_for_shipping_real > 0 -- Ignore bad rows where actual shipping days are zero or negative
  AND Days_for_shipment_scheduled > 0 -- Ignore bad rows where scheduled shipping days are zero or negative
GROUP BY YEAR(order_date_DateOrders), MONTH(order_date_DateOrders), DATENAME(MONTH, order_date_DateOrders) --Group by year and month
ORDER BY Order_Year ASC, Order_Month ASC; --Show results in chronological order
-- Q8: Weekly Exception Report (using last available week in dataset)
-- Business question: Which shipping mode and region combinations need urgent attention?

SELECT
    Order_Region, --The geographic region of the order
    Shipping_Mode, --The shipping method used
    COUNT(*) AS Total_Orders, --Total order rows for this week
    SUM(CASE WHEN Days_for_shipping_real > Days_for_shipment_scheduled
        THEN 1 ELSE 0 END) AS Late_Orders, --Count of late orders this week
    SUM(CASE WHEN Days_for_shipping_real <= Days_for_shipment_scheduled
        THEN 1 ELSE 0 END) AS OnTime_Orders, --Count of on-time orders this week
    CAST(100.0 *
        SUM(CASE WHEN Days_for_shipping_real > Days_for_shipment_scheduled
            THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS Late_Rate_Pct, --Gives percentage of late deliveries for this route
    CAST(AVG(CAST(Days_for_shipping_real - Days_for_shipment_scheduled
        AS FLOAT)) AS DECIMAL(5,2)) AS Avg_Delay_Days, --Average delay days for this route
    CAST(SUM(Order_Profit_Per_Order) AS DECIMAL(10,2)) AS Total_Profit, --Total profit for this route
    CASE
        WHEN CAST(100.0 *
            SUM(CASE WHEN Days_for_shipping_real > Days_for_shipment_scheduled
                THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) >= 80
        THEN 'CRITICAL' --Flag as critical if late rate is 80% or above
        WHEN CAST(100.0 *
            SUM(CASE WHEN Days_for_shipping_real > Days_for_shipment_scheduled
                THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) >= 60
        THEN 'WARNING' --Flag as warning if late rate is between 60% and 79%
        ELSE 'MONITOR' --Flag as monitor if late rate is below 60%
    END AS Risk_Flag --Risk classification for operations team
FROM DataCoSupplyChainDataset
WHERE Days_for_shipping_real > 0 -- Ignore bad rows where actual shipping days are zero or negative
  AND Days_for_shipment_scheduled > 0 -- Ignore bad rows where scheduled shipping days are zero or negative
  AND DATEPART(WEEK, order_date_DateOrders) = (
        SELECT MAX(DATEPART(WEEK, order_date_DateOrders))
        FROM DataCoSupplyChainDataset
        WHERE YEAR(order_date_DateOrders) = (
            SELECT MAX(YEAR(order_date_DateOrders))
            FROM DataCoSupplyChainDataset
        )
    ) --Filter to the last available week in the dataset
  AND YEAR(order_date_DateOrders) = (
        SELECT MAX(YEAR(order_date_DateOrders))
        FROM DataCoSupplyChainDataset
    ) --Filter to the last available year in the dataset
GROUP BY Order_Region, Shipping_Mode --Group by region and shipping mode
HAVING COUNT(*) >= 5 --Only include routes with at least 5 orders
ORDER BY
    CASE
        WHEN CAST(100.0 *
            SUM(CASE WHEN Days_for_shipping_real > Days_for_shipment_scheduled
                THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) >= 80 THEN 1
        WHEN CAST(100.0 *
            SUM(CASE WHEN Days_for_shipping_real > Days_for_shipment_scheduled
                THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) >= 60 THEN 2
        ELSE 3
    END, --Show critical first then warning then monitor
    Late_Rate_Pct DESC; --Within each risk group show worst rate first