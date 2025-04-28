from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime
import os

ENVIRONMENT = os.getenv("ENVIRONMENT", "dev")

default_args = {
    "owner": "airflow",
    "start_date": datetime(2024, 1, 1),
    "retries": 1,
}

with DAG(
    "etl_pipeline_dag",
    default_args=default_args,
    schedule_interval="@daily",
    catchup=False,
) as dag:

    generate_csv = BashOperator(
        task_id="generate_csv",
        bash_command="python /opt/airflow/scripts/extract_csv.py"
    )

    upload_csv_s3 = BashOperator(
        task_id="upload_csv_s3",
        bash_command="python /opt/airflow/scripts/upload_to_s3.py"
    )

    load_csv_postgres = BashOperator(
        task_id="load_csv_postgres",
        bash_command="python /opt/airflow/scripts/load_to_postgres.py"
    )

    generate_csv >> upload_csv_s3 >> load_csv_postgres