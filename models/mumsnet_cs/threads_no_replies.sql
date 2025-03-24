select
t.thread_id,
count(reply_id) as no_replies
from {{ref ('src_threads_raw')}} t
left join {{ref ('src_replies_raw')}} r
on t.thread_id = r.thread_id
group by t.thread_id
order by no_replies DESC
