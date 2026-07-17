    from datetime import datetime

    from airflow import DAG
    from airflow.decorators import task
    from airflow.providers.snowflake.hooks.snowflake import SnowflakeHook


    default_args = {
        "owner": "airflow",
    }


    with DAG(
        dag_id="test_snowflake_connection",
        default_args=default_args,
        start_date=datetime(2026, 1, 1),
        schedule=None,
        catchup=False,
        tags=["teste", "snowflake"],
    ):

        @task
        def testar_conexao():

            conn_id = "tupa_motors_snowflake_wh"

            hook = SnowflakeHook(
                snowflake_conn_id=conn_id
            )

            conn = hook.get_conn()

            cursor = conn.cursor()

            try:
                cursor.execute("""
                    SELECT
                        CURRENT_ACCOUNT(),
                        CURRENT_DATABASE(),
                        CURRENT_SCHEMA(),
                        CURRENT_WAREHOUSE(),
                        CURRENT_VERSION(),
                        CURRENT_USER();
                """)

                resultado = cursor.fetchone()

                print("=" * 60)
                print("✅ Conexão realizada com sucesso!")
                print(f"Account   : {resultado[0]}")
                print(f"Database  : {resultado[1]}")
                print(f"Schema    : {resultado[2]}")
                print(f"Warehouse : {resultado[3]}")
                print(f"Versão    : {resultado[4]}")
                print(f"Usuário   : {resultado[5]}")
                print("=" * 60)

            finally:
                cursor.close()
                conn.close()

        testar_conexao()
