select min(price), max(price), avg(price), sum(price)
from provider_product_info_ybs p
join product_hrf p_h on p.product_id = p_h.id
where p_h.category = 'часы'