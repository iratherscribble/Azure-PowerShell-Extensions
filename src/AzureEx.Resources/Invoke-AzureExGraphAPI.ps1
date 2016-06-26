function Invoke-AzureExGraphAPI
{
    <#
    .Synopsis
        Invokes AAD Graph REST API.
	.Example
		PS> Invoke-AzureExGraphAPI tenantDetails
		PS> Invoke-AzureExGraphAPI me
    .Example
        PS> Invoke-AzureExGraphAPI 'applications?$filter=...'
	.Link
		https://msdn.microsoft.com/en-us/library/azure/ad/graph/api/api-catalog
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string] $RelativeUrl,

        # If not specified then uses the current azure subscription's default tenant id
        [string] $TenantId,

        [string] $Method,

        $Body,

        [string] $ApiVersion = '1.6'
        )
	$p = GetProfile
    $graphUrl = $p.Context.Environment.Endpoints.Graph | NormalizeUrl
    if (!$TenantId) { 
		$TenantId = $p.Context.Tenant.Id 
		if (!$TenantId) { throw 'Unable to get tenant id from AzureRM profile' }
	}
    
    $accessToken = Get-AzureExGraphAccessToken $TenantId
    if ($RelativeUrl -match '\?') {
        $RelativeUrl = $RelativeUrl.Replace('?', "?api-version=$ApiVersion&")
    } else {
        $RelativeUrl = $RelativeUrl + "?api-version=$ApiVersion"
    }
    $headers = @{
        Authorization = "Bearer $accessToken"
    }
    $p = @{
        Uri = "${graphUrl}$TenantId/$RelativeUrl"
        Headers = $headers
    }
    if ($Method -and $Method -ne 'GET') { 
        $p.Method = $Method 
        $p.ContentType = 'application/json'
        if (!$Body) { throw "Must provide Body if not using GET" }
        if ($Body -isnot 'string') {
            $Body = ConvertTo-Json $Body -Depth 99
        }
        Write-Verbose $Body
        $p.Body = $Body
    }

    Invoke-RestMethod @p
}
