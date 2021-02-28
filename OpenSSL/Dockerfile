# escape=`
#
# docker image ls
# docker container ls -a
# docker image rm -f [container-name-or-id]
# PS> docker container ls -aq | foreach { docker rm -f $_ }
# PS> docker rmi $(docker images -f "dangling=true" -q)
#
ARG BASE_OS_LAYER
ARG BASE_OS_LAYER_VERSION
ARG BUILD_BASE_OS_LAYER
ARG BUILD_BASE_OS_LAYER_VERSION
FROM ${BUILD_BASE_OS_LAYER}-${BUILD_BASE_OS_LAYER_VERSION} AS builder

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR C:/

ARG VC_BUILDTOOLS_URL
ARG NASM_VERSION
ARG NASM_URL
ARG PERL_URL
ARG OPENSSL_VERSION
ARG OPENSSL_URL
ENV PERL_URL=${PERL_URL}
ENV OPENSLL_VERSION=${OPENSSL_VERSION}
ENV OPENSSL_URL=${OPENSSL_URL}
ENV NASM_VERSION=${NASM_VERSION}
ENV NASM_URL=${NASM_URL}
ENV VC_BUILDTOOLS_URL=${VC_BUILDTOOLS_URL}

RUN Write-Host "Downloading: $ENV:PERL_URL"; `
    $fileName = 'perl.zip'; `
    curl -o $fileName "$ENV:PERL_URL"; `
    Expand-Archive -Path $fileName -DestinationPath './' -Verbose; `
    Remove-Item -Path $fileName -Force; `
    # Set the environment variables manually to the Machine level, then terminate this session and start a new session. The new session will have the environment variables set. `
    $ENV:PATH = 'C:\Perl\bin;{0}' -f $ENV:PATH; `
    [System.Environment]::SetEnvironmentVariable('Path', $ENV:PATH, [System.EnvironmentVariableTarget]::Machine); `
    $url = "$ENV:OPENSSL_URL" -f $ENV:OPENSSL_VERSION; `
    Write-Host "Downloading: $url"; `
    $fileName = 'openssl.tar.gz'; `
    curl -o $fileName $url; `
    tar -zxvf $fileName; `
    Remove-Item -Path $fileName -Force; `
    $url = "$ENV:NASM_URL" -f $ENV:NASM_VERSION; `
    Write-Host "Downloading: $url"; `
    $fileName = 'nasm.zip'; `
    Invoke-WebRequest -Uri $url -OutFile $fileName -UseBasicParsing; `
    Expand-Archive -Path $fileName -DestinationPath './' -Verbose; `
    Remove-Item -Path $fileName -Force; `
    $ENV:PATH = 'C:\{0};{1}' -f $ENV:NASM_VERSION, $ENV:PATH; `
    [System.Environment]::SetEnvironmentVariable('Path', $ENV:PATH, [System.EnvironmentVariableTarget]::Machine); `
    Write-Host "Downloading: $ENV:VC_BUILDTOOLS_URL"; `
    $fileName = 'vs_buildtools.exe'; `
    Invoke-WebRequest -Uri "$ENV:VC_BUILDTOOLS_URL" -OutFile $fileName -UseBasicParsing; `
    $args = '--installPath C:\BuildTools --quiet --norestart --wait --nocache `
             --add Microsoft.VisualStudio.Workload.VCTools;includeRecommended `
             --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64;includeRecommended'; `
    $process = Start-Process -FilePath $fileName -ArgumentList $args -Wait -NoNewWindow -PassThru; `
    Remove-Item -Path $fileName -Force; `
    Remove-Item -Path *.txt; `
    if (0 -ne $process.ExitCode) `
    { `
      Write-Host "VS C++ compiler installation failed."; `
      Write-Host "ExitCode: $process.ExitCode"; `
      exit($process.ExitCode); `
    } `
    #Write-Host "Executing the VsDevCmd.bat..."; `
    #$fileName = 'C:\BuildTools\{0}' -f (Get-ChildItem -Path 'C:\BuildTools\' -Recurse -Name VsDevCmd.bat); `
    #Write-Host $fileName; `
    Write-Host "Setting environment variables."; `
    $filePath = 'C:\BuildTools\'; `
    $p0 = $filePath + (Split-Path -Path (Get-ChildItem -Path $filePath -Recurse -Name nmake.exe | Select-String -Pattern '\x64\' -SimpleMatch)); `
    $p1 = $filePath + (Split-Path -Path (Get-ChildItem -Path $filePath -Recurse -Name setargv.obj | Select-String -Pattern '\x64\' -SimpleMatch)); `
    $filePath = 'C:\Program Files (x86)\Windows Kits\'; `
    $p2 = $filePath + (Split-Path -Path (Get-ChildItem -Path $filePath -Recurse -Name rc.exe | Select-String -Pattern '\x64\' -SimpleMatch)); `
    $ENV:PATH = '{0};{1};{2};{3}' -f ($p0, $p1, $p2, $ENV:PATH); `
    [System.Environment]::SetEnvironmentVariable('Path', $ENV:PATH, [System.EnvironmentVariableTarget]::Machine); `
    $filePath = 'C:\BuildTools\'; `
    $i0 = $filePath + (Split-Path -Path (Get-ChildItem -Path $filePath -Recurse -Name limits.h)); `
    $filePath = 'C:\Program Files (x86)\Windows Kits\'; `
    $i1 = $filePath + (Split-Path -Path (Get-ChildItem -Path $filePath -Recurse -Name stdlib.h)); `
    $i2 = $filePath + (Split-Path -Path (Get-ChildItem -Path $filePath -Recurse -Name WinSock2.h)); `
    $i3 = $filePath + (Split-Path -Path (Get-ChildItem -Path $filePath -Recurse -Name winapifamily.h)); `
    $ENV:INCLUDE = '{0};{1};{2};{3}' -f ($i0, $i1, $i2, $i3); `
    [System.Environment]::SetEnvironmentVariable('Include', $ENV:INCLUDE, [System.EnvironmentVariableTarget]::Machine); `
    # Linker... `
    $filePath = 'C:\BuildTools\'; `
    $ENV:LIB = (Get-ChildItem -Path $filePath -Filter 'x64' -Recurse -Directory).FullName | Select-String -Pattern 'lib\x64' -SimpleMatch; `
    $filePath = 'C:\Program Files (x86)\Windows Kits'; `
    $libs = (Get-ChildItem -Path $filePath -Filter 'x64' -Recurse -Directory).FullName | Select-String -Pattern 'ucrt\x64', 'um\x64' -SimpleMatch; `
    for ($l = 0; $l -lt $libs.Length; ++$l) `
    { `
      $ENV:LIB = '{0};{1}' -f ($libs[$l], $ENV:LIB); `
    } `
    [System.Environment]::SetEnvironmentVariable('LIB', $ENV:LIB, [System.EnvironmentVariableTarget]::Machine);

RUN Write-Host "Build OpenSSL"; `
    # Display the values of all the environment variables. `
    # Because environment variables do not have child items, the output of Get-Item and Get-ChildItem is the same. `
    # Sort the list of environment variables by variable name. `
    Get-ChildItem Env: | Sort Name; `
    Set-Location -Path './openssl-1.1.1i'; `
    # Run the perl script 'configure' to automatically modify the '.h' files to work properly. `
    # --release -> Build OpenSSL without debugging symbols. This is the default. `
    # --openssldir -> Directory for OpenSSL configuration files, and the default certificate and key store. `
    # no-shared -> Static library. `
    # WIN64A -> 64-bit. `
    # --prefix -> The installation folder. `
    # --openssl-no-asm -> This will result in binaries that do not take advantage of modern CPU cryptographic instructions and will therefore be slower. `
    New-Item -Path "C:\openssl" -ItemType "Directory"; `
    New-Item -Path "C:\openssl-certs" -ItemType "Directory"; `
    $process = Start-Process -FilePath 'perl.exe' -ArgumentList 'Configure no-shared VC-WIN64A --prefix="C:\openssl" --release --openssldir="C:\openssl"' -Wait -NoNewWindow -PassThru; `
    if (0 -ne $process.ExitCode) `
    { `
      Write-Host "Perl failed."; `
      Write-Host "ExitCode: $process.ExitCode"; `
      exit($process.ExitCode); `
    } `
    $process = Start-Process -FilePath 'nmake' -Wait -NoNewWindow -PassThru; `
    if (0 -ne $process.ExitCode) `
    { `
      Write-Host "nmake failed."; `
      Write-Host "ExitCode: $process.ExitCode"; `
      exit($process.ExitCode); `
    } `
    #$process = Start-Process -FilePath 'nmake' -ArgumentList 'VERBOSE=1 test' -Wait -NoNewWindow -PassThru; `
    #if (0 -ne $process.ExitCode) `
    #{ `
      #Write-Host "nmake test failed."; `
      #Write-Host "ExitCode: $process.ExitCode"; `
      #exit($process.ExitCode); `
    #} `
    $process = Start-Process -FilePath 'nmake' -ArgumentList 'install' -Wait -NoNewWindow -PassThru; `
    if (0 -ne $process.ExitCode) `
    { `
      Write-Host "nmake install failed."; `
      Write-Host "ExitCode: $process.ExitCode"; `
      exit($process.ExitCode); `
    } `
    Write-Host "Done!!!";

# Final image.
FROM ${BASE_OS_LAYER}:${BASE_OS_LAYER_VERSION}

# Add metadata to the image.
LABEL copyright="Copyright (C) 2020 Juan Carlos Trimino. All rights reserved."
LABEL version="1.0.0"
LABEL maintainer="juancarlos@trimino.com"

SHELL ["cmd", "/S", "/C"]

WORKDIR C:/

COPY --from=builder C:/openssl ./openssl

# In order to set system PATH, ContainerAdministrator must be used.
USER ContainerAdministrator

# Appending to PATH from the DOS command line.
# /M specifies to set the variable in the system environment.
# Will be switching to ContainerUser below.
RUN SETX /M PATH "C:\openssl\bin;%PATH%" & `
    SETX /M OPENSSL_CONF "C:\openssl\openssl.cnf" & `
    SETX /M SSL_CERT_DIR "C:\openssl-certs"

# Switch back to the least-privilege account.
# USER ContainerUser

# The directory where certificates and private keys are stored (OPENSSLDIR).
VOLUME C:/openssl-certs

# REST APIs
#EXPOSE "9200/tcp"
# Cluster
#EXPOSE "9300/tcp"

# The Nano Server image uses a least-privilege user by default. Volumes are not accessible by that user; hence, this Dockerfile switches to the administrative account so that when a container is run from this image, volume directories can be accessed.
#USER ContainerAdministrator
ENTRYPOINT ["openssl"]
#CMD "openssl"
