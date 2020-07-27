#!/bin/sh

SCRIPT_DIR="$(dirname "$(realpath "$0" || echo "$0")")"

echo "Initializing postgres"
cat $SCRIPT_DIR/pg-init.sql | docker-compose exec -T postgres psql -U postgres -f -
echo "Initializing mysql"
cat $SCRIPT_DIR/mysql-init.sql | docker-compose exec -T mysql mysql -uroot
