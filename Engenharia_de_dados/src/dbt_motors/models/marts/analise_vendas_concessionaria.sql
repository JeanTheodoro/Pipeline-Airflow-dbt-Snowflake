{{ config(materialized='table') }}

SELECT

    con.concessionaria_id,

    con.nome_concessionaria,

    cid.nome_cidade,

    est.nome_estado,

    COUNT(v.venda_id) AS quantidade_vendas,

    COUNT(DISTINCT v.cliente_id) AS clientes,

    COUNT(DISTINCT v.vendedor_id) AS vendedores,

    COUNT(DISTINCT v.veiculo_id) AS modelos_vendidos,

    ROUND(SUM(v.valor_venda),2) AS faturamento_total,

    ROUND(AVG(v.valor_venda),2) AS ticket_medio,

    ROUND(AVG(v.desconto),2) AS desconto_medio,

    COUNT(
        CASE
            WHEN v.financiamento THEN 1
        END
    ) AS vendas_financiadas

FROM {{ ref('fct_vendas') }} v

LEFT JOIN {{ ref('dim_concessionarias') }} con
    ON v.concessionaria_id = con.concessionaria_id

LEFT JOIN {{ ref('dim_cidades') }} cid
    ON con.cidade_id = cid.cidade_id

LEFT JOIN {{ ref('dim_estados') }} est
    ON cid.estado_id = est.estado_id

GROUP BY

    con.concessionaria_id,

    con.nome_concessionaria,

    cid.nome_cidade,

    est.nome_estado

ORDER BY faturamento_total DESC
