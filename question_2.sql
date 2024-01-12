SELECT d.month_name AS month, ROUND(CAST(SUM(o.product_quantity * p.sale_price) AS NUMERIC), 2) AS revenue 
FROM orders AS o
INNER JOIN dim_product AS p ON
o.product_code = p.product_code
INNER JOIN dim_date AS d ON
o.order_date = d.date
WHERE d.year = 2022
GROUP BY month
ORDER BY revenue DESC
LIMIT 1;