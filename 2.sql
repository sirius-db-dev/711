SELECT DISTINCT v.name
FROM vendor_pxi v
INNER JOIN vendor_product_info_sao vp ON v.id = vp.vendor_id
INNER JOIN product_azi p ON p.id = vp.product_id
WHERE p.brand = 'Apple' OR p.brand = 'Samsung';
