{{ config(
    materialized = 'table',
    schema = 'dw_ecoessentials'
    )
}}

SELECT
{{ dbt_utils.generate_surrogate_key(['product_id', 'product_name']) }} as product_key,
product_id,
product_name
FROM {{ source('eco_transactional_landing', 'product') }}