/*
===============================================================================
data segmentation analysis
===============================================================================
purpose:
    - to group data into meaningful categories for targeted insights.
    - for customer segmentation, product categorization, or regional analysis.

sql functions used:
    - case: defines custom segmentation logic.
    - group by: groups data into segments.
===============================================================================
*/

/*segment products into cost ranges and 
count how many products fall into each segment*/
with product_segments as (
    select
        product_key,
        product_name,
        cost,
        case 
            when cost < 100 then 'below 100'
            when cost between 100 and 500 then '100-500'
            when cost between 500 and 1000 then '500-1000'
            else 'above 1000'
        end as cost_range
    from gold.dim_products
)
select 
    cost_range,
    count(product_key) as total_products
from product_segments
group by cost_range
order by total_products desc;

/*group customers into three segments based on their spending behavior:
    - vip: customers with at least 12 months of history and spending more than €5,000.
    - regular: customers with at least 12 months of history but spending €5,000 or less.
    - new: customers with a lifespan less than 12 months.
and find the total number of customers by each group
*/
with customer_spending as (
    select
        c.customer_key,
        sum(f.sales_amount) as total_spending,
        min(order_date) as first_order,
        max(order_date) as last_order,
        datediff(month, min(order_date), max(order_date)) as lifespan
    from gold.fact_sales f
    left join gold.dim_customers c
        on f.customer_key = c.customer_key
    group by c.customer_key
)
select 
    customer_segment,
    count(customer_key) as total_customers
from (
    select 
        customer_key,
        case 
            when lifespan >= 12 and total_spending > 5000 then 'vip'
            when lifespan >= 12 and total_spending <= 5000 then 'regular'
            else 'new'
        end as customer_segment
    from customer_spending
) as segmented_customers
group by customer_segment
order by total_customers desc;
