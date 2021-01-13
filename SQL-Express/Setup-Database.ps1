#
function Database-Setup
(
  # By default, mandatory parameters don't allow $null or empty strings.
  [Parameter(Mandatory=$true)]
  [string] $baselinePath,
  [Parameter(Mandatory=$true)]
  [string] $dbInfo,
  [string] $serverName = '.\SQLEXPRESS',  # Local server.
  [string] $sa_password = $ENV:SA_PASSWORD,
  [string] $passwordFilePath = $ENV:PASSWORD_FILE_PATH,
  [string] $dataPath = $ENV:DATA_PATH
)
{
  try
  {
    $dbOp = 1;  # Create.
    if ($dataPath -notmatch '.+?\\$')  # Detect if the string ends with a backslash.
    {
      $dataPath += '\';
    }
    #
    if ('.\SQLEXPRESS' -eq $serverName)
    {
      $serviceName = 'MSSQL$SQLEXPRESS';
      $serviceInfo = Get-Service $serviceName;
      Write-Verbose -Message "$serviceName is now $($serviceInfo.Status)";
      if ('running' -ne $serviceInfo.Status)
      {
        # SQL Server (SQLEXPRESS); Service Name = MSSQL$SQLEXPRESS
        Start-Service -Name $serviceName;
        $serviceInfo = Get-Service $serviceName;
        Write-Verbose -Message "$serviceName is now $($serviceInfo.Status)";
      }
      #
      if ("_" -eq $sa_password)
      {
        if ($null -ne $passwordFilePath -and (Test-Path -Path $passwordFilePath) -eq $true)
        {
          $sa_password = Get-Content -Path $passwordFilePath -Raw;
        }
        else
        {
          Write-Verbose -Message "Secret file not found; using default 'sa' password.";
        }
      }
      #
      if ("_" -ne $sa_password)
      {
        Write-Verbose -Message "Changing the 'sa' login credentials";
        $sqlcmd = "USE master`r`n";
        $sqlcmd += "GO`r`n";
        $sqlcmd += "ALTER LOGIN sa WITH PASSWORD = N'$sa_password';`r`n";
        $sqlcmd += "GO`r`n";
        $sqlcmd += "ALTER LOGIN sa ENABLE;`r`n";
        $sqlcmd += "GO`r`n";
        # Write-Verbose -Message "$sqlcmd";  If display, password will be displayed.
        Invoke-Sqlcmd -Query $sqlcmd -ServerInstance $serverName;
      }
    }
    $dbInfoJson = $dbInfo | ConvertFrom-Json;
    if ([string]::IsNullOrEmpty($dbInfoJson.dbsToAttach))
    {
      Write-Verbose -Message "Missing the data files; creating a new database.";
    }
    else
    {
      $dbOp = 2;  # Attach
      foreach($db in $dbInfoJson.dbsToAttach)
      {
        $mdfPath = $dataPath;
        $ldfPath = $dataPath;
        if (2 -eq $db.dbFiles.Length)
        {
          $mdfPath += $db.dbFiles[0];
          $ldfPath += $db.dbFiles[1];
        }
        Write-Verbose -Message "MDF file at: $mdfPath";
        Write-Verbose -Message "LDF file at: $ldfPath";
        # Attach the data and log files, if they exist.
        # Determine whether all elements of a path exist.
        if ((Test-Path -Path $mdfPath -PathType Leaf) -eq $true -and (Test-Path -Path $ldfPath -PathType Leaf) -eq $true)
        {
          if ([string]::IsNullOrEmpty($db.dbName))
          {
            $dbOp = -1;
            Write-Verbose -Message "`r`n`r`n*** Cannot attach the database; database name missing ***`r`n`r`n";
          }
          else
          {
            Write-Verbose -Message 'Attaching database files...';
            $sqlcmd = "USE master`r`n";
            $sqlcmd += "GO`r`n";
            $sqlcmd += "IF (DB_ID(N'$($db.dbName)') IS NULL)  -- Is the database attached?`r`n";
            $sqlcmd += "BEGIN`r`n";
            $sqlcmd += "  CREATE DATABASE $($db.dbName) ON`r`n";
            $sqlcmd += "    (FILENAME = N'$mdfPath'),`r`n";
            $sqlcmd += "    (FILENAME = N'$ldfPath')`r`n";
            $sqlcmd += "  FOR ATTACH;`r`n";
            $sqlcmd += "END`r`n";
            $sqlcmd += "GO`r`n";
            Write-Verbose -Message "$sqlcmd";
            Invoke-Sqlcmd -Query $sqlcmd -ServerInstance $serverName -Verbose;
            Write-Verbose -Message "`r`n`r`n*** Database '$($db.dbName)' attached ***`r`n`r`n";
          }
        }
        else
        {
          $dbOp = -1;
          Write-Verbose -Message "Data files are missing...";
          Write-Verbose -Message "`r`n`r`n*** Database was not attached ***`r`n`r`n";
        }
      }  #foreach
    }
    #
    if (1 -eq $dbOp)
    {
      # Deploy or upgrade the database.
      # Dacpac goes here...
      if ([string]::IsNullOrEmpty($dbInfoJson.dbScriptName))
      {
        $dbOp = -1;
        Write-Verbose -Message "`r`n`r`n*** Missing the database script ***`r`n`r`n";
      }
      elseif ('.\SQLEXPRESS' -eq $serverName)
      {
        if ($baselinePath -notmatch '.+?\\$')  # Detect if the string ends with a backslash.
        {
          $baselinePath += '\';
        }
        $sqlcmdPath = $("{0}{1}" -f $baselinePath, $($dbInfoJson.dbScriptName));
        $sqlcmdVars = "mdfDir=$dataPath",
                      "ldfDir=$dataPath",
                      "baselineDir=$baselinePath";
        Write-Verbose -Message "Invoke-Sqlcmd -InputFile $sqlcmdPath -ServerInstance $serverName -Variable $sqlcmdVars";
        try
        {
          Invoke-Sqlcmd -InputFile $sqlcmdPath -ServerInstance $serverName -Variable $sqlcmdVars -ErrorAction Stop -Verbose;
          Write-Verbose -Message "`r`n`r`n*** Database created ***`r`n`r`n";
        }
        catch
        {
          $dbOp = -1;
          Write-Verbose -Message "Exception type: $($_.Exception.GetType().FullName)";
          Write-Verbose -Message "Exception message: $($_.Exception.Message)";
          Write-Verbose -Message "Error: $($_.Exception)";
        }
      }
      else  # Remote server.
      {
        $dbOp = -1;
        Write-Verbose -Message "`r`n`r`n*** Invalid operation ***`r`n`r`n";
      }
    }
    #
    if (-1 -eq $dbOp)
    {
      Write-Verbose -Message "To create a new disposable database:";
      Write-Verbose -Message "docker container run --rm --detach --name sqlexpress --env DB_INFO=`"[{'dbScriptName': 'RunInvestmentsSchema.sql'}]`" --publish 1433:1433 sqlexpress/mssql-server-windows:2017`r`n`r`n";
      Write-Verbose -Message "To create a new persistent database:";
      Write-Verbose -Message "docker container run --rm --detach --name sqlexpress --env DB_INFO=`"[{'dbScriptName': 'RunInvestmentsSchema.sql'}]`" --publish 1433:1433 --mount type=bind,source=c:\db\sqlexpress,target=c:\db\data sqlexpress/mssql-server-windows:2017`r`n`r`n";
      Write-Verbose -Message "To attach a database:";
      Write-Verbose -Message "docker container run --rm --detach --name sqlexpress --env DB_INFO=`"[{'dbName': 'Investments', 'mdfFilename': 'Investments_data.mdf', 'ldfFilename': 'Investments_log.ldf'}]`" --publish 1433:1433 --volume c:\db\sqlexpress:C:\db\data sqlexpress/mssql-server-windows:2017`r`n`r`n";
    }
  }
  catch
  {
    Write-Verbose -Message "Exception type: $($_.Exception.GetType().FullName)";
    Write-Verbose -Message "Exception message: $($_.Exception.Message)";
    Write-Verbose -Message "Error: $_.Exception";
  }
  finally
  {
    # Keep the container running.
    $lastCheck = (Get-Date).AddSeconds(-2);
    while ($true)
    {
      Get-EventLog -LogName Application -Source "MSSQL*" -After $lastCheck | Select-Object TimeGenerated, EntryType, Message;
      $lastCheck = Get-Date;
      Start-Sleep -Seconds 5;
    }
  }
}
