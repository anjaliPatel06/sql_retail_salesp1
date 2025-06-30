--SQL Retail Sales Analysis - P1

--Create table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales(
       transaction_id INT PRIMARY KEY,
	   sale_date DATE,
	   sale_time TIME,
	   customer_id INT,
	   gender VARCHAR(15),
	   age INT,
	   category VARCHAR(15),
	   quantiy INT,
	   price_per_unit FLOAT,
	   cogs FLOAT,
	   total_sale FLOAT
)
SELECT * FROM retail_sales
LIMIT 10;

SELECT COUNT(*) FROM retail_sales;

-- Data cleaning
SELECT * FROM retail_sales
WHERE 
      transaction_id IS NULL
      OR
	  sale_date IS NULL
	  OR
	  sale_time IS NULL
	  OR
	  customer_id IS NULL
	  OR
	  gender IS NULL
	  OR
	  age IS NULL
	  OR
	  category IS NULL
	  OR
	  quantiy IS NULL
	  OR
	  price_per_unit IS NULL
	  OR 
	  cogs IS NULL
	  OR
	  total_sale IS NULL;

DELETE FROM retail_sales
WHERE 
      transaction_id IS NULL
      OR
	  sale_date IS NULL
	  OR
	  sale_time IS NULL
	  OR
	  customer_id IS NULL
	  OR
	  gender IS NULL
	  OR
	  age IS NULL
	  OR
	  category IS NULL
	  OR
	  quantiy IS NULL
	  OR
	  price_per_unit IS NULL
	  OR 
	  cogs IS NULL
	  OR
	  total_sale IS NULL;

-- DATA Exploration

-- How many sales we have ?
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- HOW MANY CUSTOMERS WE HAVE ?
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

--HOW MANY CATEGORIES WE HAVE ?
SELECT COUNT(DISTINCT category) AS Total_category FROM retail_sales;

SELECT DISTINCT category AS Total_category FROM retail_sales;

-- Data Analysis & Business key problem & answers

-- 1. Write a sql query to retrive all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- 2. Write a sql query to retrive all transaction where the category is 'clothing' and the 
-- quantity sold more than the month of Nov-2022

SELECT
   *
FROM retail_sales
WHERE 
      category = 'Clothing'
      AND
	  TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
      AND
	  quantiy >= 4;
	  
-- 3. Write a sql query to calculate the total sales for each category
SELECT category,
       SUM(total_sale) AS Total_sale,
	   COUNT(*) AS total_orders
From retail_sales
GROUP BY category;

-- 4. write a sql query to find the average age of customer who purchase items from the 'beauty' category
SELECT ROUND(AVG(age)) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- 5. Write a sql query to find all trasaction where the total sale is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- 6. Write a sql query to find the total number of transaction made by each gender in each category
SELECT 
     category,
	 gender,
     COUNT(*) AS total_trans
FROM retail_sales
GROUP BY 
     gender,
	 category;
	 
-- 7. Write a sql query to calculate the avg sale for each month. find out best selling month in each year
SELECT * FROM
(
SELECT 
      EXTRACT(YEAR FROM sale_date) AS year,
	  EXTRACT(MONTH FROM sale_date) AS month,
	  AVG(total_sale) AS total_sale,
	  RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
FROM retail_sales
GROUP BY 1, 2
) AS T1
WHERE RANK = 1
--ORDER BY 1, 3 DESC

-- 8. Write a sql query to find the top 5 customer based on the highest total sales
SELECT customer_id,
       	SUM(total_sale) as total_sale
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 9. Write a sql query to find the number of unique customer who purchased items from each category
SELECT 
   category,
   COUNT(DISTINCT customer_id) AS cnt_unique_cust
FROM retail_sales
GROUP BY category

-- 10. Write a sql query to create each shift and number of orders (example morning<=12, afternoon between 12 & 17, evening > 17)
WITH hourly_sale
AS
(
SELECT *,
       CASE
	       	WHEN EXTRACT(HOURS FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT(HOURS FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
	   END AS Shift
FROM retail_sales
)
SELECT 
       Shift,
      COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY Shift
