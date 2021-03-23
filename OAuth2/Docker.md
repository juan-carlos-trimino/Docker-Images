Usage
=====
Useful Docker Commands
----------------------
List local images
>`PS>` docker image ls

Remove given image (force removal)
>`PS>` docker image rm -f [container-name-or-id]

Remove given container (it must be stopped first)
>`PS>` docker rm [container-name-or-id]

Kill a running container
>`PS>` docker container kill [container-name-or-id]

List running containers
>`PS>` docker container ls
>`PS>` docker ps

List all containers
>`PS>` docker container ls -a

Remove all containers (active and non-active)
>`PS>` docker container ls -aq | foreach { docker rm -f $_ }

Remove images with TAG=<none>
>`PS>` docker rmi $(docker images -f "dangling=true" -q)

<br>
