# 1

select 
  model,
  category,
  brand
from product_sur ps
where category in ('ноутбуки', 'смартфоны') 
and brand in ('Apple', 'Samsung');


# 2

select 
  name
from vendor_nde vn
left join vendor_product_info_skf vpis on vn.id = vpis.vendor_id
left join product_sur ps on ps.id = vpis.product_id
where brand = 'Apple'
intersect
select 
  name
from vendor_nde vn
left join vendor_product_info_skf vpis on vn.id = vpis.vendor_id
left join product_sur ps on ps.id = vpis.product_id
where brand = 'Samsung';

# 3

select
  name
from vendor_nde vn
left join vendor_product_info_skf vpis on vn.id = vpis.vendor_id
left join product_sur ps on ps.id = vpis.product_id
where category = 'часы'
intersect
select 
  name
from vendor_nde vn
left join vendor_product_info_skf vpis on vn.id = vpis.vendor_id
left join product_sur ps on ps.id = vpis.product_id
where category != 'смартфоны';

# 4

select name
from vendor_nde vn
left join vendor_product_info_skf vpis on vn.id = vpis.vendor_id
left join product_sur ps on ps.id = vpis.product_id
where brand = 'Apple'
union
select name
from vendor_nde vn
left join vendor_transport_info_lwf vtil on vn.id = vtil.vendor_id
left join transport_hsc th on th.id = vtil.transport_id
where body_volume between 27 and 30;

# 5

select
  min(price),
  max(price),
  avg(price),
  sum(price)
from vendor_product_info_skf vpis
left join product_sur ps on ps.id = vpis.product_id
where category = 'часы' and brand = 'Apple';

# 6

select model
from product_sur ps
left join vendor_product_info_skf vpis on ps.id = vpis.product_id 
where price = (select max(price) from vendor_product_info_skf)

# 7

select count(*) as count_category
from (select distinct category from product_sur);