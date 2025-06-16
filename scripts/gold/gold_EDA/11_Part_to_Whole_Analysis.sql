/*
===============================================================================
part-to-whole analysis
===============================================================================
purpose:
    - to compare performance or metrics across dimensions or time periods.
    - to evaluate differences between categories.
    - useful for a/b testing or regional comparisons.

sql functions used:
    - sum(), avg(): aggregates values for comparison.
    - window functions: sum() over() for total calculations.
===============================================================================
*/

-- which categories contribute the most to overall sales?
with category_sales as (
    select
        p.category,
        sum(f.sales_amount) as total_sales
    from gold.fact_sales f
    left join gold.dim_products p
        on p.product_key = f.product_key
    group by p.category
)
select
    category,
    total_sales,
    sum(total_sales) over () as overall_sales,
    round((cast(total_sales as float) / sum(total_sales) over ()) * 100, 2) as percentage_of_total
from category_sales
order by total_sales desc;
