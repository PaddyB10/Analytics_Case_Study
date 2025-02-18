with unique_applications as (
    select
    *
    from {{ ref ('stg_applications_raw_applications_data') }}   
    where tracking_token in (select max(tracking_token)
     from {{ ref ('stg_applications_raw_applications_data') }}
     group by tracking_token)  
    
),

applications as (
    select
        posting_id,
        'applied' as type,
        month(created_at) as _month,
        count(*) as _count
    from unique_applications
    group by posting_id, _month
    
),

clicks as (
    select 
        posting_id,
        'opened' as type,
        month(processed_timestamp) as _month,
        count(*) as _count
    from {{ ref ('stg_searches_raw_searches_data') }}
    where event = 'opened'
    group by posting_id, _month
    
),

application_rate_setup as (
   select  * from applications
   union
   select * from clicks
   
)

select * from application_rate_setup
order by posting_id, type, _month