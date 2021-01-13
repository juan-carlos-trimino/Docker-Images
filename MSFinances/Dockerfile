# escape=`
#
# msfinances
#
# Usage
#  > docker image build --tag msfinances-1.0.0/nanoserver-1903 ./MSFinances
#  > docker container run --rm --detach --name msfinances msfinances-1.0.0/nanoserver-1903
#  > docker container run --rm -it --name msfinances msfinances-1.0.0/nanoserver-1903 cmd
#
# Build stage.
ARG BASE_OS_LAYER
ARG BASE_OS_LAYER_VERSION
ARG BUILD_BASE_OS_LAYER
ARG BUILD_BASE_OS_LAYER_VERSION
FROM ${BUILD_BASE_OS_LAYER}:${BUILD_BASE_OS_LAYER_VERSION} AS builder

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR C:/MSFinances/

ARG VC_REDIST_URL
ENV VC_REDIST_URL=${VC_REDIST_URL}

RUN $url = $ENV:VC_REDIST_URL; `
    Write-Host "Downloading: $url..."; `
    $vc_redist = 'vc_redist_x64.exe'; `
    # The Microsoft Visual C++ Redistributable for Visual Studio 2015, 2017 and 2019. `
    Invoke-WebRequest -Uri $url -OutFile $vc_redist -UseBasicParsing; `
    Start-Process -FilePath $vc_redist -ArgumentList '/install', '/quiet', '/norestart', '/log log.txt' -Wait -NoNewWindow; `
    Remove-Item -Force -Path $vc_redist; `
    Remove-Item -Force -Path "*.txt";

# Final image stage.
FROM $BASE_OS_LAYER:$BASE_OS_LAYER_VERSION

SHELL ["cmd", "/S", "/C"]

# Add metadata to the image.
LABEL copyright="Copyright (C) 2019 Juan Carlos Trimino. All rights reserved."
LABEL version="1.0.0"
LABEL maintainer="juancarlos@trimino.com"

WORKDIR C:/MSFinances/

# Copy from the host.
COPY ./MSFinances/*.dll ./
COPY ./MSFinances/MSFinances.exe ./

# Nano Server uses a least-privilege user by default; this switches to a built-in account in the container image, which has
# administrative rights. (To listen on a hostname other than localhost or to listen on port 80, the user needs to run as
# administrator.)
USER ContainerAdministrator

# RUN netsh http add urlacl url=http://+:80/api/v1/ user=ContainerUser listen=yes
# The Integrity Control Access Control List.
# icacls.exe displays or modifies discretionary access control lists (DACLs) on specified files and applies stored DACLs to files
# in specified directories.
# /t performs the operation on all specified files in the current directory and its subdirectories.
# /c continues the operation despite any file errors. Error messages will still be displayed.
# /q suppresses success messages.
# /save stores DACLs for all matching files into the given text file for later use with /restore.
# /restore applies stored DACLs from the given text file to files in the specified directory.
# RUN icacls ./ /save ./acls.txt /t /c /q
# RUN icacls ./ /grant:r ContainerAdministrator:(OI)(CI)(F) /t /c
# RUN icacls ./ /setowner ContainerAdministrator /t /c
# RUN icacls ./ /restore ./acls.txt /c /q /t
RUN net user /add finances
RUN net localgroup Administrators finances /add
#USER ContainerUser
USER finances

# Copy from the builder image.
# To determine the dependencies of the executable, run Dependency Walker or other similar tool.
# To use Dependency Walker without its graphical interface, type:
# /c - Console mode
# /ot:path - Output file in text format
# C:\> depends /c /ot:".\out.txt" "C:\Windows\System32\calc.exe"
COPY --from=builder C:/Windows/System32/MSVCP140.dll C:/Windows/System32/
COPY --from=builder C:/Windows/System32/VCRUNTIME140_1.dll C:/Windows/System32/
COPY --from=builder C:/Windows/System32/VCRUNTIME140.dll C:/Windows/System32/
COPY --from=builder C:/Windows/System32/CONCRT140.dll C:/Windows/System32/
#COPY --from=builder C:/Windows/System32/KERNEL32.dll C:/Windows/System32/
#COPY --from=builder C:/Windows/System32/advapi32.dll C:/Windows/System32/

ENV DB_NAME=""
ENV DB_URL="http://elasticsearch:9200"
# INADDR_ANY (IPv4) / INADDR6_ANY (IPv6)
ENV HTTP_SERVER="http://0.0.0.0:49480/api/v1/"

EXPOSE "49480/tcp"

CMD ["cmd", "/S", "/C", "MSFinances.exe", "-HTTP_SERVER", "%HTTP_SERVER%", "-DB_NAME", "%DB_NAME%", "-DB_URL", "%DB_URL%"]
