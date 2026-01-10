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

    count(*) as total_items,
    sum(price) as total_item_value,
    sum(freight_value) as total_freight_value,
    sum(price + freight_value) as order_gross_value,

    avg(price) as avg_item_price,
    count(distinct seller_id) as distinct_sellers,
    count(distinct product_id) as distinct_products,

    count(distinct seller_id) > 1 as has_multiple_sellers,
    count(distinct product_id) > 1 as has_multiple_products
from {{ ref('int_order_items_metrics') }}
group by order_id

{% if is_incremental() %}
where ingested_at > (select max_ingested_at from ingested_max_date)
{% endif %}
