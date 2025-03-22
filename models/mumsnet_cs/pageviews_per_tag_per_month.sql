select
sum(p.pageviews) as tag_pageviews,
t.tag,
month(p.pageviews_date) as _month
from {{source ("pageviews_raw","pageviews_raw")}} p
left join {{source ("tags_raw","tags_raw")}} t
on p.thread_id = t.thread_id
group by t.tag,_month
order by _month, tag_pageviews desc
