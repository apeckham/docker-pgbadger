Docker image to download recent RDS Postgres logs, run [pgbadger](https://github.com/dalibo/pgbadger), and upload the HTML report to an S3 bucket.

# Enable logging on RDS
```
aws rds modify-db-parameter-group --db-parameter-group-name postgres-custom --parameters "ParameterName=log_min_duration_statement, ParameterValue=0, ApplyMethod=immediate"
aws rds modify-db-parameter-group --db-parameter-group-name postgres-custom --parameters "ParameterName=log_statement, ParameterValue=all, ApplyMethod=immediate"
```

http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_LogAccess.Concepts.PostgreSQL.html

# Run
```
docker build -t pgbadger .
docker run -t -e AWS_SECRET_ACCESS_KEY -e AWS_ACCESS_KEY_ID -e AWS_DEFAULT_REGION=my-region -e BUCKET=my-bucket -e DB_INSTANCE_IDENTIFIER=my-db-instance-identifier -e LOG_FILE_COUNT=10 -v /mnt:/run pgbadger
```