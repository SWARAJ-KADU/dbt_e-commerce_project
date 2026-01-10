select *
from {{ ref('int_order_basket_summary') }}
where order_gross_value != total_item_value + total_freight_value
