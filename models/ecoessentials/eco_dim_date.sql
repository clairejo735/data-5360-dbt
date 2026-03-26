{{ config(
    materialized = 'table',
    schema = 'dw_ecoessentials'
    )
}}

with cte_date as (
{{ dbt_date.get_date_dimension("1990-01-01", "2050-12-31") }}
)

SELECT
{{ dbt_utils.generate_surrogate_key(['date_day']) }} as date_key,
date_day as Date,
month_of_year as Month,
day_of_month as Day,
year_number as Year,
quarter_of_year as Quarter
from cte_date