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
Write-Output "NIPM Installed (maybe)"

Remove-Item $nipmInstaller

return