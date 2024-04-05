select p_i.name
from provider_product_info_ybs p
left join provider_iox p_i on p.provider_id = p_i.id
left join product_hrf p_h on p.product_id = p_h.id
where p_h.brand = 'Apple'

union

select p_i.name
from provider_product_info_ybs p
left join provider_iox p_i on p.provider_id = p_i.id
left join product_hrf p_h on p.product_id = p_h.id
where p_h.brand = 'Samsung'
