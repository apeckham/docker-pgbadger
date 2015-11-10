#!/bin/sh

set -ex

: ${DB_INSTANCE_IDENTIFIER?"Need to set DB_INSTANCE_IDENTIFIER"}
: ${BUCKET?"Need to set BUCKET"}
: ${AWS_DEFAULT_REGION?"Need to set AWS_DEFAULT_REGION"}

cd /tmp
        
aws rds describe-db-log-files --db-instance-identifier $DB_INSTANCE_IDENTIFIER >/tmp/describe-db-log-files.json

FILES=$(cat /tmp/describe-db-log-files.json | jq ".DescribeDBLogFiles[] .LogFileName" --raw-output | tail -5)

for FILE in $FILES; do
  aws rds download-db-log-file-portion --db-instance-identifier $DB_INSTANCE_IDENTIFIER \
    --log-file-name $FILE --starting-token 0 --output text | pv > $(basename $FILE)
done
        
pgbadger -j $(nproc) -p '%t:%r:%u@%d:[%p]:' $@ postgresql.log.*

aws s3 cp out.html s3://$BUCKET/pgbadger-$(date +"%Y-%m-%d").html --acl public-read