{{ config(materialized='view') }}

WITH source AS (

    SELECT
        id_cidades,
        INITCAP(cidade) AS nome_cidade,
        id_estados,
        load_date,
        source_system

    FROM {{ source('raw', 'cidades') }}

)

SELECT
    id_cidades,
    nome_cidade,
    id_estados,
    load_date,
    source_system

FROM source
