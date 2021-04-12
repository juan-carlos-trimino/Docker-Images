# Usage
>`>` docker image build --tag veni-vidi-vici/nats-publisher-1.0.0:2.2-runtime-nanoserver-1903 ./Nats.Publisher

>`>` docker container run --rm --detach veni-vidi-vici/postgres-9.6:nanoserver-20H2

>`>` docker container run --rm -it veni-vidi-vici/postgres-9.6:nanoserver-20H2 -v C:\jct\Repos\Volumes\postgresql:C:/postgresql-data cmd


to check your PostgreSQL version:
postgres --version
postgres -V


PostgreSQL Quick Reference Guide
================================
To start PostgreSQL with: database=hydra; user=hydra; password=$3cuR3.
>`PS>` docker run -d --rm veni-vidi-vici/postgres-9.6.21:nanoserver-20H2 -e POSTGRES_DB=hydra -e POSTGRES_USER=hydra -e POSTGRES_PASSWORD=s3cuR3 -v C:\jct\Repos\Volumes\postgresql:C:/postgresql-data

<br>

