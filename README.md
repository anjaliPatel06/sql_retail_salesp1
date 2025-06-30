Retail Sales Analysis in PostgreSQL

Project Overview
This project involves analyzing a retail sales dataset using PostgreSQL. I have created and solved 10 analytical questions using SQL queries to gain insights into customer behavior, sales trends, and transactional patterns.

Dataset
The dataset contains details of retail transactions, including:

Transaction date and time
Customer ID
Product category
Product details
Gender of the customer
Transaction amount (total sales)

Analysis Questions and Solutions
** Q.1 Write a sql query to retrive all columns for sales made on '2022-11-05'**
```sql
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';
```
** Q.2 Write a sql query to retrive all transaction where the category is 'clothing' and the 
quantity sold more than the month of Nov-2022 **
```sql
SELECT
   *
FROM retail_sales
WHERE 
      category = 'Clothing'
      AND
	  TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
      AND
	  quantiy >= 4;
```
** Q.3 Write a sql query to calculate the total sales for each category **
```sql
SELECT category,
       SUM(total_sale) AS Total_sale,
	   COUNT(*) AS total_orders
From retail_sales
GROUP BY category;
```
** Q.4 write a sql query to find the average age of customer who purchase items from the 'beauty' category **
```sql
SELECT ROUND(AVG(age)) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';
```
** Q.5  Write a sql query to find all trasaction where the total sale is greater than 1000 **
```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```
** Q.6 Write a sql query to find the total number of transaction made by each gender in each category **
```sql
category,
	 gender,
     COUNT(*) AS total_trans
FROM retail_sales
GROUP BY 
     gender,
	 category;
```
** Q.7 Write a sql query to calculate the avg sale for each month. find out best selling month in each year **
```sql
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
```
** Q.8  Write a sql query to find the top 5 customer based on the highest total sales **
```sql
SELECT customer_id,
       	SUM(total_sale) as total_sale
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```
** Q.9  Write a sql query to find the number of unique customer who purchased items from each category **
```sql
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
```
Technologies Used
PostgreSQL
SQL

How to Run
Load your dataset into PostgreSQL.
Use provided SQL scripts (in queries.sql) to execute each analysis query.

Results
Each query provides insights such as shift-based sales distribution, customer purchasing behavior, gender-based transaction counts, and monthly sales trends.

Author
This project was completed as part of my practice in advanced SQL and data analysis.
