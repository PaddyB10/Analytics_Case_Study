with impressions as (
    select * from {{ ref ('no_entered_viewports') }}
),

clicks as (
    select * from {{ ref('no_search_opened') }}
),

ctr as (
   select (select count(*) from clicks) / CAST((select count(*) from impressions) as float) * 100
)  

select * from ctr