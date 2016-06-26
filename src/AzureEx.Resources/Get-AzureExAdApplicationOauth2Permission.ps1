function Get-AzureExAdApplicationOauth2Permission
{
    <#
    .Synopsis
        Returns some well-known RequiredResourceAccess objects.
    .Example
        PS> Get-AzureExAdApplicationOauth2Permission AadSigninAndReadUserProfile
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateSet('AadSigninAndReadUserProfile')]
        [string] $Name
        )
    switch ($Name) {
        'AadSigninAndReadUserProfile' {
            New-AzureExAdRequiredResourceAccess -ApplicationId '00000002-0000-0000-c000-000000000000' -PermissionId '311a71cc-e848-46a1-bdf8-97ff7156d8e6'
        }
    }
}
