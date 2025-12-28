-- OLAP Analytics Queries for FlexiMart Data Warehouse
-- Database: fleximart_dw

-- Query 1: Monthly Sales Drill-Down Analysis
-- Business Scenario: "The CEO wants to see sales performance broken down by time periods. 
-- Start with yearly total, then quarterly, then monthly sales for 2024."

SELECT 
    d.year,
    d.quarter,
    d.month_name,
    COUNT(DISTINCT f.order_number) as total_orders,
    SUM(f.quantity_sold) as total_quantity,
    SUM(f.total_amount) as total_sales,
    ROUND(AVG(f.unit_price), 2) as avg_unit_price
FROM 
    fact_sales f
JOIN 
    dim_date d ON f.date_key = d.date_key
WHERE 
    d.year = 2024
GROUP BY 
    d.year,
    d.quarter,
    d.month_name,
    d.month  -- For proper ordering
WITH ROLLUP  -- Creates subtotals and grand total
ORDER BY 
    d.year,
    d.quarter,
    d.month;

-- Alternative: Using GROUPING SETS for more control
SELECT 
    COALESCE(CAST(d.year AS CHAR), 'All Years') as year,
    COALESCE(d.quarter, 'All Quarters') as quarter,
    COALESCE(d.month_name, 'All Months') as month_name,
    COUNT(DISTINCT f.order_number) as total_orders,
    SUM(f.quantity_sold) as total_quantity,
    SUM(f.total_amount) as total_sales
FROM 
    fact_sales f
JOIN 
    dim_date d ON f.date_key = d.date_key
WHERE 
    d.year = 2024
GROUP BY GROUPING SETS (
    (d.year),                    -- Year level
    (d.year, d.quarter),         -- Quarter level  
    (d.year, d.quarter, d.month_name),  -- Month level
    ()                           -- Grand total
)
ORDER BY 
    d.year,
    d.quarter,
    d.month;

-- Query 2: Product Performance Analysis
-- Business Scenario: "The product manager needs to identify top-performing products. 
-- Show the top 10 products by revenue, along with their category, total units sold, 
-- and revenue contribution percentage."

WITH product_performance AS (
    SELECT 
        p.product_name,
        p.category,
        p.subcategory,
        p.brand,
        SUM(f.quantity_sold) as units_sold,
        SUM(f.total_amount) as revenue,
        COUNT(DISTINCT f.order_number) as order_count,
        COUNT(DISTINCT f.customer_key) as unique_customers
    FROM 
        fact_sales f
    JOIN 
        dim_product p ON f.product_key = p.product_key
    WHERE 
        p.current_flag = TRUE
    GROUP BY 
        p.product_name, p.category, p.subcategory, p.brand
),
total_revenue AS (
    SELECT SUM(revenue) as grand_total FROM product_performance
)
SELECT 
    pp.product_name,
    pp.category,
    pp.subcategory,
    pp.brand,
    pp.units_sold,
    pp.revenue,
    pp.order_count,
    pp.unique_customers,
    ROUND((pp.revenue / tr.grand_total) * 100, 2) as revenue_percentage,
    ROUND(pp.revenue / pp.units_sold, 2) as avg_price_per_unit
FROM 
    product_performance pp
CROSS JOIN 
    total_revenue tr
ORDER BY 
    pp.revenue DESC
LIMIT 10;

-- Alternative: Using window function for percentage calculation
SELECT 
    product_name,
    category,
    subcategory,
    brand,
    units_sold,
    revenue,
    order_count,
    ROUND((revenue / SUM(revenue) OVER()) * 100, 2) as revenue_percentage,
    DENSE_RANK() OVER (ORDER BY revenue DESC) as revenue_rank,
    ROW_NUMBER() OVER (PARTITION BY category ORDER BY revenue DESC) as category_rank
FROM (
    SELECT 
        p.product_name,
        p.category,
        p.subcategory,
        p.brand,
        SUM(f.quantity_sold) as units_sold,
        SUM(f.total_amount) as revenue,
        COUNT(DISTINCT f.order_number) as order_count
    FROM 
        fact_sales f
    JOIN 
        dim_product p ON f.product_key = p.product_key
    WHERE 
        p.current_flag = TRUE
    GROUP BY 
        p.product_name, p.category, p.subcategory, p.brand
) as product_stats
ORDER BY 
    revenue DESC
LIMIT 10;

