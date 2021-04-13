Usage
=====
>`>` docker run -d --rm -v C:\jct\Repos\Volumes\hydra:c:/hydra-data veni-vidi-vici/hydra-1.10.1-sqlite:nanoserver-20H2<br>
>`>` docker run -it --rm -v C:\jct\Repos\Volumes\hydra:c:/hydra-data veni-vidi-vici/hydra-1.10.1-sqlite:nanoserver-20H2 cmd

Any service with the 'build' attribute specified will be built and tagged with the name in the 'image' attribute. (-f [--file])
>`>` docker-compose -f docker-compose.yml -f docker-compose.hydra.yml -f docker-compose.build.yml -f docker-compose.build.hydra.yml build [--no-cache]

Start the application. (-d [--detach])
>`>` docker-compose -f docker-compose.yml -f docker-compose.hydra.yml up -d

Stop the application.
>`>` docker-compose -f docker-compose.yml -f docker-compose.hydra.yml down

<br>

Useful Docker Commands
----------------------
**Security**<br>
If possible, run containers with non-Admin user account (nonroot user); i.e., use a least-privilege user account to run containers and set ACLs as narrowly as possible.<br>
*ContainerAdministrator* is the default user account for *Windows Server Core*.<br>
*ContainerUser* is the default user account for *Nano Server*.<br>
>`>` docker run veni-vidi-vici/hydra-1.10.1-sqlite:nanoserver-20H2 cmd /C echo %USERDOMAIN%\%USERNAME%

**Container**<br>
List running containers
>`PS>` docker container ls<br>
>`PS>` docker ps

List all containers
>`PS>` docker container ls -a

Remove given container (it must be stopped first)
>`PS>` docker rm [container-name-or-id]

Remove all containers (active and non-active)
>`PS>` docker container ls -aq | foreach { docker rm -f $_ }

Kill a running container
>`PS>` docker container kill [container-name-or-id]

**Image**<br>
List local images
>`PS>` docker image ls

Remove given image (force removal)
>`PS>` docker image rm -f [image-name-or-id]

Remove images with TAG=<none>
>`PS>` docker rmi $(docker images -f "dangling=true" -q)

<br>

ORY Hydra Quick Reference Guide
===============================
ORY Hydra Information
---------------------
Check Hydra Version
>`C:\>` docker run --rm --entrypoint hydra veni-vidi-vici/hydra-1.10.1-sqlite:nanoserver-20H2 version

Display all environment variables that can be set. Equivalent to **hydra help serve**.<br>
>`C:\>` docker run --rm --entrypoint hydra veni-vidi-vici/hydra-1.10.1-sqlite:nanoserver-20H2 help serve

Deployment of ORY Hydra
-----------------------
If the configuration key dsn (Data Source Name) is prefixed with sqlite://, then SQLite will be used as the storage backend. The _fk parameter must be set to true for foreign keys to work (
https://www.ory.sh/docs/ecosystem/deployment); e.g., sqlite://**C:/database_path_in_container/filename.sqlite**?_fk=true
>`>` SET DSN=sqlite://C:/hydra-data/db.sqlite?_fk=true

The system secret can only be set against a fresh database. Key rotation is currently not supported. This secret is used to encrypt the database and needs to be set to the same value every time the process starts. The length of the system secret must be equal or greater than 16 characters.
>`>` SET SECRETS_SYSTEM=this_needs_to_be_the_same_always_and_also_very_$3cuR3-._

Display the value of the environment variables.
>`C:\>` echo %DSN% & echo %SECRETS_SYSTEM%

Running the SQL migration is required when installing a new version of ORY Hydra or upgrading an existing installation. Equivalent to **hydra migrate sql --yes sqlite://C:/hydra-data/db.sqlite?_fk=true**.
>`C:\>` docker run --rm --entrypoint hydra -v C:\jct\Repos\Volumes\hydra:c:/hydra-data veni-vidi-vici/hydra-1.10.1-sqlite:nanoserver-20H2 migrate sql --yes %DSN%

Run the ORY Hydra Server
------------------------

Ensure that there are no conflicts with existing docker containers or other open ports. Please make sure that ports 9000, 9001, 9010, 9020 are open.

If the result of the command lists open ports, you must kill the command that listens on that port first. Next you should check if any existing ORY Hydra Docker container is running. If there is one, you should kill that Docker container.


>`C:\>` netstat -an | findstr /r "9000 9001 9010 9020"

docker network create -d bridge hydraguide

>`C:\>` docker run -d --network natoauth --entrypoint hydra -p 9000:4444 -p 9001:4445 -e SECRETS_SYSTEM=%SECRETS_SYSTEM% -e DSN=%DSN% -e URLS_SELF_ISSUER=https://localhost:9000/ -e URLS_CONSENT=http://localhost:9020/consent -e URLS_LOGIN=http://localhost:9020/login veni-vidi-vici/hydra-1.10.1-sqlite:nanoserver-20H2 serve all


