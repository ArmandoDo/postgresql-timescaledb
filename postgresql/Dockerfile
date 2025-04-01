FROM timescale/timescaledb-ha:pg15.2-ts2.10.0-latest

### Set up environment and install dependencies
USER root
RUN apt-get update && apt-get install gettext-base -y

### Set up the Postgresql image
USER postgres

# Scripts of configuration
COPY config/postgresql.conf /etc/postgresql/postgresql.conf
COPY config/pg_hba.conf /etc/postgresql/pg_hba.conf

# Scripts for the DB initialization
COPY config/create-users.sh /docker-entrypoint-initdb.d/100-create-users.sh
