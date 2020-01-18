#
# A function that will display out all the properties of an error object and then iterate through any InnerException properties on the error record exception to show all the underlying errors that occurred.
#
# There's a special variable $error that contains a collection of the errors that occurred while the engine was running. This collection is maintained as a circular bounded buffer. As new errors occur, old ones are discarded. The number of errors that is retained is controlled by the $MaximumErrorCount variable, which can be set to a number from 256 (the default setting) to 32768. The collection in $error is an array (technically an instance of System.Collections.ArrayList) that buffers errors as they occur. The most recent error is always stored in $error[0].
#
# NOTE - Although it's tempting to think that you could set $MaximumErrorCount to some large value (32768 is the largest allowed) and never have to worry about capturing errors, in practice this strategy isn't a good idea. Rich error objects also imply fairly large error objects. If you set $MaximumErrorCount to too large a value, you won't have any memory left. In practice, there's usually no reason to set it to anything larger than the default, though you may set it to something smaller if you want to make more space available for other things. Also, even if you have only a few objects, these objects may be large. If you find that this is the case for a particular script, you can change the maximum error count to something small. As an alternative, you could clean out all the entries in $error by calling $error.Clear().
#
function Show-ErrorDetails
(
  # By default, it shows the most recent error recorded in $error.
  $errorRecord = $error[0]
)
{
  $errorRecord | Format-List -Property * -Force;
  $errorRecord.InvocationInfo | Format-List -Property *;
  $exception = $errorRecord.Exception;
  for ($depth = 0; $null -ne $exception; ++$depth)
  {
    "$depth" * 80;  # Show depth of nested exception.
    $exception | Format-List -Property * -Force;  # Show exception properties.
    $exception = $exception.InnerException;  # Link to nest exceptions.
  }
}
