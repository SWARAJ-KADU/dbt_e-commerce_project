select *
from {{ ref('int_order_reviews_enriched') }}
where review_answer_timestamp < review_creation_date
