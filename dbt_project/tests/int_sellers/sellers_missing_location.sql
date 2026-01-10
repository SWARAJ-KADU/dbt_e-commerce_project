select *
from {{ ref('int_sellers') }}
where city is null
   or state is null
