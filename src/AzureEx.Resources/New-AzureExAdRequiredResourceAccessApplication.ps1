function New-AzureExAdRequiredResourceAccessApplication
{
    <#
    .Synopsis
        Create a new AAD AzureExAdRequiredResourceAccessApplication object with an initial permission and permission type specified.
        Additional permissions for the object can be added with Add-AzureExAdRequiredResourceAccessPermission.
    .Example
        PS> New-AzureExAdRequiredResourceAccessApplicationn -ApplicationId "00000000-0000-0000-0000-000000000001" -ReplyUrls https://myapp1 -PermissionsToOtherApplicationIdentifierUris http://myapp2
    .Example
        PS> $requireResourceAccess = @()
        PS> $resourceApplication1 = New-AzureExAdRequiredResourceAccessApplication -ApplicationId "00000002-0000-0000-c000-000000000000" -PermissionId "00000000-0000-0000-0000-000000000002" -PermissionType 'Scope'
        PS> Add-AzureExAdRequiredResourceAccessPermission -RequiredResourceAccessApplication $resourceApplication1 -PermissionId "00000000-0000-0000-0000-000000000003" -PermissionType 'Role'
        PS> $resourceApplication2 = New-AzureExAdRequiredResourceAccessApplication -ApplicationId "00000003-0000-0000-c000-000000000000" -PermissionId "00000000-0000-0000-0000-000000000004" -PermissionType 'Scope'
        PS> $requireResourceAccess += $resourceApplication1, $resourceApplication2
        PS> New-AzureExAdApplication -DisplayName MyApp1 -IdentifierUris https://myapp1 -ReplyUrls https://myapp1 -RequiredResourceAccessApplications $requireResourceAccess -PermissionsToOtherApplicationIdentifierUris https://myapp2
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string] $ApplicationId,

        [Parameter(Mandatory=$true)]
        [guid] $PermissionId,

        [string] $PermissionType = 'Scope'
        )
    $resourceAccess = @{ id = $PermissionId; type = $PermissionType }
    $result = @{resourceAppId = $ApplicationId; resourceAccess =  @();}
    $result.resourceAccess += $resourceAccess
    $result
}
