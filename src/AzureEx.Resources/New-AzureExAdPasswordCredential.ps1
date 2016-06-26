function New-AzureExAdPasswordCredential
{
	<#
	.Synopsis
		Creates a new PasswordCredential object.
	#>
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true)]
		[string] $Password,

		[int] $Years = 2
		)
	@{
		startDate = (Get-Date).ToString('o')
		endDate = (Get-Date).AddYears($Years).ToString('o')
		value = $Password
	}
}
