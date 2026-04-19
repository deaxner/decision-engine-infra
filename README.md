# Decision Engine Infra

Infrastructure and operational wiring for the real-time decision platform.

This repository owns local and deployment configuration that crosses application boundaries.

## Responsibilities

- Docker Compose for local services.
- PostgreSQL service configuration.
- Redis service configuration.
- Mercure service configuration.
- Environment examples.
- Deployment notes.

## Services

- `postgres`
- `redis`
- `mercure`
- `api`
- `worker`
- `web`

## Local Dev Stack

Copy the shared env file first:

```bash
cp .env.example .env
```

Start the full stack:

```bash
docker compose up --build
```

Local entrypoints:

- Web UI: `http://127.0.0.1:5173`
- API: `http://127.0.0.1:8000`
- Mercure: `http://127.0.0.1:3001/.well-known/mercure`

The API container installs Composer dependencies if needed, waits for PostgreSQL, runs migrations, and serves Symfony on port `8000`. The worker installs dependencies if needed and consumes the `async` Messenger transport.

The web container runs Vite in dev mode on port `5173` and proxies `/api` requests to the `api` service inside Compose.

## Operations

Stop the stack:

```bash
docker compose down
```

Reset the stack, including PostgreSQL data:

```bash
docker compose down -v
```

Inspect logs:

```bash
docker compose logs -f api
docker compose logs -f worker
docker compose logs -f web
```

Mercure only pushes notifications. Result snapshots remain authoritative in the API and should still be read from `GET /sessions/{id}/results`.
