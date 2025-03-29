-- ADVANCE ANALYTICS PROJECT


/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/
-- CHANGES OVER TIME ANALYSIS: Analyse how a measure evolves over time. Helps track trends and identify seasonality in your data

-- Analyse sales performance over time
-- Quick Date Functions

USE DataWarehouse

SELECT 
YEAR(order_date) AS order_year,
MONTH(order_date) AS order_month,
sum(sales_amount) AS total_Sales,
count(DISTINCT customer_key) as total_customers,
SUM(quantity) as total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date),MONTH(order_date)
ORDER BY YEAR(order_date),MONTH(order_date)

SELECT 
	YEAR(order_date) AS order_year,
	sum(sales_amount) AS total_Sales,
	count(DISTINCT customer_key) as total_customers,
	SUM(quantity) as total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)



SELECT 
DATETRUNC(MONTH, order_date) AS order_month,
--MONTH(order_date) AS order_month,
sum(sales_amount) AS total_Sales,
count(DISTINCT customer_key) as total_customers,
SUM(quantity) as total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
ORDER BY DATETRUNC(MONTH, order_date)

SELECT 
DATETRUNC(YEAR, order_date) AS order_year,
--MONTH(order_date) AS order_month,
sum(sales_amount) AS total_Sales,
count(DISTINCT customer_key) as total_customers,
SUM(quantity) as total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(YEAR, order_date)
ORDER BY DATETRUNC(YEAR, order_date)

SELECT 
FORMAT(order_date, 'yyyy-MMM') AS order_year,
--MONTH(order_date) AS order_month,
sum(sales_amount) AS total_Sales,
count(DISTINCT customer_key) as total_customers,
SUM(quantity) as total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM')

-- CUMULATIVE ANALYSIS: Aggregate the data progressively over time. Helps to understanding whether our business is growing or declining

/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/
--Calculate the total sales per month 
--and the running total of sales over time

SELECT 
FORMAT(DATETRUNC(MONTH, Order_date), 'MMM-yyyy') AS order_date,
SUM(sales_amount) AS total_sales
FROM gold.fact_Sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_Date)
ORDER BY DATETRUNC(MONTH, order_date)


--and the running total of sales over time
--Cumulative over time without annual break


SELECT 
order_date,
total_sales,
SUM(total_Sales) OVER (ORDER BY order_date) AS running_total_sales
FROM
(
SELECT
DATETRUNC(MONTH, Order_date) AS order_date,
SUM(sales_amount) AS total_sales
FROM gold.fact_Sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_Date)
)t

--Cumulative over time with annual break

SELECT 
order_date,
total_sales,
SUM(total_Sales) OVER (PARTITION BY order_date ORDER BY order_date) AS running_total_sales
FROM
(
SELECT
DATETRUNC(MONTH, Order_date) AS order_date,
SUM(sales_amount) AS total_sales
FROM gold.fact_Sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_Date)
)t


-- Cumulative by year - total sales and  moving average

SELECT
order_date,
total_sales,
SUM(total_Sales) OVER (ORDER BY order_date) AS running_total_sales,
AVG(avg_price) OVER (ORDER BY order_date) AS running_average_sales
FROM
(
SELECT
DATETRUNC(YEAR, Order_date) AS order_date,
SUM(sales_amount) AS total_sales,
AVG(sales_amount) AS avg_price
FROM gold.fact_Sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(YEAR, order_Date)
)t


-- PERFORMANCE ANALYSIS

/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

-- Comparing the current value to a target value

/* Analyze the yearly performance of products by comparing their sales
to both the average sales performance of the product and the previous year's sales */

-- YEAR-OVER-YEAR ANALYSIS
WITH yearly_product_sales AS (
	SELECT
		YEAR(f.order_date) AS order_year,
		p.product_name,
		SUM(f.sales_amount) AS current_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
		ON f.product_key = p.product_key
	WHERE f.order_date IS NOT NULL
	GROUP BY
		YEAR(f.order_date),
		p.product_name
)

