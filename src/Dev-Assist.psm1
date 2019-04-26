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