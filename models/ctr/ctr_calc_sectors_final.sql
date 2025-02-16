
with ranked_data as (
    select 
        company_industry_name,
        _month,
        _count,
        lag(_count) over (
            partition by company_industry_name 
            order by _month, _event
        ) as prev_count
    from {{ ref ('ctr_calc_sectors_primer') }}
),

ctr_data as ( 
    select 
        company_industry_name,
        _month,
        _count,
        prev_count,
        case 
            when prev_count IS NOT NULL AND prev_count != 0 
            then _count * 1.0 / prev_count * 100
            else NULL 
        end as ctr
    from ranked_data
)

select 
    company_industry_name,
    _month,
    _count,
    prev_count,
    ctr
    from (select *, Row_number() over (partition by company_industry_name order by _month) as RN
from ctr_data)
where RN = 2 or RN = 4
