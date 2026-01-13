	--- 6 --- Ranking
-- Order the values of dimensions by measure.
-- top N performers | bottm N performers


-- * Which five products generate the highest revenue
-- using subquery
select * 
from (
	select 
		product_name,
		f.product_key,
		sum(f.sales_amount) as Revenue,
		sum(f.quantity) as items_sold,
		row_number() over (order by sum(f.sales_amount) desc) as rank_products
	from gold.fact_sales f
	left join gold.dim_products p on p.product_key = f.product_key
	 group by f.product_key, product_name
	 )t
where rank_products <= 5
-- * What are the five worst-performing products in terms of sales
-- using top command
select top 5
	product_name,
	f.product_key,
	sum(f.sales_amount) as Revenue,
	sum(f.quantity) as items_sold
from gold.fact_sales f
left join gold.dim_products p on p.product_key = f.product_key
 group by f.product_key, product_name
 order by Revenue asc

 -- Find the top 10 customers who have generated the highest revenue
 -- and 3 customers with the fewest orders placed
select * from (
select 
c.first_name + ' ' + c.last_name as customer_name,
f.customer_key,
sum(sales_amount) as Total_Revenue,
row_number() over (order by sum(sales_amount) desc) as rank_customers
from gold.fact_sales f left join gold.dim_customers c on f.customer_key = c.customer_key
group by f.customer_key, c.first_name, c.last_name ) t 
where rank_customers <= 5

select top 3
c.first_name + ' ' + c.last_name as customer_name,
f.customer_key Total_Revenue,
sum(sales_amount),
count(order_number) as Total_Orders,
row_number() over (order by count(order_number), sum(sales_amount) asc) as rank_customers
from gold.fact_sales f left join gold.dim_customers c on f.customer_key = c.customer_key
group by f.customer_key, c.first_name, c.last_name
