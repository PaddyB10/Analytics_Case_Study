select
sum(pageviews) as total_pageviews,
month(pageviews_date) as _month
from {{source ("pageviews_raw","pageviews_raw")}}
group by _month