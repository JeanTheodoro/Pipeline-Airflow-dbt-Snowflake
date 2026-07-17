{{ config(materialized='table') }}

SELECT

    vei.veiculo_id,

    vei.nome_veiculo,

    vei.fabricante,

    vei.tipo,

    vei.ano_modelo,

    vei.valor,

    COUNT(v.venda_id) AS quantidade_vendas,

    ROUND(SUM(v.valor_venda),2) AS faturamento_total,

    ROUND(AVG(v.valor_venda),2) AS ticket_medio,

    ROUND(AVG(v.desconto),2) AS desconto_medio,

    ROUND(
        AVG(v.valor_venda) - vei.valor,
    2) AS diferenca_media,

    ROUND(
        (
            AVG(v.valor_venda) /
            NULLIF(vei.valor,0)
        ) * 100,
    2) AS percentual_preco

FROM {{ ref('fct_vendas') }} v

LEFT JOIN {{ ref('dim_veiculos') }} vei
    ON v.veiculo_id = vei.veiculo_id

GROUP BY

    vei.veiculo_id,

    vei.nome_veiculo,

    vei.fabricante,

    vei.tipo,

    vei.ano_modelo,

    vei.valor

ORDER BY quantidade_vendas DESC
