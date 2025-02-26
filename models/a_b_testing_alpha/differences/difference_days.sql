with control as (
    select * from {{ref('stg_control_raw_data')}}
),

test as (
    select * from {{ref('stg_test_raw_data')}}
),

control_and_test as (
    select * from control
    union
    select * from test
)

select * from control_and_test
order by DAY(date)