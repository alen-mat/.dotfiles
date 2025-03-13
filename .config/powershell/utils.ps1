function tmp{
	cd $env:TEMP
}

function URun{
	Param(
		[Parameter(
			Mandatory=$True,
			ValueFromRemainingArguments=$True
		)]
		[string[]]$oargs
	)
	begin{
		$programargs = ""
		if($oargs.length -lt 0){
			Write-Host "Expects One param"
			return
		}
		$app = $oargs[0]
		if($oargs.length -gt 1){
			$programargs = $oargs[1..($oargs.length - 1)] -join " "
		}
	}
	process{
		Start-Process $app -ArgumentList "$programargs"
	}
}
