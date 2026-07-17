{{ config(materialized='table') }}

SELECT
    id_estados AS estado_id,
    nome_estado,
    load_date,
    source_system
FROM {{ ref('stg_estados') }}