#!/bin/bash
set -e

if [ ! -e '/var/www/html/index.php' ]; then
        cd /var/www/html
	tar cf - --one-file-system -C /usr/src/tastyigniter . | tar xf -
	chown -R www-data /var/www/html
	if [ -n "${MYSQL_HOSTNAME}" ]; then
		sed -i -e "s/localhost/$MYSQL_HOSTNAME/g" /var/www/html/system/tastyigniter/config/database.php
		sed -i -e "s/your database username/$MYSQL_USER/g" /var/www/html/system/tastyigniter/config/database.php
		sed -i -e "s/your database password/$MYSQL_PASSWORD/g" /var/www/html/system/tastyigniter/config/database.php
		sed -i -e "s/your database name/$MYSQL_DATABASE/g" /var/www/html/system/tastyigniter/config/database.php
	fi
fi

exec "$@"
