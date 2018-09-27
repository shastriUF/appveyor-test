function Assert-FileExists {
    Param ([string]$path)
    if (![System.IO.File]::Exists($path))
    {
        throw "Could not find file at $path"
    }
    else 
    {
        Write-Output "Found file at $path"
    }
}

function Assert-FileDoesNotExist {
    Param ([string]$path)
    if ([System.IO.File]::Exists($path))
    {
        throw "Found unexpected file at $path."
    }
    else 
    {
        Write-Output "$path not installed."
    }
}

function WaitForNIPM {
    $id = (Get-Process 'nipkg').Id
    Wait-Process -Id $id
}

$rootDirectory = (Get-Location).Path
Write-Output "Current directory $rootDirectory"


# $nipm = 'C:\Program Files\National Instruments\NI Package Manager\NIPackageManager.exe'
$nipm = 'C:\Program Files\National Instruments\NI Package Manager\nipkg.exe'
$install_NIPM = $true
if ($install_NIPM)
{
    $nipmDownloadPath = 'http://download.ni.com/support/softlib/AST/NIPM/NIPackageManager18.5.exe'
    $nipmInstaller = Join-Path -Path $rootDirectory -ChildPath 'install-nipm.exe'
    Assert-FileDoesNotExist($nipm)
    Write-Output "Downloading NIPM from $nipmDownloadPath..."
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($nipmDownloadPath, $nipmInstaller)
    $time = (Get-Date).ToUniversalTime()
    Write-Output "...done at UTC $time"
    Assert-FileExists($nipmInstaller)
    
    Assert-FileDoesNotExist($nipm)
    Write-Output "Installing NIPM..."
    Start-Process -FilePath $nipmInstaller -ArgumentList "/Q" -Wait
    $time = (Get-Date).ToUniversalTime()
    Write-Output "...done at UTC $time"
    Remove-Item $nipmInstaller
}

Assert-FileExists($nipm)

$install_nxg = $true
if ($install_nxg)
{
    $nxg = 'C:\Program Files\National Instruments\LabVIEW NXG 2.0\LabVIEW NXG.exe'
    Assert-FileDoesNotExist($nxg)
    # Start-Process -FilePath $nipm -ArgumentList 'install ni-labview-nxg-2.0.0 --temp-feeds="http://download.ni.com/support/nipkg/products/ni-labview-nxg-2.0.0/2.1/released,http://download.ni.com/support/nipkg/products/ni-labview-nxg-2.0.0-rte/2.1/released" --progress-only --accept-eulas --prevent-reboot'
    Start-Process -FilePath $nipm -ArgumentList 'feed-add http://download.ni.com/support/nipkg/products/ni-labview-nxg-2.0.0/2.1/released'
    WaitForNIPM
    Start-Process -FilePath $nipm -ArgumentList 'feed-add http://download.ni.com/support/nipkg/products/ni-labview-nxg-2.0.0-rte/2.1/released'
    WaitForNIPM
    Start-Process -FilePath $nipm -ArgumentList 'feed-add http://download.ni.com/support/nipkg/products/ni-labview-nxg-2.0.0-web-module/2.1/released'
    WaitForNIPM
    Start-Process -FilePath $nipm -ArgumentList 'update'
    WaitForNIPM
    Write-Output "Installing NI Certificates..."
    Start-Process -FilePath $nipm -ArgumentList 'install ni-certificates --accept-eulas --assume-yes --verbose'
    WaitForNIPM
    $time = (Get-Date).ToUniversalTime()
    Write-Output "...done at UTC $time"
    Write-Output "Installing LabVIEW NXG..."
    Start-Process -FilePath $nipm -ArgumentList 'install ni-labview-nxg-2.0.0 --accept-eulas --assume-yes --verbose'
    WaitForNIPM
    $time = (Get-Date).ToUniversalTime()
    Write-Output "...done at UTC $time"
    Write-Output "Installing LabVIEW NXG Web Module..."
    Start-Process -FilePath $nipm -ArgumentList 'install ni-labview-nxg-2.0.0-web-module --accept-eulas --assume-yes --verbose'
    WaitForNIPM
    $time = (Get-Date).ToUniversalTime()
    Write-Output "...done at UTC $time"
    Assert-FileExists($nxg)
}

return