{{ config(
    materialized='incremental',
    incremental_strategy='append'
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
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value,
    ingested_at
from {{ source('raw', 'order_items') }}
{% if is_incremental() %} 
where ingested_at > (select max_ingested_at from ingested_max_date)
{% endif %}