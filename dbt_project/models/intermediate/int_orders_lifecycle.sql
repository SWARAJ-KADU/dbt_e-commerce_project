{{ config(
    materialized='incremental',
    unique_key='order_id',
    incremental_strategy='merge'
) }}

{% if is_incremental() %}
with ingested_max_date as (
    select
        max(ingested_at) as max_ingested_at
    from {{ this }}
)
{% endif %}


select
    order_id,
    customer_id,
    order_status,

    order_purchase_timestamp,
    order_approve_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    
    datediff(hour, order_purchase_timestamp, order_approve_at) as order_processing_hours,
    datediff(day, order_approve_at, order_delivered_carrier_date) as order_shipping_days,
    datediff(day, order_purchase_timestamp, order_delivered_customer_date) as order_delivery_days,
    datediff(day, order_estimated_delivery_date, order_delivered_customer_date) as delivery_delay_days,

    order_status = 'delivered' as is_delivered,
    order_status = 'canceled' as is_cancelled,
    delivery_delay_days > 0 as is_late_delivery,

    date(order_purchase_timestamp) as order_date,
    year(order_purchase_timestamp) as order_year,
    month(order_purchase_timestamp) as order_month,

    ingested_at
from {{ ref('stg_orders') }}

{% if is_incremental() %}
where ingested_at > (select max_ingested_at from ingested_max_date)
{% endif %}
