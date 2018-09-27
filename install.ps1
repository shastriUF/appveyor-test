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

$rootDirectory = (Get-Location).Path
Write-Output "Current directory $rootDirectory"

$install_NIPM = $true
if ($install_NIPM)
{
    $nipmDownloadPath = 'http://download.ni.com/support/softlib/AST/NIPM/NIPackageManager18.5.exe'
    $nipmInstaller = Join-Path -Path $rootDirectory -ChildPath 'install-nipm.exe'
    Assert-FileDoesNotExist($nipmInstaller)
    Write-Output "Downloading NIPM from $nipmDownloadPath..."
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($nipmDownloadPath, $nipmInstaller)
    Write-Output "...done"
    Assert-FileExists($nipmInstaller)
    
    Assert-FileDoesNotExist($nipm)
    Write-Output "Installing NIPM..."
    Start-Process -FilePath $nipmInstaller -ArgumentList "/Q" -Wait
    Write-Output "...done"
    Remove-Item $nipmInstaller
}

# $nipm = 'C:\Program Files\National Instruments\NI Package Manager\NIPackageManager.exe'
$nipm = 'C:\Program Files\National Instruments\NI Package Manager\nipkg.exe'
Assert-FileExists($nipm)

$install_nxg = $true
if ($install_nxg)
{
    Assert-FileDoesNotExist($nxg)
    Write-Output "Installing LabVIEW NXG..."
    # Start-Process -FilePath $nipm -ArgumentList 'install ni-labview-nxg-2.0.0 --temp-feeds="http://download.ni.com/support/nipkg/products/ni-labview-nxg-2.0.0/2.1/released,http://download.ni.com/support/nipkg/products/ni-labview-nxg-2.0.0-rte/2.1/released" --progress-only --accept-eulas --prevent-reboot'
    Start-Process -FilePath $nipm -ArgumentList 'feed-add http://download.ni.com/support/nipkg/products/ni-labview-nxg-2.0.0/2.1/released' -Wait
    Start-Process -FilePath $nipm -ArgumentList 'feed-add http://download.ni.com/support/nipkg/products/ni-labview-nxg-2.0.0-rte/2.1/released' -Wait
    Start-Process -FilePath $nipm -ArgumentList 'update' -Wait
    Start-Process -FilePath $nipm -ArgumentList 'install ni-certificates --accept-eulas --assume-yes --verbose' -Wait
    Start-Process -FilePath $nipm -ArgumentList 'install ni-labview-nxg-2.0.0 ni-certificates --accept-eulas --assume-yes --verbose'
    $id = (Get-Process 'nipkg').Id
    Wait-Process -Id $id
    Write-Output "...done"
    $nxg = 'C:\Program Files\National Instruments\LabVIEW NXG 2.0\LabVIEW NXG.exe'
    Assert-FileExists($nxg)
}

return