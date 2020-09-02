#!/bin/bash

# turn on bash's job control
set -m

#######
# clean old pid and "fix" cron
find /var/run/ -type f -iname \*.pid -delete
touch /etc/crontab  /etc/cron.d/phpipam /etc/cron.d/php 

#######
# timezone
if [ -f /usr/share/zoneinfo/$TZ ]; then
  echo $TZ > /etc/timezone 
  rm /etc/localtime &&  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
  dpkg-reconfigure -f noninteractive tzdata 

  echo "date.timezone=$TZ" > /etc/php/7.2/apache2/conf.d/99_datatime.ini 
fi

#######
# URL Base dir 
if test ! -z $IPAM_BASE; then 
  ln -s /var/www/html /var/www/html/$(echo $IPAM_BASE | sed 's/\///g')
fi

#######
while ! mysqladmin ping -h"$IPAM_DATABASE_HOST" --silent; do
  echo "Waiting... $IPAM_DATABASE_HOST not is alive..."
    sleep 5
done

#######
# Check install db
TABLE=vrf
SQL_EXISTS=$(printf 'SHOW TABLES LIKE "%s"' "$TABLE")
if [[ $(mysql -h$IPAM_DATABASE_HOST -u$IPAM_DATABASE_USER -p$IPAM_DATABASE_PASS -e "$SQL_EXISTS" $IPAM_DATABASE_NAME) ]]
then
    echo "Table exists ..."
else
    mysql -h$IPAM_DATABASE_HOST -u$IPAM_DATABASE_USER -p$IPAM_DATABASE_PASS --default_character_set utf8 $IPAM_DATABASE_NAME < /var/www/html/db/SCHEMA.sql
    php /var/www/html/functions/scripts/reset-admin-password.php ChangeIT
fi

#######
# Set/Reset admin pass
if test ! -z $IPAM_ADMIN_PASS; then 
  php /var/www/html/functions/scripts/reset-admin-password.php $IPAM_ADMIN_PASS
fi

#######
supervisord -c /etc/supervisord.conf