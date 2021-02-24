#
# Load the function to the current PowerShell session.
# PS> . .\Hash-String.ps1
# PS> Hash-String "admin"
#
# While some hash algorithms, including MD5 and SHA1, are no longer considered secure against attack, the goal of a secure hash algorithm is to render it impossible to change the contents of a file -- either by accident, or by malicious or unauthorized attempt -- and maintain the same hash value. You can also use hash values to determine if two different files have exactly the same content. If the hash values of two files are identical, the contents of the files are also identical.
#
function Hash-String
(
  # By default, mandatory parameters don't allow $null or empty strings.
  [Parameter(Mandatory=$true)]
  [string] $stringToHash,
  # The acceptable values for this parameter are: SHA1, SHA256, SHA384, SHA512, MD5.
  [string] $algorithm = "SHA1"
)
{
  if ([string]::IsNullOrEmpty($algorithm) -or
      [string]::IsNullOrWhiteSpace($algorithm))
  {
    Write-Host "The algorithm parameter cannot be empty, null, or white space.`r`n";
  }
  else
  {
    $stream = [System.IO.MemoryStream]::new();
    $writer = [System.IO.StreamWriter]::new($stream);
    $writer.write($stringToHash);
    $writer.Flush();
    $stream.Position = 0;
    # Write-Host "$(Get-FileHash -Algorithm $($algorithm) -InputStream $($stream) | Select-Object Hash)";
    Get-FileHash -Algorithm $algorithm -InputStream $stream | Select-Object Hash;
  }
}
