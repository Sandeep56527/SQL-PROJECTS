/*
This dataset captures transactional data for a fictional business and is split into three logical subsets:

1) Sales Data: Contains details about sales transactions, including columns such as 
Sale_ID, Product_ID, Customer_ID, Sale_Date, Sale_Amount, Region, and Discount.

2) Product Data: Contains information about products, including columns like 
Product_ID, Product_Name, Category, Price, Stock_Quantity, and Launch_Date.

3) Customer Data: Contains customer details, with columns such as 
Customer_ID, Customer_Name, Email, Phone_Number, Registration_Date, and Country.
*/

# The dataset is a fictitious one and the data has been imported into MySQL database using the Table import wizard option.

CREATE DATABASE Sales_Analysis;

-- The date columns have been imported as 'text' format, let's convert them to 'date' format.
SELECT * FROM customer_data LIMIT 5;

ALTER TABLE customer_data
MODIFY COLUMN Registration_Date DATE;

DESCRIBE customer_data; -- The datatype of 'Registration_Date' has been successfully converted to DATE format.

ALTER TABLE product_data
MODIFY COLUMN launch_date DATE;

DESCRIBE product_data; -- The datatype of 'launch_date' has been successfully converted to DATE format.

ALTER TABLE sales_data
MODIFY COLUMN Sale_Date DATE;

DESCRIBE sales_data;  -- The datatype of 'Sale_Date' has been successfully converted to DATE format.

SELECT * FROM sales_data
LIMIT 100;

-- Checking for duplicate records
SELECT 
    Product_ID,
    Product_Name,
    Category,
    Price,
    Stock_Quantity,
    Launch_Date
FROM product_data
GROUP BY Product_ID, Product_Name,
         Category,
         Price,
         Stock_Quantity,
         Launch_Date
HAVING COUNT(*) > 1; -- Found no duplicate records in any of the columns

/*
	#############
	  Objective: 
	#############
Which product categories are generating the highest revenue, and how does their performance vary across 
different regions over the past year? Additionally, identify the top 5 customers contributing the most 
to our revenue within these high-performing categories.
*/

SELECT * FROM customer_data LIMIT 5;

SELECT * FROM product_data LIMIT 5;

SELECT * FROM sales_data LIMIT 5;

-- Which product categories are generating the highest revenue?
SELECT 
    pd.Category,
    ROUND(SUM(sd.Sale_Amount),2) AS Total_Revenue
FROM product_data pd
LEFT JOIN sales_data sd
ON pd.Product_ID = sd.Product_ID
GROUP BY  pd.Category
ORDER BY Total_Revenue DESC; -- Out of the four different categories 'Books' and 'Clothing' seems to produce the highest revenue.

-- Let's focus only on to 'Books' and 'Clothing' categories

-- How does their('Books' and 'Clothing') performance vary across different regions over the past year?
CREATE VIEW Product_Performance AS 
SELECT pd.Product_Name,
       pd.category,
       pd.Launch_date,
       sd.Sale_Amount,
       sd.Sale_Date,
       sd.Region
FROM product_data pd
LEFT JOIN sales_data sd
ON pd.Product_ID = sd.Product_ID
WHERE pd.category IN ('Books', 'Clothing');

SELECT * ,
FIRST_VALUE(Region) OVER(ORDER BY Revenue_Window DESC) AS FV
FROM
	(SELECT category,
	   	Region,
       		Sale_Amount,
       		SUM(Sale_Amount) OVER(PARTITION BY category, Region ORDER BY Sale_Amount) AS Revenue_Window
	FROM Product_Performance)sq; -- Overall in the 'East' region the sales happened the most

SELECT * FROM Product_Performance;

SELECT COUNT(*)
FROM Product_Performance
WHERE category = 'Clothing'; -- 22420

SELECT COUNT(*)
FROM Product_Performance
WHERE category = 'Books'; -- 22690

-- The category of most number of items sold are 'Books' when comparing with 'Clothing' Products.

SELECT pd.Category, COUNT(*) AS Total_Count
FROM product_data pd
LEFT JOIN sales_data sd
ON pd.Product_ID = sd.Product_ID
GROUP BY pd.Category
ORDER BY Total_Count DESC; -- The products from 'Books' category were sold the most.

