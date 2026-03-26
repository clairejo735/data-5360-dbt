{{ config(
    materialized = 'table',
    schema = 'dw_ecoessentials'
    )
}}

SELECT
{{ dbt_utils.generate_surrogate_key(['eventtimestamp::time', 'emaileventid']) }} as timestamp_key,
eventtimestamp::time as event_time,
date_part('hour', eventtimestamp) as hour,
date_part('minute', eventtimestamp) as minute,
date_part('second', eventtimestamp) as second
FROM {{ source('eco_marketing_landing', 'marketingemails') }}