# Stage 1: base image with PHP and required extensions
FROM php:8.1-fpm-alpine AS base

# Install system dependencies and PHP extensions
RUN apk add --no-cache \
    git \
    unzip \
    openssl \
    libzip-dev \
    oniguruma-dev && \
    docker-php-ext-install pdo_mysql mbstring zip && \
    pecl install apcu && docker-php-ext-enable apcu

# Install Composer
COPY --from=composer:2.5 /usr/bin/composer /usr/bin/composer

WORKDIR /app

# Copy composer files and install dependencies
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Generate JWT keys at build time
# Pass the JWT_PASSPHRASE as a build argument
ARG JWT_PASSPHRASE
RUN mkdir -p config/jwt && \
    openssl genrsa -out config/jwt/private.pem -aes256 -passout pass:${JWT_PASSPHRASE} 4096 && \
    openssl rsa -pubout -in config/jwt/private.pem -passin pass:${JWT_PASSPHRASE} -out config/jwt/public.pem && \
    chmod 640 config/jwt/private.pem && chmod 644 config/jwt/public.pem

# Stage 2: production image
FROM php:8.1-fpm-alpine

# Copy PHP extensions and Composer from base
COPY --from=base /usr/local/etc/php /usr/local/etc/php
COPY --from=base /usr/local/lib/php/extensions /usr/local/lib/php/extensions
COPY --from=base /usr/bin/composer /usr/bin/composer

WORKDIR /app

# Copy application code and generated keys
COPY --from=base /app /app

# Expose PHP-FPM port
EXPOSE 9000

# Default command
CMD ["php-fpm"]