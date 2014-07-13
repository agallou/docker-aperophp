#!/bin/bash -e

if [ ! -d /var/www ]; then
echo 'No application found in /var/www'
exit 1;
fi

if [ ! -d vendor ]; then
    composer install
fi

/usr/bin/mysqld_safe > /dev/null 2>&1 &

echo "=> Creating database aperophp"
RET=1
while [[ RET -ne 0 ]]; do
	sleep 5
	mysql -uroot -e "CREATE DATABASE IF NOT EXISTS aperophp"
	RET=$?
done

/var/www/app/console db:install
/var/www/app/console db:load-fixtures

mysqladmin -uroot shutdown

exec svscan /srv/services
