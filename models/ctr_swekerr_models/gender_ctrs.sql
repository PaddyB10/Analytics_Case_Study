with gender as (
    select
        gender,
        clicked_on_ad,
        count(*) as _count
    from {{ref('ctr_swekerr_raw')}}
    group by gender, clicked_on_ad
),

gender_1 as (
    select 
        gender,
        clicked_on_ad,
        _count,
        lag(_count) over (partition by gender order by clicked_on_ad) as prev_count
    from gender    


),

gender_2 as (
    select
        gender,
        clicked_on_ad,
        _count,
        prev_count,
        case
            when prev_count is not null and prev_count != 0
            then _count + prev_count
            else null
         end as sum_count,
        case
            when sum_count is not null and sum_count != 0
            then (_count * 1.0) / (sum_count) * 100
            else null
        end as click_percentage
    from gender_1         

)

select * from gender_2