SELECT p.category AS product_category, ROUND(CAST(SUM(o.product_quantity * p.sale_price) AS NUMERIC), 2) AS revenue 
FROM orders AS o
INNER JOIN dim_product AS p ON
o.product_code = p.product_code
INNER JOIN dim_store AS s ON
o.store_code = s.store_code
INNER JOIN dim_date AS d ON
o.order_date = d.date
WHERE d.year = 2021
AND s.full_region = 'Wiltshire, UK'
GROUP BY category
ORDER BY revenue DESC
LIMIT 1;