SELECT sd.Region, COUNT(*) AS Total_Count
FROM product_data pd
LEFT JOIN sales_data sd
ON pd.Product_ID = sd.Product_ID
GROUP BY sd.Region
ORDER BY Total_Count DESC; -- The products were sold the most in 'East' region followed by the 'South'

SELECT * FROM Product_Performance;

SELECT MAX(Launch_date) AS Max_Date,
       MIN(Launch_date) AS Min_Date 
FROM Product_Performance
WHERE category = 'Clothing'; -- Max: 2030-12-11, Min: 2020-01-01

SELECT MAX(Launch_date) AS Max_Date,
	   MIN(Launch_date) AS Min_Date 
FROM Product_Performance
WHERE category = 'Books'; -- Max: 2030-12-12, Min: 2020-01-03

SELECT DISTINCT Launch_Date FROM product_data
ORDER BY Launch_Date DESC; -- The launch date column seems to have future date values, so need to fix those

SELECT DATE(NOW()); -- Since the future dates are invalid we can update those dates that are greater than todays date into Null's.

SELECT DISTINCT Launch_Date
FROM product_data
WHERE Launch_Date > DATE(NOW())
ORDER BY Launch_Date;

SET SQL_SAFE_UPDATES = 0;

UPDATE product_data
SET Launch_Date = NULL 
WHERE Launch_Date > DATE(NOW()); -- The issue has now been fixed

SELECT * FROM Product_Performance;

SELECT MIN(Launch_date) AS Initial_Launch
FROM Product_Performance
WHERE category = 'Clothing'; -- Min: 2020-01-01

SELECT MIN(Launch_date) AS Initial_Launch
FROM Product_Performance
WHERE category = 'Books'; -- Min: 2020-01-03

-- Let's now dig deeper into the 'sale_date' column
CREATE VIEW product_performance_sale AS
SELECT *,
	year(Sale_Date) AS Sales_Year,
	date_format(Sale_Date,'%b') AS Sales_Month,
        date_format(Sale_Date,'%a') AS Sale_Day
 FROM product_performance;
 
 SELECT * FROM product_performance_sale;
 
 SELECT Sales_Year, COUNT(*) AS Total_Count
 FROM product_performance_sale
 GROUP BY Sales_Year
 ORDER BY Total_Count DESC; -- Most number of sales happened in 2023 (39668)
 
 SELECT Sales_Month, COUNT(*) AS Total_Count
 FROM product_performance_sale
 GROUP BY Sales_Month
 ORDER BY Total_Count DESC; -- Most number of sales happened in 'Jan' month, and the least being 'Aug'
 
 SELECT Sale_Day, COUNT(*) AS Total_Count
 FROM product_performance_sale
 GROUP BY Sale_Day
 ORDER BY Total_Count DESC; -- Most number of sales happened on 'Sunday' (6646)
 
 SELECT category,
	Sale_Amount,
        Sale_date,
        Region,
        Sales_month,
ROUND(SUM(Sale_Amount) OVER(PARTITION BY category,Region ORDER BY Sale_Date),2) AS Sales_Running_Total
FROM product_performance_sale; 
 
 -- For the category 'Books' the Running_Total amount started with '12760.36' and the start Sale_date was '2023-01-01'
 -- For the category 'Books' the Running_Total amount ended with '2946647.71' and the end Sale_date was '2024-02-21'
 
 -- For the category 'Clothing' the Running_Total amount started with '8005.06' and the start Sale_date was '2023-01-01'
 -- For the category 'Clothing' the Running_Total amount ended with '2838077.58' and the end Sale_date was '2024-02-21'
 
 SELECT * FROM product_performance_sale;
 
 -- For each specific regions which month saw the highest number of sales and which month saw the lowest
SELECT *,
		FIRST_VALUE(Sales_Month) OVER(
		PARTITION BY Region 
		ORDER BY Total_Sale_Amount DESC) AS Highest_Sale_month,
        FIRST_VALUE(Sales_Month) OVER(
		PARTITION BY Region 
		ORDER BY Total_Sale_Amount ASC) AS Lowest_Sale_month
