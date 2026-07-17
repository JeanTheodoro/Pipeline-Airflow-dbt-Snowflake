# Tupã Motors — Projeto de Engenharia de Dados 🏍️

Pipeline completo de dados para um projeto com fins educativo para um concessionaria Fictícia
 **Tupã Motors**, cobrindo desde a extração dos dados operacionais até a disponibilização de modelos analíticos prontos para consumo. O projeto é composto por três repositórios que trabalham em conjunto.

---

## 🗂️ Repositórios do Projeto

| Repositório | Descrição | README |
|---|---|---|
| `tupa-motors-airflow` | Orquestração com Apache Airflow via Astro CLI | [README Airflow](./Engenharia_de_dados/airflow/README.md) |
| `tupa-motors-dbt` | Transformações dbt — camadas BRONZE, SILVER e GOLD | [README dbt](./Engenharia_de_dados/src/README.md) |
| `tupa-motors-src` | Scripts SQL, configurações e dados de origem | — |

---

## 🏗️ Arquitetura Geral

O pipeline segue a arquitetura **ELT** (Extract → Load → Transform):

```
PostgreSQL (Supabase)
        │
        │  Extração via Airflow
        ▼
Snowflake · camada RAW        ← dados brutos sem transformação
        │
        │  Transformações via dbt
        ▼
Snowflake · BRONZE            ← limpeza e padronização
        │
        ▼
Snowflake · SILVER            ← regras de negócio e enriquecimento
        │
        ▼
Snowflake · GOLD              ← modelos analíticos e agregações
```

A orquestração é feita pelo **Airflow**, que executa sequencialmente a DAG de extração/carga e, ao seu término, aciona a DAG de transformações dbt.

---

## 🗄️ Modelo Relacional

O banco de dados operacional roda no **PostgreSQL (Supabase)** e é composto por 8 tabelas que modelam o domínio de vendas de veículos da Tupã Motors.

### Tabelas

| Tabela | Descrição |
|---|---|
| `estados` | Estados brasileiros |
| `cidades` | Cidades vinculadas a um estado |
| `concessionarias` | Unidades físicas da rede de concessionárias |
| `vendedores` | Equipe de vendas de cada concessionária |
| `clientes` | Cadastro de clientes |
| `veiculos` | Catálogo de veículos disponíveis |
| `vendas` | Registro de cada venda realizada |
| `avaliacoes_clientes` | Avaliações de atendimento e experiência de compra |

### Scripts SQL

Os scripts de criação das tabelas ficam na pasta `scripts/` do repositório principal:

```
scripts/
├── postgres/     # DDL para o PostgreSQL / Supabase (fonte de dados)
└── snowflake/    # DDL para criação das tabelas RAW no Snowflake
```

---

## 🔄 Fluxo Completo do Projeto

```
┌─────────────────────────────────────────────────────────┐
│  PostgreSQL / Supabase                                  │
│  estados · cidades · concessionarias · vendedores       │
│  clientes · veiculos · vendas · avaliacoes_clientes     │
└────────────────────┬────────────────────────────────────┘
                     │
              Airflow · DAG EL
         pipeline_el_tupa_motors
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│  Snowflake · RAW                                        │
│  Cópia fiel das tabelas de origem                       │
└────────────────────┬────────────────────────────────────┘
                     │
             Airflow · DAG dbt
        pipeline_dbt_tupa_motors
                     │
          ┌──────────┼──────────┐
          ▼          ▼          ▼
       BRONZE     SILVER      GOLD
    Limpeza e   Regras de  Modelos
    padroni-    negócio    analíticos
    zação
```

---

## 🚀 Como Rodar o Projeto

### 1. Prepare o banco de origem

Execute os scripts SQL da pasta `scripts/postgres/` no seu Supabase para criar e popular as tabelas operacionais.

### 2. Prepare o Snowflake

Execute os scripts da pasta `scripts/snowflake/` para criar o banco, schemas (RAW, BRONZE, SILVER, GOLD) e as tabelas de destino.

### 3. Suba o Airflow

Siga as instruções do [README Airflow](./airflow/README.md):

```bash
astro dev start
```

Configure as conexões `tupa_motors_postgres` e `tupa_motors_snowflake_wh` no painel `Admin > Connections`.

### 4. Execute as DAGs

