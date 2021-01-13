# escape=`
#
# sqlexpress
#
# Usage
#  > docker image build --tag veni-vidi-vici/sqlexpress:mssql-server-windows-express-2017 .
#
# This SQL Express image supports multiple scenarios for setting up a database:
#	* Starting a new container with an empty database
# *	Starting a new container with an existing database
# *	Starting a new container with an existing database and upgrade the database
#
# Note
# ----
# To connect remotely using a SQL client to the database running inside the container, publish the standard SQL Server Express
# port 1433. If there is a SQL Server Express instance already running on the host using port 1433, map the container's port 1433
# to a different and unused port on the host.
#
# TO CREATE A NEW EMPTY DISPOSABLE DATABASE
# -----------------------------------------
# The mdf and ldf files are being stored in a volume on the host's disk. But if the container is removed, the files will be
# removed as well. This database will not survive beyond the life of the container.
# > docker container run --rm --detach --name sqlexpress --env DB_INFO="[{'dbScriptName': 'RunInvestmentsSchema.sql'}]" --publish 1433:1433 sqlexpress/mssql-server-windows:2017
#
# TO CREATE A NEW EMPTY PERSISTENT DATABASE
# -----------------------------------------
# To store the mdf and ldf files permanently, map the files to a location on the host. The first time a container is run, it will
# create the files in the host directory. Thereafter, if using the same volume mount, the new container will attach to the
# existing files. By mounting a host directory as a volume, the process in the container will be accessing the files from the
# host filesystem.
# > docker container run --rm --detach --name sqlexpress --env DB_INFO="[{'dbScriptName': 'RunInvestmentsSchema.sql'}]" --publish 1433:1433 --volume c:\db\sqlexpress:c:\db\sqlexpress veni-vidi-vici/sqlexpress:mssql-server-windows-express-2017
#
# or
#
# > docker container run --rm --detach --name sqlexpress --env DB_INFO="[{'dbScriptName': 'RunInvestmentsSchema.sql'}]" --publish 1433:1433 --mount type=bind,source=c:\db\sqlexpress,target=c:\db\sqlexpress veni-vidi-vici/sqlexpress:mssql-server-windows-express-2017
#
# TO ATTACH TO A PERSISTENT DATABASE
# ----------------------------------
# One database to attach.
# > docker container run --rm --detach --name sqlexpress --env DB_INFO="[{'dbsToAttach': [{'dbName': 'Investments', 'dbFiles': ['Investments_data.mdf', 'Investments_log.ldf']}]}]" --publish 1433:1433 --mount type=bind,source=c:\db\sqlexpress,target=c:\db\sqlexpress veni-vidi-vici/sqlexpress:mssql-server-windows-express-2017
#
# Two or more databases to attach.
# > docker container run --rm --detach --name sqlexpress --env DB_INFO="[{'dbsToAttach': [{'dbName': 'Investments', 'dbFiles': ['Investments_data.mdf', 'Investments_log.ldf']}, {'dbName': 'Nova', 'dbFiles': ['Nova_data.mdf', 'Nova_log.ldf']}]}]" --publish 1433:1433 --mount type=bind,source=c:\db\sqlexpress,target=c:\db\sqlexpress veni-vidi-vici/sqlexpress:mssql-server-windows-express-2017
#
# DISPLAY THE LOGS
# ----------------
# > docker container logs sqlexpress
#
# CONNECT TO DATABASE
# -------------------
# To connect to the database in the container using SQL Server Management Studio or any other SQL Server client, get the IP
# address of the container from the host and use the 'sa' credentials.
# PS> docker container inspect --format "{{ .NetworkSettings.Networks.nat.IPAddress }}" sqlexpress
#
# and to obtain the port
#
# > docker container port sqlexpress
#
# TO QUERY THE DATABASE
# ---------------------
# > docker container exec sqlexpress powershell -Command "Invoke-SqlCmd -Query 'SELECT * FROM Security.Securities' -Database Investments -ServerInstance .\SQLEXPRESS"
#
# TO CHECK THE DATABASE VERSION RUNNING IN THE CONTAINER
# ------------------------------------------------------
# To obtain the version of SQL Server Express in a running container, run the following command. Replace "Passw0rd" with the SQL
# Server Express password for the 'sa' login.
# PS> docker exec sqlexpress sqlcmd -S localhost -U sa -P "Passw0rd" -Q 'SELECT @@VERSION'
# PS> docker exec sqlexpress sqlcmd -Q 'SELECT @@VERSION'
#
# EXECUTE COMMANDS IN A CONTAINER
# -------------------------------
# If you have a running container, you can execute commands within the container from a host terminal. By starting a terminal,
# you can run commands as though you are running them at the terminal inside the container. When finished, type exit. This exits
# the interactive command session, but your container continues to run.
# > docker container exec -it sqlserver powershell
#
# TO CHECK THE RESOURCES
# ----------------------
# To display the current resources
# > docker exec sqlexpress1 SystemInfo | Select-String 'Total Physical Memory', 'Processor'
#
# or
#
# PS> docker exec -it sqlexpress1 powershell
# > Get-WmiObject -Class Win32_Processor | Format-Table -Property Name, NumberOfCores, NumberOfLogicalProcessors
#
# TO CHANGE THE RESOURCES
# -----------------------
# To change the resources available to a container at runtime, use the --cpus and --memory switches.
# > docker container run --rm -d --name sqlexpress1 --cpus=3 --memory=8192M -p 1401:1433 -e ACCEPT_EULA="Y" -e SA_PASSWORD="Passw0rd" microsoft/mssql-server-windows-express:2017
#
# RUNNING MULTIPLE SQL SERVER CONTAINERS
# --------------------------------------
# To run multiple SQL Server containers on the same host, each container must expose itself on a different port. In the following
# example, the first container is mapped to port 1401 on the host, and the second container is mapped to port 1402. Clients can
# connect to each SQL Server Express instance by using the IP address and port of the container.
# > docker container run --rm -d --name sqlexpress1 -p 1401:1433 -e ACCEPT_EULA="Y" -e SA_PASSWORD="Passw0rd" microsoft/mssql-server-windows-express:2017
# > docker container run --rm -d --name sqlexpress2 -p 1402:1433 -e ACCEPT_EULA="Y" -e SA_PASSWORD="Passw0rd" microsoft/mssql-server-windows-express:2017
#
# SQL Express is the free version of SQL Server; it is suitable for development and test environments as well as for production
# with a smaller workload.
ARG BASE_OS_LAYER
ARG BASE_OS_LAYER_VERSION
FROM ${BASE_OS_LAYER}:${BASE_OS_LAYER_VERSION}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Add metadata to the image.
LABEL copyright="Copyright (C) 2019 Juan Carlos Trimiño. All rights reserved."
LABEL version="1.0.0"
LABEL maintainer="juancarlos@trimino.com"

