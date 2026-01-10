{{
    config(
        materialized='incremental',
        incremental_strategy='append'
    )
}}

{% if is_incremental() %}
with ingested_max_date as (
    select
        max(ingested_at) as max_ingested_at
    from {{ this }}
)
{% endif %}

select
    customer_unique_id as customer_sk,
    city,
    state,
    customer_id,
    region,
    ingested_at
from {{ ref('int_customers') }}

{% if is_incremental() %} 
where ingested_at > (select max_ingested_at from ingested_max_date)
{% endif %}