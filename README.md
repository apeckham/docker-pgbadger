Docker image to download recent RDS Postgres logs, run [pgbadger](https://github.com/dalibo/pgbadger), and upload the report to S3.

# Enable logging on RDS
```aws rds modify-db-parameter-group --db-parameter-group-name postgres-custom --parameters "ParameterName=log_min_duration_statement, ParameterValue=0, ApplyMethod=immediate"```

http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_LogAccess.Concepts.PostgreSQL.html

# Run
```docker build -t pgbadger .```
```docker run -e AWS_SECRET_ACCESS_KEY -e AWS_ACCESS_KEY_ID -e AWS_DEFAULT_REGION=my-region -e BUCKET=my-bucket -e DB_INSTANCE_IDENTIFIER=my-db-instance -e LOG_FILE_COUNT=2 -v /mnt:/run pgbadger```

# Disable logging on RDS
```aws rds modify-db-parameter-group --db-parameter-group-name postgres-custom --parameters "ParameterName=log_min_duration_statement, ParameterValue=-1, ApplyMethod=immediate"```

# Todo

- Pipe logs straight to pgbadger instead of saving them to disk
- Pass flags from docker command to pgbadger (https://github.com/dalibo/pgbadger)