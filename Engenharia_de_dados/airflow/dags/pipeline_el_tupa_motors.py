from airflow.decorators import dag, task
from airflow.providers.snowflake.hooks.snowflake import SnowflakeHook
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.operators.trigger_dagrun import TriggerDagRunOperator

from datetime import datetime, timedelta, timezone

import pandas as pd

from snowflake.connector.pandas_tools import write_pandas


default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "start_date": datetime(2026, 1, 1),
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}


SNOWFLAKE_DATABASE = "TUPA_MOTORS"
SNOWFLAKE_SCHEMA = "RAW"

SOURCE_SYSTEM = "postgres_tupa_motors"


TABLE_PK_MAP = {
    "estados": "id_estados",
    "cidades": "id_cidades",
    "concessionarias": "id_concessionarias",
    "vendedores": "id_vendedores",
    "clientes": "id_clientes",
    "veiculos": "id_veiculos",
    "vendas": "id_vendas",
    "avaliacoes_clientes": "id_avaliacao",
}



def create_table_tasks(table_name, pk_column):

    sf_table = table_name.upper()
    pk_sf = pk_column.upper()


    @task(
        task_id=f"get_max_{table_name}"
    )
    def get_max_primary_key():

        hook = SnowflakeHook(
            snowflake_conn_id="tupa_motors_snowflake_wh"
        )


        conn = hook.get_conn()
        cursor = conn.cursor()


        try:

            cursor.execute(
                f"""
                SELECT COALESCE(MAX({pk_sf}),0)
                FROM {SNOWFLAKE_DATABASE}.{SNOWFLAKE_SCHEMA}.{sf_table}
                """
            )


            result = cursor.fetchone()

            return result[0]


        except Exception as error:

            print(
                f"Erro consultando {sf_table}: {error}"
            )

            return 0


        finally:

            cursor.close()
            conn.close()



    @task(
        task_id=f"load_data_{table_name}"
    )
    def load_incremental(max_id):


        start_time = datetime.now(timezone.utc)



        postgres = PostgresHook(
            postgres_conn_id="tupa_motors_postgres"
        )


        engine = postgres.get_sqlalchemy_engine()



        query = f"""
            SELECT *
            FROM {table_name}
            WHERE {pk_column} > %(max_id)s
            ORDER BY {pk_column}
        """



        df = pd.read_sql(
            query,
            engine,
            params={
                "max_id": max_id
            }
        )



        rows_extracted = len(df)



        if df.empty:

            print(
                f"Nenhum dado novo encontrado em {table_name}"
            )

            return



        # Padroniza colunas Snowflake RAW

        df.columns = [
            column.upper()
            for column in df.columns
        ]



        df["SOURCE_SYSTEM"] = SOURCE_SYSTEM



        snowflake = SnowflakeHook(
            snowflake_conn_id="tupa_motors_snowflake_wh"
        )


        sf_conn = snowflake.get_conn()



        success, _, rows_loaded, _ = write_pandas(
            sf_conn,
            df,
            table_name=sf_table,
            database=SNOWFLAKE_DATABASE,
            schema=SNOWFLAKE_SCHEMA,
            quote_identifiers=False
        )



        sf_conn.close()



        end_time = datetime.now(timezone.utc)



        print(
            f"""
            =====================================
            Tabela origem : {table_name}
            Tabela destino: {sf_table}

            Registros extraídos: {rows_extracted}
            Registros inseridos: {rows_loaded}

            Sucesso: {success}

            Tempo execução:
            {(end_time-start_time).total_seconds():.2f}s

            =====================================
            """
        )



    max_id = get_max_primary_key()


    load_task = load_incremental(
        max_id
    )


    return load_task





@dag(
    dag_id="pipeline_el_tupa_motors",
    default_args=default_args,
    description="Pipeline incremental PostgreSQL para Snowflake RAW",
    schedule=timedelta(days=1),
    catchup=False,
    tags=[
        "postgres",
        "snowflake",
        "raw",
        "tupa_motors"
    ],
)
def postgres_to_snowflake_etl():



    load_tasks = []



    for table_name, pk_column in TABLE_PK_MAP.items():

        load_task = create_table_tasks(
            table_name,
            pk_column
        )

        load_tasks.append(
            load_task
        )



    trigger_dbt = TriggerDagRunOperator(

        task_id="trigger_pipeline_dbt_tupa_motors",

        trigger_dag_id="pipeline_dbt_tupa_motors",

        wait_for_completion=True,

        reset_dag_run=True

    )



    for load_task in load_tasks:

        load_task >> trigger_dbt





postgres_to_snowflake_etl()