# escape=`
#
# https://traefik.io/
#
# If system.exe (PID 4) is listening on port 80, the service "World Wide Web Publishing Service" is listening on port 80. Stop
# and disable the W3SVC service. To see ports usage:
#   C:\> netstat -aon
#   C:\> sc stop w3svc
#   C:\> sc config w3svc start=disabled
# or
#   C:\> net stop http /y
#   C:\> sc config http start=disabled
#   Microsoft Windows HTTP Services (WinHTTP) provides developers with an HTTP client application programming interface (API) to
#   send requests through the HTTP protocol to other HTTP servers.
#   (sc config http start=auto --> To start the service)
#
# Usage
#  > docker image build --tag veni-vidi-vici/traefik-2.1.1:nanoserver-1903 ./Traefik
#  > docker container run --rm -d -p 80:80 -p 8080:8080 --name reverse-proxy -v //./pipe/docker_engine://./pipe/docker_engine `
#         veni-vidi-vici/traefik-2.1.1:nanoserver-1903 --api --docker --docker.endpoint=npipe:////./pipe/docker_engine --logLevel=DEBUG
#  > docker container run --rm --detach --publish 80:80 --publish 8080:8080 --name reverse-proxy `
#         --volume \\.\pipe\docker_engine:\\.\pipe\docker_engine veni-vidi-vici/traefik-2.1.1:nanoserver-1903 `
#         --api --docker --docker.endpoint=npipe:////./pipe/docker_engine --logLevel=DEBUG
#  > docker container run --rm --entrypoint traefik veni-vidi-vici/traefik-2.1.1:nanoserver-1903 version
#
# In the browser type
#  http://localhost:8080
#
# Open the homepage:
#  PS> $ip = docker container inspect -f '{{ .NetworkSettings.Networks.nat.IPAddress }}' traefik; start "http://$($ip):8080";
#  PS> Start-Process -FilePath "http://localhost:8080";
ARG BASE_OS_LAYER
ARG BASE_OS_LAYER_VERSION
ARG BUILD_BASE_OS_LAYER
ARG BUILD_BASE_OS_LAYER_VERSION
FROM ${BUILD_BASE_OS_LAYER}:${BUILD_BASE_OS_LAYER_VERSION} AS builder

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ARG TRAEFIK_VERSION
ARG TRAEFIK_ROOT_URL
ENV TRAEFIK_VERSION=${TRAEFIK_VERSION}
ENV TRAEFIK_ROOT_URL=${TRAEFIK_ROOT_URL}

WORKDIR c:/traefik

RUN $url = ("$ENV:TRAEFIK_ROOT_URL" -f $ENV:TRAEFIK_VERSION, $ENV:TRAEFIK_VERSION); `
    Write-Host "Downloading: $url..."; `
    $traefik = 'traefik.zip'; `
    Invoke-WebRequest -Uri $url -OutFile $traefik -UseBasicParsing; `
    Expand-Archive -Path $traefik -DestinationPath ./ -Verbose; `
    Write-Host "Removing $traefik..."; `
    Remove-Item $traefik -Force; `
    Write-Host 'Verifying Traefik installation...'; `
    Write-Host 'Traefik Version: ' (./traefik version);

# Final image
FROM ${BASE_OS_LAYER}:${BASE_OS_LAYER_VERSION}

WORKDIR c:/windows/system32

# Nano Server does not contain the netapi32.dll; get it from windows servercore.
COPY --from=builder /windows/system32/netapi32.dll ./netapi32.dll

WORKDIR c:/traefik

#COPY --from=traefik:v1.7.11-nanoserver-sac2016 ./traefik.exe ./traefik.exe
COPY --from=builder C:/traefik/traefik.exe ./traefik.exe
COPY ./traefik.yml ./traefik.yml

# Nano Server uses a least-privilege user by default. This switches to a built-in account in the container image, which has
# administrative rights.
USER ContainerAdministrator

# HTTP port
EXPOSE "80/tcp"
# HTTPS port
EXPOSE "443/tcp"
# Web UI (enabled by --api)
EXPOSE "8080/tcp"

ENTRYPOINT ["traefik", "--configFile=traefik.yml"]

ARG TRAEFIK_VERSION
# Metadata (copied from official Traefik image)
LABEL org.opencontainers.image.vendor="Containous" `
      org.opencontainers.image.url="https://traefik.io" `
      org.opencontainers.image.title="Traefik" `
      org.opencontainers.image.description="A modern reverse-proxy" `
      org.opencontainers.image.version="v${TRAEFIK_VERSION}" `
      org.opencontainers.image.documentation="https://docs.traefik.io"
