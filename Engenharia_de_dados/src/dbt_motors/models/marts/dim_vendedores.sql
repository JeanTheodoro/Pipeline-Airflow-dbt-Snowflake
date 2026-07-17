{{ config(materialized='table') }}

select

    id_vendedores as vendedor_id,
    nome_vendedor,
    email,
    telefone,
    salario,
    meta_mensal,
    data_admissao,
    ativo,
    id_concessionarias as concessionaria_id

from {{ ref('stg_vendedores') }}
