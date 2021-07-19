#!/bin/bash
MYSQL_USER=${MYSQL_USER:-root}
MYSQL_HOST=${MYSQL_HOST:-localhost}

[ -v MYSQL_PASSWORD ] && PASSWORD="-p${MYSQL_PASSWORD}"
[ "${MYSQL_USER}" = "root" ] && [ -v MYSQL_ROOT_PASSWORD ] && PASSWORD="-p${MYSQL_ROOT_PASSWORD}"

query="set global log_output = 'TABLE'";
`mysql -h ${MYSQL_HOST} -u${MYSQL_USER} ${PASSWORD} -Dmysql -sse "${query}"`

query="set global general_log = 1";
`mysql -h ${MYSQL_HOST} -u${MYSQL_USER} ${PASSWORD} -Dmysql -sse "${query}"`
