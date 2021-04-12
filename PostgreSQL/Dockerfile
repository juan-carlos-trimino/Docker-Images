# escape=`
#
ARG BASE_OS_LAYER
ARG BASE_OS_LAYER_VERSION
ARG BUILD_BASE_OS_LAYER
ARG BUILD_BASE_OS_LAYER_VERSION
FROM ${BUILD_BASE_OS_LAYER}:${BUILD_BASE_OS_LAYER_VERSION} AS builder

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR C:/

ARG POSTGRESQL_URL
ENV POSTGRESQL_URL=${POSTGRESQL_URL}

RUN Write-Host "Downloading: $ENV:POSTGRESQL_URL"; `
#    New-Item -Path './' -ItemType "Directory"; `
#    Set-Location -Path 'C:\postgresql'; `
    $fileName = 'postgresql.zip'; `
    curl -o $fileName "$ENV:POSTGRESQL_URL"; `
    tar -xvf $fileName; `
    Remove-Item -Path $fileName -Force; `
    #Remove-Item -Path "License.txt" -Force; `
    ##Remove-Item -Path "./pgsql/doc/" -Recurse -Force; `
    ##Remove-Item -Path "./pgsql/include/" -Recurse -Force; `
    ##Remove-Item -Path "./pgsql/symbols/" -Recurse -Force; `
    Write-Host "Done!!!";

# Final image.
FROM ${BASE_OS_LAYER}:${BASE_OS_LAYER_VERSION}

# Add metadata to the image.
LABEL copyright="Copyright (C) 2021 Juan Carlos Trimiño. All rights reserved."
LABEL version="1.0.0"
LABEL maintainer="juancarlos@trimino.com"

SHELL ["cmd", "/S", "/C"]

WORKDIR C:/

COPY --from=builder C:/pgsql ./postgresql

# In order to set system PATH, ContainerAdministrator must be used.
USER ContainerAdministrator

# Appending to PATH from the DOS command line.
# /M specifies to set the variable in the system environment.
RUN SETX /M PATH "C:\postgresql\bin;%PATH%"

EXPOSE "5432/tcp"

VOLUME C:/postgresql-data/

ENTRYPOINT ["postgres"]
#CMD ["start", "all"]
