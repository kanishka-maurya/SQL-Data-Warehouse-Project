/*
===============================================================================
performance analysis (year-over-year, month-over-month)
===============================================================================
purpose:
    - to measure the performance of products, customers, or regions over time.
    - for benchmarking and identifying high-performing entities.
    - to track yearly trends and growth.

sql functions used:
    - lag(): accesses data from previous rows.
    - avg() over(): computes average values within partitions.
    - case: defines conditional logic for trend analysis.
===============================================================================
*/

/* analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */
with yearly_product_sales as (
    select
        year(f.order_date) as order_year,
        p.product_name,
        sum(f.sales_amount) as current_sales
    from gold.fact_sales f
    left join gold.dim_products p
        on f.product_key = p.product_key
    where f.order_date is not null
    group by 
        year(f.order_date),
        p.product_name
)
select
    order_year,
    product_name,
    current_sales,
    avg(current_sales) over (partition by product_name) as avg_sales,
    current_sales - avg(current_sales) over (partition by product_name) as diff_avg,
    case 
        when current_sales - avg(current_sales) over (partition by product_name) > 0 then 'above avg'
        when current_sales - avg(current_sales) over (partition by product_name) < 0 then 'below avg'
        else 'avg'
    end as avg_change,
    -- year-over-year analysis
    lag(current_sales) over (partition by product_name order by order_year) as py_sales,
    current_sales - lag(current_sales) over (partition by product_name order by order_year) as diff_py,
    case 
        when current_sales - lag(current_sales) over (partition by product_name order by order_year) > 0 then 'increase'
        when current_sales - lag(current_sales) over (partition by product_name order by order_year) < 0 then 'decrease'
        else 'no change'
    end as py_change
from yearly_product_sales
order by product_name, order_year;
