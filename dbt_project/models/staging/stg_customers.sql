{{ config(
    materialized='incremental',
    incremental_strategy='append'
) }}

{% if is_incremental() %}
with ingested_max_date as (
    select max(ingested_at) as max_ingested_at
    from {{ this }}
)
{% endif %}

select
    customer_unique_id,
    customer_id,
    zip_code_prefix,
    city,
    upper(state) as state,
    dateadd(
        millisecond,
        row_number() over (
            partition by customer_id
            order by ingested_at desc
        ),
        ingested_at
    ) as ingested_at

from {{ source('raw', 'customers') }}
{% if is_incremental() %}
where ingested_at > (select max_ingested_at from ingested_max_date)
{% endif %}
