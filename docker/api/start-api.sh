#!/bin/sh
set -eu

if [ ! -f composer.json ]; then
  echo "composer.json not found in /app"
  exit 1
fi

if [ ! -f vendor/autoload.php ]; then
  composer install --no-interaction
fi

until pg_isready -h postgres -p 5432 -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" >/dev/null 2>&1; do
  echo "Waiting for postgres..."
  sleep 2
done

php bin/console doctrine:migrations:migrate --no-interaction
exec php -S 0.0.0.0:8000 -t public public/index.php
