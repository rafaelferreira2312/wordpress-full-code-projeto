FROM php:7.4-fpm

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libzip-dev \
    libxml2-dev \
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql zip xml

COPY conf/php.ini /usr/local/etc/php/php.ini

WORKDIR /var/www/html

CMD ["php-fpm"]
