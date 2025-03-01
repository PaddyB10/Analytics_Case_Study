with control as (
    select
    *,
    usd/purchase as "cost_per_purchase",
    searches/purchase as "conversion_rate"
    from {{ref('stg_control_raw_data')}}
),

test as (
    select
    *,
    usd/purchase as "cost_per_purchase",
    searches/purchase as "conversion_rate"
    from {{ref('stg_test_raw_data')}}
)


select * from control
union
select * from test

