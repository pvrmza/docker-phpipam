# base
FROM ubuntu:18.04
LABEL maintainer="Pablo A. Vargas <pablo@pampa.cloud>"

# Environment
ENV DEBIAN_FRONTEND noninteractive

# update & upgrade & install base
RUN apt-get update && apt-get -y dist-upgrade && \
    apt-get -y install apache2 libapache2-mod-php7.2 php7.2-cli php7.2-mysql php7.2-gd php7.2-gmp php7.2-ldap \
         php7.2-mbstring php7.2-curl php-php-gettext php7.2-snmp php7.2-json php-pear \
         snmp iputils-ping fping mysql-client \
         wget supervisor cron

# Cleanup, this is ran to reduce the resulting size of the image.
RUN apt-get clean autoclean && apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/lib/cache/* /var/lib/log/* /var/lib/apt/lists/*

# base config
RUN a2dismod mpm_event && \
    a2enmod mpm_prefork && \
    a2enmod php7.2 && \
    a2enmod rewrite
#
COPY files/apache-phpipam.conf /etc/apache2/sites-available/000-default.conf
COPY files/cron-phpipam /etc/cron.d/phpipam
COPY files/supervisord.conf /etc/supervisord.conf
COPY files/foreground.sh /etc/foreground.sh

RUN echo "TLS_REQCERT never" >> /etc/ldap/ldap.conf && \
    chmod +x /etc/foreground.sh

#
RUN wget -c https://github.com/phpipam/phpipam/releases/download/v1.4.1/phpipam-v1.4.1.tgz -O /tmp/phpipam-v1.4.1.tgz && \
    cd /var/www && tar zxvf /tmp/phpipam-v1.4.1.tgz && mv html html.old && mv phpipam html && chown root.root html -R && \
    rm -rf /tmp/phpipam-v1.4.1.tgz && \
    ln -s /var/www/html/config.docker.php /var/www/html/config.php && \
    cd /var/www/html/ && find . -type f -exec chmod 0644 {} \; && find . -type d -exec chmod 0755 {} \; && \
    chown www-data.www-data /var/www/html/css/images/logo -R 


#Puertos y Volumenes
EXPOSE 80 
CMD ["/etc/foreground.sh"]

