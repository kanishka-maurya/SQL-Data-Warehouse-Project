/*
===============================================================================
cumulative analysis
===============================================================================
purpose:
    - to calculate running totals or moving averages for key metrics.
    - to track performance over time cumulatively.
    - useful for growth analysis or identifying long-term trends.

sql functions used:
    - window functions: sum() over(), avg() over()
===============================================================================
*/

-- calculate the total sales per month 
-- and the running total of sales over time 
select
	order_date,
	total_sales,
	sum(total_sales) over (order by order_date) as running_total_sales,
	avg(avg_price) over (order by order_date) as moving_average_price
from
(
    select 
        datetrunc(year, order_date) as order_date,
        sum(sales_amount) as total_sales,
        avg(price) as avg_price
    from gold.fact_sales
    where order_date is not null
    group by datetrunc(year, order_date)
) t
