function Get-AzureExAdApplication
{
    <#
    .Synopsis
        Return AAD application using AAD Graph REST API directly. 
    .Example
        PS> Get-AzureExAdApplication 
    #>
    [CmdletBinding()]
    param (
        [string] $ApplicationId,

        [string] $IdentifierUri,

        [string] $DisplayNameStartsWith,

        # You can specify a tenant id to only search in it, otherwise will search for all applicable tenants.
        [string] $TenantId,

        # Only used when not specifying TenantId, to continue searching in remaining tenants after found in a tenant already.
        [switch] $AllTenants
        )
    $ErrorActionPreference = 'Stop'
    if ($ApplicationId) {
        $filter = "appId eq '$ApplicationId'"
        $msg = "application with id $ApplicationId"
    } elseif ($IdentifierUri) {
        $filter = "identifierUris/any(s:s eq '$IdentifierUri')"
        $msg = "application with identifierUri '$IdentifierUri'"
    } elseif ($DisplayNameStartsWith) {
        $filter = "startswith(displayName, '$DisplayNameStartsWith')"
        $msg = "applications with display name starts with '$DisplayNameStartsWith'"
    } else {
        return (Invoke-AzureExGraphAPI 'applications').value
    }

    if (!$filter) { throw "Must specify a condition to search for" }

    function GetOne($tenantId) {
        (Invoke-AzureExGraphAPI "applications?`$filter=$filter" -TenantId $tenantId).value
    }

    if ($TenantId) {
        GetOne $TenantId
    } else {
        # Using Get-AzureExTenant instead of Get-AzureRmTenant since we want to ignore those
        # tenants that we couldn't get access token, such as msn.com when using MSA account to sign-in.
        foreach($tenant in (Get-AzureExTenant)) {
            $tenantId = $tenant.TenantId
            $result = GetOne $tenantId
            if ($result) {
                $result | Add-Member -PassThru -Force TenantId $tenantId
                if (!$AllTenants) { break }
            }
        }
    }
}
