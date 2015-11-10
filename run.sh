#!/bin/sh -ex

: ${DB_INSTANCE_IDENTIFIER?"Need to set DB_INSTANCE_IDENTIFIER"}
: ${BUCKET?"Need to set BUCKET"}

TEMP=$(mktemp -d)
cd $TEMP

FILES=$(aws rds describe-db-log-files --db-instance-identifier $DB_INSTANCE_IDENTIFIER | \
  jq ".DescribeDBLogFiles[] .LogFileName" | tail -5)

for FILE in $FILES; do  
  aws rds download-db-log-file-portion --db-instance-identifier $DB_INSTANCE_IDENTIFIER \
    --log-file-name $FILE --starting-token 0 --output text > $(basename $FILE)
done
        
pgbadger -j $(nproc) -p '%t:%r:%u@%d:[%p]:' postgresql.log.*

aws s3 cp out.html s3://$BUCKET/out-$(date +"%Y-%m-%d").html --acl public-read

rm -rf $TEMP