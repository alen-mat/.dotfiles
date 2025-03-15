if($IsWindows){
	$env:GIT_SSH=""
	Register-ArgumentCompleter -Native -CommandName git -ScriptBlock{
		Param(
			$wordToComplete,$commandAst,$cursorColumn
		)
		[string[]] $firstArgs = ("commit","log","push","diff","difftool","show","config")
		$firstArgs += git config --list | select-string 'alias' | %{ (($_ -split '=')[0] -split 'alias.')[1]}
	}
}

function gitPS1{
	# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
	# wrapping command in () will make exit code true in some version of windows
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
