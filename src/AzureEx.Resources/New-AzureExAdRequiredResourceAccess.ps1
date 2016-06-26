function New-AzureExAdRequiredResourceAccess
{
    <#
    .Synopsis
        Create a new AAD RequiredResourceAccess object.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string] $ApplicationId,

        [Parameter(Mandatory=$true)]
        [guid] $PermissionId,

        [string] $PermissionType = 'Scope'
        )
    $resourceAccess = @{
        id = $PermissionId
        type = $PermissionType
    }
    $result = @{
        resourceAppId = $ApplicationId
        resourceAccess = @($resourceAccess)
    }
    $result
}
