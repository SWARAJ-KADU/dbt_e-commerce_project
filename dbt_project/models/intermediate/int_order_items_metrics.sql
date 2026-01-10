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

    price,
    freight_value,
    price + freight_value as item_total_value,

    case 
        when price > 0 then freight_value / price 
        else null 
    end as freight_percentage,

    freight_value = 0 as is_free_shipping,
    freight_value > price * 0.5 as is_high_freight,

    shipping_limit_date,
    ingested_at
from {{ ref('stg_order_items') }}

{% if is_incremental() %}
where ingested_at > (select max_ingested_at from ingested_max_date)
{% endif %}
