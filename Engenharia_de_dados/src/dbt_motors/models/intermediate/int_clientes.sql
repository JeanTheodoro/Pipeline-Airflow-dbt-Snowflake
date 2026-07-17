{{ config(materialized='view') }}

select

    c.id_clientes,
    c.nome_cliente,
    c.cpf,
    c.email,
    c.telefone,

    c.cidade,
    c.estado,

    c.renda_estimada,

    case
        when c.renda_estimada < 3000 then 'Baixa'
        when c.renda_estimada between 3000 and 8000 then 'Média'
        when c.renda_estimada between 8001 and 15000 then 'Alta'
        else 'Premium'
    end as faixa_renda,

    date_part('year', current_date) - date_part('year', c.data_nascimento) as idade,

    current_timestamp() as data_processamento

from {{ ref('stg_clientes') }} c
