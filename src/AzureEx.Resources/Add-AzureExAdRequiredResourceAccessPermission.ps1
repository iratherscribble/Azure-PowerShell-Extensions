function Add-AzureExAdRequiredResourceAccessPermission
{
    <#
    .Synopsis
        Adds a AzureExAdRequiredResourceAccessPermission to an existing AzureExAdRequiredResourceAccessApplication.
    .Example
        PS> $raa = New-AzureExAdRequiredResourceAccessApplication -ApplicationId "00000002-0000-0000-c000-000000000000" -PermissionId "00000000-0000-0000-0000-000000000001" -PermissionType 'Scope'
        PS> Add-AzureExAdRequiredResourceAccessPermission -RequiredResourceAccessApplication $raa -PermissionId "00000000-0000-0000-0000-000000000002" -PermissionType 'Role'
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [PSCustomObject] $RequiredResourceAccessApplication,

        [Parameter(Mandatory=$true)]
        [guid] $PermissionId,

        [string] $PermissionType = 'Scope'
        )
    $resourceAccess = @{
        id = $PermissionId
        type = $PermissionType
    }
    $RequiredResourceAccessApplication.resourceAccess += $resourceAccess
    $result = $RequiredResourceAccessApplication
}