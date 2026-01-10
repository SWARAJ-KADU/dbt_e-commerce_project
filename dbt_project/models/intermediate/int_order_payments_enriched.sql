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

    payment_installments > 1 as is_installment,
    payment_type = 'credit_card' as is_credit_card,
    payment_type = 'voucher' as is_voucher,
    payment_type in ('debit_card', 'boleto') as is_cash_equivalent,

    ingested_at
from {{ ref('stg_order_payments') }}

{% if is_incremental() %}
where ingested_at > (select max_ingested_at from ingested_max_date)
{% endif %}