WITH ranked_data AS (
    SELECT 
        COMPANY_INDUSTRY_NAME,
        _MONTH,
        _COUNT,
        LAG(_COUNT) OVER (
            PARTITION BY COMPANY_INDUSTRY_NAME 
            ORDER BY _MONTH
        ) AS prev_count
    FROM {{ ref ('ctr_calc_sectors') }}
)
SELECT 
    COMPANY_INDUSTRY_NAME,
    _MONTH,
    _COUNT,
    prev_count,
    CASE 
        WHEN prev_count IS NOT NULL AND prev_count != 0 
        THEN _COUNT * 1.0 / prev_count 
        ELSE NULL 
    END AS count_ratio
FROM ranked_data
order by COMPANY_INDUSTRY_NAME