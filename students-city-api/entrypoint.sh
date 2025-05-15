#!/usr/bin/env sh
set -e

# Génère .env.local depuis les env vars Docker
cat > /app/.env.local <<EOF
APP_ENV=${APP_ENV:-prod}
APP_SECRET=${APP_SECRET}
DATABASE_URL="${DATABASE_URL}"
JWT_SECRET_KEY=%kernel.project_dir%/config/jwt/private.pem
JWT_PUBLIC_KEY=%kernel.project_dir%/config/jwt/public.pem
JWT_PASSPHRASE=${JWT_PASSPHRASE}
EOF

# Cache & migrations si nécessaire
composer dump-autoload --optimize
php bin/console cache:clear --env="${APP_ENV}"
php bin/console doctrine:migrations:migrate --no-interaction

# Démarre PHP-FPM
exec php-fpm