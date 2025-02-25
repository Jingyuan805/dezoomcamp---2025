{{ config(materialized='view') }}
 
with tripdata as 
(
  select *
  from {{ source('staging','fhv_tripdata') }}
  where dispatching_base_num is not null 
)

select
   -- identifiers
    {{ dbt_utils.generate_surrogate_key(['dispatching_base_num', 'pickup_datetime']) }} as tripid,    
    {{ dbt.safe_cast("dispatching_base_num", api.Column.translate_type("string")) }} as dispatching_base_num,    
    {{ dbt.safe_cast("affiliated_base_number", api.Column.translate_type("string")) }} as affiliated_base_number,
    {{ dbt.safe_cast("pulocationid", api.Column.translate_type("integer")) }} as pickup_locationid,
    {{ dbt.safe_cast("dolocationid", api.Column.translate_type("integer")) }} as dropoff_locationid,
    cast(sr_flag as string) as sr_flag,

    -- timestamps
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropoff_datetime as timestamp) as dropoff_datetime

    

from tripdata
