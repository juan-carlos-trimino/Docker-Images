# escape=`
#
# RabbitMQ
ARG BASE_OS_LAYER
ARG BASE_OS_LAYER_VERSION
FROM ${BASE_OS_LAYER}:${BASE_OS_LAYER_VERSION}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR C:/

ARG ERLANG_HOME
ARG ERLANG_VERSION
ARG ERLANG_ROOT_URL

# RabbitMQ requires the Erlang runtime.
RUN Write-Host "Installing ERLANG..."; `
    $url = ("$ENV:ERLANG_ROOT_URL" -f $ENV:ERLANG_VERSION); `
    Write-Host "Downloading Erlang version: $ENV:ERLANG_VERSION, from: $url"; `
    # Using TLS v1.2 -> In PS 6+, use -SslProtocol 'Tls12' `
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; `
    $erlang_install = 'erlang_install.exe'; `
    # -UseBasicParsing -> This parameter has been deprecated. Beginning with PowerShell 6.0.0, all Web requests use basic `
    #                     parsing only. `
    Invoke-WebRequest -Uri $url -OutFile "$erlang_install" -UseBasicParsing; `
    $args = @( `
      # /S -> Silent mode. `
      '/S', `
      # /D -> Set the default installation directory ($INSTDIR), overriding InstallDir and InstallDirRegKey. It must be the `
      #       last parameter used in the command line and must not contain any quotes, even if the path contains spaces. Only `
      #       absolute paths are supported. `
      ('/D={0}' -f $ENV:ERLANG_HOME)); `
    # Build the Erlang emulator and the OTP libraries. `
    # Important: The Erlang installer must be run using an administrative account otherwise a registry key expected by the `
    # RabbitMQ installer will not be present. `
    # -Wait -> Indicate that this cmdlet waits for the specified process and its descendants to complete before accepting more `
    #          input. `
    $process = Start-Process -FilePath $erlang_install -Wait -NoNewWindow -PassThru -ArgumentList $args; `
    if (0 -ne $process.ExitCode) `
    { `
      Write-Host "ERLANG installation failed."; `
      Write-Host "ExitCode: $process.ExitCode"; `
      exit($process.ExitCode); `
    } `
    Remove-Item -Force -Path $erlang_install; `
    Write-Host 'ERLANG is installed.';

ARG ERLANG_HOME
ARG RABBITMQ_BASE
ARG RABBITMQ_ROOT_URL
ARG RABBITMQ_VERSION

RUN Write-Host 'Installing RabbitMQ...'; `
    $url = ("$ENV:RABBITMQ_ROOT_URL" -f $ENV:RABBITMQ_VERSION, $ENV:RABBITMQ_VERSION); `
    Write-Host "Downloading RabbitMQ version: $ENV:RABBITMQ_VERSION, from: $url"; `
    $rabbitmq_install = 'rabbitmq_install.zip'; `
    # Installing on Windows Manually (https://www.rabbitmq.com/install-windows-manual.html) `
    # -UseBasicParsing -> This parameter has been deprecated. Beginning with PowerShell 6.0.0, all Web requests use basic parsing only. `
    Invoke-WebRequest -Uri $url -OutFile $rabbitmq_install -UseBasicParsing; `
    Expand-Archive -Path $rabbitmq_install -DestinationPath "C:/" -Verbose; `
    Remove-Item -Force -Path $rabbitmq_install; `
    Rename-Item -Path "./rabbitmq_server-$ENV:RABBITMQ_VERSION" -NewName './rabbitmq'; `
    Remove-Item -Force -Path "./rabbitmq/*.txt"; `
    # How to save in UTF-8 without Byte Order Mark (BOM). `
    # It is possible to allow the guest user to connect from a remote host by setting the loopback_users configuration to none. `
    # Allowing remote connections for default user is highly discouraged as it dramatically decreases the security of the system!!! `
    # Moved to rabbitmq.config file!!! `
    #$utf8NoBom = New-Object -TypeName System.Text.UTF8Encoding $False; `
    #[System.IO.File]::WriteAllText('./rabbitmq/rabbitmq.config', '[{rabbit, [{loopback_users, []}]}].', $utf8NoBom); `
    #Get-Content -Path './rabbitmq/rabbitmq.config' -Raw; `
    # https://thycotic.github.io/rabbitmq-helper/clustering/ `
    [System.Environment]::SetEnvironmentVariable('PATH', ('{0}bin\;{1}sbin\;{2}' -f $ENV:ERLANG_HOME, $ENV:RABBITMQ_BASE, $Env:Path), [System.EnvironmentVariableTarget]::Machine); `
    #[System.Environment]::SetEnvironmentVariable('HOMEDRIVE', 'C:', [System.EnvironmentVariableTarget]::Machine); `
    #[System.Environment]::SetEnvironmentVariable('HOMEPATH', '/Users/' + $Env:USERNAME, [System.EnvironmentVariableTarget]::Machine); `
    # COMPUTERNAME is different from HOSTNAME (https://www.rabbitmq.com/windows-quirks.html#computername-vs-hostname) `
    #[System.Environment]::SetEnvironmentVariable('RABBITMO_NODENAME', 'rabbit@ALL_CAPS_HOSTNAME', [System.EnvironmentVariableTarget]::Machine); `
    #[System.Environment]::SetEnvironmentVariable('RABBITMQ_NODENAME', 'rabbit@' + $Env:COMPUTERNAME, [System.EnvironmentVariableTarget]::Machine); `
    [System.Environment]::SetEnvironmentVariable('RABBITMQ_NODENAME', 'rabbit@localhost', [System.EnvironmentVariableTarget]::Machine); `
    # Reload the session's environment variables. `
    #$Env:Path = [System.Environment]::GetEnvironmentVariable('PATH', [System.EnvironmentVariableTarget]::Machine); `
    #$Env:HOMEDRIVE = [System.Environment]::GetEnvironmentVariable('HOMEDRIVE', [System.EnvironmentVariableTarget]::Machine); `
    #$Env:HOMEPATH = [System.Environment]::GetEnvironmentVariable('HOMEPATH', [System.EnvironmentVariableTarget]::Machine); `
    #$Env:RABBITMO_NODENAME = [System.Environment]::GetEnvironmentVariable('RABBITMQ_NODENAME', [System.EnvironmentVariableTarget]::Machine); `
    Write-Host 'RabbitMQ is installed.';

