with max_sum as (
select price
from provider_product_info_ybs p
join product_hrf p_h on p.product_id = p_h.id
where p_h.category = 'мониторы'
)


select p_h.model
from provider_product_info_ybs p
join product_hrf p_h on p.product_id = p_h.id
where p_h.category = 'мониторы' and p.price = (select max(price) from max_sum)