# ──────────────── Stage 1: builder ────────────────
FROM php:8.3-fpm AS builder

# 1) Installer les dépendances de build + extensions PHP
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      git \
      unzip \
      zip \
      libzip-dev \
      oniguruma-dev \
      autoconf \
      build-essential \
 && docker-php-ext-install pdo_mysql mbstring zip \
 && pecl install apcu \
 && docker-php-ext-enable apcu \
 && apt-get purge -y --auto-remove autoconf build-essential

# 2) Copier et installer les dépendances PHP
WORKDIR /app
COPY --from=composer:2.7 /usr/bin/composer /usr/bin/composer
COPY composer.json composer.lock ./
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer install \
      --no-dev \
      --optimize-autoloader \
      --no-interaction \
      --no-scripts

# 3) Générer les clés JWT (passphrase passée en build-arg)
ARG JWT_PASSPHRASE
RUN mkdir -p config/jwt \
 && openssl genrsa -out config/jwt/private.pem -aes256 -passout pass:${JWT_PASSPHRASE} 4096 \
 && openssl rsa -pubout -in config/jwt/private.pem -passin pass:${JWT_PASSPHRASE} -out config/jwt/public.pem \
 && chmod 640 config/jwt/private.pem \
 && chmod 644 config/jwt/public.pem

# ──────────────── Stage 2: production ────────────────
FROM php:8.3-fpm

# 1) Dépendance runtime pour zip
RUN apt-get update \
 && apt-get install -y --no-install-recommends libzip unzip zip \
 && rm -rf /var/lib/apt/lists/*

# 2) Copie du build
WORKDIR /app
COPY --from=builder /app /app

# 3) Entrypoint pour générer .env.local et lancer PHP
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000
CMD ["entrypoint.sh"]