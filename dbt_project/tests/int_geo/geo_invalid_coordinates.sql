select *
from {{ ref('int_geo_reference') }}
where latitude not between -90 and 90
   or longitude not between -180 and 180
