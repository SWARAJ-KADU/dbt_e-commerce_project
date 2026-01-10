select distinct
    zip_code_prefix,
    city,
    state,
    latitude,
    longitude
from {{ ref('int_geo_reference') }}
