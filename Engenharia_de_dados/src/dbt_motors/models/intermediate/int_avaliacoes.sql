{{ config(materialized='view') }}

select

    a.id_avaliacao,
    a.id_clientes,
    c.nome_cliente as cliente,

    a.id_concessionarias,
    co.nome_concessionaria as concessionaria,

    a.nota_atendimento,
    a.nota_veiculo,
    a.nota_processo_compra,
    a.sentimento_ia,
    a.data_avaliacao

from {{ ref('stg_avaliacoes_clientes') }} a

left join {{ ref('stg_clientes') }} c
    on a.id_clientes = c.id_clientes

left join {{ ref('stg_concessionarias') }} co
    on a.id_concessionarias = co.id_concessionarias