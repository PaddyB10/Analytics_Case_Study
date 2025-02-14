select 
apply_id,
posting_id,
application,
created_at,
tracking_token

from {{ source('applications', 'applications_data') }}
