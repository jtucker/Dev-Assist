$ErrorActionPreference = "Stop"

function getVswhereUrlFromGithub() {   
    Write-Host "`tGetting the latest version of vswhere from github"
    # We need TLS1.2
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # Get that hipster xml from github
    $githubApiResponse = Invoke-WebRequest "https://api.github.com/repos/Microsoft/vswhere/releases/latest" -UseBasicParsing
    $githubApiJson = ConvertFrom-Json $githubApiResponse.Content
    
    # pop the first asset, since this should be the release.
    $releaseAsset, $null = $githubApiJson.assets
    
    # return the Url to the download
    return $releaseAsset.browser_download_url
}

function getVswhereFromGithub(
    # URL to download VSWhere From
    [parameter(ValueFromPipeline)]
    [string]    
    $VswhereUrl,
    # TempFolder To Download To
    [string]
    $TempFolderLocation
) {
    Write-Host "`tDownloading vswhere from $VsWhereUrl"
    $vswhereDownloadLocation = Join-Path $TempFolderLocation "vswhere.exe"
    (New-Object Net.WebClient).DownloadFile($VswhereUrl, $vswhereDownloadLocation)
    return $vswhereDownloadLocation
}

function getVisualStudioGitLocation
(
    # Parameter help description
    [Parameter(ValueFromPipeline)]
    [string]
    $VswhereExeLocation, 

    # Parameter help description
    [Parameter()]
    [Switch]
    $GetPrereleaseVersion
) {
    $params = @("-all", "-property", "installationPath", "-nologo")
    if ($GetPrereleaseVersion) { $params += "-prerelease" }
   
    Write-Host "`tvswhere command: $VswhereExeLocation $params"
    
    $vsInstallPath = Start-Process -FilePath $VswhereExeLocation -ArgumentList $params    
    return Join-Path $vsInstallPath "Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Git"
}

function getGitInstalled() {    
    return $null -ne $(Get-Command git)
}


function getDodInstallRootInstaller
(
    # Parameter help description
    [Parameter(ValueFromPipeline)]
    [string]
    $TempFolderLocation
) {
    Write-Host "`tDownloading the InstallRoot Installer"

    # We need TLS1.2
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # Install the DOD Certs
    $installRootPath = Join-Path $TempFolderLocation "InstallRoot"
    $installRootInstaller = Join-Path $installRootPath "InstallRoot_5.2x32_NonAdmin.msi"
    
    # If the installer is already downloaded then we can continue on.
    if (-Not (Test-Path $installRootPath)) {
        mkdir $installRootPath -Force
        Write-Host "`tInstall Root Installer: $installRootInstaller"
        (New-Object Net.WebClient).DownloadFile('https://militarycac.com/CACDrivers/InstallRoot_5.2x32_NonAdmin.msi', $installRootInstaller)    
    }
    
    return $installRootInstaller
}

function installDodInstallRoot
(
    # InstallRoot installer location
    [Parameter(ValueFromPipeline)]
    [string]
    $InstallRootInstallerLocation
) {
    Write-Host "`tAdding the InstallRoot DoD Certs to the store"
    # Install the InstallRoot Util 
    $params = @("/i", $InstallRootInstallerLocation, "/passive", "/norestart")
    Start-Process msiexec -ArgumentList $params -Wait -NoNewWindow
    
    # Put the certs in the Trusted Root Cert.
    $installRootInstalledLocation = Join-Path $env:APPDATA "DoD-PKE\InstallRoot\InstallRoot.exe"
    & $installRootInstalledLocation @("--insert", "--silent")

    return $installRootInstalledLocation
}

function exportDodRootCert
(
    [string]
    $CertThumbprint = "5EAE74A8068D42F2F3E0174BF270A13A92EAAA5D", 
    
    [string]
    [Parameter(Mandatory = $true)]
    $ExportFileLocation
) {
    Write-Host "`tExporting out the appropriate certificate for git"
    $certificate = Get-Item -Path "Cert:\LocalMachine\CA\$CertThumbprint"
    $baseEncodedCert = @(
        '-----BEGIN CERTIFICATE-----'
        [System.Convert]::ToBase64String($certificate.RawData, 'InsertLineBreaks')
        '-----END CERTIFICATE-----'
    )
    $baseEncodedCert | Out-File -FilePath $ExportFileLocation -Encoding ascii
    return $baseEncodedCert
}
