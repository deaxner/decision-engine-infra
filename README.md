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

## Local Installation

Expected sibling checkout layout:

```text
projects/
  decision-engine-api/
  decision-engine-web/
  decision-engine-infra/
```

The Compose file bind-mounts `../decision-engine-api` into the `api` and `worker` containers, and `../decision-engine-web` into the `web` container.

Copy the shared env file first:

```bash
cp .env.example .env
```

Start the full stack:

```bash
docker compose up --build
```

The first startup can take a few minutes because the API and web containers install dependencies. The API container runs database migrations automatically.

Local entrypoints:

- Web UI: `http://127.0.0.1:5173`
- API: `http://127.0.0.1:8000`
- Mercure: `http://127.0.0.1:3001/.well-known/mercure`

These URLs use the committed `.env.example` defaults. If your local `.env` changes `WEB_PORT`, `API_PORT`, or `MERCURE_PORT`, use those host ports instead.

The API container installs Composer dependencies if needed, waits for PostgreSQL, runs migrations, and serves Symfony on port `8000`. The worker installs dependencies if needed and consumes the `async` Messenger transport.

The web container runs Vite in dev mode on port `5173` and proxies `/api` requests to the `api` service inside Compose.

## Demo Data And Login

Seed the local database after the stack is running:

```bash
docker compose exec api php bin/console app:seed:demo-data
```

If the database already has users or workspaces, recreate the demo dataset from scratch:

```bash
docker compose exec api php bin/console app:seed:demo-data --reset
```

Primary demo login:

```text
Email: alex@demo.local
Password: Decision123!
```

Additional seeded users all use the same password:

```text
bianca@demo.local
carlos@demo.local
dina@demo.local
emma@demo.local
farid@demo.local
gia@demo.local
hugo@demo.local
ines@demo.local
jules@demo.local
```

The seed creates demo workspaces, members, draft/open/closed sessions, options, votes, and result snapshots. Use `--reset` only for disposable local data because it truncates the decision tables.

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
