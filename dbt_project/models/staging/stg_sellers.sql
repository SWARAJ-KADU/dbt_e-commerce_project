with source as (

    select
        seller_id,
        zip_code_prefix,
        city,
        upper(state) as state
    from {{ source('raw', 'sellers') }}

)

select * from source
