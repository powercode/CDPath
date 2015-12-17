$script:Options = [pscustomobject] @{  
  SetWindowTitle = $true
}

$script:PreviousWorkingDir = '~'

<#
.SYNOPSIS
  Changing location using by resolving a pattern agains a set of paths

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
function Set-CDPathLocation 
{
  param(
    [Parameter(Position=0)]
    [string] $Path,
    [Parameter(ValueFromRemainingArguments)]
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
    $Path = $path.Substring(1) -replace '.','..\'
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
    $script:PreviousWorkingDir = $Pwd.Path
    Set-Location $NewPath        
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


function Update-Cdpath 
{
  $script:cdpath=Get-Content '~\documents\WindowsPowershell\cdpath.txt' | 
    Where-Object {$_.Trim()} |   
    ForEach-Object { $ExecutionContext.InvokeCommand.ExpandString($_) }         
}

function Add-CDPath 
{
  param(
    [string[]] $NewPath
    ,
    [Switch] $Prepend
  )
  
  if ($Prepend)
  {
    Set-CDPath @($NewPath + $script:cdpath)
  }
  else
  {
    Set-CDPath @($script:cdpath + $NewPath)
  }  
}

function Get-CDPath
{
  $script:cdpath
}

function Get-CDPathOption
{
  $script:Options
}

function Set-CDPath
{
  param(
    [Parameter(Mandatory)]
    [string[]] $Path
  )
  $script:CDPath = $Path
  Set-Content '~\documents\WindowsPowershell\cdpath.txt' $Path
}

<#
.SYNOPSIS
  Customizes the behavior of Set-CDPathLocation in CDPath
#>
function Set-CDPathOption
{
  param(    
    # Indicates if the the window title should be changed when changing location
    [Switch] $SetWindowTitle
  ) 
  
  $script:Options.SetWindowTitle = [bool] $SetWindowTitle
  
}