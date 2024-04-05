--1

select model, category, brand
from product_qtg pq 
where category = 'ноутбуки' or category  = 'смартфоны'
intersect 
select model, category, brand
from product_qtg pq 
where brand = 'Apple' or brand = 'Samsung'


--2
select name
from provider_product_info_qk1 ppiq 
join product_qtg pq on pq.id = ppiq.product_id 
join provider_ake pa on pa.id  = ppiq.provider_id
where
pq.brand = 'Samsung'
intersect 
select name
from provider_product_info_qk1 ppiq 
join product_qtg pq on pq.id = ppiq.product_id 
join provider_ake pa on pa.id  = ppiq.provider_id
where
pq.brand = 'Apple'


--3
select name
from provider_product_info_qk1 ppiq 
join product_qtg pq on pq.id = ppiq.product_id 
join provider_ake pa on pa.id  = ppiq.provider_id
where pq.category = 'часы'
intersect 
select name
from provider_product_info_qk1 ppiq 
join product_qtg pq on pq.id = ppiq.product_id 
join provider_ake pa on pa.id  = ppiq.provider_id
where pq.category != 'смартфоны'


--4
select name
from provider_product_info_qk1 ppiq 
join product_qtg pq on pq.id = ppiq.product_id 
join provider_ake pa on pa.id  = ppiq.provider_id
where
pq.brand = 'Apple'
union 
select name
from provider_car_info_o7i pcio
join provider_ake pa on pa.id = pcio.provider_id
join car_wc8 cw on cw.id = pcio.car_id
where
cw.body_volume > 27 and cw.body_volume < 30


--5
select max(price), min(price), round(avg(price), 2), sum(price)
from provider_product_info_qk1 ppiq 
join product_qtg pq on pq.id = ppiq.product_id 
where brand  = 'Apple'


--6
select model
from product_qtg pq 
join provider_product_info_qk1 ppiq on ppiq.product_id = pq.id 
where category = 'мониторы'
and 
ppiq.price = (
select max(price) 
from provider_product_info_qk1 pp
join product_qtg p on p.id = pp.product_id
where p.category = 'мониторы'
)


--7
-- я не помню, как убрать повторения
select count(category)
from product_qtg pq 








