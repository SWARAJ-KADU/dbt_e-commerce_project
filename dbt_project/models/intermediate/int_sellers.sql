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
    dbt_scd_id as unique_seller_id,
    seller_id,
    city,
    state,
    case
        when state in ('SP','RJ','MG','ES') then 'Southeast'
        when state in ('RS','SC','PR') then 'South'
        else 'Other'
    end as region,
    dbt_valid_from as valid_from,
    dbt_valid_to as valid_to,
    dbt_updated_at as updated_at
from {{ ref('sellers_snapshot') }}
{% if is_incremental() %}
where dbt_updated_at > (select max_updated_at from updated_max_date)
{% endif %}