
with ranked_data as (
    select 
        COMPANY_INDUSTRY_NAME,
        _MONTH,
        _COUNT,
        lag(_COUNT) over (
            partition by COMPANY_INDUSTRY_NAME 
            order by _MONTH, _EVENT
        ) as prev_count
    from {{ ref ('ctr_calc_sectors') }}
),

ctr_data as ( 
    select 
        COMPANY_INDUSTRY_NAME,
        _MONTH,
        _COUNT,
        prev_count,
        case 
            when prev_count IS NOT NULL AND prev_count != 0 
            then _COUNT * 1.0 / prev_count * 100
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
