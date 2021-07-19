#!/bin/bash
set -x
DB_HOST=$1
DB_USER=$2
DB_PASSWORD=$3
OUTPUT_PATH=$4


test -e ${OUTPUT_PATH} && cp ${OUTPUT_PATH} ${OUTPUT_PATH}_base

[ -n "$DB_PASSWORD" ] && PASSWORD="-p${DB_PASSWORD}"

query="select replace(replace(replace(replace(argument, '\r\n', ''), '\r', ''), '\n', ''), '\0', '') from general_log where command_type = 'Query';"
`mysql -h ${DB_HOST} -u${DB_USER} ${PASSWORD} -Dmysql -sse "${query}"| \
  sed -e 's/$/;/g' | pt-fingerprint --match-embedded-numbers | sort | uniq > ${OUTPUT_PATH}`


if [ `test -e ${OUTPUT_PATH}_base` ]; then
  d=`diff -u ${OUTPUT_PATH}_base ${OUTPUT_PATH} | grep ^+ | grep -v ^+++ | sed s/^+//`
else
  d=`cat ${OUTPUT_PATH}`
fi

d="${d//$'\n'/\\n}"
echo "::set-output name=new-queries::${d}"
echo "::set-output name=save-path::${OUTPUT_PATH}"
