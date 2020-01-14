# Docker Desktop
**https://dockr.ly/docker-for-windows**

# Docker Version and Info
>`>` docker version

>`>` docker -v

>`>` docker info

# Notes
1. Docker logging is powerful and pluggable, but it only reads log entries from the container's **console output stream**.
2. Windows Versions  
   Because applications in Windows Server containers run processes directly on the host, the version of Windows on the server **needs to match** the version of Windows inside the container. But if the applications are running in Hyper-V containers, the version of Windows on the server does not need to match the version of Windows inside the container.
3. Nano Server is a minimal operating system built for running apps in containers. It is not a full version of Windows, and it can't be run as the OS on a VM or a physical machine. Furthermore, not all Windows apps can run in a Nano Server container.

# Docker Compose
**https://docs.docker.com/compose/compose-file/**
## Notes
1. Docker Compose works with services and applications. An application is a single unit composed of one or more services; services are deployed as containers at runtime. Docker Compose is used to define all of the resources of an application -- services, networks, volumes, etc. -- and the dependencies among them. Since a container is a single instance of an image, a service is a template to run a container from an image with a known configuration. By using services, an application can scale up or down the number of containers running from the same image and using the same configuration as a single unit. Services are used in Docker Compose and with a cluster of Docker Engines running in Docker Swarm; services are not used in a standalone Docker Engine.
2. Since Docker Compose **doesn't guarantee the order in which containers are created**, start-up dependencies among services have to be captured in the service definition with the depends_on attribute. Capturing dependencies with this attribute is acceptable for a distributed application running on a single machine, but it doesn't scale. When running on a cluster, an orchestrator is required to manage distributing the workload.
   Note:
    Capturing dependencies like this is fine for running distributed applications on a single machine, but **it doesn't scale**. When you're running in a cluster you want the orchestrator to manage distributing the workload. It can't do that effectively if you have explicit dependencies, because it needs to make sure all the containers running the dependent service are healthy before it starts the consuming containers. See Docker Swarm.
3. After executing the 'docker-compose up' command, containers can be managed using the Compose CLI or the standard Docker CLI.
4. The Docker Compose file represents the desired state of the application. When a docker-compose command is executed, it compares the Composite file to the existing state of the application in Docker and makes any changes needed to get the desired state; e.g., starting containers, stopping containers, creating volumes, etc.
5. All Docker Compose commands are processed by comparing the Compose file to the services running on Docker; hence, it is required to have access to the Compose file to run any Docker Compose commands.
6. If 'docker-compose up' is run repeatedly from the same Compose file, no changes will be made after the first run since the definition of the application has not changed; hence, Docker Compose can be used to manage application upgrades.
7. Docker Compose supports override files. When running 'docker-compose' commands, the commands can accept multiple files as arguments; Compose will join all of the files together in the order specified in the command from left to right. Override files are used to add new sections to the application definition, or they can replace existing definitions. (The default configuration is designed for development use.)
8. Be careful when modifying Compose files of running applications. If the definition of a running service is removed from the Compose file, Docker Compose will not recognize that the removed service is part of the application, and the containers created from the removed service will not be included in the difference checks. This results in orphaned containers.
9. Warning!!! Ports can be specified without quotes, but this is best avoided as it can cause confusion when YAML parses statements such as 56:56 as a base 60 number.

### Start the application
The **up** command creates resources specified in the Compose file that do not exist, and it creates and starts containers for all the services.
>`>` docker-compose up -d

### Scale a container
>`>` docker-compose up -d --scale container-name-or-id=2

### Stop the application
The **down** command stops all running containers and removes the resources. Networks are removed, if they were created by Docker Compose, but volumes are not removed thereby retaining all application data.
>`>` docker-compose down

### Stop all running containers
The **stop** command stops all running containers without removing them or other resources. Stopping a container ends the running process with a graceful shutdown.
>`>` docker-compose stop

### Stop a container
>`>` docker-compose stop service-name

### Kill all containers
The **kill** command stops all containers by forcibly ending the running processes.
>`>` docker-compose kill

### Start all stopped containers
The **start** command starts all stopped containers via the entry point of the containers.
>`>` docker-compose start

### List all running containers
>`>` docker-compose ps

### Check memory and CPU usage of all running containers
>`>` docker-compose top

