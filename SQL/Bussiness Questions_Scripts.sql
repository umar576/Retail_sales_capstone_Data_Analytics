--1. What is the total revenue generated in the last 12 months?
SELECT
    SUM(quantity * unit_price * (1 - discount_pct)) AS total_revenue_last_12_months
FROM cleaned_sales
WHERE order_date >= DATEADD(MONTH, -12, GETDATE());
--2.Which are the top 5 best-selling products by quantity?
SELECT TOP 5
    p.product_id,
    p.product_name,
    SUM(s.quantity) AS total_quantity_sold
FROM cleaned_sales s
JOIN cleaned_product p
    ON s.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC;

--3. How many customers are from each region?
SELECT
    region,
    COUNT(customer_id) AS total_customers
FROM clean_customers
GROUP BY region
ORDER BY total_customers DESC;


--4. Which store has the highest profit in the past year?
SELECT TOP 1
    st.store_id,
    st.store_name,
    SUM(
        (s.unit_price - p.cost_price)
        * s.quantity
        *(1 - s.discount_pct)
    ) AS total_profit
FROM cleaned_sales s
JOIN cleaned_product p
    ON s.product_id = p.product_id
JOIN cleaned_stores st
    ON s.store_id = st.store_id
WHERE s.order_date >= DATEADD(MONTH, -12, GETDATE())
GROUP BY st.store_id, st.store_name
ORDER BY total_profit DESC;
--5. What is the return rate by product category?
SELECT
    p.category,
    COUNT(DISTINCT r.order_id) * 100.0
        / COUNT(DISTINCT s.order_id) AS return_rate_pct
FROM cleaned_sales s
JOIN cleaned_product p
    ON s.product_id = p.product_id
LEFT JOIN cleaned_returns r
    ON s.order_id = r.order_id
GROUP BY p.category
ORDER BY return_rate_pct DESC;
--6. What is the average revenue per customer by age group?
SELECT
    p.category,
    COUNT(DISTINCT r.order_id) * 100.0
        / COUNT(DISTINCT s.order_id) AS return_rate_pct
FROM cleaned_sales s
JOIN cleaned_product p
    ON s.product_id = p.product_id
LEFT JOIN cleaned_returns r
    ON s.order_id = r.order_id
GROUP BY p.category
ORDER BY return_rate_pct DESC;

--7. Which sales channel (Online vs In-Store) is more profitable on average?
SELECT
    s.sales_channel,
    AVG(
        (s.unit_price - p.cost_price)
        * s.quantity
        * (1 - s.discount_pct)
    ) AS avg_profit_per_order
FROM cleaned_sales s
JOIN cleaned_product p
    ON s.product_id = p.product_id
GROUP BY s.sales_channel
ORDER BY avg_profit_per_order DESC;

--8. How has monthly profit changed over the last 2 years by region?
SELECT
    FORMAT(s.order_date, 'yyyy-MM') AS month,
    c.region,
    SUM(
        (s.unit_price - p.cost_price)
        * s.quantity
        * (1 - s.discount_pct)
    ) AS monthly_profit
FROM cleaned_sales s
JOIN cleaned_product p
    ON s.product_id = p.product_id
JOIN clean_customers c
    ON s.customer_id = c.customer_id
WHERE s.order_date >= DATEADD(MONTH, -24, GETDATE())
GROUP BY FORMAT(s.order_date, 'yyyy-MM'), c.region
ORDER BY month, c.region;

--9. Identify the top 3 products with the highest return rate in each category.
WITH product_return_rates AS (
    SELECT
        p.category,
        p.product_id,
        p.product_name,
        COUNT(DISTINCT r.order_id) * 100.0
            / COUNT(DISTINCT s.order_id) AS return_rate_pct
    FROM cleaned_sales s
    JOIN cleaned_product p
        ON s.product_id = p.product_id
    LEFT JOIN cleaned_returns r
        ON s.order_id = r.order_id
    GROUP BY
        p.category,
        p.product_id,
        p.product_name
),
ranked_products AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY return_rate_pct DESC
        ) AS rank_in_category
    FROM product_return_rates
)
SELECT
    category,
    product_id,
    product_name,
    return_rate_pct
FROM ranked_products
WHERE rank_in_category <= 3
ORDER BY category, return_rate_pct DESC;

-- Which 5 customers have contributed the most to total profit, and what is their tenure with the company?
SELECT TOP 5
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(
        (s.unit_price - p.cost_price)
        * s.quantity
        * (1 - s.discount_pct)
    ) AS total_profit,
    DATEDIFF(YEAR, c.signup_date, GETDATE()) AS tenure_years
FROM cleaned_sales s
JOIN cleaned_product p
    ON s.product_id = p.product_id
JOIN clean_customers c
    ON s.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.signup_date
ORDER BY total_profit DESC;




