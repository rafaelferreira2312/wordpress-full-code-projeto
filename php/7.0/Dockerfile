FROM php:7.0-fpm

# Instalar extensões PHP necessárias
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd pdo pdo_mysql mysqli zip

# Copiar configurações personalizadas
COPY conf/php.ini /usr/local/etc/php/php.ini

WORKDIR /var/www/html

CMD ["php-fpm"]
