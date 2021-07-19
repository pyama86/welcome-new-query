#!/bin/bash

DB_HOST=$1
DB_USER=$2
DB_PASSWORD=$3

[ -n "$DB_PASSWORD" ] && PASSWORD="-p${DB_PASSWORD}"

query="set global log_output = 'TABLE'";
`mysql -h ${DB_HOST} -u${DB_USER} ${PASSWORD} -Dmysql -sse "${query}"`

query="set global general_log = 1";
`mysql -h ${DB_HOST} -u${DB_USER} ${PASSWORD} -Dmysql -sse "${query}"`
