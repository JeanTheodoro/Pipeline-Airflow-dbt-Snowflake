{{ config(materialized='view') }}

WITH source AS (

    SELECT
        id_clientes,
        INITCAP(cliente) AS nome_cliente,
        cpf,
        LOWER(email) AS email,
        telefone,
        INITCAP(cidade) AS cidade,
        UPPER(estado) AS estado,
        renda_estimada,
        data_nascimento,
        data_cadastro,
        load_date,
        source_system

    FROM {{ source('raw', 'clientes') }}

)

SELECT
    id_clientes,
    nome_cliente,
    cpf,
    email,
    telefone,
    cidade,
    estado,
    renda_estimada,
    data_nascimento,
    data_cadastro,
    load_date,
    source_system

FROM source
