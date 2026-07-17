{{ config(materialized='table') }}

SELECT

    DATE_TRUNC('month', data_venda) AS competencia,

    YEAR(data_venda) AS ano,

    MONTH(data_venda) AS mes,

    MONTHNAME(data_venda) AS nome_mes,

    QUARTER(data_venda) AS trimestre,

    COUNT(venda_id) AS quantidade_vendas,

    COUNT(DISTINCT cliente_id) AS clientes,

    COUNT(DISTINCT vendedor_id) AS vendedores,

    ROUND(SUM(valor_venda),2) AS faturamento_total,

    ROUND(AVG(valor_venda),2) AS ticket_medio,

    ROUND(AVG(desconto),2) AS desconto_medio,

    COUNT(
        CASE
            WHEN financiamento THEN 1
        END
    ) AS vendas_financiadas

FROM {{ ref('fct_vendas') }}

GROUP BY

    DATE_TRUNC('month', data_venda),

    YEAR(data_venda),

    MONTH(data_venda),

    MONTHNAME(data_venda),

    QUARTER(data_venda)

ORDER BY competencia
