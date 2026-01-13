	--- 11 --- Data Segmentation
-- Group the data based on a specific range.
-- Helps to understand the relation between two measures
-- Segment products into cost ranges and count how many products fall into each segment

with price_segmentation as(
select 
	product_key,
	cost,
	case when cost > 1500 then 'high'
		 when cost > 500 then 'medium'
		 else 'low'
	end price_segment
from gold.dim_products )
select
price_segment as Segment,
count(product_key) as Total_products
from price_segmentation
group by price_segment
order by Segment

-- Group Customers into three segments based on their spending behavior
-- * VIP: At least 12 months of history and spending more than $5000
-- * Regular: At least 12 months of history but spending $5000 or less
-- * New: lifespan less than 12 months
-- And find the total number of customers by each group 
with customer_spending as(
select 
	f.customer_key,
	c.first_name + ' ' + c.last_name as Customer_Name,
	sum (f.sales_amount) as Total_spending,
	datediff(month,min(order_date), max(order_date)) as Spending_History
from gold.fact_sales f left join gold.dim_customers c on f.customer_key = c.customer_key
group by f.customer_key, c.last_name, c.first_name
)
select 
	count( customer_key) as Total_Customers,
	Segment as Customer_segment
from (
select
	customer_key,
	customer_name,
	concat(Total_spending, ' $') as Total_Spending,
	case when total_spending > 5000 and Spending_History > 12 then 'VIP'
		 when total_spending <= 5000 and Spending_History > 12 then 'Regular'
		 else 'New'
	end Segment
from customer_spending ) t
group by Segment
order by Total_Customers
