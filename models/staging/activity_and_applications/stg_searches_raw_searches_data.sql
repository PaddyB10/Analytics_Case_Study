select *
from {{ source('searches', 'searches_data') }}