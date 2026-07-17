{{ config(materialized='table') }}

select

    id_concessionarias as concessionaria_id,
    nome_concessionaria,
    endereco,
    telefone,
    email,
    id_cidades as cidade_id

from {{ ref('stg_concessionarias') }}
