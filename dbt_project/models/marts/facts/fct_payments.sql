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
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value,
    is_installment,
    is_credit_card,
    is_voucher,
    is_cash_equivalent,
    ingested_at
from {{ ref('int_order_payments_enriched') }}

{% if is_incremental() %}
where ingested_at > (select max_ingested_at from ingested_max_date)
{% endif %}
