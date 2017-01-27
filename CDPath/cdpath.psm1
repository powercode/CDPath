using namespace System.Management.Automation
using namespace System.Collections.Generic
using namespace System.Management.Automation.Language


Set-StrictMode -Off
[string]  $script:PathFile = '~/.cdpath'
[string[]]$script:cdpath = $null
$script:Options = [pscustomobject] @{  
  SetWindowTitle = $true
}

$script:PreviousWorkingDir = '~'
if(-not (Test-Path $script:PathFile))
{
    Set-Content -Path $script:PathFile -Value ''
}

class CDPathCompleter : System.Management.Automation.IArgumentCompleter {
    [IEnumerable[CompletionResult]] 
    CompleteRemaining(
                      [string] $wordToComplete,
                      [System.Management.Automation.Language.CommandAst] $commandAst,
                      [System.Collections.IDictionary] $fakeBoundParameters)
    {
         
         $cdpath = ,'.' + $script:cdpath        

         $ce = $commandAst.CommandElements[1]
         if ($ce -isnot [StringConstantExpressionAst])
         {
            return $null
         }
         $el = $commandAst.CommandElements
         $count = ($el.Count - 1)
         if ($wordToComplete){
            $count--
         }
         if($count -eq 1){
            $v = $el[1].Value
            if($v.EndsWith('\'))
            {
                $pattern = "$v\$wordtoComplete*"
            }
            else
            {
                $pattern = $v + "*\$wordtoComplete*"
            }
         }
         else{
            $v = $el[1..$count].Value
            $pattern = $v -join '*\' 
            $pattern += "*\$wordtoComplete*"
         }
         $res = [System.Collections.Generic.List[CompletionResult]]::new(10)
            
         if([io.path]::IsPathRooted($pattern))
         {
            foreach($r in Resolve-Path $pattern)
            {
                $name = $r.Substring(0,$v.length)
                $res.Add([CompletionResult]::new($name,$name, [CompletionResultType]::ProviderContainer,  $name))
            }
         }
         else{                 
             Join-Path -Path $cdpath -ChildPath $pattern -Resolve -ea:SilentlyContinue | foreach {        
                if ([io.Directory]::Exists($_))
                {
                    $name = [io.path]::GetFileName($_)
                    if ($name.Contains(' ')){
                        $name = "'$name'"
                    }
                    $res.Add([CompletionResult]::new($name,$name, [CompletionResultType]::ProviderContainer,  $name))            
                }            
             }
         }
         
         return $res
     }
     
     [IEnumerable[CompletionResult]] CompletePath([string] $wordToComplete, [CommandAst] $commandAst,
                  [System.Collections.IDictionary] $fakeBoundParameters) 
    {
        if ($commandAst.CommandElements.Count -ne 2)
        {
            return $null
        }
        $cdpath = ,'.' + $script:cdpath 
                                  

        $ce = $commandAst.CommandElements[1]
        if ($ce -isnot [StringConstantExpressionAst])
        {
            return $null
        }
        $pattern = $commandAst.CommandElements[1].Value         	
     
        $res = [System.Collections.Generic.List[CompletionResult]]::new(10)
         foreach($r in [CompletionCompleters]::CompleteFilename("$wordToComplete*"))
         {
            if($_.ResultType -eq [CompletionResultType]::ProviderContainer)
            {
                $res.Add($r)
            }
         }
     
        foreach($r in Join-Path -Path $cdpath -ChildPath "$pattern*" -Resolve -ea:SilentlyContinue)
        {        
            if ([io.Directory]::Exists($r))
            {
                if ($r.Contains(' ')){
                    $r = "'$r'"
                }
                $res.Add([CompletionResult]::new($r,[io.path]::GetFileName($r), [CompletionResultType]::ProviderContainer,  $r))
            }
        }
        return $res
    }


     [IEnumerable[CompletionResult]] CompleteArgument([string] $commandName,
                      [string] $parameterName,
                      [string] $wordToComplete,
                      [System.Management.Automation.Language.CommandAst] $commandAst,
                      [System.Collections.IDictionary] $fakeBoundParameters) 
    {
        switch($parameterName)
        {
            'Path' {return $this.CompletePath($wordToComplete, $commandAst, $fakeBoundParameters);break}
            'Remaining' {return $this.CompleteRemaining($wordToComplete, $commandAst, $fakeBoundParameters)}
        }    
        return $null
    }
}
    

<#
    .SYNOPSIS
    Changing location using by resolving a pattern agains a set of paths
    .DESCRIPTION
    CDPath replaces the 'cd' alias with Set-CDPathLocation
  
    Parts of paths can be specified with a space.
  
    PS> cd win mo

    will change directory to ~/documents/windowspowershell/modules
  

    .EXAMPLE
    Set-CDPathLocation ....

    The example changes the current location to the parent three levels up.
    .. (first parent)
    ... (second parent)
    .... (third parent)

    .EXAMPLE
    Set-CDLocation 'C:\Program Files (X86)\Microsoft Visual Studio 12'
    Set-CDLocation ~
    # Go back to 'C:\Program Files (X86)\Microsoft Visual Studio 12'
    Set-CDPathLocation -

    .EXAMPLE

    Get-CDPath
    ~/Documents/GitHub
    ~/Documents
    ~/corpsrc

    # go to ~/documents/WindowsPowerShell/Modules/CDPath
    Set-CDLocation win mod cdp


#>
function Set-CDPathLocation {
  [Alias('cd')]
  param(
    [Parameter(Position=0)]
    [ArgumentCompleter([CDPathCompleter])]
    [string] $Path,
    [Parameter(ValueFromRemainingArguments)]
    [ArgumentCompleter([CDPathCompleter])]
    [string[]] $Remaining=$null,
    [switch] $Exact
    )

  $CurrentWorkingDir = $Pwd.ProviderPath      
  $NewPath = $null
  
  # If there are extra arguments, create a globbing expression
  # so that cd a b c => cd a*\b*\c*
  if ($Remaining)
  {        
    $ofs='*\'
    $path= "$path*\$Remaining*"	
  }	
  
  # Resolve Path
  if (!$Path) 
  {
    $Path = '~'
  }
  
  # .'ing shortcuts for ... and ....
  if ($Path -match "^\.{3,}$")
  {
    $Path = $path.Substring(1) -replace '\.','..\'
  } 
  
  
  if ($Path -eq '-')
  {
    # pop back to your old Path
    Set-Location $script:PreviousWorkingDir
    $script:PreviousWorkingDir = $CurrentWorkingDir
    return
  }
  # See if the location exists. If it does not, use $CDPath to
  # resolve to a location that exists    
  if (Test-Path $Path -ea SilentlyContinue)
  {
    $NewPath = $Path
  }
  else
  {
    if ($Exact)
    {
      $paths = Join-Path $cdpath "$path"
    }
    else 
    {                  
      $paths = Join-Path $cdpath "$path*" -Resolve -ea SilentlyContinue
    }
    if ($paths) {
      if ($paths -is [string])
      {
        $NewPath=$paths
      } 
      else 
      {
        # find the first match that is a container
        $res=Test-Path -PathType:Container $paths
        for($i=0; $i -lt $res.Length;++$i)
        {
          if ($res[$i])
          {
            $NewPath=$paths[$i]
            break
          } #if
        } #for        
      } 
    } #if $paths
    # clear $newpath if it is not a directory
    if($NewPath -and !(Test-Path $NewPath -PathType:Container))
    {
      $NewPath=$null
    }
    
  }#else
  
  if ($NewPath )
  {
    $script:PreviousWorkingDir = $Pwd.ProviderPath
    $newPath = (Resolve-Path -path $NewPath).ProviderPath
    Set-Location -Path $NewPath
    if($script:Options.SetWindowTitle)
    {

      $Host.UI.RawUI.WindowTitle=$NewPath
    }
  } 
  else 
  {
    if (Test-Path $path -ea SilentlyContinue) 
    {
      Set-Location $path
    }
    else {
      Write-Error "Directory not found: $path"
    }
  }    
}

<#
    .SYNOPSIS
    Read the cdpath from ~/.cdpath

    .DESCRIPTION
    This is useful if you have modified your path file with an external editor
#>
function Update-Cdpath {
  $script:cdpath=Get-Content -Path $script:PathFile | 
    Where-Object {$_.Trim()} |   
    ForEach-Object { $ExecutionContext.InvokeCommand.ExpandString($_) }         
}

<#
    .SYNOPSIS
    Adds one or more paths to your cdpath

    .DESCRIPTION
    This is useful if you have modified your path file with an external editor
#>
function Add-CDPath {
  param(
    [string[]] $Path
    ,
    # Specify Prepend to add the paths before the existing paths
    [Switch] $Prepend
  )
  
  if ($Prepend)
  {
    Set-CDPath @($Path + $script:cdpath)
  }
  else
  {
    Set-CDPath @($script:cdpath + $Path)
  }  
}


function Get-CDPath {
  $script:cdpath
}

function Get-CDPathOption {
  $script:Options
}

function Set-CDPath {
  param(
    [Parameter(Mandatory)]
    [string[]] $Path
  )
  $script:CDPath = $Path  
  $ofs = [Environment]::NewLine
  Set-Content -Path $script:PathFile  -value $Path
}

<#
    .SYNOPSIS
    Customizes the behavior of Set-CDPathLocation in CDPath
#>
function Set-CDPathOption {
  param(    
    # Indicates if the the window title should be changed when changing location
    [Switch] $SetWindowTitle   
  ) 
  if($PSBoundParameters.ContainsKey('SetWindowTitle'))
  {
    $script:Options.SetWindowTitle = [bool] $SetWindowTitle
  }     
}

# read cdpath from file
Update-Cdpath

if ($null -eq $script:cdpath) {
  Set-CDPath ~,~/documents,$env:programfiles  
}

