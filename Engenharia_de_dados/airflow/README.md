# Tupa Motors — Airflow Pipeline 🏍️

Projeto de orquestração de dados com [Apache Airflow](https://airflow.apache.org/) via [Astro CLI](https://docs.astronomer.io/astro/cli/overview), responsável por extrair dados do PostgreSQL, carregá-los na camada **RAW** do Snowflake e acionar as transformações dbt nas camadas **BRONZE**, **SILVER** e **GOLD**.

---

## 📁 Estrutura do Projeto

```
.
├── .astro/                      # Configurações do Astro CLI
├── dags/                        # DAGs do Airflow
│   ├── pipeline_el_tupa_motors  # DAG de extração e carga (EL)
│   └── pipeline_dbt_tupa_motors # DAG de transformações dbt
├── include/                     # Arquivos auxiliares (SQL, configs)
├── logs/                        # Logs de execução
├── plugins/                     # Plugins customizados do Airflow
├── tests/                       # Testes das DAGs
├── docker-compose.override.yml  # Override do Docker Compose
├── Dockerfile                   # Imagem customizada do Airflow
├── packages.txt                 # Pacotes do SO
└── requirements.txt             # Dependências Python
```

---

## ⚙️ Pré-requisitos

- [Docker](https://docs.docker.com/get-docker/) e [Docker Compose](https://docs.docker.com/compose/)
- [Astro CLI](https://docs.astronomer.io/astro/cli/install-cli)
- Python 3.12+ (para execução local com venv)

### Instalar o Astro CLI

```bash
# macOS (Homebrew)
brew install astro

# Linux
curl -sSL install.astronomer.io | sudo bash -s

# Windows (via winget)
winget install -e --id Astronomer.AstroCLI
```

---

## 🐍 Ambiente Virtual Python (venv / uv)

O ambiente virtual é necessário para rodar scripts locais, testes e o dbt fora do Docker.

### Com `venv` (padrão)

```bash
# Criar
python -m venv .venv

# Ativar — Linux/macOS
source .venv/bin/activate

# Ativar — Windows (PowerShell)
.venv\Scripts\Activate.ps1

# Instalar dependências
pip install --upgrade pip
pip install -r requirements.txt
```

### Com `uv` (mais rápido ⚡)

```bash
# Instalar o uv (se ainda não tiver)
pip install uv

# Criar e ativar o ambiente
uv venv .venv
source .venv/bin/activate   # Linux/macOS
.venv\Scripts\Activate.ps1  # Windows

# Instalar dependências
uv pip install -r requirements.txt
```

---

## 🚀 Subindo o Airflow com Astro CLI

### 1. Configure as variáveis de ambiente

```bash
cp .env.example .env
```

Edite o `.env` com suas credenciais (conexões do PostgreSQL, Snowflake, etc.).

### 2. Inicie o ambiente

```bash
astro dev start
```

O Astro CLI irá fazer o build da imagem e subir todos os serviços (Scheduler, Webserver, Triggerer, PostgreSQL de metadados).

### 3. Acesse o Airflow

Quando os serviços estiverem **up**, acesse:

🌐 **[http://localhost:8080](http://localhost:8080)**

> Credenciais padrão: `admin` / `admin`

### Outros comandos úteis

```bash
astro dev stop        # Para os serviços
astro dev restart     # Reinicia
astro dev logs        # Exibe logs em tempo real
astro dev ps          # Status dos containers
```

---

## 🔄 Pipeline de Dados

### DAG 1 — Extração e Carga (EL)

🔗 **[pipeline_el_tupa_motors](http://localhost:8080/dags/pipeline_el_tupa_motors)**

Responsável por:
- Conectar ao **PostgreSQL** de origem
- Extrair os dados das tabelas configuradas
- Carregar na camada **RAW** do Snowflake

Ao finalizar com sucesso, aciona automaticamente a DAG de transformação.

---

### DAG 2 — Transformações dbt

🔗 **[pipeline_dbt_tupa_motors](http://localhost:8080/dags/pipeline_dbt_tupa_motors)**

Responsável por executar as transformações dbt em sequência:

| Camada | Descrição |
|---|---|
| **BRONZE** | Limpeza e padronização dos dados brutos |
| **SILVER** | Regras de negócio e enriquecimento |
| **GOLD** | Modelos analíticos e agregações finais |

---

## 🗺️ Fluxo da Pipeline

```
PostgreSQL  ──▶  [pipeline_el_tupa_motors]  ──▶  Snowflake RAW
                                                        │
                                                        ▼
                                         [pipeline_dbt_tupa_motors]
                                                        │
                                         ┌──────────────┼──────────────┐
                                         ▼              ▼              ▼
                                       BRONZE        SILVER          GOLD
```

---

## 🔌 Conexões do Airflow

Com o ambiente no ar, é necessário cadastrar **duas conexões** no painel administrativo antes de executar as DAGs.

Acesse: **Admin > Connections** → botão **+** para adicionar cada uma.

### 1. `tupa_motors_postgres`

Conexão com o banco de dados PostgreSQL de origem.

| Campo | Valor |
|---|---|
| Connection Id | `tupa_motors_postgres` |
| Connection Type | `Postgres` |
| Host | endereço do servidor PostgreSQL |
| Database | nome do banco de dados |
| Login | usuário |
| Password | senha |
| Port | `5432` |

### 2. `tupa_motors_snowflake_wh`

Conexão com o Snowflake para carga e transformações.

| Campo | Valor |
|---|---|
| Connection Id | `tupa_motors_snowflake_wh` |
| Connection Type | `Snowflake` |
| Account | identificador da conta (ex: `xy12345.us-east-1`) |
| Warehouse | nome do virtual warehouse |
| Database | banco de dados alvo |
| Schema | schema alvo |
| Login | usuário |
| Password | senha |
| Role | role utilizada (ex: `TRANSFORMER`) |

> ⚠️ Os IDs das conexões devem ser exatamente `tupa_motors_postgres` e `tupa_motors_snowflake_wh` — as DAGs os referenciam diretamente por esse nome.

---

## 📦 Compartilhamento do Projeto dbt

O projeto `dbt_motors` é compartilhado com os containers do Airflow via **volume Docker**, configurado no `docker-compose.override.yml`. Isso permite que as DAGs executem os comandos dbt diretamente sobre os arquivos do repositório, sem necessidade de rebuild da imagem a cada alteração.

```yaml
services:
  scheduler:
    volumes:
      - ./dags:/usr/local/airflow/dags
      - ../src/dbt_motors:/dbt       # projeto dbt montado em /dbt
    env_file:
      - ../src/.env

  api-server:
    volumes:
      - ./dags:/usr/local/airflow/dags
      - ../src/dbt_motors:/dbt       # disponível também no api-server
```

O diretório `../src/dbt_motors` do seu sistema de arquivos local é montado em `/dbt` dentro dos containers `scheduler` e `api-server`. As DAGs referenciam esse caminho para executar os comandos dbt (`dbt run`, `dbt test`, etc.).

> ⚠️ **Estrutura de pastas esperada:** o repositório do Airflow e o projeto dbt devem estar lado a lado dentro de um diretório `src/`, conforme abaixo:
>
> ```
> /
> ├── airflow/          # este repositório
> │   ├── dags/
> │   ├── docker-compose.override.yml
> │   └── ...
> └── src/
>     ├── dbt_motors/   # projeto dbt
>     └── .env
> ```
>
> Se a estrutura de diretórios for diferente, ajuste o caminho `../src/dbt_motors` no `docker-compose.override.yml` para refletir a localização correta do projeto dbt.

---

## 📝 Dicas Rápidas

| Ação | Comando |
|---|---|
| Subir o ambiente | `astro dev start` |
| Parar o ambiente | `astro dev stop` |
| Ver logs | `astro dev logs` |
| Reiniciar | `astro dev restart` |
| Rodar testes das DAGs | `astro dev pytest` |
| Acessar o Airflow | [http://localhost:8080](http://localhost:8080) |
