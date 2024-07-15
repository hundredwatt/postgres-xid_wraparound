# Temporary build stage to build the xid_wraparound extension
FROM debian:bookworm-slim AS build

# Download Postgres REL_17_STABLE branch
RUN apt-get update && apt-get install -y unzip wget
RUN wget https://github.com/postgres/postgres/archive/refs/heads/REL_17_STABLE.zip -O postgres.zip && \
    unzip postgres.zip

# Install Postgres build dependencies, source: https://wiki.postgresql.org/wiki/Compile_and_Install_from_source_code
RUN apt-get install -y build-essential libreadline-dev zlib1g-dev flex bison libxml2-dev libxslt-dev libssl-dev libxml2-utils xsltproc ccache pkg-config

# Build Postgres and xid_wraparound extension
RUN cd postgres-REL_17_STABLE && ./configure && make && \
    cd src/test/modules/xid_wraparound && make


# Final stage to install the xid_wraparound extension in
FROM postgres:17beta2 AS final

COPY --from=build /postgres-REL_17_STABLE/src/test/modules/xid_wraparound/xid_wraparound.so /usr/lib/postgresql/17/lib/xid_wraparound.so
COPY --from=build /postgres-REL_17_STABLE/src/test/modules/xid_wraparound/xid_wraparound.control /usr/share/postgresql/17/extension/xid_wraparound.control
COPY --from=build /postgres-REL_17_STABLE/src/test/modules/xid_wraparound/xid_wraparound--1.0.sql /usr/share/postgresql/17/extension/xid_wraparound--1.0.sql

RUN echo "CREATE EXTENSION xid_wraparound;" > /docker-entrypoint-initdb.d/xid_wraparound.sql


