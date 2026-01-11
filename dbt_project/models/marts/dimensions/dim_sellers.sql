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
    unique_seller_id as seller_sk,
    city,
    state,
    seller_id,
    region,
    valid_from,
    valid_to,
    updated_at
from {{ ref('int_sellers') }}

{% if is_incremental() %}
where updated_at > (select max_updated_at from updated_max_date)
{% endif %}
