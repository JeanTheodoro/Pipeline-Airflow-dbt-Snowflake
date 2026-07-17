{{ config(
    materialized='incremental',
    unique_key='venda_id'
) }}

with source_data as (
    select
        id_vendas              as venda_id,
        id_veiculos            as veiculo_id,
        id_concessionarias     as concessionaria_id,
        id_vendedores          as vendedor_id,
        id_clientes            as cliente_id,
        valor_venda,
        desconto,
        forma_pagamento,
        financiamento,
        parcelas,
        data_venda,
        load_date,
        source_system
    from {{ ref('stg_vendas') }}
    
    {% if is_incremental() %}
    where load_date > (
        select coalesce(max(load_date), '1900-01-01')
        from {{ this }}
    )
    {% endif %}
)

select * 
from source_data
-- O QUALIFY garante que apenas a linha mais recente de cada venda vá para o MERGE
qualify row_number() over (
    partition by venda_id 
    order by load_date desc
) = 1
