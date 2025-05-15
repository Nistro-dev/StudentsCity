#!/bin/sh
set -e

# Assurez-vous que .env.local existe
[ -f /app/.env.local ] || { echo ".env.local manquant" >&2; exit 1; }

# Générer l’autoload optimisé (au cas où nouveaux paquets)
composer dump-autoload --optimize

# Lancer les auto-scripts Symfony (cache, assets…)
php bin/console cache:clear --env="${APP_ENV:-prod}"

# Enfin démarrer PHP intégré (ou php-fpm)
exec php -S 0.0.0.0:8000 -t public