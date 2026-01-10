{{ config(
    materialized = 'table'
) }}

with date_spine as (

    {{ dbt_utils.date_spine(
        datepart = "day",
        start_date = "cast('2016-01-01' as date)",
        end_date   = "cast('2027-12-31' as date)"
    ) }}

),

final as (

    select
        {{ surrogate_key(['date_day']) }} as date_sk,
        date_day                                   as calendar_date,

        -- Day attributes
        day(date_day)                              as day_of_month,
        dayofweek(date_day)                        as day_of_week,
        dayname(date_day)                          as day_name,
        case when dayofweek(date_day) in (6, 7) then true else false end as is_weekend,

        -- Week attributes
        week(date_day)                             as week_of_year,
        yearofweek(date_day)                       as week_year,

        -- Month attributes
        month(date_day)                            as month,
        monthname(date_day)                        as month_name,
        year(date_day)                             as year,

        -- Quarter attributes
        quarter(date_day)                          as quarter,
        'Q' || quarter(date_day)                   as quarter_name,


    from date_spine

)

select * from final
order by calendar_date
