# pgvector-postgis

PostgreSQL image with both [pgvector](https://github.com/pgvector/pgvector) and
[PostGIS](https://postgis.net/), built on top of the official
`pgvector/pgvector` image (Debian bookworm). Entrypoint, environment variables
and data layout are identical to the official `postgres` image, so it can
replace `pgvector/pgvector:pg18-bookworm` on an existing data directory.

## Tags

| Tag | Moves? | Contents |
|---|---|---|
| `pg18`, `pg18-bookworm` | yes, every build | PostgreSQL 18 + pgvector + PostGIS 3.7.x, Debian 12 |
| `pg18-bookworm-postgis3.7.0` | yes, until the next PostGIS patch | same, specific PostGIS release |
| `pg18-bookworm-YYYYMMDD` | no | snapshot of one build, use this (or a digest) to pin / roll back |

Image: `ghcr.io/schellevis/pgvector-postgis`. Platforms: `linux/amd64`, `linux/arm64`
(only amd64 is tested in CI).

## What gets updated, and what doesn't

- A scheduled build runs every Monday without build cache, so it picks up a new
  `pgvector/pgvector:pg18-bookworm` base (PostgreSQL minor releases, pgvector
  releases, Debian security updates) and PostGIS **patch** releases.
- PostgreSQL itself always comes from the base image; installing PostGIS is not
  allowed to upgrade it (`apt-mark hold`).
- PostGIS minor/major versions (e.g. 3.7 → 3.8) are only changed deliberately via
  `POSTGIS_VERSION` in the Dockerfile and `EXPECT_POSTGIS` in the workflow. Once
  the PostGIS packages repository drops 3.7, the build fails instead of silently
  switching; previously pushed images remain available.
- CI fails if the image is not Debian 12 / glibc 2.36 / PostgreSQL 18, so a base
  OS switch (which changes libc collations) can't slip in unnoticed.

After a pgvector or PostGIS update you can optionally run, per database:

```sql
ALTER EXTENSION vector UPDATE;
SELECT postgis_extensions_upgrade();
```

## Usage

```yaml
services:
  postgres:
    image: ghcr.io/schellevis/pgvector-postgis:pg18-bookworm-YYYYMMDD
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
