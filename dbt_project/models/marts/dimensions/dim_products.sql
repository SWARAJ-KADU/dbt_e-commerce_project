{{
    config(
        materialized='incremental',
        incremental_strategy='append'
    )
}}

{% if is_incremental() %}
with updated_max_date as (
    select
        max(updated_at) as max_updated_at
    from {{ this }}
)
{% endif %}


select
    unique_product_id as product_sk,
    product_id,
    product_category_name as category,
    product_category_name_english,
    product_weight_g,
    product_volume_cm3,
    product_size_class,
    valid_from,
    valid_to,
    updated_at
from {{ ref('int_products') }}

{% if is_incremental() %}
where updated_at > (select max_updated_at from updated_max_date)
{% endif %}