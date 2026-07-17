{{ config(materialized='view') }}

WITH source AS (

    SELECT
        id_vendas,
        id_veiculos,
        id_concessionarias,
        id_vendedores,
        id_clientes,

        valor_pago::DECIMAL(12,2) AS valor_venda,

        desconto,
        forma_pagamento,
        financiamento,
        parcelas,

        data_venda,

        load_date,
        source_system

    FROM {{ source('raw', 'vendas') }}

)

SELECT
    id_vendas,
    id_veiculos,
    id_concessionarias,
    id_vendedores,
    id_clientes,
    valor_venda,
    desconto,
    forma_pagamento,
    financiamento,
    parcelas,
    data_venda,
    load_date,
    source_system

FROM source
