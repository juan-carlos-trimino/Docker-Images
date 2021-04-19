# Usage
Windows
-------
>`\>` docker run -d --rm veni-vidi-vici/nats-subscriber-1.0.0:dotnet-5.0-nanoserver-20H2<br>
>`\>` docker run -it --rm veni-vidi-vici/nats-subscriber-1.0.0:dotnet-5.0-nanoserver-20H2 cmd

Any service with the 'build' attribute specified will be built and tagged with the name in the 'image' attribute. (-f [--file])
>`\>` docker build -t veni-vidi-vici/nats-subscriber-1.0.0:dotnet-5.0-nanoserver-20H2 ./Nats.Subscriber<br>
>`\>` docker-compose -f docker-compose.nats.yml -f docker-compose.build.nats.yml build [--no-cache]
>`\>` docker-compose -f docker-compose.yml -f docker-compose.nats.yml -f docker-compose.build.yml -f docker-compose.build.nats.yml build [--no-cache]

Start the application. (-d [--detach])
>`\>` docker-compose -f docker-compose.yml -f docker-compose.nats.yml up -d

Stop the application.
>`\>` docker-compose -f docker-compose.yml -f docker-compose.nats.yml down

Linux
-----
>`\>` docker build -t veni-vidi-vici/nats-subscriber-1.0.0:dotnet-5.0-alpine -f ./Nats.Subscriber/Dockerfile.k8s ./Nats.Subscriber<br>
>`\>` docker run -it --rm veni-vidi-vici/nats-subscriber-1.0.0:dotnet-5.0-alpine sh

<br>

Useful Docker Commands
----------------------
**Security**<br>
If possible, run containers with non-Admin user account (nonroot user); i.e., use a least-privilege user account to run containers and set ACLs as narrowly as possible.<br>
*ContainerAdministrator* is the default user account for *Windows Server Core*.<br>
*ContainerUser* is the default user account for *Nano Server*.<br>
>`\>` docker run mcr.microsoft.com/windows/nanoserver:20H2 cmd /C echo %USERDOMAIN%\\%USERNAME%<br>
>`\>` docker run mcr.microsoft.com/windows/servercore:20H2 cmd /C echo %USERDOMAIN%\\%USERNAME%

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
