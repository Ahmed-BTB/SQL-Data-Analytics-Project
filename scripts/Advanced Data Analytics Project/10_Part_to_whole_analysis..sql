	--- 10 --- Part to whole analysis
-- Analyze how an indidvual part is performing compared to the overall,
-- allowing us to understand which category has the greatest impact on the buisiness

-- SQL TASK: Which categories contribute the most to overall sales
select 
t.category,
Total_Sales,
sum(Total_Sales) over() As Overall_Sales,
concat(round(cast(total_sales as float)/sum(Total_Sales) over() ,4) * 100 , ' %') as Percentage_of_Total
from
(
select
p.category,
sum(f.sales_amount) Total_Sales
from gold.fact_sales f
left join gold.dim_products p on f.product_key = p.product_key
group by p.category
) t