ARG DB_INFO
# Environment variables are not meant for sensitive data; Docker Secrets are a better option.
# This is not explicitly stated, but the SA_PASSWORD and ACCEPT_EULA environment variables must be set, or the container instance
# of SQL Server will not start.
ENV ACCEPT_EULA="Y"
# Set a default password for the 'sa' user.
# Set SA_PASSWORD="_" to read the password from PASSWORD_FILE_PATH.
ENV SA_PASSWORD="Passw0rd"
# For a persistent database, the database files will be stored outside of the container in a volume.
ENV DATA_PATH="C:\db\sqlexpress\"
#ENV DB_INFO="[]"
ENV DB_INFO=${DB_INFO}
ENV PASSWORD_FILE_PATH="C:\ProgramData\Docker\secrets\sa-password.txt"
ENV BASELINE_PATH="C:\db\DbScripts\Baseline"

VOLUME ${DATA_PATH}

# The default port for SQL Server.
EXPOSE 1433/tcp

WORKDIR "C:\db\"

COPY ./DbScripts/ ./DbScripts/
COPY ./Setup-Database.ps1 ./

EXPOSE "1433/tcp"

# This script will create the new schema or apply changes to the old schema to upgrade it.
# Dot-sourcing the script or function to run in the current scope.
CMD . .\Setup-Database.ps1; `
    Database-Setup -baselinePath $ENV:BASELINE_PATH -dbInfo $ENV:DB_INFO -Verbose;

HEALTHCHECK --start-period=10s `
            --interval=10s `
            --retries=10 `
            --timeout=3s `
  CMD ["sqlcmd", "-Q", "select 1"]
