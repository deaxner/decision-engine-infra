FROM composer:2 AS composer

FROM php:8.5-cli-bookworm

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        libcurl4-openssl-dev \
        libicu-dev \
        libpq-dev \
        libzip-dev \
        postgresql-client \
        unzip \
        zip \
    && docker-php-ext-install \
        curl \
        intl \
        pdo_pgsql \
        pgsql \
        zip \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer /usr/bin/composer /usr/local/bin/composer
COPY docker/api/start-api.sh /usr/local/bin/start-api
COPY docker/api/start-worker.sh /usr/local/bin/start-worker
RUN chmod +x /usr/local/bin/start-api /usr/local/bin/start-worker

WORKDIR /app
