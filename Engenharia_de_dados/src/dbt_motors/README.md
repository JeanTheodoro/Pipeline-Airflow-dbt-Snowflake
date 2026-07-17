# dbt Motors 🚗

Projeto de transformação de dados com [dbt (data build tool)](https://www.getdbt.com/), containerizado via Docker e compatível com ambiente virtual Python.

---

## 📁 Estrutura do Projeto

```
.
├── dbt_motors/          # Projeto dbt (models, seeds, macros, tests, etc.)
├── logs/                # Logs de execução
├── .env                 # Variáveis de ambiente (não versionar)
├── env_example          # Exemplo de variáveis de ambiente
├── .gitignore
├── Dockerfile
└── requirements.txt
```

---

## ⚙️ Pré-requisitos

- [Docker](https://docs.docker.com/get-docker/) instalado, **ou**
- Python 3.12+ com `pip` para execução via virtual environment

---

## 🐳 Execução com Docker

### 1. Configure as variáveis de ambiente

Copie o arquivo de exemplo e preencha com suas credenciais:

```bash
cp env_example .env
```

Edite o `.env` com suas configurações de banco de dados (host, usuário, senha, schema, etc.).

### 2. Build da imagem

```bash
docker build -t dbt-motors .
```

### 3. Execute o `dbt debug`

Para validar a conexão e as configurações do projeto:

```bash
docker run --rm \
  --env-file .env \
  -v $(pwd)/dbt_motors:/app \
  dbt-motors \
  dbt debug
```

> **Windows (PowerShell):** substitua `$(pwd)` por `${PWD}`.

### 4. Outros comandos dbt via Docker

```bash
# Rodar todos os models
docker run --rm --env-file .env -v $(pwd)/dbt_motors:/app dbt-motors dbt run

# Rodar os testes
docker run --rm --env-file .env -v $(pwd)/dbt_motors:/app dbt-motors dbt test

# Gerar documentação
docker run --rm --env-file .env -v $(pwd)/dbt_motors:/app dbt-motors dbt docs generate
```

---

## 🐍 Execução com Virtual Environment (venv)

### 1. Crie e ative a virtual environment

```bash
# Criar
python -m venv .venv

# Ativar — Linux/macOS
source .venv/bin/activate

# Ativar — Windows (PowerShell)
.venv\Scripts\Activate.ps1
```

### 2. Instale as dependências

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

### 3. Configure as variáveis de ambiente

```bash
cp env_example .env
```

Edite o `.env` e carregue as variáveis no shell:

```bash
# Linux/macOS
export $(grep -v '^#' .env | xargs)

# Windows (PowerShell)
Get-Content .env | ForEach-Object {
  if ($_ -match '^\s*([^#][^=]*)=(.*)$') {
    [System.Environment]::SetEnvironmentVariable($matches[1].Trim(), $matches[2].Trim())
  }
}
```

### 4. Execute o `dbt debug`

```bash
cd dbt_motors
dbt debug
```

### 5. Outros comandos dbt

```bash
dbt run          # executa os models
dbt test         # roda os testes
dbt docs generate && dbt docs serve   # abre a documentação no browser
```

---

## 🔐 Variáveis de Ambiente

Copie `env_example` para `.env` e preencha os valores:

| Variável | Descrição |
|---|---|
| `SNOWFLAKE_ACCOUNT` | Identificador da conta Snowflake (ex: `xy12345.us-east-1`) |
| `SNOWFLAKE_USER` | Usuário de acesso |
| `SNOWFLAKE_PASSWORD` | Senha do usuário |
| `SNOWFLAKE_ROLE` | Role utilizada nas queries (ex: `TRANSFORMER`) |
| `SNOWFLAKE_DATABASE` | Banco de dados alvo (ex: `MOTORS_DB`) |
| `SNOWFLAKE_SCHEMA` | Schema alvo das transformações (ex: `DBT_DEV`) |
| `SNOWFLAKE_WAREHOUSE` | Virtual warehouse para execução (ex: `COMPUTE_WH`) |

> ⚠️ O arquivo `.env` está no `.gitignore` e **não deve ser commitado**.

### profiles.yml

O dbt utiliza o arquivo `dbt_motors/profiles.yml` para conectar ao Snowflake, lendo as credenciais via variáveis de ambiente:

```yaml
dbt_motors:
  target: dev

  outputs:

    dev:
      type: snowflake

      account: "{{ env_var('SNOWFLAKE_ACCOUNT') }}"

      user: "{{ env_var('SNOWFLAKE_USER') }}"

      password: "{{ env_var('SNOWFLAKE_PASSWORD') }}"

      role: "{{ env_var('SNOWFLAKE_ROLE') }}"

      database: "{{ env_var('SNOWFLAKE_DATABASE') }}"

      warehouse: "{{ env_var('SNOWFLAKE_WAREHOUSE') }}"

      schema: "{{ env_var('SNOWFLAKE_SCHEMA') }}"

      threads: 4
```

> ⚠️ **Caso o `dbt debug` retorne erro de variável não encontrada** (ex: `env var 'SNOWFLAKE_ACCOUNT' is not set`), substitua os `env_var(...)` pelos valores diretamente no `profiles.yml`:
>
> ```yaml
>       account: "xy12345.us-east-1"
>       user: "meu_usuario"
>       password: "minha_senha"
>       role: "TRANSFORMER"
>       database: "MOTORS_DB"
>       warehouse: "COMPUTE_WH"
>       schema: "DBT_DEV"
> ```
>
> Nesse caso, **nunca versione o `profiles.yml`** com valores preenchidos — adicione-o ao `.gitignore`.

---

## 🧰 Tecnologias

- [dbt Core](https://docs.getdbt.com/docs/core/installation)
- Python 3.12
- Docker

---

## 📝 Dicas Rápidas

| Ação | Comando |
|---|---|
| Validar conexão | `dbt debug` |
| Rodar models | `dbt run` |
| Rodar testes | `dbt test` |
| Compilar SQL | `dbt compile` |
| Ver linhagem | `dbt docs generate && dbt docs serve` |
| Rodar model específico | `dbt run --select nome_do_model` |
