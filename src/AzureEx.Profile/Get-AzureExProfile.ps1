function Get-AzureExProfile
{
    <#
    .Synopsis
        Save-AzureRmProfile currently (1.5.0) only persists the profile to a file, this helper script
        will use a temporary file to save it, then return the deserialized json object and delete 
        the temporary file.

        If you specify optional switch `-DecodeTokenCache` then it will also deserialize the base64 encoded token caches.
    .Example
        PS> Get-AzureExProfile 
    #>
    [CmdletBinding()]
    param (
        [switch] $DecodeTokenCache
    )
    
    $tempfile = [IO.Path]::GetTempFileName()
    Save-AzureRmProfile -Path $tempfile
    $result = ConvertFrom-Json (Get-Content $tempfile -Raw)
    Remove-Item $tempfile

    if ($DecodeTokenCache) {
        $result.Context.TokenCache = $result.Context.TokenCache | ConvertFrom-AdalTokenCacheBase64
    }

    $result
}
