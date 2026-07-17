{{ config(materialized='table') }}
SELECT
    id_cidades AS cidade_id,
    nome_cidade,
    id_estados AS estado_id,
    load_date,
    source_system
FROM {{ ref('stg_cidades') }}
