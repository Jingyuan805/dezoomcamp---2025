{{
    config(
        materialized='view'
    )
}}

with main as (
    select date(date_trunc(pickup_datetime, month)) as m, *
    from {{ ref('fact_trips') }}
    where fare_amount > 0
    and trip_distance > 0
    and payment_type_description in ('Cash', 'Credit card')
)


select distinct service_type, m
    , PERCENTILE_CONT(fare_amount, 0.97) OVER (partition by service_type, m )  as p97
    , PERCENTILE_CONT(fare_amount, 0.95) OVER (partition by service_type, m )  as p95
    , PERCENTILE_CONT(fare_amount, 0.9) OVER (partition by service_type, m )  as p90
from main
where m = '2020-04-01'


