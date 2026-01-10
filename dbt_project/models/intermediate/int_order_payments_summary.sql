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

    sum(payment_value) as total_payment_value,
    sum(payment_installments) as total_installments,
    count(distinct payment_type) as payment_method_count,

    max(is_credit_card) as used_credit_card,
    max(is_voucher) as used_voucher,
    max(is_installment) as used_installments
from {{ ref('int_order_payments_enriched') }}
group by order_id

{% if is_incremental() %}
where ingested_at > (select max_ingested_at from ingested_max_date)
{% endif %}
