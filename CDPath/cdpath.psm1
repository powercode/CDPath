
Set-StrictMode -Version 4

. $PSScriptRoot\CDPathLocation.ps1

# read cdpath from file
Update-Cdpath

if (-not $script:cdpath)
{
  $script:cdpath=$env:USERPROFILE,$env:programfiles,$env:windir
}

Export-ModuleMember Set-CDPathLocation, Update-CdPath, Get-CDPath, Add-CDPath, Set-CDPathOption, Get-CDPathOption -alias cd

