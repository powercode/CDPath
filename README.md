CDPath
======

PowerShell module to make navigating your system a breeze.

The main function of the module is Set-CDPathLocation (below referenced by 'cd') and supports the following:

*	Go to previous location without pushd/popd (cd -)
*	Go upwards multiple levels (cd ....)
*	Go to a directory in a predefined path
*	Integration with TabExpansion++


Usage
-----
Assuming you've installed the module somewhere in your module path, just import the module in your profile, e.g.:
```powershell
Import-Module CDPath
# if you've imported PSCX and want to use cd as an alias for Set-CDPathLocation, 
# you must first remove the alias set by PSCX
Remove-Item alias:cd
Set-Alias cd Set-CDPathLocation
```

To setup the CDPath, i.e. the parent directories of the directories you most often navigate to, call
```powershell
# a user who has github projects and a directory where corporate source code is stored
# may set up the path like this 
Set-CDPath -Path ~\Documents\GitHub,d:\corpsrc,~\documents
```
The CDPath is persisted at ~/Documents/WindowsPowerShell/cdpath.txt

Imagine the following directory structure
```
~/Documents/
	GitHub
		PSReadLine
		TabExpansion++
		CDPath
	WindowsPowerShell
		ArgumentCompleters
		Modules
D:\CorpSrc
	PSApi
	ToolingApi
	Frontend
	Backend
```
Navigation can then be done like this:

```powershell
# go to PSReadline
PS> cd psr

# go to ~/Documents/WindowsPowerShell/Modules
cd win mod

# go to ToolingApi
cd too

# go to TabExpansion++
cd tab
# go up three levels
cd ....
# go back to previous directory 
cd -

```
