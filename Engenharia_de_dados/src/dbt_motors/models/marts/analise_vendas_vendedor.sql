{{ config(materialized='table') }}

SELECT

    ven.vendedor_id,

    ven.nome_vendedor,

    c.nome_concessionaria,

    COUNT(v.venda_id) AS quantidade_vendas,

    ROUND(SUM(v.valor_venda),2) AS faturamento_total,

    ROUND(AVG(v.valor_venda),2) AS ticket_medio,

    ROUND(SUM(v.desconto),2) AS desconto_total,

    ROUND(AVG(v.desconto),2) AS desconto_medio,

    COUNT(
        CASE
            WHEN v.financiamento THEN 1
        END
    ) AS vendas_financiadas

FROM {{ ref('fct_vendas') }} v

LEFT JOIN {{ ref('dim_vendedores') }} ven
    ON v.vendedor_id = ven.vendedor_id

LEFT JOIN {{ ref('dim_concessionarias') }} c
    ON ven.concessionaria_id = c.concessionaria_id

GROUP BY

    ven.vendedor_id,

    ven.nome_vendedor,

    c.nome_concessionaria

ORDER BY faturamento_total DESC
