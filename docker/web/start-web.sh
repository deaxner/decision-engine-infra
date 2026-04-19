#!/bin/sh
set -eu

if [ ! -f package.json ]; then
  echo "package.json not found in /app"
  exit 1
fi

if [ ! -x node_modules/.bin/vite ]; then
  npm install
fi

exec npm run dev -- --host 0.0.0.0
