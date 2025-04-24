drop table  if exists retail_sales ;
CREATE TABLE retail_sales(
transactions_id	int PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id	INT,
gender varchar(15),
age	int,
category varchar(15),
quantiy	int,
price_per_unit	float,
cogs float,
total_sale float
)
select*from retail_sales;

copy retail_sales from 'C:\Program Files\PostgreSQL\SQL - Retail Sales Analysis_utf .csv'CSV header;

select count(*)
from retail_sales;
select from retail_sales
	where 
	transactions_id is null
	or
	sale_time is null
	or
	customer_id is null
	or 
	gender is null
	or
	age is null
	or
	category is null
	or
	quantity is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

alter table retail_sales
rename column quantiy to quantity;

--data cleaning --
delete from retail_sales
where
	transactions_id is null
	or
	sale_time is null
	or
	customer_id is null
	or 
	gender is null
	or
	age is null
	or
	category is null
	or
	quantity is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

-- data exploration --
--How many sales we have ?
SELECT COUNT(*)
AS total_sale
FROM retail_Sales;

--How many customers we have ?
SELECT COUNT(DISTINCT customer_id)
FROM retail_sales;

SELECT DISTINCT (CATEGORY)
FROM retail_sales;
select*from retail_sales;

-- Data Analysis & Business Key Problem and Answers
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select *
from retail_sales
where sale_date='2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select *
from retail_sales	
where category='Clothing' and to_char(sale_date,'YYYY-MM-DD') ='2022-11-14' and quantity>=4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category,
sum(total_sale) as net_sale,
count(*) as total_orders
from retail_sales
group by 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),2) as avg_age
from retail_sales
where category='Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select *
from retail_sales
where total_sale >1000;

select*from retail_sales;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category,gender,count(*) as total_sales
from retail_sales
group by category, gender;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
	Round(AVG(total_sale),2) AS avg_sale,
    RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail_sales
GROUP BY year, month
limit 5;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id,
sum(total_sale) as total_Sales
from retail_sales
group by 1
order by 2 desc
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select 
category,
count(distinct customer_id) as distinct_id
from retail_sales
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
