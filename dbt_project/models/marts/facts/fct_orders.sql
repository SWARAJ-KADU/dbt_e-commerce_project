{{ config(
    materialized='incremental',
    unique_key='order_sk',
    incremental_strategy='merge'
) }}

with
{% if is_incremental() %}
ingested_max_date as (
    select
        max(ingested_at) as max_ingested_at
    from {{ this }}
),
{% endif %}

customer_data as (
    select
        c1.customer_sk as unique_id,
        c2.customer_sk as customer_sk
    from {{ ref('dim_customers') }} c1
    left join (
        select *
        from {{ ref('dim_customers') }}
        qualify row_number() over (
            partition by customer_id
            order by ingested_at desc nulls first
        ) = 1
    ) c2
        on c1.customer_id = c2.customer_id
)



select
    o.order_id as order_sk,
    c.customer_sk,
    o.order_status,
    {{ surrogate_key(['o.order_purchase_timestamp::date']) }} as order_purchase_timestamp_sk,
    {{ surrogate_key(['o.order_approve_at::date']) }} as order_approve_at_sk,
    {{ surrogate_key(['o.order_delivered_carrier_date::date']) }} as order_delivered_carrier_date_sk,
    {{ surrogate_key(['o.order_delivered_customer_date::date']) }} as order_delivered_customer_date_sk,
    {{ surrogate_key(['o.order_estimated_delivery_date::date']) }} as order_estimated_delivery_date_sk,
    o.order_processing_hours,
    o.order_shipping_days,
    o.order_delivery_days,
    o.delivery_delay_days,
    o.is_delivered,
    o.is_cancelled,
    o.is_late_delivery,
    o.order_date,
    o.order_year,
    o.order_month

from (
    select * from {{ ref('int_orders_lifecycle') }} 
    {% if is_incremental() %}
    where ingested_at > (select max_ingested_at from ingested_max_date)
    {% endif %}
) o
left join 
customer_data c
on o.customer_id = c.unique_id