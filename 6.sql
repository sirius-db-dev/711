WITH max_monitor_price AS (
  SELECT max(price) AS max_price
  FROM product_azi p
  INNER JOIN vendor_product_info_sao vp ON p.id = vp.product_id
  WHERE p.category = 'мониторы'
)

SELECT DISTINCT model
FROM product_azi p
INNER JOIN vendor_product_info_sao vp ON p.id = vp.product_id
WHERE p.category = 'мониторы'
AND vp.price IN (SELECT max_price FROM max_monitor_price);
