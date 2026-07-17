from airflow.decorators import dag, task
from airflow.providers.postgres.hooks.postgres import PostgresHook
from pendulum import datetime


@dag(
    dag_id="test_postgres_connection",
    start_date=datetime(2026, 1, 1),
    schedule=None,
    catchup=False,
    tags=["postgres", "teste"],
)
def test_postgres_connection():

    @task
    def check_connection():
        """
        Testa a conexão com o PostgreSQL.
        """

        hook = PostgresHook(postgres_conn_id="tupa_motors_postgres")

        conn = hook.get_conn()

        cursor = conn.cursor()

        cursor.execute("SELECT version();")

        version = cursor.fetchone()[0]

        print("=" * 80)
        print("Conexão realizada com sucesso!")
        print(version)
        print("=" * 80)

        cursor.close()
        conn.close()

    check_connection()


dag = test_postgres_connection()