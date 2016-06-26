# Azure-PowerShell-Extensions

## AzureEx.Profile

### Get-AzureExProfile
Since `Save-AzureRmProfile` can only save the profile object to a file, this is a handy wrapper to use a temporary file to return the profile object in memory. The profile object contains useful information such as the token cache, and various REST API endpoints.

## AzureEx.Resources

### Invoke-AzureExGraphAPI
Use this cmdlet to invoke [AAD Graph REST API](https://msdn.microsoft.com/en-us/library/azure/ad/graph/api/api-catalog) using the existing access token from AzureRM.Profile.

Examples:

```
Invoke-AzureExGraphAPI me
Invoke-AzureExGraphAPI tenantDetails
Invoke-AzureExGraphAPI applications
```

### New-AzureExAdApplication
Create AAD applications using REST API.

Examples:

```
New-AzureExAdApplication -DisplayName test1 -ReplyUrls http://test1 -HomePage http://test1 -IdentifierUris http://test1
New-AzureExAdApplication -DisplayName test2 -ReplyUrls http://test2 -HomePage http://test2 -IdentifierUris http://test2 -PermissionsToOtherApplicationIdentifierUris http://test1
```
