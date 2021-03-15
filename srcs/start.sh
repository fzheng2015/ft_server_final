#!/bin/bash

openssl req -newkey rsa:4096 -days 365 -nodes -x509 -subj \
	"/CN=localhost" \
	-keyout localhost.dev.key -out localhost.dev.crt
mv localhost.dev.crt etc/ssl/certs/
mv localhost.dev.key etc/ssl/private/
chmod 600 etc/ssl/certs/localhost.dev.crt etc/ssl/private/localhost.dev.key

cp -r default etc/nginx/sites-available/

wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz
tar -xvf phpMyAdmin-5.0.2-all-languages.tar.gz
mv phpMyAdmin-5.0.2-all-languages phpmyadmin
mv phpmyadmin /var/www/html/
cp -r config.inc.php var/www/html/phpmyadmin/config.inc.php

service nginx start && service mysql start && service php7.3-fpm start
echo "CREATE DATABASE IF NOT EXISTS  wordpress;" | mysql -u root --skip-password
echo "CREATE USER 'wordpress'@'localhost';" | mysql -u root --skip-password
echo "SET password FOR 'wordpress'@'localhost' = password('password');" | mysql -u root --skip-password
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY 'password';" | mysql -u root --skip-password
echo "FLUSH PRIVILEGES;" | mysql -u root --skip-password

service php7.3-fpm restart

wget https://wordpress.org/latest.tar.gz
tar -xvf latest.tar.gz
mv wordpress/ var/www/html/
chown -R www-data:www-data /var/www/html/wordpress
cp -r wp-config.php  var/www/html/wordpress/wp-config.php

rm var/www/html/index.nginx-debian.html

bash
