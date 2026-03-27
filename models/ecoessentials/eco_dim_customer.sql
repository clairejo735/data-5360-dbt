{{ config(
    materialized = 'table',
    schema = 'dw_ecoessentials'
    )
}}

WITH prep as 
(
    SELECT DISTINCT c.customer_id,
    c.customer_first_name,
    c.customer_last_name,
    m.subscriberfirstname,
    m.subscriberlastname,

    c.customer_phone,
    c.customer_address,
    c.customer_city,
    c.customer_state,
    c.customer_zip,
    c.customer_country,

    c.customer_email,
    m.subscriberemail,

    m.subscriberid
    FROM {{ source('eco_transactional_landing', 'customer') }} c
    FULL OUTER JOIN {{ source('eco_marketing_landing', 'marketingemails')}} m ON c.customer_id = NULLIF(m.customerid, 'NULL')
),
prep2 as (
SELECT customer_id,
    CASE
        WHEN customer_id is null then subscriberfirstname
        else customer_first_name end as customer_firstname,
    CASE
        WHEN customer_id is null then subscriberlastname
        else customer_last_name end as customer_lastname,
    customer_phone, customer_address, customer_city, customer_state, customer_zip, customer_country,
    CASE
        WHEN customer_id is null then subscriberemail
        else customer_email end as customer_emailaddress,
    subscriberid
FROM prep
)
SELECT {{ dbt_utils.generate_surrogate_key(["TO_VARCHAR(customer_firstname)","TO_VARCHAR(customer_lastname)"]) }} AS customer_key, *
    --{{ dbt_utils.generate_surrogate_key(["customer_firstname", 'customer_lastname']) }} AS customer_key, *
FROM prep2

