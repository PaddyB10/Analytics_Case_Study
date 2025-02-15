select * from {{ ref ('stg_searches_raw_searches_data') }}
where EVENT = 'entered_viewport'