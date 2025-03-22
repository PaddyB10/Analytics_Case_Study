select
sum(p.pageviews) as tag_pageviews,
t.tag,
month(p.pageviews_date) as _month
from {{ref ('src_pageviews_raw')}} p
left join {{ref ('src_tags_raw')}} t
on p.thread_id = t.thread_id
group by t.tag,_month
order by _month, tag_pageviews desc
