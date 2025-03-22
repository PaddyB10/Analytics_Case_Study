select
sum(pageviews) as total_pageviews,
month(pageviews_date) as _month
from {{ref ('src_pageviews_raw')}}
group by _month