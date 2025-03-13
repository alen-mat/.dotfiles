Import-Module PSReadLine

Set-PSReadLineOption -EditMode vi
Set-PSReadLineOption -ViModeIndicator Cursor

Set-PSReadLineOption -CommandValidationHandler {
	param($CommadAst)
	switch ($CommadAst.GetCommandName()){
		'git'	{
			$gitcmd = $CommandAst.CommandElements[1].Extent
			switch ($gitcmd){
				'cmt'	{
					[Microsoft.Powershell.PSReadLine]::Replace(
						$gitcmd.StartOffset,$gitcmd.EndOffset - $gitcmd.StartOffset,'commit')
				}
			}
		}
	}
}

Set-PSReadLineKeyHandler -Chord 'Enter' -Function ValidateAndAcceptLine
Set-PSReadLineKeyHandler -Chord Control+c -Function RevertLine

Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
