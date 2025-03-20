with age_bins as (
    select
        gender,
        count(case when age >9 and age <=20 then 1 end) as _10_20,
        count(case when age >20 and age <=30 then 1 end) as _20_30,
        count(case when age >30 and age <=40 then 1 end) as _30_40,
        count(case when age >40 and age <=50 then 1 end) as _40_50,
        count(case when age >50 then 1 end) as _50_plus
    from {{ref('ctr_swekerr_raw')}}
    group by gender    

)

select * from age_bins