select *
from {{ ref('int_orders_lifecycle') }}
where order_delivered_customer_date < order_purchase_timestamp
