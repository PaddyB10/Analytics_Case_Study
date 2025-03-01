with converted as (
    select
        test_group,
        converted,
        count(*) as _count
    from {{ref ('stg_ab_testing_gamma_raw_data')}}
    group by test_group, converted
),

test as (select
 test_group,
 converted,
 _count,
 lag(_count) over (
                partition by test_group 
                order by converted )  as prev_count            
from converted)

select 
test_group,
converted,
_count,
prev_count,
case 
        when prev_count IS NOT NULL AND prev_count != 0 
        then prev_count + _count
        else NULL 
    end as sum_count,
case 
        when sum_count IS NOT NULL AND sum_count != 0 
        then prev_count*1.0/ sum_count * 100
        else NULL 
    end as false_count_percentage,
case 
        when sum_count IS NOT NULL AND sum_count != 0 
        then _count*1.0/ sum_count * 100
        else NULL 
    end as true_count_percentage         
from test    