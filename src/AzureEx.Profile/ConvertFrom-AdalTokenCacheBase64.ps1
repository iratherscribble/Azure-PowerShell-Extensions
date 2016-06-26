function ConvertFrom-AdalTokenCacheBase64
{
	<#
	.Synopsis
		This cmdlet will deserialize from a base64 encoded ADAL token cache.
	.Example
		PS> ConvertFrom-AdalTokenCacheBase64 $base64
	#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string] $TokenCacheBase64Encoded
        )
    process {
        $bytes = [Convert]::FromBase64String($TokenCacheBase64Encoded)
        $tokenCache = New-Object Microsoft.IdentityModel.Clients.ActiveDirectory.TokenCache(@(,$bytes))
        $tokenCache.ReadItems()
    }
}
