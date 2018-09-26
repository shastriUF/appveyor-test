Write-Output "Installing NIPM"
$rootDirectory = (Get-Location).Path
Write-Output "Current directory $rootDirectory"

$nipmDownloadPath = 'http://download.ni.com/support/softlib/AST/NIPM/NIPackageManager18.0.2.exe'
$nipmInstaller = Join-Path -Path $rootDirectory -ChildPath 'install-nipm.exe'
Invoke-WebRequest -Uri $nipmDownloadPath -OutFile $nipmInstaller -Verbose

if (![System.IO.File]::Exists($nipmInstaller))
{
    throw "Could not find downloaded NIPM installer"
}

Start-Process -FilePath $nipmInstaller -ArgumentList "/Q" -Wait
Write-Output "NIPM Installed..."

Remove-Item $nipmInstaller

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