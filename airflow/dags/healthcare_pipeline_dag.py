from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime
import os

ENVIRONMENT = os.getenv("ENVIRONMENT", "dev")

default_args = {
    "owner": "airflow",
    "start_date": datetime(2025, 1, 1),
    "retries": 1,
}

with DAG(
    "etl_pipeline_dag",
    default_args=default_args,
    schedule_interval="@daily",
    catchup=False,
) as dag:

    upload_file_to_s3 = BashOperator(
        task_id="upload_file_to_s3",
        bash_command="python /opt/airflow/scripts/upload_file_to_s3.py"
    )

    load_file_to_postgres = BashOperator(
        task_id="load_file_to_postgres",
        bash_command="python /opt/airflow/scripts/load_file_to_postgres.py"
    )

    upload_file_to_s3 >> load_file_to_postgres