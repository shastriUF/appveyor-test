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

$rootDirectory = (Get-Location).Path
Write-Output "Current directory $rootDirectory"

$install_NIPM = $true
if ($install_NIPM)
{
    # $nipmDownloadPath = 'http://download.ni.com/support/softlib/AST/NIPM/NIPackageManager18.0.2.exe'
    $nipmDownloadPath = 'www.ni.com/download/package-manager-18.0/7809/en/'
    $nipmInstaller = Join-Path -Path $rootDirectory -ChildPath 'install-nipm.exe'
    Write-Output "Downloading NIPM from $nipmDownloadPath..."
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($nipmDownloadPath, $nipmInstaller)
    Write-Output "...done"
    Assert-FileExists($nipmInstaller)
    
    Write-Output "Installing NIPM..."
    Start-Process -FilePath $nipmInstaller -ArgumentList "/Q" -Wait
    Write-Output "...done"
    Remove-Item $nipmInstaller
}

$nipm = 'C:\Program Files\National Instruments\NI Package Manager\NIPackageManager.exe'
Assert-FileExists($nipm)

$install_nxg = $false
if ($install_nxg)
{
    Write-Output "Installing LabVIEW NXG..."
    Start-Process -FilePath $nipm -ArgumentList "install ni-labview-nxg-2.0.0 ni-certificates --progress-only --accept-eulas --prevent-reboot" -Wait
    Write-Output "...done"
    $nxg = 'C:\Program Files\National Instruments\LabVIEW NXG 2.0\LabVIEW NXG.exe'
    Assert-FileExists($nxg)
}

return