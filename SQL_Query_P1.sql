select count(*) from retail_sales;

-- how to change column name --
ALTER TABLE retail_sales RENAME COLUMN ï»¿transactions_id TO transactions_id;

select * from retail_sales
where transactions_id is null;

select * from retail_sales
where sale_date is null;

select * from retail_sales
where sale_time is null;

select * from retail_sales
where customer_id is null;

select * from retail_sales
where transactions_id is null
	or 
	sale_date is null
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
    quantiy is null
    or
    price_per_unit is null
    or
    cogs is null
    or
    total_sale is null;
    
    delete from retail_sales
    where transactions_id in (679, 746, 1225);
    
-- data exploration --
-- how many sales we have? --
    select count(*) as total_sale from retail_sales;

-- how many customers we have --
select count(customer_id) from retail_sales;

-- how many unique customers we have --
select count(distinct customer_id) from retail_sales;

-- how many unique category we have --
select count(distinct category) from retail_sales;

-- which categorys we have --
select distinct category from retail_sales;

--  Data Anlysis & Business Key Problems & Answers --

-- My Analysis --

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:

select * from retail_sales
where sale_date = '2022-11-05';

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022: --
select 
	* from retail_sales
	where category = 'clothing'
	and 
    month(sale_date)  = '11' 
    and 
    year(sale_date) = '2022'
    and 
    quantiy >= 4;
    
    
-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.: --
select 
	category, sum(total_sale), count(*) from retail_sales
	group by category;
    
-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.: --
select category, round(avg(age),2) from retail_sales
where category = 'beauty';

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.: --
select * from retail_sales
where total_sale > 1000;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.: --
select  
	category, gender,count(transactions_id) 
from retail_sales
group 
	by category, gender
order
	by category;
    
-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:  --
select 
	year,
    month,
    avg_sale
 from
(
	select 
		year(sale_date) as year, 
		month(sale_date) as month, 
		avg(total_sale) as avg_sale,
        dense_rank() over(partition by year(sale_date) order by avg(total_sale) desc) as 'rank'
        from retail_sales
	group by year, month
) as t1
where `rank` = 1;
-- order by 1, 2;


-- 8. Write a SQL query to find the top 5 customers based on the highest total sales --
select 
	customer_id,
    sum(total_sale) as total_sale
from retail_sales
 group by customer_id
 order by total_sale desc
 limit 5;
 
 -- 9. Write a SQL query to find the number of unique customers who purchased items from each category --
 select 
	category,
    count(distinct customer_id) as cnt_unique_cus
from retail_sales
group by category;
    
-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17): --
with hourly_sale
as
(
select *,
	case
		when hour(sale_time) < 12 then 'morning'
        when hour(sale_time) between 12 and 17 then 'afternoon'
        else 'evening'
	end as shift
from retail_sales
)
select 
	shift,
	count(*) as total_orders
from hourly_sale
group by shift

-- END of Project --