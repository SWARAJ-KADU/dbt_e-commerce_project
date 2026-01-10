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
    zip_code_prefix,
    cast(lat as number(20, 15)) as latitude,
    cast(lng as number(20, 15)) as longitude,
    city,
    upper(state) as state,
    ingested_at
from {{ source('raw', 'geolocation') }}

{% if is_incremental() %} 
where ingested_at > (select max_ingested_at from ingested_max_date)
{% endif %}
