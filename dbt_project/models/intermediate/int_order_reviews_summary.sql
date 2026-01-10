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

    avg(review_score) as avg_review_score,
    min(review_score) as min_review_score,
    max(review_score) as max_review_score,
    count(*) as review_count,

    count(*) > 0 as has_review,
    avg(review_score) < 3 as is_poorly_rated
from {{ ref('int_order_reviews_enriched') }}
group by order_id

{% if is_incremental() %}
where ingested_at > (select max_ingested_at from ingested_max_date)
{% endif %}