-- Query 3: Customer Segmentation Analysis
-- Business Scenario: "Marketing wants to target high-value customers. 
-- Segment customers into 'High Value' (>₹50,000 spent), 
-- 'Medium Value' (₹20,000-₹50,000), and 'Low Value' (<₹20,000). 
-- Show count of customers and total revenue in each segment."

WITH customer_spending AS (
    SELECT 
        c.customer_key,
        c.customer_name,
        c.city,
        c.state,
        SUM(f.total_amount) as total_spent,
        COUNT(DISTINCT f.order_number) as total_orders,
        COUNT(DISTINCT f.product_key) as unique_products
    FROM 
        fact_sales f
    JOIN 
        dim_customer c ON f.customer_key = c.customer_key
    GROUP BY 
        c.customer_key, c.customer_name, c.city, c.state
),
customer_segments AS (
    SELECT 
        cs.*,
        CASE 
            WHEN cs.total_spent >= 50000 THEN 'High Value'
            WHEN cs.total_spent >= 20000 THEN 'Medium Value'
            ELSE 'Low Value'
        END as customer_segment,
        CASE 
            WHEN cs.total_orders >= 10 THEN 'Frequent'
            WHEN cs.total_orders >= 5 THEN 'Regular'
            ELSE 'Occasional'
        END as frequency_segment
    FROM 
        customer_spending cs
)
SELECT 
    cs.customer_segment,
    cs.frequency_segment,
    COUNT(DISTINCT cs.customer_key) as customer_count,
    SUM(cs.total_spent) as total_revenue,
    ROUND(AVG(cs.total_spent), 2) as avg_revenue_per_customer,
    ROUND(AVG(cs.total_orders), 2) as avg_orders_per_customer,
    ROUND(SUM(cs.total_spent) / SUM(SUM(cs.total_spent)) OVER() * 100, 2) as segment_revenue_percentage
FROM 
    customer_segments cs
GROUP BY 
    cs.customer_segment,
    cs.frequency_segment
WITH ROLLUP
ORDER BY 
    CASE cs.customer_segment
        WHEN 'High Value' THEN 1
        WHEN 'Medium Value' THEN 2
        WHEN 'Low Value' THEN 3
        ELSE 4
    END,
    CASE cs.frequency_segment
        WHEN 'Frequent' THEN 1
        WHEN 'Regular' THEN 2
        WHEN 'Occasional' THEN 3
        ELSE 4
    END;

-- Additional: RFM Analysis (Recency, Frequency, Monetary)
WITH customer_rfm AS (
    SELECT 
        c.customer_key,
        c.customer_name,
        c.city,
        MAX(d.full_date) as last_purchase_date,
        DATEDIFF('2024-02-29', MAX(d.full_date)) as recency_days,
        COUNT(DISTINCT f.order_number) as frequency,
        SUM(f.total_amount) as monetary
    FROM 
        fact_sales f
    JOIN 
        dim_customer c ON f.customer_key = c.customer_key
    JOIN 
        dim_date d ON f.date_key = d.date_key
    GROUP BY 
        c.customer_key, c.customer_name, c.city
),
rfm_scores AS (
    SELECT 
        *,
        NTILE(4) OVER (ORDER BY recency_days DESC) as recency_score,
        NTILE(4) OVER (ORDER BY frequency) as frequency_score,
        NTILE(4) OVER (ORDER BY monetary) as monetary_score
    FROM 
        customer_rfm
)
SELECT 
    CONCAT(recency_score, frequency_score, monetary_score) as rfm_cell,
    CASE 
        WHEN CONCAT(recency_score, frequency_score, monetary_score) IN ('444', '443', '434') THEN 'Champions'
        WHEN CONCAT(recency_score, frequency_score, monetary_score) IN ('433', '344', '343') THEN 'Loyal Customers'
        WHEN CONCAT(recency_score, frequency_score, monetary_score) IN ('442', '441', '431') THEN 'Potential Loyalists'
        WHEN CONCAT(recency_score, frequency_score, monetary_score) LIKE '4__' THEN 'Recent Customers'
        WHEN CONCAT(recency_score, frequency_score, monetary_score) LIKE '_4_' THEN 'Frequent Customers'
        WHEN CONCAT(recency_score, frequency_score, monetary_score) LIKE '__4' THEN 'Big Spenders'
        ELSE 'Need Attention'
    END as rfm_segment,
    COUNT(*) as customer_count,
    ROUND(AVG(monetary), 2) as avg_monetary,
    ROUND(AVG(frequency), 2) as avg_frequency
FROM 
    rfm_scores
GROUP BY 
    rfm_cell
ORDER BY 
    customer_count DESC;
