#!/bin/bash -e

if [ ! -d /var/www ]; then
echo 'No application found in /var/www'
exit 1;
fi

if [ ! -d vendor ]; then
    composer install
fi

/usr/local/bin/start_mysql

echo "=> Creating database aperophp"
RET=1
while [[ RET -ne 0 ]]; do
	sleep 5
 	mysql -uroot -e "SHOW DATABASES"
	RET=$?
done

if [ ! -d /var/lib/mysql/aperophp ] ; then
	mysql -uroot -e "CREATE DATABASE IF NOT EXISTS aperophp"
	/var/www/app/console db:install
	/var/www/app/console db:load-fixtures
fi

mysqladmin -uroot shutdown

exec svscan /srv/services
