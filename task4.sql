select p_i.name
from provider_product_info_ybs p
left join provider_iox p_i on p.provider_id = p_i.id
left join product_hrf p_h on p.product_id = p_h.id
where p_h.brand = 'Apple'

union

select p_i.name
from provider_car_info_2jd p
left join provider_iox p_i on p.provider_id = p_i.id
left join car_crh c on p.car_id = c.id
where 27 < c.body_volume and c.body_volume < 31
