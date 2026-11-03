# pgvector-postgis

PostgreSQL image with both [pgvector](https://github.com/pgvector/pgvector) and
[PostGIS](https://postgis.net/), built on top of the official
`pgvector/pgvector` image (Debian bookworm). Entrypoint, environment variables
and data layout are identical to the official `postgres` image.

## Tags

| Tag | Contents |
|---|---|
| `ghcr.io/schellevis/pgvector-postgis:pg18` | PostgreSQL 18 + pgvector + PostGIS 3, bookworm |
| `ghcr.io/schellevis/pgvector-postgis:pg18-bookworm` | same |

Platforms: `linux/amd64`, `linux/arm64`. Rebuilt weekly to pick up upstream updates.

## Usage

```yaml
services:
  postgres:
    image: ghcr.io/schellevis/pgvector-postgis:pg18
    environment:
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - ./data:/var/lib/postgresql
```

Then, per database:

```sql
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS postgis;
```
