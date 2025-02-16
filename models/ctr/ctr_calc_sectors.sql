with impressions as (
    select 'entered_viewport' as _event, company_industry_name,month(processed_timestamp) as _month,count(*) as _count from {{ ref ('stg_searches_raw_searches_data') }}
    where event = 'entered_viewport'
    group by company_industry_name, _month
),

clicks as (
    select 'opened' as _event,company_industry_name,month(processed_timestamp) as _month,count(*) as _count from {{ ref ('stg_searches_raw_searches_data') }}
    where event = 'opened'
    group by company_industry_name, _month
),

ctr_setup as (
   select  * from impressions
   union
   select * from clicks
   
)

select * from ctr_setup



