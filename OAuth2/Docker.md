Usage
=====
>`>` docker run -d --rm -v C:\jct\Repos\Volumes\hydra:c:/hydra-data veni-vidi-vici/hydra-1.10.1-sqlite:nanoserver-20H2<br>
>`>` docker run -it --rm -v C:\jct\Repos\Volumes\hydra:c:/hydra-data veni-vidi-vici/hydra-1.10.1-sqlite:nanoserver-20H2 cmd

<br>

Useful Docker Commands
----------------------
**Container**<br>
List running containers
>`PS>` docker container ls
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

Hydra Quick Reference Guide
===========================
Hydra Information
-----------------
**Check Hydra Version**
>`OpenSSL>` version -a
