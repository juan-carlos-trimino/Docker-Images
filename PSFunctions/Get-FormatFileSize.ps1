#
function Get-FormatFileSize
(
  # By default, mandatory parameters don't allow $null or empty strings.
  [Parameter(Mandatory=$true)]
  [int] $size
)
{
  if ($size -gt 1TB)
  {
    [string]::Format("{0:0.000} TB", $size / 1TB);
  }
  elseif ($size -gt 1GB)
  {
    [string]::Format("{0:0.000} GB", $size / 1GB);
  }
  elseif ($size -gt 1MB)
  {
    [string]::Format("{0:0.000} MB", $size / 1MB);
  }
  elseif ($size -gt 1KB)
  {
    [string]::Format("{0:0.000} KB", $size / 1KB);
  }
  else
  {
    [string]::Format("{0} B", $size);
  }
}
