{{ config(materialized='table') }}

select distinct

    data_venda as data,

    year(data_venda) as ano,

    month(data_venda) as mes,

    day(data_venda) as dia,

    quarter(data_venda) as trimestre,

    monthname(data_venda) as nome_mes,

    dayname(data_venda) as dia_semana

from {{ ref('stg_vendas') }}

