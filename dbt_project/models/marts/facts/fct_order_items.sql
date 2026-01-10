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
    {{ surrogate_key(['oi.order_item_id', 'oi.order_id']) }} as order_item_sk,
    oi.order_item_id,
    oi.order_id,
    p.product_sk,
    s.seller_sk,
    oi.price,
    oi.freight_value,
    oi.freight_percentage,
    oi.item_total_value,
    oi.is_free_shipping,
    oi.is_high_freight,
    {{ surrogate_key(['oi.shipping_limit_date::date']) }} as shipping_limit_date_sk,
    oi.ingested_at
from(
    select * from {{ ref('int_order_items_metrics') }}
    {% if is_incremental() %}
    where ingested_at > (select max_ingested_at from ingested_max_date)
    {% endif %}
    ) oi
join {{ ref('dim_products') }} p
    on oi.product_id = p.product_id and p.valid_to is null
join {{ ref('dim_sellers') }} s
    on oi.seller_id = s.seller_id and s.valid_to is null

