{{ config(
    materialized = 'table',
    schema = 'dw_ecoessentials'
) }}

SELECT
    p.product_key,
    d.date_key,
    c.campaign_key,
    cu.customer_key,
    ol.quantity,
    ol.discount,
    round(ol.price_after_discount/(1-ol.discount), 2) as price,
    ol.price_after_discount
FROM {{ source('eco_transactional_landing', 'order_line') }} ol
INNER JOIN {{ source('eco_transactional_landing', 'orders') }} o ON o.order_id = ol.order_id
INNER JOIN {{ ref('eco_dim_product') }} p ON p.product_id = ol.product_id
LEFT JOIN {{ ref('eco_dim_campaign') }} c ON c.campaign_id = ol.campaign_id
INNER JOIN {{ ref('eco_dim_customer') }} cu ON cu.customer_id = o.customer_id
INNER JOIN {{ ref('eco_dim_date') }} d ON d.date = o.order_timestamp::date