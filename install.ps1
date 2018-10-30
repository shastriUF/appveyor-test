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
    $nipmDownloadPath = 'http://download.ni.com/support/softlib/AST/NIPM/NIPackageManager18.5.1.exe'
    $nipmInstaller = Join-Path -Path $rootDirectory -ChildPath 'install-nipm.exe'
    # Assert-FileDoesNotExist($nipm)
    # Write-Output "Downloading NIPM from $nipmDownloadPath..."
    # $webClient = New-Object System.Net.WebClient
    # $webClient.DownloadFile($nipmDownloadPath, $nipmInstaller)
    # $time = (Get-Date).ToUniversalTime()
    # Write-Output "...done at UTC $time"
    Assert-FileExists($nipmInstaller)
    
    Assert-FileDoesNotExist($nipm)
    Write-Output "Installing NIPM..."
    # Start-Process -FilePath $nipmInstaller -ArgumentList "/Q" -Wait
    $pinfo = New-Object System.Diagnostics.ProcessStartInfo
	$pinfo.FileName = $nipmInstaller
	$pinfo.RedirectStandardError = $true
	$pinfo.RedirectStandardOutput = $true
	$pinfo.UseShellExecute = $false
	$pinfo.Arguments = "/Q"
	$p = New-Object System.Diagnostics.Process
	$p.StartInfo = $pinfo
	$p.Start()# | Out-Null
	while (!$p.HasExited)
	{
		$stdout = $p.StandardOutput.ReadToEnd()
		$stderr = $p.StandardError.ReadToEnd()
		Write-Output "stdout: $stdout"
		Write-Output "stderr: $stderr"
		
		Thread.Sleep(1000)
		$p.Refresh()
	}
	
	$time = (Get-Date).ToUniversalTime()
    Write-Output "...done at UTC $time"
    # Remove-Item $nipmInstaller
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
    # Start-Process -FilePath $nipm -ArgumentList 'install ni-certificates --accept-eulas --assume-yes --verbose'
	$pinfo = New-Object System.Diagnostics.ProcessStartInfo
	$pinfo.FileName = $nipm
	$pinfo.RedirectStandardError = $true
	$pinfo.RedirectStandardOutput = $true
	$pinfo.UseShellExecute = $false
	$pinfo.Arguments = "install ni-certificates --accept-eulas --assume-yes --verbose"
	$p = New-Object System.Diagnostics.Process
	$p.StartInfo = $pinfo
	
	$SOut = New-Object System.Collections.ArrayList
	$handler = 
	{
        if (! [String]::IsNullOrEmpty($EventArgs.Data)) 
		{
            $Event.MessageData.Add($EventArgs.Data)
        }
    }
	
	$SOutEvent = Register-ObjectEvent -InputObject $p -Action $handler -EventName 'OutputDataReceived' -MessageData $SOut
		
	$p.Start() | Out-Null
	$p.BeginOutputReadLine()	
	while (!$p.HasExited)
	{
		Wait-Event -Timeout 1
		while($SOut.Length -gt 0)
		{
			$SOut[0].ToString()
			$SOut.RemoveAt(0)
		}
	}
	while($SOut.Length -gt 0)
	{
		$SOut[0].ToString()
		$SOut.RemoveAt(0)
	}
	Unregister-Event -SourceIdentifier $SOutEvent.Name
    # WaitForNIPM
    $time = (Get-Date).ToUniversalTime()
    Write-Output "...done at UTC $time"
    Write-Output "Installing LabVIEW NXG..."
	# Start-Process -FilePath $nipm -ArgumentList 'install ni-labview-nxg-2.0.0 --accept-eulas --assume-yes --verbose'
	$pinfo = New-Object System.Diagnostics.ProcessStartInfo
	$pinfo.FileName = $nipm
	$pinfo.RedirectStandardError = $true
	$pinfo.RedirectStandardOutput = $true
	$pinfo.UseShellExecute = $false
	$pinfo.Arguments = "install ni-labview-nxg-2.0.0 --accept-eulas --assume-yes --verbose"
	$p = New-Object System.Diagnostics.Process
	$p.StartInfo = $pinfo
	
	$SOut = New-Object System.Collections.ArrayList
	$handler = 
	{
        if (! [String]::IsNullOrEmpty($EventArgs.Data)) 
		{
            $Event.MessageData.Add($EventArgs.Data)
        }
    }
	
	$SOutEvent = Register-ObjectEvent -InputObject $p -Action $handler -EventName 'OutputDataReceived' -MessageData $SOut
		
	$p.Start() | Out-Null
	$p.BeginOutputReadLine()	
	while (!$p.HasExited)
	{
		Wait-Event -Timeout 1
		while($SOut.Length -gt 0)
		{
			$SOut[0].ToString()
			$SOut.RemoveAt(0)
		}
	}
	while($SOut.Length -gt 0)
	{
		$SOut[0].ToString()
		$SOut.RemoveAt(0)
	}
	Unregister-Event -SourceIdentifier $SOutEvent.Name
	# WaitForNIPM
    $time = (Get-Date).ToUniversalTime()
    Write-Output "...done at UTC $time"
    # Write-Output "Installing LabVIEW NXG Web Module..."
    # Start-Process -FilePath $nipm -ArgumentList 'install ni-labview-nxg-2.0.0-web-module --accept-eulas --assume-yes --verbose'
    # WaitForNIPM
    # $time = (Get-Date).ToUniversalTime()
    # Write-Output "...done at UTC $time"
    Assert-FileExists($nxg)
}

return
