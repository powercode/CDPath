
Set-StrictMode -Version Latest

. $PSScriptRoot\CDPathLocation.ps1

# read cdpath from file
Update-Cdpath

if (-not $script:cdpath)
{
  $script:cdpath=$env:USERPROFILE,$env:programfiles,$env:windir
}

. $PSScriptRoot\CDCompletion.ps1

Export-ModuleMember Set-CDPathLocation, Update-CdPath, Get-CDPath, Add-CDPath, Set-CDPathOption, Get-CDPathOption -alias cd

