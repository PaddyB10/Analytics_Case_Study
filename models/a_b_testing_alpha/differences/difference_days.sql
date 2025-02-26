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
),

ranked_data as (
    select 
        campaign,
        day(date) as _date,
        usd,
        impressions,
        reach,
        clicks,
        searches,
        view_content,
        add_to_cart,
        purchase,
        lag(impressions) over (
                partition by _date 
                order by campaign
            ) as prev_count
 from control_and_test       
)


select 
    campaign,
    _date,
    impressions,
    prev_count,
    case 
        when prev_count IS NOT NULL AND prev_count != 0 
        then impressions - prev_count
        else NULL 
    end as diff_impressions
from ranked_data

