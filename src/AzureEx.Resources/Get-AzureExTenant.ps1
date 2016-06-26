function Get-AzureExTenant
{
    <#
    .Synopsis
        Return cached azure tenant information including tenant name.
    .Example
        PS> Get-AzureExTenant 
    #>
    [CmdletBinding()]
    param ( )
    
    if (!(Test-Path variable:global:AzureTenantCache)) {
        $global:AzureTenantCache = Get-AzureRmTenant | % {
            $tenantId = $_.TenantId
            $domain = $_.Domain
			try {
				(Invoke-AzureExGraphAPI 'tenantDetails' -TenantId $tenantId).value | 
					Add-Member -PassThru -Force TenantId $tenantId | 
					Add-Member -PassThru -Force Domain $domain
			} catch {
				Write-Warning "Unable to get tenant details for tenant ${tenantId}: $($_.Exception.Message)"
			}
        }
    }
    $global:AzureTenantCache
}
