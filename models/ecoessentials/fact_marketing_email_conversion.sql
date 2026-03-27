{{ config(
    materialized = 'table',
    schema = 'dw_ecoessentials'
) }}

SELECT DISTINCT
    e.email_key,
    ev.emailevent_key,
    t.timestamp_key,
    d.date_key,
    c.campaign_key,
    COALESCE(cu.customer_key, cu2.customer_key) AS customer_key
FROM {{ source('eco_marketing_landing', 'marketingemails') }} m
INNER JOIN {{ ref('eco_dim_email') }} e ON m.emailid = e.emailid
INNER JOIN {{ ref('eco_dim_event') }} ev ON ev.eventtype = m.eventtype
INNER JOIN {{ ref('eco_dim_timestamp') }} t ON t.timestamp_key = {{ dbt_utils.generate_surrogate_key(['m.eventtimestamp::time', 'm.emaileventid']) }}
INNER JOIN {{ ref('eco_dim_date') }} d ON d.date = m.eventtimestamp::date
INNER JOIN {{ ref('eco_dim_campaign') }} c ON c.campaign_id = m.campaignid
LEFT JOIN {{ ref('eco_dim_customer') }} cu ON cu.customer_id = NULLIF(m.customerid, 'NULL')
LEFT JOIN {{ ref('eco_dim_customer') }} cu2 ON cu2.subscriberid = m.subscriberid