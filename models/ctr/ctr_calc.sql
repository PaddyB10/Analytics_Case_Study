with impressions as (
    select * from {{ ref ('no_entered_viewports') }}
),

clicks as (
    select * from {{ ref('no_search_opened') }}
),

ctr as (
   select (select count(*) from impressions) / CAST((select count(*) from clicks) as float)
)  

select * from ctr