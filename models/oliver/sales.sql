
  {{ config(
    materialized = 'table',
    schema = 'dw_oliver'
    )
}}


SELECT
c.first_name as customer_first_name,
c.last_name as customer_last_name,
e.first_name as employee_first_name,
e.first_name as employee_last_name,
f.date_key,
f.quantity,
f.dollars_sold,
f.unit_price,
f.product_key,
p.product_name
FROM {{ ref('fact_sales') }} f

LEFT JOIN {{ ref('oliver_dim_customer') }} c
    ON f.customer_key = c.customer_key

LEFT JOIN {{ ref('oliver_dim_employee') }} e
    ON f.employee_key = e.employee_key

LEFT JOIN {{ ref('oliver_dim_product') }} p
    ON f.product_key = p.product_key
