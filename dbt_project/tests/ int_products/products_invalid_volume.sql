select *
from {{ ref('int_products') }}
where product_volume_cm3 <= 0
