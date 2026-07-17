{{ config(materialized='view') }}

WITH source AS (

    SELECT
        id_avaliacao,
        id_clientes,
        id_concessionarias,
        nota_atendimento,
        nota_veiculo,
        nota_processo_compra,
        comentario,
        sentimento_ia,
        data_avaliacao,
        load_date,
        source_system

    FROM {{ source('raw', 'avaliacoes_clientes') }}

),

tratamento AS (

    SELECT
        id_avaliacao,
        id_clientes,
        id_concessionarias,

        COALESCE(nota_atendimento, 0) AS nota_atendimento,
        COALESCE(nota_veiculo, 0) AS nota_veiculo,
        COALESCE(nota_processo_compra, 0) AS nota_processo_compra,

        TRIM(comentario) AS comentario,

        UPPER(TRIM(sentimento_ia)) AS sentimento_ia,

        CAST(data_avaliacao AS TIMESTAMP) AS data_avaliacao,

        load_date,
        source_system

    FROM source

)

SELECT *
FROM tratamento
