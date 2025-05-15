#!/usr/bin/env bash
set -e

# Assurez-vous que .env.local est présent
[ -f /app/.env.local ] || { echo ".env.local manquant !"; exit 1; }

# Run auto-scripts
composer dump-autoload --optimize
php bin/console cache:clear --env="${APP_ENV:-dev}"
php bin/console doctrine:migrations:migrate --no-interaction

# Finally start PHP built-in server
exec php -S 0.0.0.0:8000 -t public