FROM
		(SELECT
			   Sales_Month,
			   Region,
			   ROUND(SUM(Sale_Amount)) AS Total_Sale_Amount
		FROM product_performance_sale
		GROUP BY Sales_Month, Region) AS sq;
		
/*
While analysing the data the highest number of sales across all the regions was on 'January'
and the lowest sales month differs across the regions, and are as follows:

Region vs Lowest Sale Month:
1. East : Nov
2. North : April
3. South : June
4. West : September
*/	
-- Additionally, identify the top 5 customers contributing the most 
-- to our revenue within these high-performing categories.		
CREATE VIEW top_Customers AS 
SELECT 
	cd.customer_id,
    cd.customer_name,
    cd.Country,
    pd.Product_ID,
    pd.Product_Name,
    pd.Category,
    sd.sale_date,
    sd.Sale_Amount,
    sd.region
FROM customer_data cd
LEFT JOIN sales_data sd
ON cd.Customer_ID = sd.Customer_ID
LEFT JOIN  product_data pd
ON pd.Product_ID = sd.Product_ID
WHERE pd.category IN ('Clothing' , 'Books');

SELECT customer_id, 
	   ROUND(SUM(Sale_Amount),2) AS Total_Sale_Amount
FROM top_Customers
GROUP BY customer_id
ORDER BY Total_Sale_Amount DESC
LIMIT 5;
/*
The top 5 performing customers with their contribution in generating the revenue are as follows:
Customer_ID VS Total_Revenue
9692	20927.5
4209	20447.77
2247	17617.77
4791	16787.88
8361	16666.12
*/
SELECT * FROM top_customers;	

SELECT DISTINCT Customer_id, Customer_name, Country
FROM top_customers
WHERE customer_id IN (3326,3893,4651,4774,2326)
ORDER BY customer_name; -- Seems like there is a clean-up needed in Country column

DELETE FROM customer_data
WHERE customer_id IN (
    SELECT customer_id
    FROM (
        SELECT customer_id, 
               ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY country) AS Rnk
        FROM customer_data
    ) AS subquery
    WHERE Rnk > 1
);

 -- Running the previous queries again to find out the required result
 SELECT customer_id, 
	   ROUND(SUM(Sale_Amount),2) AS Total_Sale_Amount
FROM top_Customers
GROUP BY customer_id
ORDER BY Total_Sale_Amount DESC
LIMIT 5;
/*
The top 5 performing customers with their contribution in generating the revenue are as follows:
Customer_ID VS Total_Revenue
9692	20927.5
4209	20447.77
2247	17617.77
4791	16787.88
8361	16666.12
*/
SELECT DISTINCT Customer_id, Customer_name, Country
FROM top_customers
WHERE customer_id IN (9692,4209,2247,4791,8361)
ORDER BY customer_name;
-- The top customers are from UK, India, Germany and USA

/*
######### Conclusion #########

Below are the summary of the above data: 

> Out of the four different categories 'Books' and 'Clothing' seems to produce the highest revenue.
> The sales figures was the highest in the 'East' region followed by the 'South'
> The total sales count of category 'Clothing' is 22,420 and that of 'Books' is 22,690
> Launch date for both of these categories('Clothing' and 'Books') were happened on the month of January.
> Most number of sales happened in 2023 (around 39,600)
> Most number of sales happened in the month of 'Jan', and the least in 'Aug'.
> Most number of sales occured on 'Sunday' (6,646)
> For the category 'Books' initial day revenue was '12,760.36'.
> For the category 'Clothing' initial day revenue was '8005.06' .
> While analyzing the data the lowest sales month differs across the regions, and are as follows:

	Region vs Lowest Sale Month:
	----------------------------
1. For East region the lowest sales happened on the month of November.
2. For North region the lowest sales happened on the month of April.
3. For South region the lowest sales happened on the month of June.
4. For West region the lowest sales happened on the month of September.

> The top 5 performing customers with their contribution in generating the revenue are as follows:
Customer_ID VS Total_Revenue
9692	20927.5
4209	20447.77
2247	17617.77
4791	16787.88
8361	16666.12
> The top customers are from UK, India, Germany and USA

*/

