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
    p.dbt_scd_id as unique_product_id,
    p.product_id,
    p.product_category_name,
    c.product_category_name_english,

    p.product_weight_g,
    p.product_length_cm * p.product_width_cm * p.product_height_cm as product_volume_cm3,

    case
        when p.product_weight_g < 1000 then 'small'
        when p.product_weight_g < 5000 then 'medium'
        else 'large'
    end as product_size_class,
    p.dbt_valid_from as valid_from,
    p.dbt_valid_to as valid_to,
    p.dbt_updated_at as updated_at
from 
(select * from {{ ref('products_snapshot') }}
{% if is_incremental() %}
where dbt_updated_at > (select max_updated_at from updated_max_date)
{% endif %}
) p
left join {{ ref('stg_product_category') }} c
    on p.product_category_name = c.product_category_name_english
