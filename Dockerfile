ARG PG_MAJOR=18
ARG DEBIAN_RELEASE=bookworm
FROM pgvector/pgvector:pg${PG_MAJOR}-${DEBIAN_RELEASE}

ARG PG_MAJOR
# PostGIS major.minor; patch releases are picked up automatically,
# a minor/major bump has to be made here on purpose.
ARG POSTGIS_VERSION=3.7

# Keep the PostgreSQL server/client from the base image: installing PostGIS
# must never upgrade PostgreSQL itself.
RUN set -eux; \
    apt-mark hold "postgresql-${PG_MAJOR}" "postgresql-client-${PG_MAJOR}" libpq5; \
    apt-get update; \
    pkg="postgresql-${PG_MAJOR}-postgis-3"; \
    ver="$(apt-cache madison "$pkg" | awk '{print $3}' | grep -E "^${POSTGIS_VERSION}\.[0-9]+" | head -1)"; \
    [ -n "$ver" ] || { echo "no $pkg ${POSTGIS_VERSION}.x available" >&2; exit 1; }; \
    apt-get install -y --no-install-recommends "$pkg=$ver" "${pkg}-scripts=$ver"; \
    apt-mark hold "$pkg" "${pkg}-scripts"; \
    rm -rf /var/lib/apt/lists/*
