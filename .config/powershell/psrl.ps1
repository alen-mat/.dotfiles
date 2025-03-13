Import-Module PSReadLine

Set-PSReadLineOption -EditMode vi
Set-PSReadLineOption -ViModeIndicator Cursor

Set-PSReadLineKeyHandler -Chord Enter -Function ValidateAndAcceptLine
Set-PSReadLineKeyHandler -Chord Control+c -Function RevertLine

Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete

Set-PSReadLineOption -CommandValidationHandler {
    param($CommandAst)

    switch ($CommandAst.GetCommandName()) {
        'git' {
            $gitCmd = $CommandAst.CommandElements[1].Extent
            switch ($gitCmd.Text) {
                'cmt' {
                    [Microsoft.PowerShell.PSConsoleReadLine]::Replace(
                        $gitCmd.StartOffset, $gitCmd.EndOffset - $gitCmd.StartOffset, 'commit')
                }
            }
        }
    }
}
