select * from vendas;

INSERT INTO vendas
(
    id_clientes,
    id_vendedores,
    id_veiculos,
    id_concessionarias,
    valor_pago,
    desconto,
    forma_pagamento,
    financiamento,
    parcelas,
    data_venda
)
SELECT

-- 🔥 CLIENTES REAIS
c.id_clientes,

-- 🔥 VENDEDORES REAIS
v.id_vendedores,

-- 🔥 VEÍCULOS REAIS
ve.id_veiculos,

-- 🔥 CONCESSIONÁRIAS REAIS
co.id_concessionarias,

-- 💰 valor realista
(80000 + (gs % 180000)),

-- 🎯 desconto realista
CASE
    WHEN gs % 11 = 0 THEN 8000
    WHEN gs % 7 = 0 THEN 4000
    ELSE 0
END,

-- 💳 forma de pagamento
CASE
    WHEN gs % 3 = 0 THEN 'Financiado'
    WHEN gs % 3 = 1 THEN 'À vista'
    ELSE 'Consórcio'
END,

-- 📊 financiamento
(gs % 3 = 0),

-- 🧾 parcelas
CASE
    WHEN gs % 3 = 0 THEN 36 + (gs % 36)
    ELSE NULL
END,

-- 📅 período correto
DATE '2026-01-05' + (gs % 177)

FROM generate_series(1, 1200) gs

-- =========================
-- JOIN SEGURO COM DADOS REAIS
-- =========================

JOIN LATERAL (
    SELECT id_clientes
    FROM clientes
    ORDER BY id_clientes
    OFFSET (gs % (SELECT COUNT(*) FROM clientes))
    LIMIT 1
) c ON true

JOIN LATERAL (
    SELECT id_vendedores
    FROM vendedores
    ORDER BY id_vendedores
    OFFSET (gs % (SELECT COUNT(*) FROM vendedores))
    LIMIT 1
) v ON true

JOIN LATERAL (
    SELECT id_veiculos
    FROM veiculos
    ORDER BY id_veiculos
    OFFSET (gs % (SELECT COUNT(*) FROM veiculos))
    LIMIT 1
) ve ON true

JOIN LATERAL (
    SELECT id_concessionarias
    FROM concessionarias
    ORDER BY id_concessionarias
    OFFSET (gs % (SELECT COUNT(*) FROM concessionarias))
    LIMIT 1
) co ON true;
