with control as (
    select * from {{ref('stg_control_raw_data')}}
)
select * from control