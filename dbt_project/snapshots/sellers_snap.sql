{% snapshot sellers_snapshot %}

{{
    config(
        unique_key='seller_id',
        strategy='check',
        check_cols='all'
    )
}}

select
    seller_id,
    zip_code_prefix,
    city,
    upper(state) as state
from {{ source('raw', 'sellers') }}

{% endsnapshot %}
