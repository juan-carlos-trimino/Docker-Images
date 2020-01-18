#
function Initialize-Kibana
(
  [string] $elasticsearchHosts
)
{
  try
  {
    Write-Host "Starting Kibana...";
    if (-not ([string]::IsNullOrEmpty($elasticsearchHosts)))
    {
      Write-Host "Changing ELASTICSEARCH_HOSTS to: $elasticsearchHosts";
      $old = 'elasticsearch.hosts: \"http://elasticsearch:9200\"';
      $new = "elasticsearch.hosts: `"$elasticsearchHosts`"";
      $ymlPath = './config/kibana.yml';
      (Get-Content -Path $ymlPath -Raw) -replace $old, $new | Set-Content -Path $ymlPath;
    }
    # Call operator & - Run a command, script, or script block. The call operator, also known as the "invocation operator,"
    # lets you run commands that are stored in variables and represented by strings or script blocks. The call operator
    # executes in a child scope.
    & c:/kibana/bin/kibana.bat;
  }
  catch
  {
    Write-Host "Exception type: $($_.Exception.GetType().FullName)";
    Write-Host "Exception message: $($_.Exception.Message)";
    Write-Host "Error: $_.Exception";
  }
  finally
  {
    Write-Host "Exiting the container...";
  }
}
