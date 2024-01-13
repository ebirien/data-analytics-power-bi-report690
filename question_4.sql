SELECT s.store_type As "Store Type"
, ROUND(CAST(SUM(o.product_quantity * p.sale_price) AS NUMERIC), 2) AS "Total Sales"
, ROUND(CAST(100 * SUM(o.product_quantity * p.sale_price) /SUM(SUM(o.product_quantity * p.sale_price)) OVER() AS NUMERIC), 2)  AS "Percentage Total Sales"
, COUNT(o.order_date_uuid) AS "Order Count" 
FROM orders AS o
INNER JOIN dim_product AS p ON
o.product_code = p.product_code
INNER JOIN dim_store AS s ON
o.store_code = s.store_code
GROUP BY store_type