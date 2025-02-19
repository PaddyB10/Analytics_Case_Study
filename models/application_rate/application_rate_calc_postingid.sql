with application_rate_postingid as (
    select 
        posting_id, 
        type, 
        _count, 
        _month,
        lag(posting_id) over (partition by _month order by posting_id, type) as prev_posting_id,
        lag(type) over (partition by _month order by posting_id, type) as prev_type,
        lag(_count) over (partition by _month order by posting_id, type) as prev_count
    from  {{ ref ('application_rate_calc_primer' )}}
)
select 
    posting_id, 
    type, 
    _count, 
    _month,
    case 
        when type = 'opened' and prev_type = 'applied' and posting_id = prev_posting_id 
        then cast(prev_count as float) / nullif(_count, 0) 
        else NULL 
    end as application_rate
from application_rate_postingid