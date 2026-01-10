select *
from {{ ref('int_order_items_metrics') }}
where price < 0
   or freight_value < 0
   or item_total_value < 0
