	--- 4 --- Measures Exploration
-- Calculate the key metric of buisiness (Big Numbers)
-- Highest level of aggregation | Lowest level of details

-- Find the total sales 
select 
    format(sum(sales_amount), 'n0', 'fr-fr') AS Total_Sales
from gold.fact_sales;

-- Find how many items are sold
select 
	format(sum(quantity), 'N0', 'fr-FR') AS Total_Items
from gold.fact_sales;

-- Find the average selling price 
select 
avg(price) as average_selling_price
from gold.fact_sales

-- Find the total number of orders
select 
	format(count (distinct order_number), 'N0', 'fr_fr')
	from gold.fact_sales

-- Find the total number of products 
select
count(product_name) as Total_Products
from gold.dim_products

-- Find the total number of customers
select 
count(customer_key) as Total_Customers
from gold.dim_customers

-- Find the total number of customers that have placed an order
select 
count(distinct customer_key)
from gold.fact_sales

-----
-- SQL TASK: Generate a report that shows all the key metrics of the buisiness
-----
select
	'Total Sales' as measure_name,
	sum(sales_amount) as measure_value
	from gold.fact_sales

union all

select
	'Total Items' ,
	sum(quantity)
	from gold.fact_sales
union all
select 
	'Avg Price',
	avg(price)
	from gold.fact_sales
union all 
select 
	'Total Orders',
	count (distinct order_number)
	from gold.fact_sales
union all
select
	'Total Products',
	count(product_name) 
	from gold.dim_products
union all 
select 
	'Total Customers',
	count(customer_key)
	from gold.dim_customers
