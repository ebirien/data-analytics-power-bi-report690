SELECT s.store_type As top_german_store_type, ROUND(CAST(SUM(o.product_quantity * p.sale_price) AS NUMERIC), 2) AS revenue 
FROM orders AS o
INNER JOIN dim_product AS p ON
o.product_code = p.product_code
INNER JOIN dim_store AS s ON
o.store_code = s.store_code
WHERE s.country = 'Germany'
GROUP BY store_type
ORDER BY revenue DESC
LIMIT 1;