{{ config(materialized='view') }}

WITH source AS (

    SELECT
        id_vendedores,
        INITCAP(nome) AS nome_vendedor,
        email,
        telefone,
        data_admissao,
        salario,
        meta_mensal,
        ativo,
        id_concessionarias,
        load_date,
        source_system

    FROM {{ source('raw', 'vendedores') }}

)

SELECT
    id_vendedores,
    nome_vendedor,
    email,
    telefone,
    data_admissao,
    salario,
    meta_mensal,
    ativo,
    id_concessionarias,
    load_date,
    source_system

FROM source
