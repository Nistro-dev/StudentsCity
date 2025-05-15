FROM php:8.2-fpm-alpine

# Installer Composer
COPY --from=composer:2.5 /usr/bin/composer /usr/bin/composer

# build deps  extensions
RUN apk add --no-cache \
    autoconf build-base \
    libzip-dev oniguruma-dev \
    && docker-php-ext-install pdo_mysql mbstring zip \
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    && apk del autoconf build-base

# runtime libs
RUN apk add --no-cache libzip bash

WORKDIR /app
COPY . .

RUN composer install \
    --no-dev \
    --optimize-autoloader \
    --no-interaction \
    --no-scripts

EXPOSE 8000

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

CMD ["entrypoint.sh"]