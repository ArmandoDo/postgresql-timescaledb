# Postgresql and TimescaleDB on DOcker

This repo contains the scripts to build and install the dockerize
version of Postgresql and TimescaleDB.

Requirements:
 - Ubuntu or MacOS
 - Docker Compose V2

## Set up the `.env` file
Copy the `.env.tmpl` file and modify your environment variables:

```bash
cp .env.tmpl .env
```

```bash
# Password for the "postgres" user
export POSTGRES_PASSWORD="postgres_pass"
# Password for the "admin" user
export ADMIN_PASSWORD="admin_pass"
```

## Deploy Postgresql and TimescaleDB

### 1. Build the Dockerize version of Postgresql
Run the script to build the Docker image of Postgresql:

**Note:** Once the image is built, there's no need to run the script again.

```bash
./build-postgresql.sh
```

### 2. Install Postgresql
Run the script to install the Docker image of Postgresql:

```bash
./install-postgresql.sh
```

### 3. Verify the status of the Postgresql container
Take a look at the logs of Postgresql service with:

```bash
docker logs postgresql
```

