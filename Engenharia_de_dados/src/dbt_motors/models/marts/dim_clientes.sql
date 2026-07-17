{{ config(materialized='table') }}

select

    id_clientes as cliente_id,
    nome_cliente,
    cpf,
    email,
    telefone,
    cidade,
    estado,
    renda_estimada,
    faixa_renda,
    idade

from {{ ref('int_clientes') }}
