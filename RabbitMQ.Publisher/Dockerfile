# rabbitmq-publisher
#ARG BASE_OS_LAYER
#ARG BASE_OS_LAYER_VERSION
#ARG BUILD_BASE_OS_LAYER
#ARG BUILD_BASE_OS_LAYER_VERSION
#FROM ${BUILD_BASE_OS_LAYER}:${BUILD_BASE_OS_LAYER_VERSION} AS Builder
FROM mcr.microsoft.com/dotnet/core/sdk:5.0 AS Builder

WORKDIR c:/Message-CS/

COPY ./Message-CS/ ./

RUN dotnet restore "./Message.csproj"

RUN dotnet build "./Message.csproj" -c Release -o /app

RUN dotnet publish "./Message.csproj" -c Release -o /app

WORKDIR c:/Publisher-CS/

COPY ./Publisher-CS/ ./

# Use NuGet to restore dependencies as well as project-specific tools that are specified in the project file. By default, the
# restoration of dependencies and tools are executed in parallel.
RUN dotnet restore "./Publisher.csproj"

# Build a project and all of its dependencies.
# -c [--configuration] {Debug|Release}
# -o [--output] <OUTPUT_DIRECTORY>
RUN dotnet build "./Publisher.csproj" -c Release -o /app

# Pack the application and its dependencies into a folder for deployment to a hosting system.
# -c [--configuration] {Debug|Release}
# -o [--output] <OUTPUT_DIRECTORY>
RUN dotnet publish "./Publisher.csproj" -c Release -o /app

RUN del \app\*.pdb /Q

# Final image
#FROM ${BASE_OS_LAYER}:${BASE_OS_LAYER_VERSION}
FROM mcr.microsoft.com/dotnet/core/runtime:5.0

# Add metadata to the image.
LABEL copyright="Copyright (C) 2020 Juan Carlos Trimino. All rights reserved."
LABEL version="1.0.0"
LABEL maintainer="juancarlos@trimino.com"

WORKDIR c:/app/

COPY --from=Builder /app ./

CMD ["dotnet", "Publisher.dll"]
