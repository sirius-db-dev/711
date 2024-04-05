SELECT DISTINCT model, category, brand
FROM product_azi
WHERE (category = 'смартфоны' OR category = 'ноутбуки')
AND (brand = 'Apple' OR brand = 'Samsung');
