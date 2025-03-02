function Global:prompt {
	$rawUI = (Get-Host).UI.RawUI
	$cp = $rawUI.CursorPosition
	$cp.Y = $rawUI.BufferSize.Height - 1
	$rawUI.CursorPosition = $cp

	$oc = $host.ui.RawUI.ForegroundColor
	$host.UI.RawUI.ForegroundColor = "DarkCyan"

	$d = ([string]$pwd)

	if (-not(branch-name-prompt)){
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

function branch-name-prompt{
	# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
	$repoInfo = (git rev-parse --git-dir --is-inside-git-dir --is-bare-repository --is-inside-work-tree --show-ref-format --show-toplevel --short HEAD ) 2> $null
	if (-not($?)){
		return $false
	}

	$upstream_type = "@{upstream}"

	$repoInfo = $repoInfo -split '\n'
	$gdr = $repoInfo[0]
	$isBare = $repoInfo[2]
	$ref_format = $repoInfo[4]
	$gbd = $repoInfo[5]
	$short_sha = $repoInfo[6]

	$count = (git rev-list --count --left-right "$upstream_type"...HEAD )
	switch -Wildcard ("$count") {
		""	{$upstream="" ;break;}
		"0	0" {$upstream="|u=" ;break;}
		"0	*" {$upstream="|u+${count#0	}" ;break;}
		"*	0" {$upstream="|u-${count%	0}" ;break;}
		default	{ $upstream="|u+${count#*	}-${count%	*}";break;}
	}

	if(Test-Path -Path "$gdr/rebase-merge" ){
		$r = "|REBASE"
	}
	else{
		if(Test-Path -Path "$gdr/rebase-apply"){
			if(Test-Path -Path "$gdr/rebase-apply/rebasing"){
				$r="|REBASE"
			}
			elseif(Test-Path -Path "$gdr/rebase-apply/applying"){
				$r="|AM"
			}
			else{
				$r="|AM/REBASE"
			}
		}
		if(Test-Path -Path "$gdr/MERGE_HEAD"){
			$r="|MERGING"
		}
		elseif(Test-Path -Path "$gdr/CHERRY_PICK_HEAD"){
			$r="|CHERRY-PICKING"
		}
		elseif(Test-Path -Path "$gdr/REVERT_HEAD"){
			$r="|REVERTING"
		}
		elseif(Test-Path -Path "$gdr/BISECT_LOG"){
			$r="|BISECTING"
		}
	}

	if ((Get-Item "$gdr/HEAD").Attributes.ToString() -match "ReparsePoint"){
		$b=(git symbolic-ref HEAD 2>$null)
	}
	else{
		if($ref_format -eq "files") {
			$head = (Get-Content -Path "$gdr/HEAD" -TotalCount 1)
			switch -Wildcard($head) {
				"ref: *"{ $head= $head.Replace("ref: ","");break;}
				default { $head=""; break;}
			}
		}else{
			$head=(git symbolic-ref HEAD 2>$null)
		}
		if ([string]::IsNullOrEmpty($head)){
			$detached=$true
			$b = (git describe --tags --exact-match HEAD 2>$null)
			if (-not($?)){
				$b = "$short_sha..."
			}
		}else{
			$b = $head
		}
	}
	$d = $d.Replace($gbd,'')
	$b=$b.Replace("refs/heads/","")
	$color =  "Blue"
	$host.UI.RawUI.ForegroundColor = $color
	$Host.UI.Write("("+$b+")"+ " "+ $upstream +" "+ $r) 
	return $true
}

function ll {
	ls | Format-Wide Name -AutoSize
}
