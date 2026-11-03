ARG PG_MAJOR=18
ARG DEBIAN_RELEASE=bookworm
FROM pgvector/pgvector:pg${PG_MAJOR}-${DEBIAN_RELEASE}

ARG PG_MAJOR
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      postgresql-${PG_MAJOR}-postgis-3 \
      postgresql-${PG_MAJOR}-postgis-3-scripts \
 && rm -rf /var/lib/apt/lists/*
