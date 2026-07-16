-- ==========================================================
-- TUPÃ MOTORS
-- Script compatível com Supabase
-- ==========================================================

-- Remove as tabelas caso existam
DROP TABLE IF EXISTS avaliacoes_clientes CASCADE;
DROP TABLE IF EXISTS vendas CASCADE;
DROP TABLE IF EXISTS vendedores CASCADE;
DROP TABLE IF EXISTS concessionarias CASCADE;
DROP TABLE IF EXISTS veiculos CASCADE;
DROP TABLE IF EXISTS clientes CASCADE;
DROP TABLE IF EXISTS cidades CASCADE;
DROP TABLE IF EXISTS estados CASCADE;

-- ==========================================================
-- ESTADOS
-- ==========================================================

CREATE TABLE estados (
    id_estados BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    estado VARCHAR(100) NOT NULL UNIQUE
);

-- ==========================================================
-- CIDADES
-- ==========================================================

CREATE TABLE cidades (
    id_cidades BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    cidade VARCHAR(150) NOT NULL,
    id_estados BIGINT NOT NULL REFERENCES estados(id_estados)
);

-- ==========================================================
-- CONCESSIONÁRIAS
-- ==========================================================

CREATE TABLE concessionarias (
    id_concessionarias BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    concessionaria VARCHAR(200) NOT NULL,

    endereco VARCHAR(250),

    telefone VARCHAR(20),

    email VARCHAR(150),

    id_cidades BIGINT NOT NULL REFERENCES cidades(id_cidades)
);

-- ==========================================================
-- VENDEDORES
-- ==========================================================

CREATE TABLE vendedores (

    id_vendedores BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    nome VARCHAR(150) NOT NULL,

    email VARCHAR(150),

    telefone VARCHAR(20),

    data_admissao DATE,

    salario NUMERIC(12,2),

    meta_mensal NUMERIC(12,2),

    ativo BOOLEAN DEFAULT TRUE,

    id_concessionarias BIGINT NOT NULL
        REFERENCES concessionarias(id_concessionarias)
);

-- ==========================================================
-- CLIENTES
-- ==========================================================

CREATE TABLE clientes (

    id_clientes BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    cliente VARCHAR(150) NOT NULL,

    cpf VARCHAR(14) UNIQUE,

    email VARCHAR(150),

    telefone VARCHAR(20),

    cidade VARCHAR(120),

    estado VARCHAR(100),

    renda_estimada NUMERIC(12,2),

    data_nascimento DATE,

    data_cadastro TIMESTAMP DEFAULT NOW()
);

-- ==========================================================
-- VEÍCULOS
-- ==========================================================

CREATE TABLE veiculos (

    id_veiculos BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    
    id_concessionarias BIGINT,

    fabricante VARCHAR(100),

    nome VARCHAR(150) NOT NULL,

    tipo VARCHAR(50),

    ano_modelo INT,

    combustivel VARCHAR(30),

    cambio VARCHAR(30),

    cor VARCHAR(40),

    preco_base NUMERIC(12,2),

    ativo BOOLEAN DEFAULT TRUE
);

-- ==========================================================
-- VENDAS
-- ==========================================================

CREATE TABLE vendas (

    id_vendas BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    id_clientes BIGINT NOT NULL
        REFERENCES clientes(id_clientes),

    id_vendedores BIGINT NOT NULL
        REFERENCES vendedores(id_vendedores),

    id_veiculos BIGINT NOT NULL
        REFERENCES veiculos(id_veiculos),

    id_concessionarias BIGINT NOT NULL
        REFERENCES concessionarias(id_concessionarias),

    valor_pago NUMERIC(12,2) NOT NULL,

    desconto NUMERIC(12,2) DEFAULT 0,

    forma_pagamento VARCHAR(50),

    financiamento BOOLEAN DEFAULT FALSE,

    parcelas INT,

    data_venda DATE NOT NULL
);

-- ==========================================================
-- AVALIAÇÕES DOS CLIENTES
-- ==========================================================

CREATE TABLE avaliacoes_clientes (

    id_avaliacao BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    id_clientes BIGINT NOT NULL
        REFERENCES clientes(id_clientes),

    id_concessionarias BIGINT NOT NULL
        REFERENCES concessionarias(id_concessionarias),

    nota_atendimento SMALLINT CHECK (nota_atendimento BETWEEN 1 AND 5),

    nota_veiculo SMALLINT CHECK (nota_veiculo BETWEEN 1 AND 5),

    nota_processo_compra SMALLINT CHECK (nota_processo_compra BETWEEN 1 AND 5),

    comentario TEXT,

    sentimento_ia VARCHAR(30),

    data_avaliacao TIMESTAMP DEFAULT NOW()
);

-- ==========================================================
-- ÍNDICES
-- ==========================================================

CREATE INDEX idx_cidades_estado
ON cidades(id_estados);

CREATE INDEX idx_concessionaria_cidade
ON concessionarias(id_cidades);

CREATE INDEX idx_vendedor_concessionaria
ON vendedores(id_concessionarias);

CREATE INDEX idx_vendas_cliente
ON vendas(id_clientes);

CREATE INDEX idx_vendas_vendedor
ON vendas(id_vendedores);

CREATE INDEX idx_vendas_veiculo
ON vendas(id_veiculos);

CREATE INDEX idx_vendas_data
ON vendas(data_venda);

CREATE INDEX idx_avaliacoes_cliente
ON avaliacoes_clientes(id_clientes);

CREATE INDEX idx_avaliacoes_concessionaria
ON avaliacoes_clientes(id_concessionarias);

CREATE INDEX idx_avaliacoes_sentimento
ON avaliacoes_clientes(sentimento_ia);
