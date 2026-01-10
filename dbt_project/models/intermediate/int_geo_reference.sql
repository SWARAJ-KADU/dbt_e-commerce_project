select
    zip_code_prefix,
    city,
    state,
    latitude,
    longitude
from {{ ref('stg_geolocation') }}