### Display the log entries of all runninng containers
>`>` docker-compose logs
>`>` docker-compose logs --tail 5

# Images
## Notes
1. When identifying a container/image by its id, **there is no need to specify the entire id**; specify enough characters to uniquely identify it.
2. If a file is deleted in the same layer that it's created, it won't be included in the image. Because of this, Dockerfiles often download a tarball or other archive file, unpack it, and immediately remove the archive file in one RUN instruction.

### Building images
**name-of-container-image = {user-name-of-registry}/{app-name}**
>`>` docker image build --tag [name-of-container-image][:version-or-variation] .

>`>` docker image build --file Dockerfile.nats --tag [name-of-container-image][:version-or-variation] .

>`>` docker image build --build-arg ENV_NAME=TEST --tag [name-of-container-image][:version-or-variation] .

**When a build fails, it can be very useful to launch the layer before the failure**
>`>` docker container run --rm -it [image-id]

### Displaying
**Display the full set of layers that make up an image**
>`>` docker history [image-name-or-id]

### Listing
**List images**
>`>` docker image ls

>`>` docker images

>`>` docker image ls --all

>`>` docker image ls -a

>`>` docker image ls --filter reference=[name-of-container-image][:version-or-variation]

**List untagged images (dangling - TAG=<none>)**
>`>` docker images -f "dangling=true"

**List untagged image ids (dangling - TAG=<none>)**
>`>` docker images -f "dangling=true" -q

### Removing
**Remove images with TAG=<none>**
>`PS>` docker rmi $(docker images -f "dangling=true" -q)

**Remove all images**
>`PS>` docker image ls -aq | foreach { docker rmi -f $_ }

**Remove all untagged images**
>`PS>` docker rmi $(docker images -f "dangling=true" -q) -f

**Remove all images older than 6 months --> 4320h = 24 hour/day * 30 days/month * 6 months**
>`>` docker image prune --all --filter "until=4320h"

# Containers
## Notes
1. Windows 10–1809 ("October 2018 Update") + Docker engine 18.09.1 + the Windows 1809 base images from Dockerhub are the first combination that allows to run **real** Windows containers on Windows 10, without hyperv virtualization.  
   **https://docs.microsoft.com/en-us/virtualization/windowscontainers/deploy-containers/version-compatibility**

   Select a Windows base image from Dockerhub that **matches** the kernel of your host's Windows version. For Windows 10–1809, that's the :1809 version/tag of nanoserver, servercore and windows (or any higher-level image, that builds up on one of these).

   To find the version of Windows  
   **C:\>** winver  
        *Windows 10  
        Microsoft Windows  
        Version 1903 (OS Build 18362.295)*  

   By infinitely running ping (-t) against the localhost in a Windows nano server container in process-isolation mode (--isolation=process), 'ping.exe' is directly running on the host (instead of a virtual macine); this is why it can be seeing in the host system's task manager while the container is running:
    >`>` docker container run --rm --name pinger --isolation=process mcr.microsoft.com/windows/nanoserver:1903 cmd.exe /c ping 127.0.0.1 -t
2. When Docker runs a container, it starts the process specified in the Dockerfile or the command line; Docker watches that process, and when that process ends, the containers exits. But if the application starts multiple processes in a container, Docker will only monitor the last process that started. Ideally, there will be one process per container; otherwise, the application will have to take on the responsability of managing all other processes. **This is a recommendation and not a requirement.**
3. When identifying a container/image by its id, **there is no need to specify the entire id**; specify enough characters to uniquely identify it.
4. To exit a container while keeping it running in the background, **<Ctrl>PQ or <Ctrl><Shift>pq**.

### Running containers
**Task container**
>`>` docker container run [name-of-container-image][:version-or-variation]

>`>` docker container run --name source image-share-volume ...

>`>` docker container run -it --volumes-from source image-share-volume cmd

>`>` docker container run -it --volumes-from source:ro image-share-volume cmd

>`>` docker container run --volume {host-location-must-exist}:{container-location-does-not-need-to-exist-but-hidden-if-it-does} image-share-volume ...

**Interactive container**
>`>` docker container run --interactive --tty [name-of-container-image][:version-or-variation] cmd

>`>` docker container run -it --name container-name [name-of-container-image][:version-or-variation] cmd

**Detach container**
>`>` docker container run --detach [name-of-container-image][:version-or-variation]

