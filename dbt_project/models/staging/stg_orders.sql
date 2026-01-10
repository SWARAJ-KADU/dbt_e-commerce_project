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
    ingested_at,
    current_timestamp() as updated_at
from {{ source('raw', 'orders') }}

{% if is_incremental() %} 
where ingested_at > (select max_ingested_at from ingested_max_date)
{% endif %}
