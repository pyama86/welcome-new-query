#!/bin/bash
OUTPUT_PATH=$1

MYSQL_USER=${MYSQL_USER:-root}
MYSQL_HOST=${MYSQL_HOST:-localhost}

test -e ${OUTPUT_PATH} && cp ${OUTPUT_PATH} ${OUTPUT_PATH}_base
[ -v MYSQL_PASSWORD ] && PASSWORD="-p${MYSQL_PASSWORD}"
[ "${MYSQL_USER}" = "root" ] && [ -v MYSQL_ROOT_PASSWORD ] && PASSWORD="-p${MYSQL_ROOT_PASSWORD}"

query="select replace(replace(replace(replace(argument, '\r\n', ''), '\r', ''), '\n', ''), '\0', '') from general_log where command_type = 'Query';"
`mysql -h ${MYSQL_HOST} -u${MYSQL_USER} ${PASSWORD} -Dmysql -sse "${query}"| \
  sed -e 's/$/;/g' | pt-fingerprint | sort | uniq > ${OUTPUT_PATH}`


if [ `test -e ${OUTPUT_PATH}_base` ]; then
  d=`diff -u ${OUTPUT_PATH}_base ${OUTPUT_PATH} | grep ^+ | grep -v ^+++ | sed s/^+//`
else
  d=`cat ${OUTPUT_PATH}`
fi

echo "${d//$'\n'/\\n}"
