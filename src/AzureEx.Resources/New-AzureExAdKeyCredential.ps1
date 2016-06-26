function New-AzureExAdKeyCredential
{
	<#
	.Synopsis
		Creates a new KeyCredential object from a .cer file.
	#>
	[CmdletBinding()]
	param (
		# The .cer file
		[Parameter(Mandatory=$true)]
		[string] $CertFile
		)
    $fp = (Resolve-Path $CertFile).Path
	Add-Type -AssemblyName System.Security
    $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
	$cert.Import($fp)

	@{
		startDate = $cert.NotBefore.ToString('o')
		endDate = $cert.NotAfter.ToString('o')
		value = [Convert]::ToBase64String($cert.GetRawCertData())
		type = 'AsymmetricX509Cert'
		usage = 'Verify'
	}
}
