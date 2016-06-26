function Get-AzureExGraphAccessToken
{
	<#
	.Synopsis
		This cmdlet will re-use the existing AzureRM powershell cmdlets to get a valid AccessToken to access Graph API for the specified tenant (id).
	.Example
		PS> Get-AzureExGraphAccessToken
	#>
	[CmdletBinding()]
	param (
        # If not specified then uses current azure subscription's default tenant id
        [string] $TenantId
		)

	function GetTokenCacheByTenantResource($tokenCaches, $tenantId, $resource) {
		$resource = $resource.TrimEnd('/')
		foreach($tokenCache in $tokenCaches) {
			$r = $tokenCache.Resource.TrimEnd('/')
			if ($r -eq $resource) {
				$a = $tokenCache.Authority.TrimEnd('/')
				if ($a.EndsWith($tenantId, 'OrdinalIgnoreCase')) {
					return $tokenCache
				}
			}
		}
	}

	for ($i = 0; $i -lt 2; $i++) {
		$p = GetProfile

		$resource = $p.Context.Environment.Endpoints.Graph
		if (!$resource) { throw "Unable to get graph api endpoint from AzureRM profile" }
		
		if (!$TenantId) { 
			$TenantId = $p.Context.Tenant.Id 
			if (!$TenantId) { throw "Unable to get tenant id from AzureRM profile" }
		}

		[array] $tokenCaches = $p.Context.TokenCache

		$tokenCache = GetTokenCacheByTenantResource $tokenCaches $TenantId $Resource

		$reason = $null
		if (!$tokenCache) { $reason = "No Graph API access token yet" }
		elseif ($tokenCache.ExpiresOn -le (Get-Date)) { $reason = "Token cache expired" }

		if ($reason) {
			Write-Warning "$reason for tenant $TenantId, will retry after refreshing token"  
			Get-AzureRmAdApplication -IdentifierUri ([Guid]::NewGuid())
			GetProfile -Reset | Out-Null
		} else {
			if (!$tokenCache.AccessToken) {
				throw "Invalid AccessToken for the found token cache entry matching tenant $TenantId and resource $resource" 
			}
			Write-Verbose "Found valid access token which will expire at $($tokenCache.ExpiresOn.ToLocalTime())"
			return $tokenCache.AccessToken
		}
	}

	throw "Unable to get access token for Graph API for Tenant $TenantId"
}
