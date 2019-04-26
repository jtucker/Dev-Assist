<#
    .SYNOPSIS
	    Retrieves the root cert from a website
	
	.PARAMETER Url
	    The Url of the website
	
	.EXAMPLE
	    $cert = Get-SiteRootCert -Url 'https://www.google.com'
#>
function Get-SiteRootCert
{
    [CmdletBinding()]
    param
	(
        [Parameter(Mandatory = $true)]
	    [string]
		$Url
	)
	
	$webRequest = [Net.WebRequest]::Create($Url)
    try
    {
        $webRequest.GetResponse().Dispose()
    }
    catch [System.Net.WebException]
    {
    }
    $cert = $webRequest.ServicePoint.Certificate
    $chain = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Chain
    $null = $chain.Build($cert)
    $chain.ChainElements |Foreach-Object {$_.Certificate} |Select-Object -Last 1
}

<#
    .SYNOPSIS
	    Adds a X509Certificate to git trusted root certs
	
	.PARAMETER Certificate
	    The certificate to add
	
	.PARAMETER CrtPath
	    The path to the crt file to update
	
	.EXAMPLE
	    $cert = Get-SiteRootCert -Url 'https://www.google.com'
	    Add-CertToGit -Certificate $cert
	
	.EXAMPLE
	    $cert = Get-SiteRootCert -Url 'https://www.google.com'
	    Add-CertToGit -Certificate $cert -CrtPath 'C:\Certs\MyCerts.crt'
#>
function Add-CertToGit
{
    [CmdletBinding()]
    param
	(
        [Parameter(Mandatory = $true)]
	    [X509Certificate]
		$Certificate,
		
        [Parameter()]
		[ValidateScript({Test-Path -Path $_ })]
        [ValidateScript({(Get-Item -Path $_).Extension -eq '.crt'})]
		[string]
		$CrtPath
	)
	
	if($CrtPath)
	{
	    $crtInfo = Get-Item $CrtPath
	}
	else
	{
        if(Test-Path -Path 'C:\Program Files\Git')
        {
            $crtInfo = Copy-Item 'C:\Program Files\Git\mingw64\ssl\certs\ca-bundle.crt' -Destination $Env:USERPROFILE -PassThru
        }
        elseif(Test-Path -Path 'C:\Program Files (x86)\Git')
        {
            $crtInfo = Copy-Item 'C:\Program Files (x86)\Git\mingw32\ssl\certs\ca-bundle.crt' -Destination $Env:USERPROFILE -PassThru
        }       
	}
    $certBegin = '-----BEGIN CERTIFICATE-----'
	$rootBase64 = [convert]::ToBase64String($Certificate.RawData)
    $certEnd = '-----END CERTIFICATE-----'
    Add-Content -Path $crtInfo.FullName -Value "`n$certBegin`n$rootBase64`n$certEnd" -NoNewline
    #git config --global http.sslCAInfo $crtInfo.FullName
}

function Initialize-RpsDevelopmentEnvironment
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		$TempLocation, 

		[Parameter(Mandatory = $true)]
		$TfsServerName,

		[Parameter()]
		[switch]
		$UseVisualStudioGit
	)

	$tempRpsDevDirectory = Join-Path $TempLocation "RPSDevSetup"
	if(-Not (Test-Path $tempRpsDevDirectory)) {
		mkdir $tempRpsDevDirectory | Out-Null
	}

	Install-DodCertificates -TempLocation $tempRpsDevDirectory
	
	Write-Host "Starting the configuration of Git for accessing RPS Repos"
	$gitCommand = Get-GitInstallLocation -TempLocation $TempLocation -UseVisualStudioGit:$UseVisualStudioGit

	# Get the exported DOD Cert (will save the file as well)
	#$certificatePath = Join-Path $tempRpsDevDirectory "dodCert.cer"
	#$exportedCert = exportDodRootCert -ExportFileLocation $certificatePath
	# update the CA-Bundle with a line break
	# Write-Host "`tAdding the cert to the ca-bundle"
	# Add-Content $env:USERPROFILE\ca-bundle.crt "`r`n"
	# # update the CA-Bundle with the exported cert
	# Add-Content $env:USERPROFILE\ca-bundle.crt $exportedCert

	Write-Host "`tConfiguring VS Git Install to connect to TFS"
	& $gitCommand config --global credential.$($TfsServerName).authority negotiate
	& $gitCommand config --global http.sslbackend schannel

	Write-Host "You are now setup to the RPS Repository in TFS." -ForegroundColor Green
	Start-Sleep -Seconds 5
}

function Install-DodCertificates 
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		$TempLocation
	)

	Write-Host "Starting configuration for DoD Certs..."

	getDodInstallRootInstaller -TempFolderLocation $TempLocation `
		| installDodInstallRoot `
		| Out-Null
}

function Get-GitInstallLocation
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		$TempLocation,
		
		[Parameter()]
		[switch]
		$UseVisualStudioGit		
	)

	$gitCommand = $gitCommand = Get-Command git -ErrorAction SilentlyContinue | Select-Object Source -ExpandProperty Source	
	if($UseVisualStudioGit)
	{
		Write-Host "`tUsing `vswhere` to determine location of Visual Studio Git..."
		$vsGitLocation = getVswhereUrlFromGithub `
			| getVswhereFromGithub -TempFolderLocation $TempLocation `
			| getVisualStudioGitLocation -GetPrereleaseVersion 
		$gitCommand = Join-Path $vsGitLocation "cmd\git.exe"
	}

	$gitCommand
}
