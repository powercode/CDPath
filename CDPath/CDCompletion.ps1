# If TabExpansionPlusPlus is installed, This is executed


#
# .SYNOPSIS
#
#     Description of added completer
#
function CompleteCdPath
{
  param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
  $cdpath = @('.')
  if (Test-Path '~\documents\WindowsPowershell\cdpath.txt')
  {
    $cdpath += Get-CDPath    
  }
  else
  {
    $cdpath += $env:USERPROFILE
  }
  
  if ($commandAst.CommandElements.Count -ne 2)
  {
    return
  }
  $ce = $commandAst.CommandElements[1]
  if ($ce -isnot [System.Management.Automation.Language.StringConstantExpressionAst])
  {
    return
  }
  $pattern = $commandAst.CommandElements[1].Value         	
  
  Join-Path $cdpath "$pattern*" -Resolve -ea:SilentlyContinue | foreach {
    if (Test-Path -PathType Container $_)
    {
      if ($_.Contains(' '))
      {
        $_ = "'$_'"
      }
      New-CompletionResult -CompletionResultType ProviderContainer  $_
    }
  }
}
TabExpansionPlusPlus\Register-ArgumentCompleter -CommandName Set-CDPathLocation -ParameterName Path -ScriptBlock $function:CompleteCdPath