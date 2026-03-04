{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
) }}

SELECT
    c.customer_key,
    d.date_key,
    e.employee_key,
    p.product_key,
    s.store_key,
    ol.quantity,
    ol.quantity*ol.unit_price as dollars_sold,
    ol.unit_price
FROM {{ source('oliver_landing', 'orders') }} o
INNER JOIN {{ source('oliver_landing', 'orderline')}} ol ON o.order_id = ol.order_id
INNER JOIN {{ ref('oliver_dim_product') }} p ON ol.product_id = p.product_key
INNER JOIN {{ ref('oliver_dim_customer') }} c ON c.customer_key = o.customer_id
INNER JOIN {{ ref('oliver_dim_store') }} s ON s.store_key = o.store_id
INNER JOIN {{ ref('oliver_dim_employee') }} e ON e.employee_key = o.employee_id
INNER JOIN {{ ref('oliver_dim_date') }} d ON d.date_key = o.order_date
