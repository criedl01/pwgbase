FROM php:7.3-apache
RUN apt-get update && apt-get -y install wget vim net-tools supervisor libgd-dev libmcrypt-dev libgd3 libmcrypt4 libpng-dev libfreetype6-dev libjpeg62-turbo-dev ssl-cert libicu-dev sudo default-libmysqlclient-dev apache2-dev imagemagick libzip-dev
ADD usr/src /usr/src
ADD conf/remoteip.conf /etc/apache2/conf-available/
ADD conf/apache2.conf.patch /tmp/
WORKDIR /usr/src/mod_auth_cookie_mysql2_1.0
RUN make && make install
RUN apt-get -y remove apache2-dev && apt-get -y autoremove
RUN docker-php-ext-configure gd \
 && docker-php-ext-install gd \
 && docker-php-ext-install mysqli && docker-php-ext-install exif && docker-php-ext-install zip
RUN a2enmod rewrite && a2enmod ssl && a2enmod remoteip && a2enconf remoteip && patch -d/etc/apache2/ -p0 < /tmp/apache2.conf.patch
RUN ln -s /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-enabled/
WORKDIR /
