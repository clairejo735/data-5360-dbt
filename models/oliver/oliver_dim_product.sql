{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
    )
}}

SELECT
product_id as product_key,
product_id,
product_name,
description
FROM {{ source('oliver_landing', 'product') }}