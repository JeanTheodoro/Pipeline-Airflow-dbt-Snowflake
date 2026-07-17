from airflow import DAG
from airflow.operators.bash import BashOperator

from datetime import datetime


with DAG(
    dag_id="pipeline_dbt_tupa_motors",
    start_date=datetime(2026, 7, 1),
    schedule="@daily",
    catchup=False
) as dag:


    dbt_staging = BashOperator(
        task_id="dbt_staging",
        bash_command="""
        cd /dbt

        dbt run \
        --select staging \
        --profiles-dir .
        """
    )


    dbt_intermediate = BashOperator(
        task_id="dbt_intermediate",
        bash_command="""
        cd /dbt

        dbt run \
        --select intermediate \
        --profiles-dir .
        """
    )


    dbt_marts = BashOperator(
        task_id="dbt_marts",
        bash_command="""
        cd /dbt

        dbt run \
        --select marts \
        --profiles-dir .
        """
    )


    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command="""
        cd /dbt

        dbt test \
        --profiles-dir .
        """
    )


    dbt_staging >> dbt_intermediate >> dbt_marts >> dbt_test
    