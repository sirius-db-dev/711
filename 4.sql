SELECT v.name
FROM vendor_pxi v
INNER JOIN vendor_product_info_sao vp ON v.id = vp.vendor_id
INNER JOIN product_azi p ON p.id = vp.product_id
WHERE p.brand = 'Apple'

UNION

SELECT v.name
FROM vendor_pxi v
INNER JOIN vendor_car_info_i3h vc ON v.id = vc.vendor_id
INNER JOIN car_45y c ON c.id = vc.car_id
WHERE body_volume BETWEEN 27 AND 30;
