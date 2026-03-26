{{ config(
    materialized = 'table',
    schema = 'dw_ecoessentials'
    )
}}

SELECT
{{ dbt_utils.generate_surrogate_key(['emailId', 'emailname']) }} as email_key,
emailID,
emailname
FROM {{ source('eco_marketing_landing', 'marketingemails') }}