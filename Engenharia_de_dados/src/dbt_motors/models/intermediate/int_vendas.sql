{{ config(materialized='view') }}

select

    v.id_vendas,
    v.data_venda,
    v.valor_venda,
    v.desconto,
    v.forma_pagamento,

    c.nome_cliente              as cliente,
    co.nome_concessionaria            as concessionaria,
    vd.nome_vendedor             as vendedor,

    ve.fabricante,
    ve.nome_veiculo             as veiculo,
    ve.ano_modelo

from {{ ref('stg_vendas') }} v

left join {{ ref('stg_clientes') }} c
    on v.id_clientes = c.id_clientes

left join {{ ref('stg_concessionarias') }} co
    on v.id_concessionarias = co.id_concessionarias

left join {{ ref('stg_vendedores') }} vd
    on v.id_vendedores = vd.id_vendedores

left join {{ ref('stg_veiculos') }} ve
    on v.id_veiculos = ve.id_veiculos
