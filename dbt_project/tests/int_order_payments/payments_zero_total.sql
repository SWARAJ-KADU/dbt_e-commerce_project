select *
from {{ ref('int_order_payments_summary') }}
where total_payment_value < 0
