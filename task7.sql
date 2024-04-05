with all_category as (
select distinct category
from product_hrf ph
)
select count(category)
from all_category
