Set-StrictMode -Version 1

Import-Module AzureEx.Profile

Get-ChildItem (Join-Path $PSScriptRoot "*-*.ps1") | where { $_.FullName -notmatch '\.tests\.ps1$' } | foreach {. $_.FullName}
Export-ModuleMember -Alias * -Function '*-*'

$script:profile = $null
function GetProfile([switch] $Reset) {
    if (!$script:profile -OR $Reset) {
        $script:profile = Get-AzureExProfile -DecodeTokenCache
    }
    $script:profile
}

# ensure the url ends with '/', useful when comparing two urls that one might be misssing the ending slash
filter NormalizeUrl{
    param (
        [Parameter(ValueFromPipeline=$true)]
        [string] $url
    )
    if ($url -and !$url.EndsWith('/')){
        $url + '/'
    } else {
        $url
    }
}
