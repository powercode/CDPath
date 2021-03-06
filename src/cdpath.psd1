
@{

	# Script module or binary module file associated with this manifest.
	RootModule        = 'cdpath.psm1'

	# Version number of this module.
	ModuleVersion     = '3.0.1'

	# ID used to uniquely identify this module
	GUID              = '5ca4809d-c4ec-4c3c-b21d-b42956302d99'

	# Author of this module
	Author            = 'Staffan Gustafsson'

	# Company or vendor of this module
	CompanyName       = 'PowerCode'

	# Copyright statement for this module
	Copyright         = '(c) 2015 sgustafsson. All rights reserved.'

	# Description of the functionality provided by this module
	Description       = 'Fast navigation to predefined paths'

	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '5.1'

	# Script files (.ps1) that are run in the caller's environment prior to importing this module.
	ScriptsToProcess  = @('init.ps1')

	# Functions to export from this module
	FunctionsToExport = 'Add-CDPath', 'Get-CDPath', 'Set-CDPath', 'Get-CDPathOption', 'Set-CDPathLocation', 'Set-CDPathOption', 'Update-Cdpath', 'Get-CDPathCandidate'

	# Aliases to export from this module
	AliasesToExport   = 'cd'

	# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData       = @{

		PSData = @{

			# Tags applied to this module. These help with module discovery in online galleries.
			Tags       = @('cd', 'path')

			# A URL to the license for this module.
			LicenseUri = 'https://github.com/powercode/CDPath/blob/master/LICENSE'

			# A URL to the main website for this project.
			ProjectUri = 'https://github.com/powercode/CDPath'
 

		} # End of PSData hashtable

	} # End of PrivateData hashtable


}