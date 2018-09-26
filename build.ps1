$rootDirectory = (Get-Location).Path
Write-Output "Current directory $rootDirectory"

$install_NIPM = $true
if ($install_NIPM)
{
    $nipmDownloadPath = 'http://download.ni.com/support/softlib/AST/NIPM/NIPackageManager18.0.2.exe'
    $nipmInstaller = Join-Path -Path $rootDirectory -ChildPath 'install-nipm.exe'
    Write-Output "Downloading NIPM from $nipmDownloadPath..."
    $webClient = New-Object System.Net.WebClient
    $webClient.DownloadFile($nipmDownloadPath, $nipmInstaller)
    Write-Output "...done"
    if (![System.IO.File]::Exists($nipmInstaller))
    {
        throw "Could not find downloaded NIPM installer"
    }
    Write-Output "Installing NIPM..."
    Start-Process -FilePath $nipmInstaller -ArgumentList "/Q" -Wait
    Write-Output "...done"
    Remove-Item $nipmInstaller
}

$nipm = 'C:\Program Files\National Instruments\NI Package Manager\NIPackageManager.exe'
if (![System.IO.File]::Exists($nipm))
{
    throw "Could not find installed NIPM at $nipm"
}
else 
{
    Write-Output "Found NIPM at $nipm"
}

return