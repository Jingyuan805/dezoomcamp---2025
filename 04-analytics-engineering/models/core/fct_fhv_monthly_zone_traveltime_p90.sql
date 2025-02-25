{{
    config(
        materialized='view'
    )
}}

with main as (
    select *, TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, second) as trip_duration
    from {{ ref('dim_fhv_trips') }}
)

, final as (
    select distinct pickup_month, pickup_locationid, pickup_zone, dropoff_locationid, dropoff_zone
        , PERCENTILE_CONT(trip_duration, 0.9) OVER (partition by pickup_month, pickup_locationid, dropoff_locationid)  as p90
    from main)

select *
from final
where pickup_month = '2019-11-01' and pickup_zone in ('Newark Airport', 'SoHo', 'Yorkville East')
order by pickup_zone, p90 desc

