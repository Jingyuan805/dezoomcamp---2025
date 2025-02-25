{{
    config(
        materialized='view'
    )
}}

with main as (
    select *
    from {{ ref('fact_trips') }}
)

, prep as (select service_type, date(date_trunc(pickup_datetime, quarter)) as quarters, sum(total_amount) as quarterly_amount
from main
group by 1,2)

select a.service_type, a.quarters, a.quarterly_amount/b.quarterly_amount as yy
from prep as a 
left join prep as b on date_add(a.quarters, interval -12 month) = b.quarters and a.service_type = b.service_type
where a.quarters between '2020-01-01' and '2020-12-31'
order by 1, 3
