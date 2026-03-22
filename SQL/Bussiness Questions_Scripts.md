# 									    **Business Questions**







**1. What is the total revenue generated in the last 12 months?** 

**Ans:**SELECT

&nbsp;   SUM(quantity \* unit\_price \* (1 - discount\_pct)) AS total\_revenue\_last\_12\_months

FROM cleaned\_sales

WHERE order\_date >= DATEADD(MONTH, -12, GETDATE());

total\_revenue\_last\_12\_months
107966.19447393



**2. Which are the top 5 best-selling products by quantity? 
Ans:**SELECT TOP 5

&nbsp;   p.product\_id,

&nbsp;   p.product\_name,

&nbsp;   SUM(s.quantity) AS total\_quantity\_sold

FROM cleaned\_sales s

JOIN cleaned\_product p

&nbsp;   ON s.product\_id = p.product\_id

GROUP BY p.product\_id, p.product\_name

ORDER BY total\_quantity\_sold DESC;


**3. How many customers are from each region?** 

**Ans:**SELECT

&nbsp;   region,

&nbsp;   COUNT(customer\_id) AS total\_customers

FROM clean\_customers

GROUP BY region

ORDER BY total\_customers DESC; 





**4. Which store has the highest profit in the past year?** 

**Ans:**SELECT TOP 1

&nbsp;   st.store\_id,

&nbsp;   st.store\_name,

&nbsp;   SUM(

&nbsp;       (s.unit\_price - p.cost\_price)

&nbsp;       \* s.quantity

&nbsp;       \* (1 - s.discount\_pct)

&nbsp;   ) AS total\_profit

FROM cleaned\_sales s

JOIN cleaned\_product p

&nbsp;   ON s.product\_id = p.product\_id

JOIN cleaned\_stores st

&nbsp;   ON s.store\_id = st.store\_id

WHERE s.order\_date >= DATEADD(MONTH, -12, GETDATE())

GROUP BY st.store\_id, st.store\_name

ORDER BY total\_profit DESC;

**5. What is the return rate by product category?** 

**Ans:**SELECT

&nbsp;   p.category,

&nbsp;   COUNT(DISTINCT r.order\_id) \* 100.0

&nbsp;       / COUNT(DISTINCT s.order\_id) AS return\_rate\_pct

FROM cleaned\_sales s

JOIN cleaned\_product p

&nbsp;   ON s.product\_id = p.product\_id

LEFT JOIN cleaned\_returns r

&nbsp;   ON s.order\_id = r.order\_id

GROUP BY p.category

ORDER BY return\_rate\_pct DESC;

**6. What is the average revenue per customer by age group? 
Ans:**SELECT

&nbsp;   p.category,

&nbsp;   COUNT(DISTINCT r.order\_id) \* 100.0

&nbsp;       / COUNT(DISTINCT s.order\_id) AS return\_rate\_pct

FROM cleaned\_sales s

JOIN cleaned\_product p

&nbsp;   ON s.product\_id = p.product\_id

LEFT JOIN cleaned\_returns r

&nbsp;   ON s.order\_id = r.order\_id

GROUP BY p.category

ORDER BY return\_rate\_pct DESC;


**7. Which sales channel (Online vs In-Store) is more profitable on average?** 

**Ans:**SELECT

&nbsp;   s.sales\_channel,

&nbsp;   AVG(

&nbsp;       (s.unit\_price - p.cost\_price)

&nbsp;       \* s.quantity

&nbsp;       \* (1 - s.discount\_pct)

&nbsp;   ) AS avg\_profit\_per\_order

FROM cleaned\_sales s

JOIN cleaned\_product p

&nbsp;   ON s.product\_id = p.product\_id

GROUP BY s.sales\_channel

ORDER BY avg\_profit\_per\_order DESC;



**8. How has monthly profit changed over the last 2 years by region?** 

**Ans:**SELECT

&nbsp;   FORMAT(s.order\_date, 'yyyy-MM') AS month,

&nbsp;   c.region,

&nbsp;   SUM(

&nbsp;       (s.unit\_price - p.cost\_price)

&nbsp;       \* s.quantity

&nbsp;       \* (1 - s.discount\_pct)

&nbsp;   ) AS monthly\_profit

FROM cleaned\_sales s

JOIN cleaned\_product p

&nbsp;   ON s.product\_id = p.product\_id

JOIN clean\_customers c

&nbsp;   ON s.customer\_id = c.customer\_id

WHERE s.order\_date >= DATEADD(MONTH, -24, GETDATE())

GROUP BY FORMAT(s.order\_date, 'yyyy-MM'), c.region

ORDER BY month, c.region;



**9. Identify the top 3 products with the highest return rate in each category.** 

**Ans:**WITH product\_return\_rates AS (

&nbsp;   SELECT

&nbsp;       p.category,

&nbsp;       p.product\_id,

&nbsp;       p.product\_name,

&nbsp;       COUNT(DISTINCT r.order\_id) \* 100.0

&nbsp;           / COUNT(DISTINCT s.order\_id) AS return\_rate\_pct

&nbsp;   FROM cleaned\_sales s

&nbsp;   JOIN cleaned\_product p

&nbsp;       ON s.product\_id = p.product\_id

&nbsp;   LEFT JOIN cleaned\_returns r

&nbsp;       ON s.order\_id = r.order\_id

&nbsp;   GROUP BY

&nbsp;       p.category,

&nbsp;       p.product\_id,

&nbsp;       p.product\_name

),

ranked\_products AS (

&nbsp;   SELECT

&nbsp;       \*,

&nbsp;       ROW\_NUMBER() OVER (

&nbsp;           PARTITION BY category

&nbsp;           ORDER BY return\_rate\_pct DESC

&nbsp;       ) AS rank\_in\_category

&nbsp;   FROM product\_return\_rates

)

SELECT

&nbsp;   category,

&nbsp;   product\_id,

&nbsp;   product\_name,

&nbsp;   return\_rate\_pct

FROM ranked\_products

WHERE rank\_in\_category <= 3

ORDER BY category, return\_rate\_pct DESC;


**10. Which 5 customers have contributed the most to total profit, and what is their** 

**tenure with the company?**

**Ans:**SELECT TOP 5

&nbsp;   c.customer\_id,

&nbsp;   CONCAT(c.first\_name, ' ', c.last\_name) AS customer\_name,

&nbsp;   SUM(

&nbsp;       (s.unit\_price - p.cost\_price)

&nbsp;       \* s.quantity

&nbsp;       \* (1 - s.discount\_pct)

&nbsp;   ) AS total\_profit,

&nbsp;   DATEDIFF(YEAR, c.signup\_date, GETDATE()) AS tenure\_years

FROM cleaned\_sales s

JOIN cleaned\_product p

&nbsp;   ON s.product\_id = p.product\_id

JOIN clean\_customers c

&nbsp;   ON s.customer\_id = c.customer\_id

GROUP BY

&nbsp;   c.customer\_id,

&nbsp;   c.first\_name,

&nbsp;   c.last\_name,

&nbsp;   c.signup\_date

ORDER BY total\_profit DESC;










