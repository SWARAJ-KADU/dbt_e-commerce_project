{% macro surrogate_key(cols) %}
    {{ dbt_utils.generate_surrogate_key(cols) }}
{% endmacro %}
