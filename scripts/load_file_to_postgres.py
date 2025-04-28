import psycopg2
import pandas as pd
import os

def load_csv_to_postgres(csv_path, table_name, db_params):
    conn = psycopg2.connect(**db_params)
    cursor = conn.cursor()
    df = pd.read_csv(csv_path)

    cursor.execute(f"DROP TABLE IF EXISTS {table_name};")
    create_table_query = f"""
    CREATE TABLE {table_name} (
        id INT PRIMARY KEY,
        name TEXT,
        email TEXT
    );
    """
    cursor.execute(create_table_query)

    for _, row in df.iterrows():
        cursor.execute(f"INSERT INTO {table_name} (id, name, email) VALUES (%s, %s, %s);", tuple(row))

    conn.commit()
    cursor.close()
    conn.close()
    print(f"Data loaded into {table_name}")

if __name__ == "__main__":
    csv_path = os.getenv("CSV_OUTPUT_PATH", "/tmp/sample_data.csv")
    db_params = {
        "host": os.getenv("POSTGRES_HOST", "postgres_dw"),
        "port": 5432,
        "user": os.getenv("POSTGRES_USER", "dwuser"),
        "password": os.getenv("POSTGRES_PASSWORD", "dwpassword"),
        "dbname": os.getenv("POSTGRES_DB", "dw_dev")
    }
    table_name = os.getenv("POSTGRES_TABLE", "raw_users")
    load_csv_to_postgres(csv_path, table_name, db_params)