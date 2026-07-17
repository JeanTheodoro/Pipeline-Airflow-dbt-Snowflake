{{ config(materialized='view') }}

WITH source AS (

    SELECT
        id_concessionarias,
        TRIM(concessionaria) AS nome_concessionaria,
        endereco,
        telefone,
        email,
        id_cidades,
        load_date,
        source_system

    FROM {{ source('raw', 'concessionarias') }}

)

SELECT
    id_concessionarias,
    nome_concessionaria,
    endereco,
    telefone,
    email,
    id_cidades,
    load_date,
    source_system

FROM source
