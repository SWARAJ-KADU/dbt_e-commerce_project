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
    review_id,
    order_id,
    review_score,

    case
        when review_score >= 4 then 'positive'
        when review_score = 3 then 'neutral'
        else 'negative'
    end as review_sentiment,

    review_creation_date,
    review_answer_timestamp,
    datediff(hour, review_creation_date, review_answer_timestamp) as review_response_hours,

    ingested_at
from {{ ref('stg_order_reviews') }}

{% if is_incremental() %}
where ingested_at > (select max_ingested_at from ingested_max_date)
{% endif %}

