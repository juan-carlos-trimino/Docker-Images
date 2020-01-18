# escape=`
#
# Elasticsearch
ARG BASE_OS_LAYER
ARG BASE_OS_LAYER_VERSION
ARG BUILD_BASE_OS_LAYER
ARG BUILD_BASE_OS_LAYER_VERSION
FROM ${BUILD_BASE_OS_LAYER}:${BUILD_BASE_OS_LAYER_VERSION} AS builder

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ARG ES_VERSION
ARG ES_HOME
ARG ES_ROOT_URL
ENV ES_VERSION=${ES_VERSION}
ENV ES_HOME=${ES_HOME}
ENV ES_ROOT_URL=${ES_ROOT_URL}

COPY ./Get-FormatFileSize.ps1 ./

RUN Write-Host "Downloading: $ENV:ES_ROOT_URL-$ENV:ES_VERSION-windows-x86_64.zip.sha512"; `
    # -UseBasicParsing -> This parameter has been deprecated. Beginning with PowerShell 6.0.0, all Web requests use basic parsing only. `
    Invoke-WebRequest -Uri "$ENV:ES_ROOT_URL-$ENV:ES_VERSION-windows-x86_64.zip.sha512" -OutFile 'elasticsearch.zip.sha' -UseBasicParsing; `
    $esSHA = (Get-Content -Path elasticsearch.zip.sha -Raw).Split(' ')[0]; `
    Remove-Item -Path elasticsearch.zip.sha; `
    Invoke-WebRequest -Uri "$ENV:ES_ROOT_URL-$ENV:ES_VERSION-windows-x86_64.zip" -OutFile 'elasticsearch.zip' -UseBasicParsing; `
    Write-Host "Verifying sha512 ($esSHA)..."; `
    if ((Get-FileHash -Path elasticsearch.zip -Algorithm sha512).Hash.ToLower() -ne $esSHA) `
    { `
      exit(1); `
    } `
    # Unzip it with your favorite unzip tool. This will create a folder called elasticsearch-Version. `
    . .\Get-FormatFileSize.ps1; `
    Write-Host "Unzipping elasticsearch.zip -- Size: $(Get-FormatFileSize((Get-Item -Path elasticsearch.zip).Length))"; `
    # Write-Host "Unzipping elasticsearch.zip -- Size: $((Get-Item -Path elasticsearch.zip).Length)"; `
    Expand-Archive -Path elasticsearch.zip -DestinationPath C:\ -Verbose; `
    # Remove the last / from the path. `
    $newPath = $ENV:ES_HOME.Substring(0, $ENV:ES_HOME.Length - 1); `
    Rename-Item -Path "$newPath-$ENV:ES_VERSION" -NewName $newPath; `
    Remove-Item -Path elasticsearch.zip;

# Final image.
FROM ${BASE_OS_LAYER}:${BASE_OS_LAYER_VERSION}

# Add metadata to the image.
LABEL copyright="Copyright (C) 2020 Juan Carlos Trimino. All rights reserved."
LABEL version="1.0.0"
LABEL maintainer="juancarlos@trimino.com"

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ARG ES_HOME
ENV ES_HOME=${ES_HOME}

WORKDIR ${ES_HOME}

COPY --from=builder C:\elasticsearch\ ./
# Elasticsearch loads its configuration from the %ES_HOME%\config\elasticsearch.yml file by default. The format of this config
# file is explained in https://www.elastic.co/guide/en/elasticsearch/reference/current/settings.html
COPY ./config/ ./config/

# REST APIs
EXPOSE "9200/tcp"
# Cluster
EXPOSE "9300/tcp"

USER ContainerUser

# By default, Elasticsearch runs in the foreground, prints its logs to STDOUT, and can be stopped by pressing Ctrl-C.
# Elasticsearch can be started from the command line as follows:
SHELL ["cmd", "/S", "/C"]
CMD ".\bin\elasticsearch.bat"

HEALTHCHECK --start-period=10s `
            --interval=10s `
            --retries=10 `
            --timeout=3s `
  CMD powershell -Command `
      try `
      { `
        $response = Invoke-WebRequest -Uri http://localhost:9200/_cat/health -UseBasicParsing; `
        $health = $response.Content.Split(' ')[3]; `
        if ('green' -eq $health -or 'yellow' -eq $health) `
        { `
          return(0); `
        } `
        else `
        { `
          return(1); `
        } `
      } `
      catch `
      { `
        return(1); `
      }
