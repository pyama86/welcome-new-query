#!/bin/bash

DB_HOST=$INPUT_DB_HOST
DB_USER=$INPUT_DB_USER
DB_PASSWORD=$INPUT_DB_PASSWORD

[ -n "$DB_PASSWORD" ] && PASSWORD="-p${DB_PASSWORD}"

query="set global log_output = 'TABLE'";
`mysql -h ${DB_HOST} -u${DB_USER} ${PASSWORD} -Dmysql -sse "${query}"`

query="set global general_log = 1";
`mysql -h ${DB_HOST} -u${DB_USER} ${PASSWORD} -Dmysql -sse "${query}"`
