#/bin/bash
DIR="$(pwd)"
source $DIR/.env

MYSQL_ENCODED_PASSWORD=$(curl -s -w '%{url}\n' -G / --data-urlencode "=$MYSQL_PASSWORD" | cut -c 3-)
PGSQL_ENCODED_PASSWORD=$(curl -s -w '%{url}\n' -G / --data-urlencode "=$PGSQL_PASSWORD" | cut -c 3-)

MYSQL_CONNECTION_URI="mysql://"$MYSQL_USERNAME":"$MYSQL_ENCODED_PASSWORD"@"$MYSQL_HOST":"$MYSQL_PORT"/"$MYSQL_DB_NAME
PGSQL_CONNECTION_URI="postgresql://"$PGSQL_USERNAME":"$PGSQL_ENCODED_PASSWORD"@"$PGSQL_HOST":"$PGSQL_PORT"/"$PGSQL_DB_NAME

echo "MYSQL CONNECTION URL: "$MYSQL_CONNECTION_URI
echo "PGSQL CONNECTION URL: "$PGSQL_CONNECTION_URI

echo "================="
echo "MIGRATION STARTED"
echo "================="
start=$(date +%s)
sudo ./pgloader-3.6.3/build/bin/pgloader $MYSQL_CONNECTION_URI $PGSQL_CONNECTION_URI
end=$(date +%s)
echo "Time Elapsed: $(($end - $start)) seconds"
echo "\n\n"
