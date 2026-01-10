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
    customer_unique_id,
    customer_id,
    zip_code_prefix,
    city,
    state,

    case
        when state in ('SP','RJ','MG','ES') then 'Southeast'
        when state in ('RS','SC','PR') then 'South'
        when state in ('BA','PE','CE') then 'Northeast'
        else 'Other'
    end as region,
    ingested_at
from {{ ref('stg_customers') }}
{% if is_incremental() %} 
where ingested_at > (select max_ingested_at from ingested_max_date)
{% endif %}
