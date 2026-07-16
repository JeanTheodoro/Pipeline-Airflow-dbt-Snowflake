INSERT INTO avaliacoes_clientes
(
    id_clientes,
    id_concessionarias,
    nota_atendimento,
    nota_veiculo,
    nota_processo_compra,
    comentario,
    sentimento_ia,
    data_avaliacao
)
SELECT

-- 🔥 cliente real
c.id_clientes,

-- 🏢 concessionária real
co.id_concessionarias,

-- ⭐ notas realistas
CASE
    WHEN gs % 10 IN (0,1) THEN 2
    WHEN gs % 7 = 0 THEN 3
    ELSE 4 + (gs % 2)
END AS nota_atendimento,

CASE
    WHEN gs % 9 = 0 THEN 3
    ELSE 4 + (gs % 2)
END AS nota_veiculo,

CASE
    WHEN gs % 11 = 0 THEN 3
    ELSE 4
END AS nota_processo_compra,

-- 💬 comentários realistas
CASE
    WHEN gs % 6 = 0 THEN 'Atendimento excelente e rápido'
    WHEN gs % 6 = 1 THEN 'Processo de compra muito tranquilo'
    WHEN gs % 6 = 2 THEN 'Veículo superou expectativas'
    WHEN gs % 6 = 3 THEN 'Demorou mais do que o esperado'
    WHEN gs % 6 = 4 THEN 'Bom atendimento, mas pode melhorar'
    ELSE 'Experiência geral satisfatória'
END AS comentario,

-- 🧠 sentimento IA
CASE
    WHEN gs % 10 IN (0,1) THEN 'negativo'
    WHEN gs % 7 = 0 THEN 'neutro'
    ELSE 'positivo'
END AS sentimento_ia,

-- 📅 período coerente com vendas
DATE '2026-01-05' + (gs % 177)

FROM generate_series(1, 800) gs

-- =========================
-- JOIN seguro com dados reais
-- =========================

JOIN LATERAL (
    SELECT id_clientes
    FROM clientes
    ORDER BY id_clientes
    OFFSET (gs % (SELECT COUNT(*) FROM clientes))
    LIMIT 1
) c ON true

JOIN LATERAL (
    SELECT id_concessionarias
    FROM concessionarias
    ORDER BY id_concessionarias
    OFFSET (gs % (SELECT COUNT(*) FROM concessionarias))
    LIMIT 1
) co ON true;