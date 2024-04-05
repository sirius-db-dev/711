--Тарасов

--1. Вывести модель, категорию, бренд продуктов из категорий смартфоны и ноутбуки брендов Apple и Samsung.
SELECT model, category, brand FROM product_shv
WHERE category IN ('смартфоны', 'ноутбуки') AND brand IN ('Apple', 'Samsung')

--2. Вывести названия компаний (НЕ брендов), поставляющие бренды как Apple, так и Samsung.
SELECT DISTINCT o.name FROM vendor_ows o
JOIN vendor_product_info_th4 p ON o.id = p.vendor_id
JOIN product_shv s ON p.product_id = s.id
WHERE s.brand IN ('Apple', 'Samsung')

--3. Вывести названия компаний, поставляющие часы, но не смартфоны.
SELECT DISTINCT o.name FROM vendor_ows o
JOIN vendor_product_info_th4 p ON o.id = p.vendor_id
JOIN product_shv s ON p.product_id = s.id
WHERE s.category = 'часы'
INTERSECT
SELECT DISTINCT o.name FROM vendor_ows o
JOIN vendor_product_info_th4 p ON o.id = p.vendor_id
JOIN product_shv s ON p.product_id = s.id
WHERE s.category != 'смартфоны'

--4. Вывести названия компаний, поставляющих продукцию бренда Apple либо имеющие транспортные средства с объемом(body_volume) от от 27 до 30.
--Надеюсь, что здесь от 27 до 30 включительно
SELECT DISTINCT o.name FROM vendor_ows o
JOIN vendor_product_info_th4 p ON o.id = p.vendor_id
JOIN product_shv s ON p.product_id = s.id
WHERE s.brand = 'Apple'
UNION
SELECT DISTINCT o.name FROM vendor_ows o
JOIN vendor_car_info_bfd c ON o.id = c.vendor_id
JOIN car_yn2 y ON y.id = c.car_id
WHERE y.body_volume BETWEEN 27 AND 30

--5. Вывести минимальную, максимальную, среднюю и суммарную стоимость электронных часов компании Apple.
--quantity - подразумеваю, что это количество
SELECT MIN(p.price*p.quantity), MAX(p.price*p.quantity), AVG(p.price*p.quantity), SUM(p.price*p.quantity)
FROM vendor_ows o
JOIN vendor_product_info_th4 p ON o.id = p.vendor_id
JOIN product_shv s ON p.product_id = s.id
WHERE s.brand = 'Apple'

--6. Вывести модели мониторов, имеющих максимальную цену в бд.
--У каждой одной модели конкретная цена, не учитываю количество
SELECT s.model FROM product_shv s
JOIN vendor_product_info_th4 p ON s.id = p.product_id
WHERE p.price = (
SELECT MAX(p.price) FROM product_shv s
JOIN vendor_product_info_th4 p ON s.id = p.product_id
)

--7. Вывести количество различных категорий продуктов в бд.
SELECT COUNT(DISTINCT category) FROM product_shv s