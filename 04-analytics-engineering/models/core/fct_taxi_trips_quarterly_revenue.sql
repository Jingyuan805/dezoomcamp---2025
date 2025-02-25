{{
    config(
        materialized='view'
    )
}}

with main as (
    select *
    from {{ ref('fact_trips') }}
)

select service_type, year_quarter(pickup_datetime) as quarters, sum(total_amount) as quarterly_amount
from main
group by 1,2