Acesse [http://localhost:8080](http://localhost:8080) e dispare a DAG `pipeline_el_tupa_motors`. Ao finalizar, ela acionará automaticamente a `pipeline_dbt_tupa_motors`.

### 5. Verifique as transformações dbt

Para detalhes sobre os modelos e camadas, consulte o [README dbt](./dbt/README.md).

---

## 🧰 Tecnologias

| Camada | Tecnologia |
|---|---|
| Banco de origem | PostgreSQL via Supabase |
| Orquestração | Apache Airflow + Astro CLI |
| Data Warehouse | Snowflake |
| Transformações | dbt Core |
| Containerização | Docker |
 **Tupã Motors**, cobrindo desde a extração dos dados operacionais até a disponibilização de modelos analíticos prontos para consumo. O projeto é composto por três repositórios que trabalham em conjunto.

---

## 🗂️ Repositórios do Projeto

| Repositório | Descrição | README |
|---|---|---|
| `tupa-motors-airflow` | Orquestração com Apache Airflow via Astro CLI | [README Airflow](./airflow/README.md) |
| `tupa-motors-dbt` | Transformações dbt — camadas BRONZE, SILVER e GOLD | [README dbt](./dbt/README.md) |
| `tupa-motors-src` | Scripts SQL, configurações e dados de origem | — |

---

## 🏗️ Arquitetura Geral

O pipeline segue a arquitetura **ELT** (Extract → Load → Transform):

```
PostgreSQL (Supabase)
        │
        │  Extração via Airflow
        ▼
Snowflake · camada RAW        ← dados brutos sem transformação
        │
        │  Transformações via dbt
        ▼
Snowflake · BRONZE            ← limpeza e padronização
        │
        ▼
Snowflake · SILVER            ← regras de negócio e enriquecimento
        │
        ▼
Snowflake · GOLD              ← modelos analíticos e agregações
```

A orquestração é feita pelo **Airflow**, que executa sequencialmente a DAG de extração/carga e, ao seu término, aciona a DAG de transformações dbt.

---

## 🗄️ Modelo Relacional

O banco de dados operacional roda no **PostgreSQL (Supabase)** e é composto por 8 tabelas que modelam o domínio de vendas de veículos da Tupã Motors.

### Tabelas

| Tabela | Descrição |
|---|---|
| `estados` | Estados brasileiros |
| `cidades` | Cidades vinculadas a um estado |
| `concessionarias` | Unidades físicas da rede de concessionárias |
| `vendedores` | Equipe de vendas de cada concessionária |
| `clientes` | Cadastro de clientes |
| `veiculos` | Catálogo de veículos disponíveis |
| `vendas` | Registro de cada venda realizada |
| `avaliacoes_clientes` | Avaliações de atendimento e experiência de compra |

### Scripts SQL

Os scripts de criação das tabelas ficam na pasta `scripts/` do repositório principal:

```
scripts/
├── postgres/     # DDL para o PostgreSQL / Supabase (fonte de dados)
└── snowflake/    # DDL para criação das tabelas RAW no Snowflake
```

---

## 🔄 Fluxo Completo do Projeto

```
┌─────────────────────────────────────────────────────────┐
│  PostgreSQL / Supabase                                  │
│  estados · cidades · concessionarias · vendedores       │
│  clientes · veiculos · vendas · avaliacoes_clientes     │
└────────────────────┬────────────────────────────────────┘
                     │
              Airflow · DAG EL
         pipeline_el_tupa_motors
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│  Snowflake · RAW                                        │
│  Cópia fiel das tabelas de origem                       │
└────────────────────┬────────────────────────────────────┘
                     │
             Airflow · DAG dbt
        pipeline_dbt_tupa_motors
                     │
          ┌──────────┼──────────┐
          ▼          ▼          ▼
       BRONZE     SILVER      GOLD
    Limpeza e   Regras de  Modelos
    padroni-    negócio    analíticos
    zação
```

---

## 🚀 Como Rodar o Projeto

### 1. Prepare o banco de origem

Execute os scripts SQL da pasta `scripts/postgres/` no seu Supabase para criar e popular as tabelas operacionais.

### 2. Prepare o Snowflake

Execute os scripts da pasta `scripts/snowflake/` para criar o banco, schemas (RAW, BRONZE, SILVER, GOLD) e as tabelas de destino.

### 3. Suba o Airflow

Siga as instruções do [README Airflow](./airflow/README.md):

```bash
astro dev start
```

Configure as conexões `tupa_motors_postgres` e `tupa_motors_snowflake_wh` no painel `Admin > Connections`.

### 4. Execute as DAGs

Acesse [http://localhost:8080](http://localhost:8080) e dispare a DAG `pipeline_el_tupa_motors`. Ao finalizar, ela acionará automaticamente a `pipeline_dbt_tupa_motors`.

### 5. Verifique as transformações dbt

Para detalhes sobre os modelos e camadas, consulte o [README dbt](./dbt/README.md).

---

## 🧰 Tecnologias

| Camada | Tecnologia |
|---|---|
| Banco de origem | PostgreSQL via Supabase |
| Orquestração | Apache Airflow + Astro CLI |
| Data Warehouse | Snowflake |
| Transformações | dbt Core |
| Containerização | Docker |
