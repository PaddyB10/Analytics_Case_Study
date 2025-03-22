with total_pageviews_per_month as (
    select
        sum(pageviews) as total_pageviews,
        month(pageviews_date) as _month
from {{source ("pageviews_raw","pageviews_raw")}}
group by _month),

test as (
    select
        *,
        lag(total_pageviews) over (
                order by _month )  as prev_count            
from total_pageviews_per_month )

select 
*,
case 
        when prev_count IS NOT NULL AND prev_count != 0 
        then total_pageviews - prev_count
        else NULL 
    end as _difference,
case 
        when _difference IS NOT NULL AND _difference != 0 
        then _difference*1.0/ total_pageviews * 100
        else NULL 
    end as difference_percentage,       
from test

