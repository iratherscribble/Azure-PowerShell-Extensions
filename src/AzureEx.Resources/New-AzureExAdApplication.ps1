function New-AzureExAdApplication
{
	<#
	.Synopsis
		This cmdlet is created to workaround current Azure PowerShell cmdlets limitation: as of 2016.01.27: the latest Azure PowerShell
		cmdlets cannot create a usable AAD application that has correct permissions to other applications such as the Windows Azure Active
		Directory, or any other custom applications. 
	.Example
		PS> New-AzureExAdApplication -DisplayName MyWebApp -IdentifierUris http://mypp
	.Example
		PS> New-AzureExAdApplication -DisplayName MyWebApp -IdentifierUris http://mypp -AppSecret $password -AppYears 2
	.Example
		PS> New-AzureExAdApplication -DisplayName MyWebApp -IdentifierUris http://myclient -PermissionsToOtherApplicationIdentifierUris http://myapp
	.Example
		PS> New-AzureExAdApplication -DisplayName MyNativeApp -ReplyUrls https://localhost -PermissionsToOtherApplicationIdentifierUris http://myapp
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true)]
		[string] $DisplayName,

		[Parameter(Mandatory=$true)]
		[string[]] $ReplyUrls,

		[string] $HomePage,

		[string[]] $IdentifierUris,

		[string[]] $AppSecrets,

		[int] $AppYears = 2,

		[string[]] $CertFiles,

		[string[]] $PermissionsToOtherApplicationIdentifierUris,

		# used in a web app to enable Oauth2 implicit flow, such as Swagger UI
		[switch] $Oauth2AllowImplicitFlow,

		[switch] $MultiTenant,

        [string] $TenantId
		)
	$ErrorActionPreference = 'Stop'

	$app = @{
		displayName = $DisplayName
	}
	if ($HomePage) { $app.homepage = $HomePage }
	if ($IdentifierUris) { $app.identifierUris = $IdentifierUris } 
	else { 
		$app.publicClient = $true 
	}
	if ($ReplyUrls) { $app.replyUrls = $ReplyUrls }
	$app.requiredResourceAccess = @((Get-AzureExAdApplicationOauth2Permission AadSigninAndReadUserProfile))
	if ($AppSecrets) {
		[array] $app.passwordCredentials = $AppSecrets | % {
			New-AzureExAdPasswordCredential $_ $AppYears
		}
	}
	if ($CertFiles) {
		[array] $app.keyCredentials = $CertFiles | % {
			New-AzureExAdKeyCredential $_
		}
	}
	if ($PermissionsToOtherApplicationIdentifierUris) {
		$PermissionsToOtherApplicationIdentifierUris | % {
			$otherApp = Get-AzureExAdApplication -IdentifierUri $_
			if (!$otherApp) { throw "Unable to find application with IdentifierUri '$_'" }
			$userImpersonation = $otherApp.oauth2Permissions | ? { $_.value -eq 'user_impersonation' }
			if (!$userImpersonation) { throw "Unable to find oauth2Permission with value = 'user_impersonation'" }
			$requiredResourceAccess = New-AzureExAdRequiredResourceAccess $otherApp.AppId $userImpersonation.id
			$app.requiredResourceAccess += $requiredResourceAccess
		}
	}
	if ($Oauth2AllowImplicitFlow) { $app.oauth2AllowImplicitFlow = $true }
	if ($MultiTenant) { $app.availableToOtherTenants = $true }

    $app = Invoke-AzureExGraphAPI 'applications' -TenantId $TenantId -Method POST -Body $app

	$sp = @{
		appId = $app.appId
		accountEnabled = $true
        tags = @('WindowsAzureActiveDirectoryIntegratedApp')
	}
    $sp = Invoke-AzureExGraphAPI 'servicePrincipals' -TenantId $TenantId -Method POST -Body $sp
	$app
}
