FROM php:7.1-apache
RUN apt-get update && apt-get -y install wget vim net-tools supervisor libgd-dev libmcrypt-dev libgd3 libmcrypt4 libpng-dev libfreetype6-dev libjpeg62-turbo-dev ssl-cert libicu-dev sudo default-libmysqlclient-dev apache2-dev
ADD usr/src /usr/src
WORKDIR /usr/src/mod_auth_cookie_mysql2_1.0
RUN make && make install
RUN apt-get -y remove apache2-dev && apt-get -y autoremove
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
 && docker-php-ext-install gd \
 && docker-php-ext-install mysqli && docker-php-ext-install exif && docker-php-ext-install zip
RUN a2enmod rewrite
RUN a2enmod ssl
RUN ln -s /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-enabled/
WORKDIR /
