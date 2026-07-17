{{ config(materialized='table') }}

select

    id_veiculos as veiculo_id,
    fabricante,
    nome_veiculo,
    tipo,
    ano_modelo,
    combustivel,
    cambio,
    cor,
    valor,
    ativo,
    id_concessionarias as concessionaria_id

from {{ ref('stg_veiculos') }}
