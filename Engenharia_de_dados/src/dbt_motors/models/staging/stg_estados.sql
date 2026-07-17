{{ config(materialized='view') }}

WITH source AS (

    SELECT
        id_estados,
        INITCAP(estado) AS nome_estado,
        load_date,
        source_system

    FROM {{ source('raw', 'estados') }}

)

SELECT
    id_estados,
    nome_estado,
    load_date,
    source_system

FROM source
