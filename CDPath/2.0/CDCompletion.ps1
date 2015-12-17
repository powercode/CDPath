using namespace System.Management.Automation
using namespace System.Management.Automation.Language

function CompleteCdPath{    
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
     
     
     if ($commandAst.CommandElements.Count -ne 2)
     {
        return
     }
      $cdpath = @('.') 
    if (Test-Path '~\documents\WindowsPowershell\cdpath.txt') 
    { 
      $cdpath += Get-CDPath     
    }     

     $ce = $commandAst.CommandElements[1]
     if ($ce -isnot [StringConstantExpressionAst])
     {
        return
     }
     $pattern = $commandAst.CommandElements[1].Value         	
     
     
     [CompletionCompleters]::CompleteFilename("$wordToComplete*") | Where-Object ResultType -eq ProviderContainer
     
     Join-Path $cdpath "$pattern*" -Resolve -ea:SilentlyContinue | foreach {        
        if (Test-Path -PathType Container $_)
        {
            if ($_.Contains(' ')){
                $_ = "'$_'"
            }
            [CompletionResult]::new($_,$_, [CompletionResultType]::ProviderContainer,  $_)
        }
     }
}


function CompleteCdRemaining{    
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)
               
    $cdpath = @('.') 
    if (Test-Path '~\documents\WindowsPowershell\cdpath.txt') 
    { 
      $cdpath += Get-CDPath     
    }      

     $ce = $commandAst.CommandElements[1]
     if ($ce -isnot [StringConstantExpressionAst])
     {
        return
     }
     $el = $commandAst.CommandElements
     $count = ($el.Count - 1)
     if ($wordToComplete){
        $count--
     }
     if($count -eq 1){
        $pattern = $el[1].Value + "*\$wordtoComplete*"
     }
     else{
        $pattern = $el[1..$count].Value -join '*\' 
        $pattern += "*\$wordtoComplete*"
     }
     
     
     [CompletionCompleters]::CompleteFilename("$wordToComplete*") | Where-Object ResultType -eq ProviderContainer
     
     Join-Path $cdpath $pattern -Resolve -ea:SilentlyContinue | foreach {        
        if (Test-Path -PathType Container $_)
        {
            $name = split-path -leaf $_
            if ($name.Contains(' ')){
                $name = "'$name'"
            }
            [CompletionResult]::new($name,$name, [CompletionResultType]::ProviderContainer,  $name)
            
        }
     }
}


if (Get-Command Register-ArgumentCompleter -ErrorAction:SilentlyContinue){    
    
    Register-ArgumentCompleter -CommandName Set-CDPathLocation -ParameterName Path -ScriptBlock $function:CompleteCdPath
    Register-ArgumentCompleter -CommandName Set-CDPathLocation -ParameterName Remaining -ScriptBlock $function:CompleteCdRemaining
} 
 