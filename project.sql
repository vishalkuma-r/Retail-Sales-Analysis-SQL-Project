-- sql Retail sales analyze - p1
create database sql_project_p2;
-- create table;
drop table retail_sales;
use sql_project_p2;
create table retail_sales
(
				transactions_id int primary key,
				sale_date date,
				sale_time time,
				customer_id	int,
				gender varchar(6),
				age int,
				category varchar(20),
				quantiy int,
				price_per_unit float,
				cogs float,
				total_sale float

)

-- show table data;--
select * from retail_sales where transactions_id limit 100;
select count(*) from retail_sales;
select count(transactions_id) from retail_sales group by transactions_id having count(transactions_id)>1;
select * from retail_sales 
where transactions_id is null 
or 
sale_date is null
 or 
sale_time	is null 
or
customer_id is null 
or	
gender is null 
or
age is null     
or	
category is null 
or	
quantiy is null 
or	
price_per_unit is null 
or	
cogs is null 
or
total_sale is null ;

select * from retail_sales where transactions_id =746;


-- delete all null value;


delete from retail_sales 
where transactions_id is null 
or 
sale_date is null
 or 
sale_time	is null 
or
customer_id is null 
or	
gender is null 
or
age is null     
or	
category is null 
or	
quantiy is null 
or	
price_per_unit is null 
or	
cogs is null 
or
total_sale is null ;
-- data eloration
-- how many sales we have?
select count(*) as total_sales 	from retail_sales;

-- HOw many unique customers we have

select count(distinct customer_id) as total_customer from retail_sales;

-- show unique category
select distinct category from retail_sales;


-- Data Analysis & Business key  Problem & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retail_sales;
select * from retail_sales where sale_date='2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 
-- 'Clothing' and the quantity sold is more than & equal to 4 in the month of Nov-2022

select * from retail_sales where category='Clothing' and quantiy>=4 and sale_date like '2022-11%';
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category , sum(total_sale),count(quantiy) from retail_sales group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select avg(age) from retail_Sales where category='Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_Sales where total_Sale>1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) 
-- made by each gender in each category.
select category,gender,count(transactions_id) from retail_Sales group by 1,2 order by 1;
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select * from
(
	select 
    extract(year from sale_date), 
	extract(month from sale_date),
	avg (total_sale) ,
	rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc )as ranka
	from retail_sales 
	group by 1,2 
)as t1
where ranka= 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id ,sum(total_sale) from retail_sales group by 1 order by 2 desc limit 5;

-- Q.9 Write a SQL query to find the number of 
-- unique customers who purchased items from each category.
select count(distinct customer_id),category from retail_sales group by 2;

-- Q.10 Write a SQL query to create each shift and number of orders 
-- (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

select count(sale_time),  
	case
		when extract(hour from sale_time)<12 then 'Morning'
		when extract(hour from sale_time)between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
from retail_sales group by shift order by count(sale_time) ;
-- another method


with hourly_sale
as
(
select *,
	case
		when extract(hour from sale_time)<12 then 'Morning'
		when extract(hour from sale_time)between 12 and 17 then 'Afternoon'
		else 'Evening'
	end as shift
from retail_sales
)
select 
	shift,
	count(*) as total_orders
from hourly_Sale
group by shift;

