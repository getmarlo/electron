import sys
from google.cloud import storage

release = sys.argv[1]
filepath = sys.argv[2]
hashpath = sys.argv[3]

bucket_name = "marlo-storage"
destination_name = "electron/" + release + "/dist.zip"
destination_hash = "electron/" + release + "/dist.zip.md5sum"

storage_client = storage.Client()
bucket = storage_client.bucket(bucket_name)

blob = bucket.blob(destination_name)
blob_hash = bucket.blob(destination_hash)

blob.upload_from_filename(file_path)
blob.upload_from_filename(hash_path)
