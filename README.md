# Postgres with xid_wraparound Docker Images

This repository contains Docker images for Postgres with the [xid_wraparound](https://github.com/postgres/postgres/tree/master/src/test/modules/xid_wraparound) extension enabled.

The images are available on Docker Hub at [hundredwatt/postgres-xid_wraparound](https://hub.docker.com/repository/docker/hundredwatt/postgres-xid_wraparound/).

# Available Tags

* `17beta2-bookworm`, `17beta2` - PostgreSQL 17beta2 debian bookworm-slim image with xid_wraparound extension enabled

# Usage

Run the container locally and simulate transaction wraparound:

```bash
docker run -P -d -e POSTGRES_PASSWORD=password hundredwatt/postgres-xid_wraparound:17beta2
docker ps # get the port that the container is running on

PGPASSWORD=password psql -U postgres -h 0.0.0.0 -p <port>
postgres=# SELECT consume_xids((2 ^ 31)::bigint);
```

# Building

To build the images locally:

```bash
 docker build -t hundredwatt/postgres-xid_wraparound:17beta2-bookworm -f postgres-xid_wraparound/17beta2-bookworm.dockerfile .
 docker push hundredwatt/postgres-xid_wraparound:17beta2-bookworm
```

# Demo

Simulate transaction ID exhaustion in 7 seconds:

![Wraparound Demo GIF](https://github.com/hundredwatt/postgres-xid_wraparound/blob/main/docs/wraparound-demo.gif)