>`>` docker container run --detach --publish {host-port}:{container-port} [name-of-container-image][:version-or-variation]

>`>` docker container run -d -p {host-port}:{container-port} [name-of-container-image][:version-or-variation]

### IDs and Names
**Get the container id**
>`>` docker ps --filter "[name=container-name]" --format "{{ .ID }}"

**Names of all running containers**
>`PS>` docker inspect -f '{{ .Name }}' $(docker ps -q)

### Listing
**List all active containers**
>`>` docker container ls

>`>` docker ps

**List all containers**
>`>` docker container ls --all

>`>` docker container ls -a

### Stopping/Removing/Killing
**Stop a running container**  
When a **docker stop** command is issued, Docker sends a SIGTERM signal to the main process in the container and waits up to ten (10) seconds for the main process to stop. If the mian process doesn't comply with the request within the timeout period, Docker sends a SIGKILL. Whereas the main process can ignore a SIGTERM, the SIGKILL goes straight to the kernel thereby terminating the main process; the main process is forcibly killed without having an opportunity to exit gracefully. To change the default 10 seconds to wait, use the --time (-t) option.
>`>` docker container stop [container-name-or-id]

>`>` docker container stop --time=20 [container-name-or-id]

**Stop all running containers**
>`PS>` docker ps -q | foreach { docker stop $_ }

**Stop and remove all running containers**
>`PS>` docker ps -q | foreach { docker stop $_; docker rm $_ }

**Remove all containers (active and non-active)**
>`PS>` docker container ls -aq | foreach { docker rm -f $_ }

**Kill a running container**
>`>` docker container kill [container-name-or-id]

>`>` docker container kill -s=1 [container-name-or-id]

### IP Addresses and Ports
**IP Address**
>`>` docker inspect -f '{{.NetworkSettings.Networks.nat.IPAddress}}' [container-name-or-id]

>`PS>` docker container inspect --format '{{ .NetworkSettings.Networks.nat.IPAddress }}' [container-name-or-id]

**Publish all of the exposed ports from the container image to random ports on the host**
>`>` docker container run -d --publish-all -v c:\app-state:c:\app-state --name appv1 [name-of-container-image][:version-or-variation]

>`>` docker container run -d -P -v c:\app-state:c:\app-state --name appv1 [name-of-container-image][:version-or-variation]

**Ports**
>`>` docker container port [container-name-or-id]

>`>` docker inspect [container-name-or-id]

### Displaying
**Display the timestamp**
>`>` docker container logs -t [container-name-or-id]

**Display the labels**
>`PS>` docker container inspect -f '{{ json .Config.Labels }}' [container-name-or-id] | ConvertFrom-Json

**Display current restart count**
>`PS>` docker container inspect -f '{{ .RestartCount }}' $(docker ps -q)

**Display the Healthcheck logs**
>`>` docker inspect --format '{{ json .State.Health }}' [container-name-or-id] | ConvertFrom-Json | ConvertTo-Json

### Logging/Streaming
**Logging containers**
>`>` docker container logs [container-name-or-id]

>`PS>` docker container logs [container-name-or-id] | where { $_ -like '*Error *' }

**Stream the logs from a running container (*Ctrl+C to exit*)**
>`>` docker container logs -f [container-name-or-id]

**Stream events (*Ctrl+C to exit*)**
>`>` docker events

>`>` docker events --since '2019-10-23T15:49:29'

>`>` docker events --since '2019-10-23T00:35:30' --until '2019-10-23T00:36:05'

>`>` docker events --filter 'event=stop'

>`>` docker events --filter '[container=container-name-or-id]' --filter 'event=stop'

**Return a live stream of resource usage (*Ctrl+C to exit*)**
>`>` docker stats [container-name-or-id] [container-name-or-id...]

### Inspecting
**Mounts**
>`PS>` docker container inspect --format '{{ json .Mounts }}' [container-name] | ConvertFrom-Json

### Resources usage
**Processes, memory, CPU**
>`>` docker container top [container-name-or-id]

### Stats
**Stats on all running containers**
>`PS>` docker stats $(docker ps -q)

# Volumes
### Creation
**Create a volume**
>`>` docker volume create [volume-name]

### Removal
**Remove a volume**
>`>` docker volume rm [volume-name-or-id]

**Remove all volumes**
>`PS>` docker volume ls | foreach { docker volume rm -f $_ }

