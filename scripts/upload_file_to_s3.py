import boto3
import os
import logging

from pathlib import Path
from botocore.exceptions import ClientError

# Setup logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Define constants
BUCKET_NAME = "dev-portrait-data-engineer-bucket-20250427"
BASE_FOLDER = "/home/ubuntu/portrait-data-engineer-test/sample_datasets"
S3_PREFIX = "raw/"

def upload_file(file_path: Path):
    """Upload a file to S3 under raw/ folder."""
    s3_key = f"{S3_PREFIX}{file_path.name}"
    s3_client = boto3.client('s3')

    try:
        logging.info(f"Uploading {file_path} to s3://{BUCKET_NAME}/{s3_key}")
        s3_client.upload_file(str(file_path), BUCKET_NAME, s3_key)
        logging.info(f"Upload complete: {s3_key}")
    except ClientError as e:
        logging.error(f"Failed to upload {file_path.name}: {e}")

def upload_all_csvs():
    csv_files = list(Path(BASE_FOLDER).glob("*.csv"))
    
    if not csv_files:
        logging.warning("No CSV files found to upload.")
        return

    for file_path in csv_files:
        upload_file(file_path)

if __name__ == "__main__":
    upload_all_csvs()