SELECT
	order_year,
	product_name,
	current_sales,
	AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
	current_sales - AVG(current_sales)OVER (PARTITION BY product_name) AS diff_avg,
	CASE WHEN current_sales - AVG(current_sales)OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
		 WHEN current_sales - AVG(current_sales)OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
		 ELSE 'Avg'
	END avg_change,
	-- Year-over-Year Analysis
	LAG(current_Sales) OVER (PARTITION BY product_name ORDER BY order_year) py_sales,
	current_Sales - LAG(current_Sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_py,
	CASE WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
		 WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
		 ELSE 'No Change'
	END AS py_change
FROM yearly_product_sales
ORDER BY product_name, order_year


-- MONTH-ON-MONTH SALE PERFMANCE ANALYSIS

WITH monthly_product_sales AS (
SELECT
FORMAT(f.order_date, 'MMM-yyyy') AS order_year,   --FORMAT(order_date, 'yyyy-MMM')
p.product_name,
SUM(f.sales_amount) AS current_sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE f.order_date IS NOT NULL
GROUP BY
FORMAT(f.order_date, 'MMM-yyyy'),
p.product_name
)

SELECT
order_year,
product_name,
current_sales,
AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
current_sales - AVG(current_sales)OVER (PARTITION BY product_name) AS diff_avg,
CASE WHEN current_sales - AVG(current_sales)OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
	 WHEN current_sales - AVG(current_sales)OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
	 ELSE 'Avg'
END avg_change,
-- YEAR-OVER-YEAR ANALYSIS
LAG(current_Sales) OVER (PARTITION BY product_name ORDER BY order_year) py_sales,
current_Sales - LAG(current_Sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_py,
CASE WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
	 WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
	 ELSE 'No Change'
END AS py_change
FROM monthly_product_sales
ORDER BY product_name, order_year;

/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/

--PART-TO-WHOLE (PROPORTIONAL ANALYSIS): Analyse how an individual part is performing compare to the overall, allowing us 
--to understand which category has the greatest impact on the business

-- Which categories contribute the most to overall sales?

WITH category_sales AS(
SELECT
category,
SUM(sales_amount) total_Sales
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY category)

SELECT
category,
total_sales,
sum(total_sales) OVER () overall_sales,
CONCAT(ROUND((CAST(total_sales as FLOAT) / SUM(total_sales) OVER ())*100, 2), '%') AS percentage_of_total
FROM category_sales
ORDER BY percentage_of_total desc


/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/
-- Group the data based on a specific range. Helps understand the correlation between two measures

/*Segment products into cost ranges and 
count how many products fall into each segment*/


WITH product_segments AS (
	SELECT 
		product_key,
		product_name,
		cost,
		CASE WHEN cost < 100 THEN 'Below 100'
			WHEN COST BETWEEN 100 AND 500 THEN '100-500'
			WHEN COST BETWEEN 500 AND 1000 THEN '500-1000'
			ELSE 'Above 1000'
		END AS cost_range
	FROM gold.dim_products
)
SELECT 
	cost_range,
	COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
order by total_products DESC


/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spendding €5,000 or less.
	- New: Customers with a lifespan less than 12 months.

*/


WITH customer_spending AS (
	SELECT 
		c.customer_key,
		sum(f.sales_amount) as total_spending,
		MIN(order_date) AS first_order,
		MAX(order_Date) AS last_order,
		DATEDIFF (MONTH, MIN(order_date), MAX(order_date)) AS lifespan
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c
		ON f.customer_key = c.customer_key
	GROUP BY c.customer_key
)
SELECT
	customer_key,
	total_spending,
	lifespan,
	CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
		 WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
		 ELSE 'New'
	END customer_segment

FROM customer_spending

--And find the total number of customers by each group

WITH customer_spending AS (
	SELECT 
		c.customer_key,
		sum(f.sales_amount) as total_spending,
		MIN(order_date) AS first_order,
		MAX(order_Date) AS last_order,
		DATEDIFF (MONTH, MIN(order_date), MAX(order_date)) AS lifespan
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c
		ON f.customer_key = c.customer_key
	GROUP BY c.customer_key
)

SELECT
	customer_segment,
	COUNT(customer_key) AS total_customers
FROM (
	SELECT
		customer_key,
		CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
			 WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
			 ELSE 'New'
		END customer_segment
	FROM customer_spending) 
AS segmented_customers
GROUP BY customer_segment
ORDER BY total_customers DESC;


/*
================================================================================
Customer Report
================================================================================
Purpose:
	- This report consolidates key customer metrics and behaviors

Highlights:
	1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
	3. Aggregates customer-level metrics:
		- total orders
		- total sales
		- total quantity purchased
		- total products
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last order)
		- average order value
		- average monthly spend
================================================================================
*/
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
	DROP VIEW gold.report_customers

CREATE VIEW gold.report_customers AS
WITH base_query AS(
/*------------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
-------------------------------------------------------------------------------*/
SELECT
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity,
c.customer_key,
c.customer_number,
CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
DATEDIFF(YEAR, c.birthdate, GETDATE()) age
FROM gold.fact_Sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
WHERE order_date  is NOT NULL)

, customer_aggregation AS (
/*-------------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level  
--------------------------------------------------------------------------------*/
	SELECT 
	customer_key,
	customer_number,
	customer_name,
	age,
	count(distinct order_number) as total_orders,
	sum(sales_amount) as total_sales,
	sum(quantity) as total_quantity,
	COUNT(DISTINCT product_key) AS total_products,
	MAX(order_Date) AS last_order_date,
	DATEDIFF (MONTH, MIN(order_date), MAX(order_date)) AS lifespan
from base_query
group by 
customer_key,
customer_number,
customer_name,
age
)

SELECT
customer_key,
customer_number,
customer_name,
age,
CASE WHEN age < 20 THEN 'Under 20'
	 WHEN age between 20 and 29 THEN '20-29'
	 WHEN age between 30 and 39 THEN '30-39'
	 WHEN age between 40 and 49 THEN '40-49'
	 ELSE '50 and above'
END AS age_group,
CASE 
	WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
	WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
	ELSE 'New'
END customer_segment,
last_order_date,
DATEDIFF(MONTH, last_order_date, GETDATE()) as RECENCY,
total_orders,
total_sales,
total_quantity,
total_products,
lifespan,
-- Compute average order value (AVO)
CASE WHEN total_sales = 0 THEN 0
	 ELSE total_Sales / total_orders
END AS avg_order_value,
-- Compute average monthly spend
CASE WHEN lifespan = 0 THEN total_sales
	ELSE total_sales/lifespan
END AS avg_monthly_spend
FROM customer_aggregation

SELECT * FROM gold.report_customers

SELECT
age_group,
COUNT(customer_number) AS total_customers,
SUM(total_sales) total_sales
FROM gold.report_customers
GROUP BY age_group


/*
====================================================================================================
Product Report
====================================================================================================
Purpose:
	- This report consolidates key product metrics and behaviors.

Highlights:
	1. Gathers essential fields such as product name, category, subcategory, and cost.
	2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
	3. Aggregates product-level metrics:
		- total orders
		- total sales
		- total quantity sold
		- total customers (unique)
		- lifespan (in months)
	4. Calculates valuable KPIs:
		- recency (months since last sale)
		- average order revenue (AOR)
		- average monthly revenue
====================================================================================================
*/

-- Create an SQL View to Provide Product Insight
CREATE VIEW gold.report_products AS
WITH base_query AS (
/* -------------------------------------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_products
--------------------------------------------------------------------------------------------------*/

	SELECT
		f.order_number,
		f.order_date,
		f.customer_key,
		f.sales_amount,
		f.quantity,
		p.product_key,
		p.product_name,
		p.category,
		p.subcategory,
		p.cost
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON f.product_key = p.product_key
	WHERE order_date IS NOT NULL  -- only consider valid sales dates
)
,product_aggregations AS (
/*-----------------------------------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
------------------------------------------------------------------------------------------------------*/
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
	MAX(order_date) AS last_sale_date,
	COUNT(DISTINCT order_number) AS total_orders,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS total_quantity,
	ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),1) AS avg_selling_price
FROM base_query

GROUP BY
product_key,
product_name,
category,
subcategory,
cost
)

--SELECT
--	product_key,
--	product_name,
--	category,
--	subcategory,
--	cost,
--	last_sale_date
--FROM product_aggregations


/*-----------------------------------------------------------------------------------------------------
3) Final Query: Combines all product results into one output
-----------------------------------------------------------------------------------------------------*/
SELECT
	product_key,
	product_name,
	category,
	subcategory,
	cost,
	last_sale_date,
	DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency_in_months,
	CASE
		WHEN total_Sales > 50000 THEN 'Higher-Performer'
		WHEN total_Sales >= 10000 THEN 'Mid-Range'
		ELSE 'Low-Performer'
	END AS product_segment,
	lifespan,
	total_orders,
	total_sales,
	total_quantity,
	total_customers,
	avg_selling_price,
	-- Average Order Revenue (AOR)
	CASE 
		WHEN total_orders = 0 THEN 0
		else total_Sales / total_orders
	END AS avg_order_revenue,

	-- Average Monthly Revenue
	CASE 
		WHEN lifespan = 0 THEN total_sales
		else total_sales / lifespan
	END AS avg_monthly_revenue

FROM product_aggregations

SELECT * FROM gold.report_products
