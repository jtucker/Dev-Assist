$ModuleManifestName = "Dev-Assist.psd1"
$ModuleManifestPath = "$PSScriptRoot\..\src\$ModuleManifestName"

if(!$SuppressImportModule)
{
    # Global scope is needed for psake. 
    Import-Module $ModuleManifestPath -Scope Global
}