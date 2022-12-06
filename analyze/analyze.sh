#!/bin/bash
set -x
DB_HOST=$INPUT_DB_HOST
DB_USER=$INPUT_DB_USER
DB_PASSWORD=$INPUT_DB_PASSWORD
OUTPUT_PATH=$INPUT_SAVE_PATH
export AWS_ACCESS_KEY_ID=$INPUT_AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$INPUT_AWS_SECRET_ACCESS_KEY
export AWS_REGION=$INPUT_AWS_REGION
S3_BUCKET=$INPUT_S3_BUCKET

DEFAULT_BRANCH=$(git remote show origin | awk '/HEAD branch/ {print $NF}')
FILENAME=`basename $OUTPUT_PATH`

[ -n "$AWS_ACCESS_KEY_ID" ] && \
[ -n "$AWS_SECRET_ACCESS_KEY" ] && \
[ -n "$AWS_REGION" ] && \
[ -n "$S3_BUCKET" ] && {
  USE_S3=1
  aws s3 cp s3://$S3_BUCKET/$FILENAME $OUTPUT_PATH --quiet
}

test -e ${OUTPUT_PATH} && cp ${OUTPUT_PATH} ${OUTPUT_PATH}_base

[ -n "$DB_PASSWORD" ] && PASSWORD="-p${DB_PASSWORD}"

query="select replace(replace(replace(replace(argument, '\r\n', ''), '\r', ''), '\n', ''), '\0', '') from general_log where command_type = 'Query';"
`mysql -h ${DB_HOST} -u${DB_USER} ${PASSWORD} -Dmysql -sse "${query}"| \
  sed -e 's/$/;/g' | pt-fingerprint --match-embedded-numbers | sort | uniq > ${OUTPUT_PATH}`

if [ -e ${OUTPUT_PATH}_base ]; then
  d=`diff -u ${OUTPUT_PATH}_base ${OUTPUT_PATH} | grep ^+ | grep -v ^+++ | sed s/^+//`
else
  d=`cat ${OUTPUT_PATH}`
fi

[ -n "$USE_S3" ] && [ "$GITHUB_EVENT_NAME" = "push" ] && [ "$GITHUB_REF" = "refs/heads/${DEFAULT_BRANCH}" ] &&{
  aws s3 cp ${OUTPUT_PATH} s3://$S3_BUCKET/$FILENAME  --quiet
}

d="${d//$'\n'/\\n}"
echo "::set-output name=new_queries::${d}"
echo "::set-output name=save_path::${OUTPUT_PATH}"
