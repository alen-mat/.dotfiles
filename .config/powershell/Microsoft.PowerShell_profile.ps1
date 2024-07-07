function Global:prompt {
	$oc = $host.ui.RawUI.ForegroundColor
	$host.UI.RawUI.ForegroundColor = "DarkCyan"


	git rev-parse --is-inside-work-tree > $null
	if ($?){
		branch-name-prompt
	}else{
		$Host.UI.Write([System.Net.Dns]::GetHostName() + ": ")
	}


	$host.UI.RawUI.ForegroundColor = "Yellow"
	$Host.UI.Write(([string]$pwd).Replace($env:HOME, "^^")) 
	$message = (Get-Date -DisplayHint Time).ToString()
	$startposx = $Host.UI.RawUI.windowsize.width - $message.length
	$startposy = $Host.UI.RawUI.CursorPosition.Y
	$Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates $startposx,$startposy
	$host.UI.RawUI.ForegroundColor = "DarkGreen"
	$Host.UI.Write($message)
	$host.UI.RawUI.ForegroundColor = $oc
	$Host.UI.Write($([char]0x2192))
	return " "
}

function branch-name-prompt{
	$isBare = (git rev-parse --is-bare-repository)
	$branch = (git rev-parse --abbrev-ref HEAD)
	$color =  "Blue"
	if ($branch -eq "HEAD"){
		$branch = (git rev-parse --short HEAD)
		$color =  "Red"
	}
	$host.UI.RawUI.ForegroundColor = $color
	$Host.UI.Write("("+$branch+")") 
}

function ll {
	ls | Format-Wide Name -AutoSize
}
