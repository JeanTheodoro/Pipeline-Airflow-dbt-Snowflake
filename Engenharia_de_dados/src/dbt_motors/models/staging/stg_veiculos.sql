{{ config(materialized='view') }}

WITH source AS (

    SELECT
        id_veiculos,
        id_concessionarias,
        INITCAP(fabricante) AS fabricante,
        INITCAP(nome) AS nome_veiculo,
        INITCAP(tipo) AS tipo,
        ano_modelo,
        combustivel,
        cambio,
        cor,
        preco_base::DECIMAL(12,2) AS valor,
        ativo,
        load_date,
        source_system

    FROM {{ source('raw', 'veiculos') }}

)

SELECT
    id_veiculos,
    id_concessionarias,
    fabricante,
    nome_veiculo,
    tipo,
    ano_modelo,
    combustivel,
    cambio,
    cor,
    valor,
    ativo,
    load_date,
    source_system

FROM source
