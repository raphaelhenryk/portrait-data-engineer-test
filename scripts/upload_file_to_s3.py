import boto3
import os

def upload_file_to_s3(file_path, bucket_name, object_name=None):
    s3_client = boto3.client('s3')
    if object_name is None:
        object_name = os.path.basename(file_path)
    s3_client.upload_file(file_path, bucket_name, object_name)
    print(f"Uploaded {file_path} to s3://{bucket_name}/{object_name}")

if __name__ == "__main__":
    file_path = os.getenv("CSV_OUTPUT_PATH", "/tmp/sample_data.csv")
    bucket_name = os.getenv("S3_BUCKET_NAME")
    object_name = os.getenv("S3_OBJECT_NAME", "sample_data.csv")
    upload_file_to_s3(file_path, bucket_name, object_name)