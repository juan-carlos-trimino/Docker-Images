***
# [Docker Desktop](https://dockr.ly/docker-for-windows)
- Browse to the `Desktop` homepage and install the *`stable`* version.<br>
- Docker Desktop can run Windows and Linux containers.

<br>

***
# [Docker](https://docs.docker.com/)
Docker provides *an abstraction over the physical machine*; it not only packages the application and all its dependencies, but simplifies distribution as well.

## Notes
1. Docker is built from open source components and has two versions: Community Edition (CE) and Enterprise Edition (EE). Docker CE is free and has monthly releases; Docker EE is a paid subscription that comes with extended features and support, and it has quarterly releases.
2. Docker follows a client-server architecture. The Docker client communicates with the Docker daemon/service running on the Docker host over a REST API to perform operations on Docker images and containers.
3. The Docker daemon supports listening on three types of sockets: UNIX (default), TCP, and FD (file descriptor); only enabling TCP sockets allow the Docker client to communicate with the daemon remotely.
4. Docker logging is powerful and pluggable, but it only reads log entries from the container's **`console output stream`**.
5. Windows Versions<br>
   Because applications in [Windows Server](https://hub.docker.com/_/microsoft-windows-servercore) containers run processes directly on the host, the version of Windows on the server **`needs to match`** the version of Windows inside the container. But if the applications are running in Hyper-V containers, the version of Windows on the server does not need to match the version of Windows inside the container.
6. [Nano Server](https://hub.docker.com/_/microsoft-windows-nanoserver) is a minimal operating system built for running apps in containers. It is not a full version of Windows, and it can't be run as the OS on a VM or a physical machine. Furthermore, not all Windows apps can run in a Nano Server container.

### Version and Info
To verify the installation.<br>
(It displays the versions for the Docker `client` (CLI) and the Docker `server` (the service that manages containers).
>`\>` docker version

>`\>` docker -v

>`\>` docker info

<br>

***
# [Docker Compose](https://docs.docker.com/compose/compose-file/)
## Notes
1. Docker Compose works with services and applications. An application is a single unit composed of one or more services; services are deployed as containers at runtime. Docker Compose is used to define all of the resources of an application -- services, networks, volumes, etc. -- and the dependencies among them. Since a container is a single instance of an image, a service is a template to run a container from an image with a known configuration. By using services, an application can scale up or down the number of containers running from the same image and using the same configuration as a single unit. Services are used in Docker Compose and with a cluster of Docker Engines running in Docker Swarm; services are not used in a standalone Docker Engine.
2. Since Docker Compose **`doesn't guarantee the order in which containers are created`**, start-up dependencies among services have to be captured in the service definition with the `depends_on` attribute. Capturing dependencies with this attribute is acceptable for a distributed application running on a single machine, but it doesn't scale. When running on a cluster, an orchestrator is required to manage distributing the workload.<br>
   Note:<br>
    Capturing dependencies like this is fine for running distributed applications on a single machine, but **`it doesn't scale`**. When you're running in a cluster you want the orchestrator to manage distributing the workload. It can't do that effectively if you have explicit dependencies, because it needs to make sure all the containers running the dependent service are healthy before it starts the consuming containers. See Docker Swarm.
3. After executing the `docker-compose up` command, containers can be managed using the Compose CLI or the standard Docker CLI.
4. The Docker Compose file represents the desired state of the application. When a docker-compose command is executed, it compares the Composite file to the existing state of the application in Docker and makes any changes needed to get the desired state; e.g., starting containers, stopping containers, creating volumes, etc.
5. All Docker Compose commands are processed by comparing the Compose file to the services running on Docker; hence, it is required to have access to the Compose file to run any Docker Compose commands.
6. If `docker-compose up` is run repeatedly from the same Compose file, no changes will be made after the first run since the definition of the application has not changed; hence, Docker Compose can be used to manage application upgrades.
7. Docker Compose supports override files. When running `docker-compose` commands, the commands can accept multiple files as arguments; Compose will join all of the files together in the order specified in the command from left to right. Override files are used to add new sections to the application definition, or they can replace existing definitions. (The default configuration is designed for development use.)
8. *Be careful when modifying Compose files of running applications.* If the definition of a running service is removed from the Compose file, Docker Compose will not recognize that the removed service is part of the application, and the containers created from the removed service will not be included in the difference checks. This results in orphaned containers.
9. ***Warning!!!*** Ports can be specified without quotes, but this is best avoided as it can cause confusion when YAML parses statements such as 56:56 as a base 60 number.

### Start the application
The **`up`** command creates resources specified in the Compose file that do not exist, and it creates and starts containers for all the services.
>`\>` docker-compose up -d

### Scale a container
>`\>` docker-compose up -d --scale [container-name-or-id]=2

### Stop the application
The **`down`** command stops all running containers and removes the resources. Networks are removed, if they were created by Docker Compose, but volumes are not removed thereby retaining all application data.
>`\>` docker-compose down

### Stop all running containers
The **`stop`** command stops all running containers without removing them or other resources. Stopping a container ends the running process with a graceful shutdown.
>`\>` docker-compose stop

### Stop a container
>`\>` docker-compose stop [service-name]

### Kill all containers
The **`kill`** command stops all containers by forcibly ending the running processes.
>`\>` docker-compose kill

### Start all stopped containers
The **start** command starts all stopped containers via the entry point of the containers.
>`\>` docker-compose start

### List all running containers
>`\>` docker-compose ps

### Check memory and CPU usage of all running containers
>`\>` docker-compose top

### Display the log entries of all runninng containers
>`\>` docker-compose logs<br>
>`\>` docker-compose logs --tail 5

<br>

***
# Images
## Notes
1. A Docker image is a file that packs the application and all its dependencies for distribution and is built with multiple layers; the image version is commonly known as a *tag*.
2. A Docker *registry* is where Docker images are stored for distribution; as a best practice, always tag the image before pushing it to a registry.
3. A running instance of a Docker image is called a *container* and multiple Docker containers can be created from a single image.
4. When identifying a container/image by its id, **`there is no need to specify the entire id`**; specify enough characters to uniquely identify it.
5. When the `docker build` command is run to build a Docker image, Docker creates a layer for each instruction in the corresponding Dockerfile that modifies the filesystem of the base image.
6. Each layer in a Docker image is *read-only* and has a unique identifier; layers stack on top of each other adding functionality incrementally. When a container is created from an image, Docker adds a *writable* layer on top of all of the read-only layers. This layer is known as the *container layer*. All writes from the container while it's running are written to this layer, but because containers are immutable, all data written to this layer are lost after the container is removed.
7. *If a file is deleted in the same layer that it's created, it won't be included in the image.* Because of this, Dockerfiles often download a tarball or other archive file, unpack it, and immediately remove the archive file in one RUN instruction.

### Building images
**name-of-container-image = {user-name-of-registry}/{app-name}**
>`\>` docker image build --tag [name-of-container-image][:version-or-variation] .<br>
>`\>` docker image build --file Dockerfile.nats --tag [name-of-container-image][:version-or-variation] .<br>
>`\>` docker image build --build-arg ENV_NAME=TEST --tag [name-of-container-image][:version-or-variation] .

**When a build fails, it can be very useful to launch the layer before the failure**
>`\>` docker container run --rm -it [image-id]

### Tagging
**Tagging an image under an additional tag; creates an additional tag for the image**
>`\>` docker tag [old-image-tag] [new-image-tag]

### Pushing the image to Docker Hub
**Login to Docker Hub; need `userId` and `password`**
>`\>` docker login<br>
>`\>` docker push [image-tag]

### Displaying
**Display the full set of layers that make up an image**
>`\>` docker history [image-name-or-id]

### Listing
**List images**
>`\>` docker image ls<br>
>`\>` docker images<br>
>`\>` docker image ls --all<br>
>`\>` docker image ls -a<br>
>`\>` docker image ls --filter reference=[name-of-container-image][:version-or-variation]<br>
>`\>` docker image ls --filter reference=[name-of-container-image]

**List untagged images (dangling - TAG=<none>)**
>`\>` docker images -f "dangling=true"

**List untagged image ids (dangling - TAG=<none>)**
>`\>` docker images -f "dangling=true" -q

### Removing
**Remove given image**
>`PS>` docker image rm [container-name-or-id]

**Remove unused images**
>`\>` docker image prune

**Do not prompt for confirmation (-f -> --force)**
>`\>` docker image prune -f

**Remove all unused images, not just dangling ones (-a -> --all)**
>`\>` docker image prune -a

**Remove given image (force removal)**
>`PS>` docker image rm -f [container-name-or-id]

**Remove images with TAG=<none>**
>`PS>` docker rmi $(docker images -f "dangling=true" -q)

**Remove all images**
>`PS>` docker image ls -aq | foreach { docker rmi -f $_ }

**Remove all untagged images**
>`PS>` docker rmi $(docker images -f "dangling=true" -q) -f

**Remove all images older than 6 months --> 4320h = 24 hour/day * 30 days/month * 6 months**
>`\>` docker image prune --all --filter "until=4320h"

<br>

***
# Containers
## Notes
1.	From the Docker Desktop menu, select which daemon (Linux or Windows) the Docker CLI uses. Select **Switch to Windows containers...** to use Windows containers, or select **Switch to Linux containers...** to use Linux containers (the default).
2. Windows 10–1809 ("October 2018 Update") + Docker engine 18.09.1 + the Windows 1809 base images from Dockerhub are the first combination that allows to run **real** Windows containers on Windows 10, without hyperv virtualization.  
   **https://docs.microsoft.com/en-us/virtualization/windowscontainers/deploy-containers/version-compatibility**

   Select a Windows base image from Dockerhub that **matches** the kernel of your host's Windows version. For Windows 10–1809, that's the :1809 version/tag of nanoserver, servercore and windows (or any higher-level image, that builds up on one of these).

   To find the version of Windows<br>
   **C:\>** winver<br>
        *Windows 10<br>
        Microsoft Windows<br>
        Version 1903 (OS Build 18362.295)*<br>

   By infinitely running ping (-t) against the localhost in a Windows nano server container in process-isolation mode (`--isolation=process`), `ping.exe` is directly running on the host (instead of a virtual machine); this is why it can be seeing in the host system's task manager while the container is running:
    >`\>` docker run --rm --name pinger --isolation=process mcr.microsoft.com/windows/nanoserver:1903 cmd.exe /c ping 127.0.0.1 -t

    (Since Linux containers always run with the process-isolation mode of `--isolation=process`, there is no need to specify the process-isolation mode.)
3. When Docker runs a container, it starts the process specified in the Dockerfile or the command line; Docker watches that process, and when that process ends, the containers exits. But if the application starts multiple processes in a container, Docker will only monitor the last process that started. Ideally, there will be one process per container; **this is a recommendation and not a requirement**. Otherwise, the application will have to take on the responsability of managing all other processes.
4. When identifying a container/image by its id, **there is no need to specify the entire id**; specify enough characters to uniquely identify it.
5. To exit a container while keeping it running in the background, **<kbd>Ctrl</kbd>PQ or <kbd>Ctrl</kbd>+<kbd>Shift</kbd>pq**.

### Running containers
**`docker run`** is the short form of **`docker container run`**.<br><br>
**Task container**<br>
Display the host name of a Windows Nano Server container; the container ID **is** the container's hostname.
>`\>` docker run mcr.microsoft.com/windows/nanoserver:20H2 hostname

>`\>` docker run [name-of-container-image][:version-or-variation]

>`\>` docker run --name source image-share-volume ...

>`\>` docker run -it --volumes-from source image-share-volume cmd

>`\>` docker run -it --volumes-from source:ro image-share-volume cmd

>`\>` docker run --volume {host-location-must-exist}:{container-location-does-not-need-to-exist-but-hidden-if-it-does} image-share-volume ...

**Interactive container**<br>
The `-t` and `-i` options enable terminal redirection for interactive text-based programs. The `-t` option allocates a `pseudo-tty (terminal)` and attaches it to the standard input of the container. The `-i` option keeps the `standard input (STDIN)` of the container open, even if not attached, so the main process can continue waiting for input.
>`\>` docker run --interactive --tty [name-of-container-image][:version-or-variation] cmd

>`\>` docker run -it --name [container-name] [name-of-container-image][:version-or-variation] cmd

**Detach container**
>`\>` docker run --detach [name-of-container-image][:version-or-variation]

>`\>` docker run --detach --publish {host-port}:{container-port} [name-of-container-image][:version-or-variation]

>`\>` docker run -d -p {host-port}:{container-port} [name-of-container-image][:version-or-variation]

### IDs and Names
**Get the container id**
>`\>` docker ps --filter "[name=container-name]" --format "{{ .ID }}"

**Names of all running containers**
>`PS>` docker inspect -f '{{.Name}}' $(docker ps -q)

### Listing
**List all active containers**
>`\>` docker container ls

>`\>` docker ps

**List all containers**
>`\>` docker container ls --all

>`\>` docker container ls -a

### Pausing
Pausing a container will not remove its writable layer, and the data already written remains unchanged. Docker removes the data written to the container layer only when the container is removed.
>`\>` docker pause [container-name-or-id]

Because the `docker pause` command doesn't make the process(es) running in the container restart when unpausing the container, any data written to the container's memory also remains unchanged. To return the container to its running state.
>`\>` docker unpause [container-name-or-id]

### Stopping/Removing/Killing
**Stop a running container**<br>
When a `docker stop` command is issued, Docker sends a `SIGTERM` signal to the main process in the container and waits up to ten (10) seconds for the main process to stop. If the main process doesn't comply with the request within the timeout period, Docker sends a `SIGKILL`. Whereas the main process can ignore a `SIGTERM`, the `SIGKILL` goes straight to the kernel thereby terminating the main process; the main process is forcibly killed without having an opportunity to exit gracefully. To ensure a gracefully exit, the main process needs to handle the `SIGTERM` signal. To change the default 10 seconds to wait, use the --time (-t) option.
>`\>` docker container stop [container-name-or-id]

>`\>` docker container stop --time=20 [container-name-or-id]

**Stop all running containers**
>`PS>` docker ps -q | foreach { docker stop $_ }

**Stop and remove all running containers**
>`PS>` docker ps -q | foreach { docker stop $_; docker rm $_ }

**Remove all containers (active and non-active)**
>`PS>` docker container ls -aq | foreach { docker rm -f $_ }

**Kill a running container**
>`\>` docker container kill [container-name-or-id]<br>
>`\>` docker container kill -s=1 [container-name-or-id]

**Remove all stopped containers**
>`\>` docker container prune

**Do not prompt for confirmation (-f -> --force)**
>`\>` docker container prune -f

### IP Addresses and Ports
**IP Address**
>`\>` docker inspect -f '{{.NetworkSettings.Networks.nat.IPAddress}}' [container-name-or-id]

>`PS>` docker container inspect --format '{{ .NetworkSettings.Networks.nat.IPAddress }}' [container-name-or-id]

**Publish all of the exposed ports from the container image to random ports on the host**
>`\>` docker run -d --publish-all -v c:\app-state:c:\app-state --name appv1 [name-of-container-image][:version-or-variation]

>`\>` docker run -d -P -v c:\app-state:c:\app-state --name appv1 [name-of-container-image][:version-or-variation]

**Ports**
>`\>` docker container port [container-name-or-id]

>`\>` docker inspect [container-name-or-id]

### Displaying
**Display the timestamp**
>`\>` docker container logs -t [container-name-or-id]

**Display the labels**
>`PS>` docker container inspect -f '{{ json .Config.Labels }}' [container-name-or-id] | ConvertFrom-Json

**Display current restart count**
>`PS>` docker container inspect -f '{{ .RestartCount }}' $(docker ps -q)

**Display the Healthcheck logs**
>`\>` docker inspect --format '{{ json .State.Health }}' [container-name-or-id] | ConvertFrom-Json | ConvertTo-Json

### Logging/Streaming
**Logging containers**
>`\>` docker container logs [container-name-or-id]

>`PS>` docker container logs [container-name-or-id] | where { $_ -like '*Error *' }

**Stream the logs from a running container (*Ctrl+C to exit*)**
>`\>` docker container logs -f [container-name-or-id]

**Stream events (*Ctrl+C to exit*)**
>`\>` docker events

>`\>` docker events --since '2019-10-23T15:49:29'

>`\>` docker events --since '2019-10-23T00:35:30' --until '2019-10-23T00:36:05'

>`\>` docker events --filter 'event=stop'

>`\>` docker events --filter '[container=container-name-or-id]' --filter 'event=stop'

**Return a live stream of stats from the list of running containers on the host (*Ctrl+C to exit*)**
>`\>` docker stats [container-name-or-id] [container-name-or-id] [...]

**Return a live stream of stats from `all` running containers on the host (*Ctrl+C to exit*)**<br>
The `docker ps` gets the IDs of all running containers.<br>
The IDs are used as input to `docker inspect` to obtain the names.<br>
The names are used as input `docker stats`.
>`PS>` docker stats \$(docker inspect --format '{{ .Name }}' $(docker ps -q))

### Inspecting
**Verify the container started without errors.**
>`\>` docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}'

**Mounts**
>`PS>` docker container inspect --format '{{ json .Mounts }}' [container-name] | ConvertFrom-Json

### Resources usage
**Processes, memory, CPU**
>`\>` docker container top [container-name-or-id]

### Stats
**Stats on all running containers**
>`PS>` docker stats $(docker ps -q)

<br>

***
# Volumes
### Creation
**Create a volume**
>`\>` docker volume create [volume-name]

### Removal
**Remove a volume**
>`\>` docker volume rm [volume-name-or-id]

**Remove all volumes**
>`PS>` docker volume ls | foreach { docker volume rm -f $_ }

**Remove all unused local volumes; i.e., volumes which are not referenced by any containers**
>`\>` docker volume prune

**Do not prompt for confirmation (-f -> --force)**
>`\>` docker volume prune -f

### Listing
**List all volumes**
>`\>` docker volume ls

**List all volumes not referenced by any containers (-f -> --filter)**
>`\>` docker volume ls -f dangling=true

### Location
**Location where the data is physically stored on the host**
>`\>` docker volume inspect --format '{{ .Mountpoint }}' [volume-name]<br>
>`\>` docker volume inspect -f '{{ .Mountpoint }}' [volume-name]

### Displaying
**Display the Name and Driver entries separated by a colon for all volumes**
>`\>` docker volume ls --format "{{.Name}}: {{.Driver}}"

### Inspecting
**Inspect a volume**
>`\>` docker inspect [volume-name-or-id]

<br>

***
# Networks
## Notes
1. Docker on Windows has several networking options. **The default is the network address translation (nat)**. This driver isolates containers from the physical network, and it assigns each container its own IP address in a subnet managed by Docker. On the host, containers can be accessed by their IP addresses, but outside the host, containers can be accessed only through published ports. With the nat driver, other networks can be created, or other drivers can be used for different network configurations:
   * Transparent driver - It gives each container an IP address provided by the physical router.
   * 12bridge driver - It specifies static containers IP addresses on the physical network.
   * Overlay driver - It runs distributed applications in Docker Swarm.
2. The use of **0.0.0.0** as IP address binds to **all network interfaces**, which is needed to allow the container to be accessed from the host or other containers.
3. When publishing ports to the host, Docker publishes to all interfaces (0.0.0.0) by default. By specifying the interface to bind explicitly, the attack surface is reduced since only traffic from the explicitly bound interface is allowed; e.g.,
    >`\>` docker container run -p 172.123.34.23:80:80 ...
4. The **hosts** file is an Operating System file that maps hostnames to IP addresses; it is a plain text file. It is located at **C:\Windows\System32\drivers\etc\hosts**.

### Creation
**Create a network**
>`\>` docker network create --driver [-d] nat [network-name]

### Removing
**Remove a network**
>`\>` docker network rm [network-name-or-id]

### Connection
**Connect container to network**
>`\>` docker network connect [network-name-or-id] [container-name-or-id]

### Disconnection
**Disconnect container from network**
>`\>` docker network disconnect [network-name-or-id] [container-name-or-id]

### Listing
**List Docker networks**
>`\>` docker network ls

### Inspecting
**Inspect a network**
>`\>` docker network inspect [network-name-or-id]

<br>

***
# [Dockerfile](https://docs.docker.com/engine/reference/builder/)
A Dockerfile is a mechanism to automate the building of container images. Building an image from a Dockerfile is a three-step process:
1. Create a working directory.
2. Write the Dockerfile.
3. Build the image.

## The Build Context
1. The **docker build** command requires a Dockerfile and a build context, which may be empty. The build context is the set of local files and directories that can be referenced from ADD or COPY instructions in the Dockerfile and is normally specified as a path to a directory.
2. Only the instructions **FROM**, **RUN**, **COPY**, and **ADD** create layers in the final image. Other instructions configure things, add metadata, or tell Docker to do something at run time, such as expose a port or run a command.

**Lines that begin with a `hash`, or `pound`, symbol (`#`) are comments.**<br>
**Instructions `are not case-sensitive`, but the convention is to make instructions all uppercase to improve visibility.**

**\# [escape](https://docs.docker.com/engine/reference/builder/#escape)=\`**<br>
Parser directives do not add layers to the build and will not be shown as a build step. Once a comment, empty line, or builder instruction has been processed, Docker no longer looks for parser directives. Hence, all parser directives must be at the very top of a Dockerfile.<br>
Use the ``backtick (`)`` option for the escape character to split commands over multiple lines rather than the default `backslash (\)` option.

**[ARG](https://docs.docker.com/engine/reference/builder/#arg) BASE_OS_LAYER**<br>
**ARG BASE_OS_LAYER_VERSION**<br>
**[FROM](https://docs.docker.com/engine/reference/builder/#from) \${BASE_OS_LAYER}:\${BASE_OS_LAYER_VERSION}**<br>
A Dockerfile must start with a **FROM** instruction. The **FROM** instruction specifies the Base Image from which you are building. **FROM** may only be preceded by one or more **ARG** instructions, which declare arguments that are used in **FROM** lines in the Dockerfile.

**[SHELL](https://docs.docker.com/engine/reference/builder/#shell)**<br>
The default shell on **Linux is ["/bin/sh", "-c"]** and on **Windows is ["cmd", "/S", "/C"]**.<br>
&nbsp;&nbsp;**/S** --> Modify the treatment of string after **/C** or **/K**.<br>
&nbsp;&nbsp;**/C** --> Carry out the command specified by string and then terminate.<br>
The **SHELL** instruction must be written in **JSON** form in a Dockerfile.<br>
The **SHELL** instruction is particularly useful on Windows where there are two commonly used and quite different native shells: **cmd** and **powershell** as well as alternate shells available including **sh**.<br>
The **SHELL** instruction can appear multiple times. Each **SHELL** instruction overrides all previous **SHELL** instructions and affects all subsequent instructions.<br>
The following instructions can be affected by the **SHELL** instruction when the shell form of them is used in a Dockerfile: **RUN**, **CMD**, and **ENTRYPOINT**.

**SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]**<br>
**-Command** executes the specified commands (and any parameters) as though they were typed at the Windows PowerShell command prompt, and then exits, unless the NoExit parameter is specified.<br>
**$ErrorActionPreference** determines how PowerShell responds to a non-terminating error (an error that does not stop a cmdlet processing) at the command line or in a script, cmdlet, or provider, such as the errors generated by the Write-Error cmdlet.<br>
**$ProgressPreference** determines how PowerShell responds to progress updates generated by a script, cmdlet or provider, such as the progress bars generated by the Write-Progress cmdlet.

**[ENV](https://docs.docker.com/engine/reference/builder/#env)**<br>
Settings added to the Dockerfile with **ENV** become **part of the image** so every container run from the image will have these values set. When you run a container, you can add new environment variables or replace the values of existing image variables using the **--env** or **-e** option.

To keep environment values safer, Docker lets you load them from a file rather than specifying them in plain text in the **docker container run** command. Isolating values in a file means that the file itself can be secured so that only administrators and the Docker service account can access it. The environment file is a simple-text format, with one line for each environment variable, written as a key-value pair. To run the container and load the file contents as environment variables, you can use the --env-file option. Note: Environment values still are not secure. If someone gains access to your app, he could print out all the environment variables and get your secrets.

**[WORKDIR](https://docs.docker.com/engine/reference/builder/#workdir)**<br>
The instruction sets the working directory for any subsequent **RUN**, **CMD**, **ENTRYPOINT**, **COPY**, and **ADD** instructions. If the working directory doesn't exist, it will be created even if it's not used in any subsequent Dockerfile instruction.

**[ADD](https://docs.docker.com/engine/reference/builder/#add)**<br>
The instruction copies from the build context in the host files or directories, or remote URLs from `source` and adds them to the filesystem of the image at the path `destination`.

**[COPY](https://docs.docker.com/engine/reference/builder/#copy)**<br>
The instruction copies files or directories from `source` (build context in the host) to the filesystem of the container at the path `destination`; the `destination` is an absolute path, or a path relative to **WORKDIR**. Paths outside the build context cannot be specified. Furthermore, the instruction copies files or directories from a previous stage to the current stage in a multi-stage build.

**[RUN](https://docs.docker.com/engine/reference/builder/#run)**<br>

**[VOLUME](https://docs.docker.com/engine/reference/builder/#volume)**<br>
Volumes are created and managed by Docker; volumes are units of storage. When a volume is created, it is stored within a directory on the host, which is managed by Docker (**/var/lib/docker/volumes/ on Linux** or **C:\ProgramData\docker\volumes on Windows**). Non-Docker processes should not modify this part of the filesystem. A given volume can be mounted into multiple containers simultaneously. When no running container is using a volume, the volume is still available to Docker and is not removed automatically. They have a separate life cycle to containers so they can be created independently and then mounted inside one or more containers. Volumes are the best way to persist data in Docker.

You specify volumes with a target directory, which is the location inside the container where the volume is mounted. When you run a container with a volume defined in the image, the volume is mapped to a physical location on the host, which is specific to that one container. More containers running from the same image will have their volumes mapped to a different host location.

When you mount a volume, it may be named or anonymous. Anonymous volumes are not given an explicit name when they are first mounted into a container; Docker gives them a random name that is guaranteed to be unique within a given host. Besides the name, named and anonymous volumes behave the same.

In **Windows**, volume directories need to be empty. In the Dockerfile, files cannot be created in a directory and then expose it as a volume. Furthermore, volumes need to be defined on a disk that exists in the image. In the Windows base images, there is only a **C** drive available, and volumes need to be created on the **C** drive.

Bind mounts have limited functionality compared to volumes. When a bind mount is used, a file or directory on the host is mounted into a container. The file or directory is referenced by its full or relative path on the host. By contrast, when a volume is used, a new directory is created within Docker's storage directory on the host, and Docker manages that directory's contents. You can't use Docker CLI commands to directly manage bind mounts.

To mount the host *c:\host_dir* folder to the container path *c:\container_dir*
>`\>` docker run –it --rm --name [mount1] -v c:\host_dir:c:\container_dir mcr.microsoft.com/windows/servercore:1903 powershell<br>
>`PS C:\>` Set-Location -Path .\container_dir;<br>
>`PS C:\cdir>` New-Item -Path .\LogFile.txt -ItemType File;<br>
>`PS C:\cdir>` Add-Content -Path .\LogFile.txt -Value 'Juan Carlos Trimiño';<br>
>`PS C:\cdir>` <kbd>Ctrl</kbd>+<kbd>Shift</kbd>pq

To see the file in the host
>`C:\>` dir c:\host_dir

To mount the host c:\host_dir folder to another container (mount2) path c:\container_dir
>`\>` docker run -it --rm --name mount2 --mount type=bind,source=c:\host_dir,target=c:\container_dir mcr.microsoft.com/windows/servercore:1903 powershell<br>
>`PS C:\>` Get-ChildItem -Path .\container_dir\ -File;<br>
>`PS C:\>` Get-Content -Path .\container_dir\LogFile.txt;<br>
>`PS C:\>` <kbd>Ctrl</kbd>+<kbd>Shift</kbd>pq

**[USER](https://docs.docker.com/engine/reference/builder/#user)**<br>
The instruction sets the user to use in any subsequent **RUN**, **CMD**, or **ENTRYPOINT** instructions.

**Security**<br>
There are two approaches to run a container *without* the root/administrator user.
- Use the USER instruction in the Dockerfile.
- Use the flag --user (-u) in the `docker run` command, which overrides the USER instruction in the Dockerfile.

**`Linux`**<br>
In most Linux distributions, the user with an *ID 0* is called the *root* (super, administrator) user. In the Linux kernel there are two types of processes, privileged and unprivileged processes. A privileged process runs with the user ID 0 (root), and an unprivileged process runs with a nonzero user ID. When performing an operation, a privileged process bypasses all the kernel-level permissions checks, but an unprivileged process is subject to permission checks.


In Linux, all Docker containers, by default, run as the **`root user`**; consequently, can an attacker having root access to a container do any damage to another container or host filesystem? 


Because Linux's namespaces partition kernel resources to ensure that each running process has its own independent view of those resources, the mount namespace (one of six namespaces) isolates a container filesystem from other containers filesystems as well as the host filesystem. That is, changes made as the root user within a container remains inside the container filesystem; however, when a volume (`VOLUME` instruction in Docker) is used to mount a location in the container filesystem to the host filesystem, the root user has full access to the mounted location; if running as non-root, it will not. Furthermore, if a user has access to a container running as root user, it can use its root privileges to install applications within the container to search for any vulnerability to exploit.


Containers use Linux namespaces to isolate themselves from the host on which they run. In
particular, the User namespace is used to make containers rootless. This namespace maps
user and group IDs so that a process inside the namespace might appear to be running under a
different ID.
Rootless containers use the User namespace to make application code appear to be running as
root. However, from the host's perspective, permissions are limited to those of a regular user.
If an attacker manages to escape the user namespace onto the host, then it will have only the
capabilities of a regular, unprivileged user.


It's important to set USER in all the Dockerfiles or change the user within an ENTRYPOINT or CMD instruction.

Failure to do so will result in `processes running as `**`root`**` within the container`. As UIDs are the same within a container and on the host, should attackers manage to break the container, they will have root access to the host machine.


**`Windows`**<br>
A user account uniquely identifies a principal who is using the computer system. The account signals the system to enforce the appropriate authorization to allow or deny the user access to resources. Whenever a user account is created, it is assigned a unique SID to identify the user account. No two users have the same SID. *All Windows processes are owned by a user account*.

*`Windows Server Core Images`*<br>
In a **`Windows Server Core`** container, the default user account is the container administrator (`User Manager\ContainerAdministrator`), and it has **complete access to the whole filesystem and all the resources on the container**. The process specified in the ENTRYPOINT or CMD instruction on the Dockerfile runs under this account; the `whoami` tool displays the current username.
>`C:\>` docker run mcr.microsoft.com/windows/servercore:20H2 whoami<br>
user manager\containeradministrator

To find the SID of the container administrator account, run an interactive container that allows interaction with PowerShell.
>`C:\>` docker run -it --rm mcr.microsoft.com/windows/servercore:20H2 powershell<br>
PS C:\\> $user = New-Object System.Security.Principal.NTAccount("containeradministrator"); \`<br>
\>\> $sid = $user.Translate([System.Security.Principal.SecurityIdentifier]); \`<br>
\>\> $sid.Value;<br>
**S-1-5-93-2-1**

Since the account is part of the `Windows Serve Core` image, the container user account always has the same SID (**S-1-5-93-2-1**); i.e., every container has the same attributes. The process running in the `Windows Server Core` container is actually running on the *Windows Server host*, but the host has **no ContainerAdministrator** user account. Obtain the *process ID* (*PID*) inside the container.
>`C:\>` docker run -d --rm --name pinger mcr.microsoft.com/windows/servercore:20H2 ping -t localhost<br>
>`C:\>` docker exec pinger powershell Get-Process ping -IncludeUserName<br>
```
Handles      WS(K)   CPU(s)     Id UserName               ProcessName
-------      -----   ------     -- --------               -----------
     88       3936     0.02   1620 User Manager\Contai... PING
```
This is a `Windows Server Core` container running on a Windows Server host, and since the process is running on the host, the PID inside the container will *match* the PID on the host. On the host, run the Get-Process cmdlet to display the details of the process running on the host. Because the container username **does not map** to any users on the host, the username under the column `UserName` is blank. That is, the host process is running under an **anonymous user** with no permissions on the host; it has only the configured permissions within the container. Hence, if an attacker breaks out of the container, it would be running a host process with no permissions on the host.
>`PS C:\>` Get-Process -Id 1620 -IncludeUserName
```
Handles      WS(K)   CPU(s)     Id UserName               ProcessName
-------      -----   ------     -- --------               -----------
     88       3930     0.04   1620                        PING
```

*`Windows Nano Server Images`*<br>
The `Nano Server` images use the *least-privilege* user account; i.e., the default user account is the container user (`User Manager\ContainerUser`), which has no administrator access inside the container. (The `Nano Server` base image is a stripped down version of Windows Server; it has a much smaller attack surface and requires fewer updates.)
>`C:\>` docker run mcr.microsoft.com/windows/nanoserver:20H2 cmd /C echo %USERDOMAIN%\%USERNAME%<br>
User Manager\ContainerUser

If an application does not require administrator access, set the USER instruction in the Dockerfile to `ContainerUser` to ensure the container process runs with the least-privilege account. But if the application requires write access to a file, set ACL permissions with a RUN instruction.
```
RUN $fileName = "C:\test\Service.log"; `
    $acl = Get-Acl -Path $fileName; `
    $acl.SetOwner([System.Security.Principal.NTAccount]('BUILTIN\[applicable-local-account]]')); `
    Set-Acl -Path $fileName -AclObject $acl; `
    Get-ChildItem -Path $fileName -Recurse | Set-Acl -AclObject $acl;
```
 **Always use the least-privilege user account and set ACLs as narrowly as possible.**

**[EXPOSE](https://docs.docker.com/engine/reference/builder/#expose)**<br>
The instruction informs Docker that the container listens on the specified network port at runtime; the port listens on **TCP** (default) or **UDP**.

The instruction does not actually publish the port. It functions as a type of documentation about which ports are intended to be published. To actually publish the port when running the container, use the **-p** (**--publish**) flag on **docker container run** to publish and map one or more ports, or the **-P** (**--publish-all**) flag to publish all exposed ports and map them to high-order ports. Containers in the same Docker network can always access one another's port; ports only need to be published to make them available outside Docker.

**[CMD](https://docs.docker.com/engine/reference/builder/#cmd)**<br>
The instruction has three forms:
1. The exec form, which is the prefer form: **CMD ["executable","param1","param2"]**
   * The exec form is parsed as a **JSON** array, which means that double-quotes (") must be used around words instead of single-quotes (').
   * Unlike the shell form, the exec form does not invoke a command shell. This means that normal shell processing does not happen. For example, **CMD ["echo", "$HOME"]** will not do variable substitution on **$HOME**. If shell processing is required, then either use the shell form or execute a shell directly; e.g., **CMD ["sh", "-c", "echo $HOME"]**. When using the exec form and executing a shell directly, as in the case of the shell form, it is the shell that is doing the environment variable expansion, not docker.
2. The default parameters to **ENTRYPOINT**: **CMD ["param1","param2"]**
   * If **CMD** is used to provide default arguments for the **ENTRYPOINT** instruction, both the **CMD** and **ENTRYPOINT** instructions should be specified with the **JSON** array format.
3. The shell form: **CMD command param1 param2**
   * If the shell form of the **CMD** is used, then **command** will execute in the current shell set by the **SHELL** instruction, or the default shell (see the **SHELL** instruction).

There can only be one **CMD** instruction in a Dockerfile. If more than one **CMD** instruction is used, then only the last **CMD** will take effect.

The **CMD** instruction is overridden by any arguments to *docker container run* after the image name.

**[HEALTHCHECK](https://docs.docker.com/engine/reference/builder/#healthcheck)**<br>
The options that can appear before **CMD** are:<br>
--interval=30s (default)<br>
&nbsp;&nbsp;The health check will first run 'interval' seconds after the container is started, and then again 'interval' seconds after each previous check completes.<br>
--timeout=30s (default)<br>
&nbsp;&nbsp;If a single run of the check takes longer than 'timeout' seconds, then the check is considered to have failed.<br>
--start-period=0s (default)<br>
&nbsp;&nbsp;'start period' provides initialization time for containers that need time to bootstrap. Probe failure during that period will not be counted towards the maximum number of retries. However, if a health check succeeds during the start period, the container is considered started and all consecutive failures will be counted towards the maximum number of retries.<br>
--retries=3 (default)<br>
&nbsp;&nbsp;It takes 'retries' consecutive failures of the health check for the container to be considered unhealthy.

There can only be one **HEALTHCHECK** instruction in a Dockerfile. If you list more than one, then only the last **HEALTHCHECK** will take effect.

The command's exit status indicates the health status of the container. The possible values are:<br>
**0**: success - the container is healthy and ready for use<br>
**1**: unhealthy - the container is not working correctly<br>
**2**: reserved - do not use this exit code

**[ENTRYPOINT](https://docs.docker.com/engine/reference/builder/#entrypoint)**<br>
The instruction has two forms:
1. The exec form, which is the **prefer** form: **ENTRYPOINT ["executable", "param1", "param2"]**
   * The exec form is parsed as a **JSON** array, which means that double-quotes (") must be used around words instead of single-quotes (').
   * Unlike the shell form, the exec form does not invoke a command shell. This means that normal shell processing does not happen. For example, **ENTRYPOINT ["echo", "$HOME"]** will not do variable substitution on **$HOME**. If shell processing is required, then either use the shell form or execute a shell directly; e.g., **ENTRYPOINT ["sh", "-c", "echo $HOME"]**. When using the exec form and executing a shell directly, as in the case of the shell form, it is the shell that is doing the environment variable expansion, not docker.
2. The shell form: **ENTRYPOINT command param1 param2**

Only the last **ENTRYPOINT** instruction in the Dockerfile will have an effect.

<br>

***
# Quick Overview of Linux Local User Accounts
User accounts stored in a Linux system locally are called *local user accounts*, and there are three main types.

## User Accounts
### Root (Superuser) Account
The root account has full access to the system, and it is only used to perform system level administrative tasks.

### System (Daemon) Accounts
A system account is needed for the operation of system-specific functions. It is started during boot-up, by using the command root or the init command process and usually run in the background.

### Regular User Accounts
A regular user account cannot run administrator-level commands, but it provides interactive access to the system. Furthermore, the account has limited access to critical system files and directories, but it has access to files and directories that it owns or has permissions to read, write, or execute.

## User Management Files
Information about users and groups for the *local user accounts* are kept in four text files named */etc/passwd, /etc/shadow, /etc/group, and /etc/gshadow*; Linux maintains a backup copy for each of these files named */etc/passwd-, /etc/shadow-, /etc/group-, and /etc/gshadow-*.

To list these files.
>`$` ls -l /etc/pass* /etc/group* /etc/shad* /etc/gshad*

Display only the entry that refers to a specific user or group.
>`$` grep [username | groupname] /etc/passwd<br>
>`$` cat /etc/passwd | grep [username | groupname]

### /etc/passwd
A file of seven colon-delimited (`:`) fields containing basic information about users; i.e., a list of users, each on a separate line.<br><br>
**username:password:uid:gid:gecos:home-directory:shell**<br>
**username**<br>
The name used when the user logs into the system.<br>
**password**<br>
An `x` character indicates that the encrypted password is stored in */etc/shadow*.<br>
**uid**<br>
The user ID (UID) number assigned to the user in the system.<br>
The **root** user has the UID of **0**. Most Linux distros reserve the first **100** UIDs for system use; new users are assigned UIDs starting from **500** or **1000**<br>
**gid**<br>
The primary group ID (GID) number of the user in the system; it is stored in */etc/group*.<br>
The **root group** has the GID of **0**. Most Linux distros reserve the first **100** GIDs for system use; new groups are assigned GIDs starting from **1000**.
**gecos**<br>
An optional comment field that is used to add extra information about the user. The field can contain multiple comma-separated (`,`) entries.<br>
**home-directory**<br>
The absolute path of the user's home directory.<br>
**shell**<br>
The absolute path of the command or shell that is automatically launched when the user logs into the system; it is usually an interactive shell such as */bin/bash* or */bin/sh*, but it does not need to be a shell.

### /etc/shadow
A file of nine colon-delimited (`:`) fields; it is readable only by the *root and users with root privileges* and contains the encrypted passwords of the users, each on a separate line.<br><br>
**username:password:last-password-change:minimum:maximum:warn:inactive:expire:reserved**<br>
**username**<br>
The name used when user logs into the system.<br>
**password**<br>
The *encrypted password* of the user.<br>
**last-password-change**<br>
The date of the last password change, as number of days since `Jan 1, 1970`.<br>
**minimum**<br>
The minimum number of days, after a password change, which must pass before the user will be allowed to change the password again.<br>
**maximum**<br>
The maximum number of days that must pass before a password change is required.<br>
**warn**<br>
The number of days before the password expires during which the user is warned that the password must be changed.<br>
**inactive**<br>
The number of days after a password expires during which the user should update the password. After this period, if the user does not change the password, the account will be disabled.<br>
**expire**<br>
The date, as number of days since `Jan 1, 1970`, in which the user account will be disabled. An empty field means that the user account will never expire.<br>
**reserved**<br>
It is reserved for future use.

### /etc/group
A file of four colon-delimited fields containing basic information about groups; i.e., a list of groups, each on a separate line.<br>
In Linux, every user must be a member of at least one group; hence, when a user account is created, Linux creates a group and adds the user account to the group. This group is the *primary group* for the user account, and it uses the same name as the user account. Besides the primary group, additional groups can be created as per requirement.<br><br>
**groupname:password:gid:grouplist**<br>
**groupname**<br>
The name of the group.<br>
**password**<br>
An `x` character indicates that the encrypted password is stored in */etc/gshadow*.<br>
**gid**<br>
The group ID number assigned to the group in the system.<br>
**grouplist**<br>
A comma-delimited (`,`) list of users belonging to the group.

### /etc/gshadow
A file of four colon-delimited (`:`) fields; it is readable only by the *root and users with root privileges* and contains the encrypted passwords of the groups, each on a separate line.<br><br>
**groupname:password:administrators:grouplist**<br>
**group-name**<br>
The name of the group.<br>
**password**<br>
The *encrypted password* for the group.<br>
**administrators**<br>
A comma-delimited (`,`) list of the administrators of the group.<br>
**grouplist**<br>
A comma-delimited (`,`) list of the members of the group.

<br>

***
# Useful Linux Commands
## UserId and GroupId
**Get list of all users**<br>
The `getent` command displays entries from databases configured in the file `/etc/nsswitch.conf`, which includes the `passwd` database.
>`\>` getent passwd<br>
>`\>` cat /etc/passwd

**Check whether a user exists**
>`\>` getent passwd | grep [username]<br>
>`\>` getent passwd [username]

**Display the number of user accounts in the system**<br>
>`\>` getent passwd | wc -l

**Check the UID_MIN and UID_MAX values in the system**
>`\>` grep -E '^UID_MIN|^UID_MAX' /etc/login.defs

**Display all regular users in the system**<br>
To get the range, use the `grep -E` above.
>`\>` getent passwd {1000..60000}

**Display account aging information**
>`\>` chage -l [username]

**Display first entry in the `/etc/passwd` file**
>`\>` head -1 /etc/passwd

**Display all accounts with uid=0**
>`\>` awk -F: '($3 == "0") {print}' /etc/passwd

**Locking/unlocking accounts**
>`\>` passwd -l [username]<br>
>`\>` passwd -u [username]






docker images --format 'table {{.ID}}\t{{.Repository}}\t{{.Tag}}'

In Linux by default, containers run as root.  A container running as root has full control of the host machine; UIDs are the same within a container and the host.
The superuser account is for administration of the system. The name of the superuser is root and the account has UID 0. The superuser has full access to the system.
The $ character is replaced by a # character if the shell is running as the superuser, root.
# Runtime protection: All applications in container images run as non-root users, minimizing the exposure surface to malicious or faulty applications.
Create a Working Directory
The working directory is the directory containing all files needed to build the image. Creating an empty working directory is good practice to avoid incorporating unnecessary files into the image. For security reasons, the root directory, /, should never be used as a working directory for image builds.





***
# Podman
***
# Image
Login to the Red Hat Container Catalog with a Red Hat account (a valid account is required).
>`$` podman login registry.redhat.io

To search a registry or a list of registries for a matching image. The command can specify which registry to search by prefixing the registry in the search term (e.g.; `registry.fedoraproject.org/fedora`), default is the registries in the `registries.search` table in the config file `/etc/containers/registries.conf`. The default number of results is 25.<br>
Container images are named based on the following syntax:<br>
registry_name/user_name/image_name:tag
>`$` cat /etc/containers/registries.conf<br>
[registries.search]<br>
registries = ['docker.io', 'quay.io']

>`$` podman search rhel<br>
>`$` podman search registry.redhat.io/rehl<br>
>`$` podman search --format "table {{.Index}} {{.Name}}" registry.redhat.io/rhel

To download an image.
>`$` podman pull rhel

After retrieval, images are stored locally.
>`$` podman images

<br>

***
# Containers
## Notes
1. Most Podman subcommands accept the `-l` flag (`l` for latest) as a replacement for the container id. This flag applies the command to the latest used container in any Podman command.
2. By default, `Podman` and `Red Hat OpenShift` run `rootless` containers. Docker announced that rootless mode will be generally available in version 20.10.

The container performs one task and exits.
>`$` podman run ubi8/ubi:8.3 echo 'Hello world!'

Use the `-p (--publish)` option to map port 8080 on the container to a `random` port on the host. Then, use the `podman port` command to retrieve which ports the container exposes (8080) and where they are mapped on the host (42469). Finally, use this port to create the target `URL` and fetch the root page from the Apache HTTP server.
>`$` podman run -d -p 8080 registry.redhat.io/rhel8/httpd-24<br>
>`$` podman port -l<br>
8080/tcp -> 0.0.0.0:42469<br>
>`$` curl http://localhost:42469

To connect to a container interactively (`-it`).
>`$` podman run -it ubi8/ubi:8.3 /bin/bash

When running a container, use the `-e (--env)` option to add new environment variables or replace the values of existing image variables.
>`$` podman run -e GREET=Hello --env NAME=RedHat ubi8/ubi:8.3 printenv GREET NAME

To verify that the container started without errors.
>`$` podman ps --format 'table {{.ID}} {{.Image}} {{.Names}}'









