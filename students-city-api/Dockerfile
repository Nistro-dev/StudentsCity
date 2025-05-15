FROM php:8.2-fpm-alpine

# build deps + extensions
RUN apk add --no-cache \
    autoconf build-base \
    libzip-dev oniguruma-dev \
    && docker-php-ext-install pdo_mysql mbstring zip \
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    && apk del autoconf build-base

# runtime libs
RUN apk add --no-cache libzip

WORKDIR /app
COPY . .
RUN composer install --no-dev --optimize-autoloader --no-interaction

EXPOSE 8000
CMD ["php", "-S", "0.0.0.0:8000", "-t", "public"]