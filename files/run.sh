#!/bin/bash
export FPM_LISTEN=${FPM_LISTEN:-"0.0.0.0:9000"}
export FPM_USER=${FPM_USER:-"www-data"}
export FPM_GROUP=${FPM_GROUP:-"www-data"}
export USE_DOCKERIZE=${USE_DOCKERIZE:-"yes"}
export PHP_INI_DIR=${PHP_INI_DIR:-"/etc/php"}
export EXTRACONF=${EXTRACONF:-";"}

if [ $USE_DOCKERIZE == "yes" ];
then
    echo "USE the dockerize template";
    dockerize -template /etc/php/php-fpm.tmpl > /etc/php/php-fpm.conf
fi

export UPSTREAM=${UPSTREAM:-"php_container:9000"}
export DOMAIN=${DOMAIN:-"localhost"}
export LOCATION=${LOCATION:-"#ADD_LOCATION"}
export USE_DOCKERIZE=${USE_DOCKERIZE:-"yes"}
export WEBROOT=${WEBROOT:-"/var/www/public"}
if [ $USE_DOCKERIZE == "yes" ];
then
    echo "USE the dockerize template";
    dockerize -template /etc/nginx/default.tmpl > /etc/nginx/sites-available/default
fi

nginx &

/usr/local/sbin/php-fpm-env >> /etc/php/php-fpm.conf
/usr/local/sbin/php-fpm -c ${PHP_INI_DIR} --nodaemonize