RUN Get-ChildItem Env:; `
    # Enabling the Management Portal (requires an elevated command prompt). `
    # rabbitmq-plugins -> Command line tool for managing RabbitMQ plugins. `
    # enable -> Enable the specified plugins and all their dependencies. `
    # rabbitmq_management -> The RabbitMQ management plugin provides an HTTP-based API for management and monitoring of `
    #                        RabbitMQ nodes and clusters, along with a browser-based UI and a command line tool, `
    #                        rabbitmqadmin. `
    # The management UI can be accessed using a Web browser at http://{node-hostname}:15672/. For example, for a node running `
    # on a machine with the hostname of warp10.local, it can be accessed at either http://warp10.local:15672/ or `
    # http://localhost:15672/ (provided that localhost resolves correctly). `
    # --offline -> Modify node's enabled plugin state directly without contacting the node. `
    rabbitmq-plugins.bat enable rabbitmq_management --offline; `
    Write-Host 'Management Portal is enabled.';

SHELL ["cmd", "/S", "/C"]

# Add metadata to the image.
LABEL copyright="Copyright (C) 2020 Juan Carlos Trimino. All rights reserved."
LABEL version="1.0.0"
LABEL maintainer="juancarlos@trimino.com"

ARG ERLANG_HOME
ARG ERLANG_SERVICE_MANAGER_PATH
# Install erlang in this location; set the environment variable so that rabbitmq can locate the erlang installation.
ENV ERLANG_HOME=${ERLANG_HOME}
ENV ERLANG_SERVICE_MANAGER_PATH=${ERLANG_SERVICE_MANAGER_PATH}
# File and Directory Locations (https://www.rabbitmq.com/relocate.html)
# Environment Variables (https://www.rabbitmq.com/configure.html#define-environment-variables)
ARG RABBITMQ_BASE
ENV RABBITMQ_BASE=${RABBITMQ_BASE}
# Override the main RabbitMQ config file location (Default: %APPDATA%\RabbitMQ\rabbitmq); config file path without the .conf.
ENV RABBITMQ_CONFIG_FILE=${RABBITMQ_BASE}rabbitmq
# When set to true this will cause RabbitMQ to use fully qualified names to identify nodes.
ENV RABBITMQ_USE_LONGNAME=true
ENV RABBITMQ_SERVICENAME=RabbitMQ

WORKDIR ${RABBITMQ_BASE}

COPY ./rabbitmq.conf ./

WORKDIR C:/

# epmd, a peer discovery service used by RabbitMQ nodes and CLI tools
EXPOSE 4369/TCP
# 5672, 5671 (with TLS): used by AMQP 0-9-1 and 1.0 clients without and with TLS
EXPOSE 5671/TCP
EXPOSE 5672/TCP
# HTTP API clients, management UI and rabbitmqadmin (only if the management plugin is enabled)
EXPOSE 15672/TCP

# The RabbitMQ server can be run as either an application or service (not both).
# rabbitmq-server.bat starts the broker as an application
# rabbitmq-service.bat manages the service and starts the broker
# rabbitmqctl.bat manages a running broker
# Run server when container starts; container will shutdown when this process ends.
CMD "%RABBITMQ_BASE%sbin\rabbitmq-server.bat"
