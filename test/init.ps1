$moduleBasePath = Resolve-Path "$PsScriptRoot\..\src"
# The batch file that executes this script should have setup PsModulePath to include above path. The
# reason we are not updating the PsModulePath here is because it will not work in the same script so
# we have to let the batch file do that.
Import-Module (dir $moduleBasePath -Directory).Name

# To avoid re-login to ARM, you can save an already signed-in session using `Save-AzureRmProfile -Path profile_cache.json`
# in this directory.
$profileFile = "$PsScriptRoot\profile_cache.json"
if (Test-Path $profileFile) {
	Select-AzureRmProfile -Path $profileFile
}

function reload {
	Import-Module (dir $moduleBasePath -Directory).Name -Force
}
