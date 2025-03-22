with pageviews_per_tag_per_month as (
select
sum(p.pageviews) as tag_pageviews,
t.tag,
month(p.pageviews_date) as _month
from {{source ("pageviews_raw","pageviews_raw")}} p
left join {{source ("tags_raw","tags_raw")}} t
on p.thread_id = t.thread_id
group by t.tag,_month
order by _month, tag_pageviews desc  
),

test as (select
 tag_pageviews,
 tag,
 _month,
 lag(tag_pageviews) over (
                partition by tag
                order by _month )  as prev_count            
from pageviews_per_tag_per_month )

select 
tag_pageviews,
tag,
_month,
prev_count,
case 
        when prev_count IS NOT NULL AND prev_count != 0 
        then tag_pageviews - prev_count
        else NULL 
    end as _difference,
case 
        when _difference IS NOT NULL AND _difference != 0 
        then _difference*1.0/ tag_pageviews * 100
        else NULL 
    end as difference_percentage,       
from test   