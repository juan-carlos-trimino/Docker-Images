# escape=`
#
# esmovies
ARG BASE_OS_LAYER
ARG BASE_OS_LAYER_VERSION
ARG BUILD_BASE_OS_LAYER
ARG BUILD_BASE_OS_LAYER_VERSION
FROM ${BUILD_BASE_OS_LAYER}:${BUILD_BASE_OS_LAYER_VERSION} AS builder

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ARG PY_VERSION
ARG PY_HOME
ARG PY_ROOT_URL
ENV PY_VERSION=${PY_VERSION}
ENV PY_HOME=${PY_HOME}
ENV PY_ROOT_URL=${PY_ROOT_URL}

WORKDIR ${PY_HOME}

RUN $python = 'python.exe'; `
    $url = ("$ENV:PY_ROOT_URL" -f $ENV:PY_VERSION, $ENV:PY_VERSION); `
    Write-Host "Downloading: $url..."; `
    # Using TLS v1.2 -> In PS 6+, use -SslProtocol 'Tls12' `
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; `
    # -UseBasicParsing -> This parameter has been deprecated. Beginning with PowerShell 6.0.0, all Web requests use basic parsing only. `
    Invoke-WebRequest -Uri "$url" -OutFile ./$python -UseBasicParsing; `
    $dirName = 'C:\Program Files\'; `
    # Get the ACL of the directory. `
    $acl = Get-Acl -Path $dirName; `
    $acl | Format-List; `
    $user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name; `
    Write-Host "Current User: $user"; `
    $fileSystemRights = [System.Security.AccessControl.FileSystemRights]::FullControl; `
    $inheritanceFlags = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit -bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit; `
    $propagationFlags = [System.Security.AccessControl.PropagationFlags]::None; `
    $accessControlType = [System.Security.AccessControl.AccessControlType]::Allow; `
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($user, $fileSystemRights, $inheritanceFlags, $propagationFlags, $accessControlType); `
    $acl.SetAccessRule($rule); `
    Set-Acl -Path $dirName -AclObject $acl; `
    Get-Acl -Path $dirName | Format-List; `
    Write-Host 'Installing Python...'; `
    $args = @( `
      # To completely hide the installer UI and install Python silently. `
      '/quiet', `
      # Perform a system-wide installation. `
      # %ProgramFiles%\Python X.Y or %ProgramFiles(x86)%\Python X.Y `
      'InstallAllUsers=1', `
      # The installation directory. `
      # 'TargetDir=C:/Python', `
      # Add install and Scripts directories to PATH and .PY to PATHEXT. `
      'PrependPath=1', `
      # Create shortcuts for the interpreter, documentation, and IDLE, if installed. `
      'Shortcuts=0', `
      # Do not install Python manual. `
      'Include_doc=0', `
      # Install bundled pip and setuptools. `
      'Include_pip=1', `
      # Do not install standard library test suite. `
      'Include_test=0'); `
    $process = Start-Process -FilePath $python -ArgumentList $args -Wait -PassThru -NoNewWindow; `
    if (0 -eq $process.ExitCode) `
    { `
      Write-Host "Python is installed."; `
      # Environment Variable Scopes `
      # There are three scopes of environment variables; each of the scopes either combine or overwrite one another. They are defined in a hierarchy like: machine --> user --> process with each scoped variable overwriting the parent variable if one exists in the parent scope. `
      # Environment Variable Scope Types `
      # There are three different environment variable scopes in Windows. `
      # Machine `
      # Environment variables in the machine scope are associated with the running instance of Windows. Any user account can read these, but setting, changing, or deleting them needs to done with elevated privileges. `
      # `
      # User `
      # Environment variables in the user scope are associated with the user running the current process. User variables overwrite machine-scoped variables having the same name. `
      # `
      # Process `
      # Environment variables in the process scope are a combination of the machine and user scopes, along with some variables that Windows creates dynamically. `
      # `
      # The installer updated PATH (Machine) so refresh the local value. `
      Write-Host "PATH: $ENV:PATH"; `
      $ENV:PATH = [System.Environment]::GetEnvironmentVariable('PATH', [System.EnvironmentVariableTarget]::Machine); `
      Write-Host "PATH: $ENV:PATH"; `
      Write-Host 'Verifying Python installation...'; `
      Write-Host 'Python Version: ' (python --version); `
      Write-Host 'Upgrading pip...'; `
      python -m pip install -U pip; `
      Write-Host 'Installing Falcon...'; `
      pip install falcon; `
      Write-Host 'Installing Waitress...'; `
      pip install waitress; `
      Write-Host "Removing $python..."; `
      Remove-Item -Path $python; `
    } `
    else `
    { `
      Write-Host "Python installation failed."; `
      # ExitCode 1603 when silently installing - Permission issues with 'C:\Program Files\' `
      Write-Host "ExitCode: $process.ExitCode"; `
      exit($process.ExitCode); `
    } `
    Write-Host "Installation was completed...";

# Final image.
FROM ${BASE_OS_LAYER}:${BASE_OS_LAYER_VERSION}

SHELL ["cmd", "/S", "/C"]

# Add metadata to the image.
LABEL copyright="Copyright (C) 2019 Juan Carlos Trimino. All rights reserved." `
      version="1.000" `
      maintainer="juancarlos@trimino.com"

ARG PY_INSTALL_TO_PATH
ARG PY_COPY_FROM_PATH
ARG PY_HOME

WORKDIR ${PY_HOME}

COPY ./ESMovies.py ./ESMovies.py
COPY ./ESFalcon.py ./ESFalcon.py
COPY --from=builder ["${PY_COPY_FROM_PATH}", "${PY_INSTALL_TO_PATH}"]

# In order to set system PATH, ContainerAdministrator must be used.
USER ContainerAdministrator

# Appending to PATH from the DOS command line.
# /M specifies to set the variable in the system environment.
RUN SETX /M PATH "C:\Python38\Scripts\;C:\Python38\;%PATH%"

USER ContainerUser

EXPOSE "18080/tcp"

# By default, Python buffers output to sys.stdout.
# -u -> Force stdin, stdout and stderr to be totally unbuffered. On systems where it matters, also put stdin, stdout and stderr in binary mode.
# Environment variables
# PYTHONUNBUFFERED -> If this is set to a non-empty string, it is equivalent to specifying the -u option.
CMD "python -u ESMovies.py"
