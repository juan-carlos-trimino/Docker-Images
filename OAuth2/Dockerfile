# escape=`
#
ARG BASE_OS_LAYER
ARG BASE_OS_LAYER_VERSION
ARG BUILD_BASE_OS_LAYER
ARG BUILD_BASE_OS_LAYER_VERSION
FROM ${BUILD_BASE_OS_LAYER}:${BUILD_BASE_OS_LAYER_VERSION} AS builder

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR C:/

ARG HYDRA_URL
ENV HYDRA_URL=${HYDRA_URL}

RUN Write-Host "Downloading: $ENV:HYDRA_URL"; `
    New-Item -Path 'C:\hydra' -ItemType "Directory"; `
    Set-Location -Path 'C:\hydra'; `
    $fileName = 'hydra.zip'; `
    curl -o $fileName "$ENV:HYDRA_URL"; `
    tar -xvf $fileName; `
    Remove-Item -Path $fileName -Force; `
    Write-Host "Done!!!";

# Final image.
FROM ${BASE_OS_LAYER}:${BASE_OS_LAYER_VERSION}

# Add metadata to the image.
LABEL copyright="Copyright (C) 2020 Juan Carlos Trimino. All rights reserved."
LABEL version="1.0.0"
LABEL maintainer="juancarlos@trimino.com"

SHELL ["cmd", "/S", "/C"]

WORKDIR C:/

COPY --from=builder C:/hydra ./hydra

# In order to set system PATH, ContainerAdministrator must be used.

# Security run a container with non-Admin user account (nonroot user)
# ContainerAdministrator is the default user account for Windows Server Core.
# ContainerUser is the default user account for Nano Server.
# Always use a least-privilege user account to run processes and set ACLs as narrowly as possible.
#> docker run image cmd /C echo %USERDOMAIN%\%USERNAME%


USER ContainerAdministrator

# Appending to PATH from the DOS command line.
# /M specifies to set the variable in the system environment.
RUN SETX /M PATH "C:\hydra;%PATH%"

USER ContainerUser

VOLUME C:/hydra-data

ENTRYPOINT ["hydra"]
