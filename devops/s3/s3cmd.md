```sh
sudo pip install s3cmd

export S3_ACCESS_KEY=C6jn1xxxxxxxxxxxxx
export S3_SECRET_KEY=nkjUrVmRBxxxxxxxxxxxxxxxxxxxxxxxxxx
export S3_REGION=us-east-1
export S3_HOSTNAME=minio.infra.int.example.ru
export S3_HOST_BUCKET="$S3_HOSTNAME/%(bucket)"

s3cmd ls --access_key=$S3_ACCESS_KEY --secret_key=$S3_SECRET_KEY --region=$S3_REGION --host=$S3_HOSTNAME

s3cmd ls s3://my-bucket --access_key=$S3_ACCESS_KEY --secret_key=$S3_SECRET_KEY --region=$S3_REGION --host=$S3_HOSTNAME --host-bucket=$S3_HOST_BUCKET
```
