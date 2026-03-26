{{ config(
    materialized = 'table',
    schema = 'dw_ecoessentials'
    )
}}

with first as 
(
    SELECT DISTINCT campaign_id as id, discount
    from {{ source('eco_transactional_landing', 'order_line') }}
)
SELECT DISTINCT
{{ dbt_utils.generate_surrogate_key(['campaignid', 'campaignname']) }} as campaign_key,
campaignid as campaign_id,
campaignname as campaign_name,
discount as campaign_discount
FROM first f
INNER JOIN {{ source('eco_marketing_landing', 'marketingemails')}} m ON f.id = m.campaignid