**Remove all unused local volumes; i.e., volumes which are not referenced by any containers**
>`>` docker volume prune

**Do not prompt for confirmation (-f -> --force)**
>`>` docker volume prune -f

### Listing
**List all volumes**
>`>` docker volume ls

**List all volumes not referenced by any containers (-f -> --filter)**
>`>` docker volume ls -f dangling=true

### Location
**Location where the data is physically stored on the host**
>`>` docker volume inspect --format '{{ .Mountpoint }}' [volume-name]
>`>` docker volume inspect -f '{{ .Mountpoint }}' [volume-name]

### Displaying
**Display the Name and Driver entries separated by a colon for all volumes**
>`>` docker volume ls --format "{{.Name}}: {{.Driver}}"

### Inspecting
**Inspect a volume**
>`>` docker inspect [volume-name-or-id]

# Networks
## Notes
1. Docker on Windows has several networking options. **The default is the network address translation (nat)**. This driver isolates containers from the physical network, and it assigns each container its own IP address in a subnet managed by Docker. On the host, containers can be accessed by their IP addresses, but outside the host, containers can be accessed only through published ports. With the nat driver, other networks can be created, or other drivers can be used for different network configurations:
   * Transparent driver - It gives each container an IP address provided by the physical router.
   * 12bridge driver - It specifies static containers IP addresses on the physical network.
   * Overlay driver - It runs distributed applications in Docker Swarm.
2. The use of **0.0.0.0** as IP address binds to **all network interfaces**, which is needed to allow the container to be accessed from the host or other containers.
3. When publishing ports to the host, Docker publishes to all interfaces (0.0.0.0) by default. By specifying the interface to bind explicitly, the attack surface is reduced since only traffic from the explicitly bound interface is allowed; e.g.,
    >`>` docker container run -p 172.123.34.23:80:80 ...

### Creation
**Create a network**
>`>` docker network create --driver [-d] nat [network-name]

### Removing
**Remove a network**
>`>` docker network rm [network-name-or-id]

### Connection
**Connect container to network**
>`>` docker network connect [network-name-or-id] [container-name-or-id]

### Disconnection
**Disconnect container from network**
>`>` docker network disconnect [network-name-or-id] [container-name-or-id]

### Listing
**List Docker networks**
>`>` docker network ls

### Inspecting
**Inspect a network**
>`>` docker network inspect [network-name-or-id]

# Dockerfile
## The Build Context
1. The **docker build** command requires a Dockerfile and a build context, which may be empty. The build context is the set of local files and directories that can be referenced from ADD or COPY instructions in the Dockerfile and is normally specified as a path to a directory.
2. Only the instructions **FROM**, **RUN**, **COPY**, and **ADD** create layers in the final image. Other instructions configure things, add metadata, or tell Docker to do something at run time, such as expose a port or run a command.

