SELECT
  min(vp.price) AS min_price,
  max(vp.price) AS max_price,
  avg(vp.price) AS average_price,
  sum(vp.price) AS sum_price
FROM product_azi p
INNER JOIN vendor_product_info_sao vp ON p.id = vp.product_id
WHERE p.brand = 'Apple';
