if (-not ((Test-Path variable:global:IsLinux) -and (Test-Path variable:global:IsWindows) -and  (Test-Path variable:global:IsMacOS))){
	switch ([System.Environment]::OSVersion.Platform) {
	    'Win32NT' { 
	        New-Variable -Option Constant -Name IsWindows -Value $True -ErrorAction SilentlyContinue
	        New-Variable -Option Constant -Name IsLinux  -Value $false -ErrorAction SilentlyContinue
	        New-Variable -Option Constant -Name IsMacOs  -Value $false -ErrorAction SilentlyContinue
	     }
	}
}
. $PSScriptRoot/psrl.ps1
. $PSScriptRoot/utils.ps1
. $PSScriptRoot/git.ps1

function Global:prompt {
	$rawUI = (Get-Host).UI.RawUI
	$cp = $rawUI.CursorPosition
	$cp.Y = $rawUI.BufferSize.Height - 1
	$rawUI.CursorPosition = $cp

	$oc = $host.ui.RawUI.ForegroundColor
	$host.UI.RawUI.ForegroundColor = "DarkCyan"

	$d = ([string]$pwd)

	if (-not(gitPS1)){
		$Host.UI.Write([System.Net.Dns]::GetHostName() + ": ")
	}


	$host.UI.RawUI.ForegroundColor = "Yellow"
	$d = $d.Replace($env:HOME, "^^")
	$Host.UI.Write($d) 
	$message = (Get-Date -DisplayHint Time).ToString()
	$startposx = $Host.UI.RawUI.windowsize.width - $message.length
	$startposy = $Host.UI.RawUI.CursorPosition.Y
	$Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $startposx,$startposy
	$host.UI.RawUI.ForegroundColor = "DarkGreen"
	$Host.UI.Write($message)
	$host.UI.RawUI.ForegroundColor = $oc
	$out = $([char]0x2192)
	$out += " "
	return $out
}


function ll {
	ls | Format-Wide Name -AutoSize
}
