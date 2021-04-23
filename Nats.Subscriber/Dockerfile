# nats-subscriber
ARG BASE_OS_LAYER
ARG BASE_OS_LAYER_VERSION
ARG BUILD_BASE_OS_LAYER
ARG BUILD_BASE_OS_LAYER_VERSION
FROM ${BUILD_BASE_OS_LAYER}:${BUILD_BASE_OS_LAYER_VERSION} AS Builder

WORKDIR C:/NATS/

COPY ./CSharp/ ./

# The 'dotnet restore' command uses NuGet to restore dependencies as well as project-specific tools
# that are specified in the project file.
RUN dotnet restore "./Subscriber/Subscriber.csproj" --runtime win10-x64 && \
    # The 'dotnet publish' command packs the application and its dependencies into a folder for \
    # deployment to a hosting system. \
    # -c [--configuration] - {Debug|Release} \
    # -o [--output] - <OUTPUT_DIRECTORY> \
    # --no-restore - It doesn't execute an implicit restore during build. \
    # -r [--runtime] - It specifies the target runtime. \
    # --self-contained - It publishes the .NET runtime with the application so the runtime \
    #                    doesn't need to be installed on the target machine. \
    # -p:PublishTrimmed - It trims unused libraries to reduce the deployment size of an app when \
    #                     publishing a self-contained executable. \
    # -p:PublishSingleFile - It packages the app into a platform-specific single-file executable. \
    dotnet publish "./Subscriber/Subscriber.csproj" -c Release -o ./app --no-restore \
    -r win10-x64 --self-contained true -p:PublishTrimmed=true -p:PublishSingleFile=true && \
    del .\app\*.pdb /Q

# Final image
FROM ${BASE_OS_LAYER}:${BASE_OS_LAYER_VERSION}

USER ContainerUser

# Add metadata to the image.
LABEL copyright="Copyright (C) 2020 Juan Carlos Trimino. All rights reserved."
LABEL version="1.0.0"
LABEL maintainer="juancarlos@trimino.com"

WORKDIR C:/app/

COPY --from=Builder C:/NATS/app/ ./

ENTRYPOINT ["Subscriber.exe"]
