Write-Output "Installing NIPM"

$nipmDownloadPath = 'http://download.ni.com/support/softlib/AST/NIPM/NIPackageManager18.0.2.exe'
$nipmInstaller = '.\\install-nipm.exe'
Invoke-WebRequest -Uri $nipmDownloadPath -OutFile $nipmInstaller -Verbose

if (![System.IO.File]::Exists($nipmInstaller))
{
    Write-Output "Could not find downloaded NIPM installer"
    return -1
}

$output = & $nipmInstaller
Write-Output $output

return