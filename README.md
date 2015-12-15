[![Docker Repository on Quay](https://quay.io/repository/apeckham/pgbadger/status "Docker Repository on Quay")](https://quay.io/repository/apeckham/pgbadger)

Docker image to download recent RDS Postgres logs, run [pgbadger](https://github.com/dalibo/pgbadger), and upload the report to S3.

# Enable logging on RDS
```aws rds modify-db-parameter-group --db-parameter-group-name postgres-custom --parameters "ParameterName=log_min_duration_statement, ParameterValue=0, ApplyMethod=immediate"```

http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_LogAccess.Concepts.PostgreSQL.html

# Run
```docker run -e AWS_SECRET_ACCESS_KEY=XXX -e AWS_ACCESS_KEY_ID=YYY -e AWS_DEFAULT_REGION=ZZZ -e BUCKET=foobar -e DB_INSTANCE_IDENTIFIER=mydb -e LOG_FILE_COUNT=5 -v /mnt:/run quay.io/apeckham/pgbadger```

# Disable logging on RDS
```aws rds modify-db-parameter-group --db-parameter-group-name postgres-custom --parameters "ParameterName=log_min_duration_statement, ParameterValue=-1, ApplyMethod=immediate"```

# Todo
Pipe logs straight to pgbadger instead of saving them to disk