# escape=`
#
# Kibana
ARG BASE_OS_LAYER
ARG BASE_OS_LAYER_VERSION
ARG BUILD_BASE_OS_LAYER
ARG BUILD_BASE_OS_LAYER_VERSION
FROM ${BUILD_BASE_OS_LAYER}:${BUILD_BASE_OS_LAYER_VERSION} AS builder

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ARG KIBANA_VERSION
ARG KIBANA_HOME
ARG KIBANA_ROOT_URL
ENV KIBANA_VERSION=${KIBANA_VERSION}
ENV KIBANA_HOME=${KIBANA_HOME}
ENV KIBANA_ROOT_URL=${KIBANA_ROOT_URL}

COPY ./Get-FormatFileSize.ps1 ./

RUN Write-Host "Downloading: $ENV:KIBANA_ROOT_URL-$ENV:KIBANA_VERSION-windows-x86_64.zip.sha512"; `
    # -UseBasicParsing -> This parameter has been deprecated. Beginning with PowerShell 6.0.0, all Web requests use basic parsing only. `
    Invoke-WebRequest -Uri "$ENV:KIBANA_ROOT_URL-$ENV:KIBANA_VERSION-windows-x86_64.zip.sha512" -OutFile 'kibana.zip.sha' -UseBasicParsing; `
    $kibanaSHA = (Get-Content -Path kibana.zip.sha -Raw).Split(' ')[0]; `
    Remove-Item -Path kibana.zip.sha; `
    Invoke-WebRequest -Uri "$ENV:KIBANA_ROOT_URL-$ENV:KIBANA_VERSION-windows-x86_64.zip" -OutFile 'kibana.zip' -UseBasicParsing; `
    Write-Host "Verifying sha512 ($kibanaSHA)..."; `
    if ((Get-FileHash -Path kibana.zip -Algorithm sha512).Hash.ToLower() -ne $kibanaSHA) `
    { `
      exit(1); `
    } `
    # Unzip it with your favorite unzip tool. This will create a folder called kibana-Version-windows-x86_64. `
    . .\Get-FormatFileSize.ps1; `
    Write-Host "Unzipping kibana.zip -- Size: $(Get-FormatFileSize((Get-Item -Path kibana.zip).Length))"; `
    Expand-Archive -Path kibana.zip -DestinationPath C:\ -Verbose; `
    # Remove the last / from the path. `
    $newPath = $ENV:KIBANA_HOME.Substring(0, $ENV:KIBANA_HOME.Length - 1); `
    Rename-Item -Path "$newPath-$ENV:KIBANA_VERSION-windows-x86_64" -NewName $newPath; `
    Remove-Item -Path kibana.zip; `
    # Default configuration for host & Elasticsearch URL `
    $old = '#server.host: \"localhost\"'; `
    $new = 'server.host: \"0.0.0.0\"'; `
    $ymlPath = './kibana/config/kibana.yml'; `
    (Get-Content -Path $ymlPath -Raw) -replace $old, $new | Set-Content -Path $ymlPath; `
    $old = '#elasticsearch.hosts: \[\"http://localhost:9200\"\]'; `
    # The Kibana image connects to Elasticsearch by convention using the service name elasticsearch, which is the name used in `
    # the Docker Compose file to support the convention. The Docker platform will route any requests to the elasticsearch `
    # service running on the host while load-balancing between containers if there are multiple containers running the service; `
    # Kibana will be able to find Elasticsearch at the expected domain name. `
    $new = 'elasticsearch.hosts: \"http://elasticsearch:9200\"'; `
    (Get-Content -Path $ymlPath -Raw) -replace $old, $new | Set-Content -Path $ymlPath;

# Final image.
FROM ${BASE_OS_LAYER}:${BASE_OS_LAYER_VERSION}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Add metadata to the image.
LABEL copyright="Copyright (C) 2020 Juan Carlos Trimino. All rights reserved."
LABEL version="1.0.0"
LABEL maintainer="juancarlos@trimino.com"

ARG KIBANA_VERSION
ARG KIBANA_HOME
ARG ELASTICSEARCH_HOSTS
ENV KIBANA_VERSION=${KIBANA_VERSION}
ENV KIBANA_HOME=${KIBANA_HOME}
ENV ELASTICSEARCH_HOSTS=${ELASTICSEARCH_HOSTS}

WORKDIR ${KIBANA_HOME}

COPY ./Initialize-Kibana.ps1 ./
COPY --from=builder C:\kibana\ ./

# Default port for Kibana
EXPOSE "5601/tcp"

USER ContainerUser

# By default, Kibana runs in the foreground, prints its logs to STDOUT, and can be stopped by pressing Ctrl-C.
# Dot-sourcing the script or function to run in the current scope.
CMD . .\Initialize-Kibana.ps1; `
    Initialize-Kibana -elasticsearchHosts $ENV:ELASTICSEARCH_HOSTS -Verbose;

HEALTHCHECK --start-period=30s `
            --interval=10s `
            --retries=5 `
            --timeout=5s `
  CMD powershell -Command `
      try `
      { `
        # Confirm that Kibana is running. `
        $response = Invoke-WebRequest -Uri http://localhost:5601/app/kibana -UseBasicParsing; `
        if (200 -eq $response.StatusCode) `
        # if ($response.StatusCode -gt 199 -and $response.StatusCode -lt 300) `
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
