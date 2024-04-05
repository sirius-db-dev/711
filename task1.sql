select model, category, brand
from product_hrf
where (brand = 'Apple' or brand = 'Samsung') and (category = 'смартфоны' or category = 'ноутбуки');