**\# escape=\`**  
Parser directives do not add layers to the build and will not be shown as a build step. Once a comment, empty line, or builder instruction has been processed, Docker no longer looks for parser directives. Hence, all parser directives must be at the very top of a Dockerfile.  
Use the backtick (**\`**) option for the escape character to split commands over multiple lines rather than the default backslash **\\** option.

**ARG BASE_OS_LAYER**  
**ARG BASE_OS_LAYER_VERSION**  
**FROM ${BASE_OS_LAYER}:${BASE_OS_LAYER_VERSION}**  
A Dockerfile must start with a **FROM** instruction. The **FROM** instruction specifies the Base Image from which you are building. **FROM** may only be preceded by one or more **ARG** instructions, which declare arguments that are used in **FROM** lines in the Dockerfile.

**SHELL ["cmd", "/S", "/C"]**  
The default shell on **Linux is ["/bin/sh", "-c"]** and on **Windows is ["cmd", "/S", "/C"]**.  
&nbsp;&nbsp;**/S** --> Modify the treatment of string after **/C** or **/K**.  
&nbsp;&nbsp;**/C** --> Carry out the command specified by string and then terminate.  
The **SHELL** instruction must be written in **JSON** form in a Dockerfile.  
The **SHELL** instruction is particularly useful on Windows where there are two commonly used and quite different native shells: **cmd** and **powershell** as well as alternate shells available including **sh**.  
The **SHELL** instruction can appear multiple times. Each **SHELL** instruction overrides all previous **SHELL** instructions and affects all subsequent instructions.  
The following instructions can be affected by the **SHELL** instruction when the shell form of them is used in a Dockerfile: **RUN**, **CMD**, and **ENTRYPOINT**.

**SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]**  
**-Command** executes the specified commands (and any parameters) as though they were typed at the Windows PowerShell command prompt, and then exits, unless the NoExit parameter is specified.  
**$ErrorActionPreference** determines how PowerShell responds to a non-terminating error (an error that does not stop a cmdlet processing) at the command line or in a script, cmdlet, or provider, such as the errors generated by the Write-Error cmdlet.  
**$ProgressPreference** determines how PowerShell responds to progress updates generated by a script, cmdlet or provider, such as the progress bars generated by the Write-Progress cmdlet.

**ENV**  
Settings added to the Dockerfile with **ENV** become **part of the image** so every container run from the image will have these values set. When you run a container, you can add new environment variables or replace the values of existing image variables using the **--env** or **-e** option.  

To keep environment values safer, Docker lets you load them from a file rather than specifying them in plain text in the **docker container run** command. Isolating values in a file means that the file itself can be secured so that only administrators and the Docker service account can access it. The environment file is a simple-text format, with one line for each environment variable, written as a key-value pair. To run the container and load the file contents as environment variables, you can use the --env-file option. Note: Environment values still are not secure. If someone gains access to your app, he could print out all the environment variables and get your secrets.

**VOLUME**
Volumes are created and managed by Docker; volumes are units of storage. When a volume is created, it is stored within a directory on the host, which is managed by Docker (**/var/lib/docker/volumes/ on Linux** or **C:\ProgramData\docker\volumes on Windows**). Non-Docker processes should not modify this part of the filesystem. A given volume can be mounted into multiple containers simultaneously. When no running container is using a volume, the volume is still available to Docker and is not removed automatically. They have a separate life cycle to containers so they can be created independently and then mounted inside one or more containers. Volumes are the best way to persist data in Docker.

You specify volumes with a target directory, which is the location inside the container where the volume is mounted. When you run a container with a volume defined in the image, the volume is mapped to a physical location on the host, which is specific to that one container. More containers running from the same image will have their volumes mapped to a different host location.

When you mount a volume, it may be named or anonymous. Anonymous volumes are not given an explicit name when they are first mounted into a container; Docker gives them a random name that is guaranteed to be unique within a given host. Besides the name, named and anonymous volumes behave the same.

In **Windows**, volume directories need to be empty. In your Dockerfile, you can't create files in a directory and then expose it as a volume. Volumes also need to be defined on a disk that exists in the image. In the Windows base images, there is only a **C** drive available so volumes need to be created on the **C** drive.

Bind mounts have limited functionality compared to volumes. When a bind mount is used, a file or directory on the host is mounted into a container. The file or directory is referenced by its full or relative path on the host. By contrast, when a volume is used, a new directory is created within Docker's storage directory on the host, and Docker manages that directory's contents. You can't use Docker CLI commands to directly manage bind mounts.

To mount the host *c:\host_dir* folder to the container path *c:\container_dir*
>`>` docker container run –it --rm --name [mount1] -v c:\host_dir:c:\container_dir mcr.microsoft.com/windows/servercore:1903 powershell

>`PS C:\>` Set-Location -Path .\container_dir;

>`PS C:\cdir>` New-Item -Path .\LogFile.txt -ItemType File;

>`PS C:\cdir>` Add-Content -Path .\LogFile.txt -Value 'Juan Carlos Trimiño';

>`PS C:\cdir>` <Ctrl><Shift>pq

To see the file in the host
>`C:\>` dir c:\host_dir

To mount the host c:\host_dir folder to another container (mount2) path c:\container_dir
>`>` docker container run -it --rm --name mount2 --mount type=bind,source=c:\host_dir,target=c:\container_dir mcr.microsoft.com/windows/servercore:1903 powershell

>`PS C:\>` Get-ChildItem -Path .\container_dir\ -File;

>`PS C:\>` Get-Content -Path .\container_dir\LogFile.txt;

>`PS C:\>` <Ctrl><Shift>pq

**HEALTHCHECK**
The options that can appear before **CMD** are:  
--interval=30s (default)  
&nbsp;&nbsp;The health check will first run 'interval' seconds after the container is started, and then again 'interval' seconds after each previous check completes.  
--timeout=30s (default)  
&nbsp;&nbsp;If a single run of the check takes longer than 'timeout' seconds, then the check is considered to have failed.  
--start-period=0s (default)  
&nbsp;&nbsp;'start period' provides initialization time for containers that need time to bootstrap. Probe failure during that period will not be counted towards the maximum number of retries. However, if a health check succeeds during the start period, the container is considered started and all consecutive failures will be counted towards the maximum number of retries.  
--retries=3 (default)  
&nbsp;&nbsp;It takes 'retries' consecutive failures of the health check for the container to be considered unhealthy.

There can only be one **HEALTHCHECK** instruction in a Dockerfile. If you list more than one, then only the last **HEALTHCHECK** will take effect.

The command's exit status indicates the health status of the container. The possible values are:  
**0**: success - the container is healthy and ready for use  
**1**: unhealthy - the container is not working correctly  
**2**: reserved - do not use this exit code

**EXPOSE**  
The instruction informs Docker that the container listens on the specified network port at runtime; the port listens on **TCP** (default) or **UDP**.

The instruction does not actually publish the port. It functions as a type of documentation about which ports are intended to be published. To actually publish the port when running the container, use the **-p** (**--publish**) flag on **docker container run** to publish and map one or more ports, or the **-P** (**--publish-all**) flag to publish all exposed ports and map them to high-order ports. Containers in the same Docker network can always access one another's port; ports only need to be published to make them available outside Docker.

**WORKDIR**  
The instruction sets the working directory for any subsequent **RUN**, **CMD**, **ENTRYPOINT**, **COPY**, and **ADD** instructions. If the working directory doesn't exist, it will be created even if it's not used in any subsequent Dockerfile instruction.

**COPY**  
The instruction copies files or directories from <src> (build context) to the filesystem of the container at the path <dest>; the <dest> is an absolute path, or a path relative to **WORKDIR**. Paths outside the build context cannot be specified. The exec format ["<src>", "<dest>"] is required for paths containing spaces.

**RUN**  

**CMD**  
The instruction has three forms:  
1. The exec form, which is the prefer form: **CMD ["executable","param1","param2"]**
   * The exec form is parsed as a **JSON** array, which means that double-quotes (") must be used around words instead of single-quotes (').
   * Unlike the shell form, the exec form does not invoke a command shell. This means that normal shell processing does not happen. For example, **CMD ["echo", "$HOME"]** will not do variable substitution on **$HOME**. If shell processing is required, then either use the shell form or execute a shell directly; e.g., **CMD ["sh", "-c", "echo $HOME"]**. When using the exec form and executing a shell directly, as in the case of the shell form, it is the shell that is doing the environment variable expansion, not docker.
2. The default parameters to **ENTRYPOINT**: **CMD ["param1","param2"]**
   * If **CMD** is used to provide default arguments for the **ENTRYPOINT** instruction, both the **CMD** and **ENTRYPOINT** instructions should be specified with the **JSON** array format.
3. The shell form: **CMD command param1 param2**
   * If the shell form of the **CMD** is used, then the <command> will execute in the current shell set by the **SHELL** instruction, or the default shell (see the **SHELL** instruction).

There can only be one **CMD** instruction in a Dockerfile. If more than one **CMD** instruction is used, then only the last **CMD** will take effect.

The **CMD** instruction is overridden by any arguments to *docker container run* after the image name.

**ENTRYPOINT**  
The instruction has two forms:
1. The exec form, which is the **prefer** form: **ENTRYPOINT ["executable", "param1", "param2"]**
   * The exec form is parsed as a **JSON** array, which means that double-quotes (") must be used around words instead of single-quotes (').
   * Unlike the shell form, the exec form does not invoke a command shell. This means that normal shell processing does not happen. For example, **ENTRYPOINT ["echo", "$HOME"]** will not do variable substitution on **$HOME**. If shell processing is required, then either use the shell form or execute a shell directly; e.g., **ENTRYPOINT ["sh", "-c", "echo $HOME"]**. When using the exec form and executing a shell directly, as in the case of the shell form, it is the shell that is doing the environment variable expansion, not docker.
2. The shell form: **ENTRYPOINT command param1 param2**

Only the last **ENTRYPOINT** instruction in the Dockerfile will have an effect.
