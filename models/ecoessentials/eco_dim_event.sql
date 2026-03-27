{{ config(
    materialized = 'table',
    schema = 'dw_ecoessentials'
    )
}}

SELECT DISTINCT
{{ dbt_utils.generate_surrogate_key(['eventtype']) }} as emailevent_key,
eventtype
FROM {{ source('eco_marketing_landing', 'marketingemails') }}