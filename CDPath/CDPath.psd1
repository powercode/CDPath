
@{

# Script module or binary module file associated with this manifest.
RootModule = 'cdpath.psm1'

# Version number of this module.
ModuleVersion = '2.0.1'

# ID used to uniquely identify this module
GUID = '5ca4809d-c4ec-4c3c-b21d-b42956302d99'

# Author of this module
Author = 'Staffan Gustafsson'

# Company or vendor of this module
CompanyName = 'PowerCode'

# Copyright statement for this module
Copyright = '(c) 2015 sgustafsson. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Fast navigation to predefined paths'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.0'

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
ScriptsToProcess = @('init.ps1')

# Functions to export from this module
FunctionsToExport = 'Add-CDPath','Get-CDPath','Set-CDPath','Get-CDPathOption','Set-CDPathLocation','Set-CDPathOption','Update-Cdpath'

# Aliases to export from this module
AliasesToExport = 'cd'

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('cd','path')

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/powercode/CDPath/blob/master/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/powercode/CDPath'
 

    } # End of PSData hashtable

} # End of PrivateData hashtable


}

# SIG # Begin signature block
# MIINLAYJKoZIhvcNAQcCoIINHTCCDRkCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUTGjhFn5ahWuapDks7AB5EafB
# 3OKgggpuMIIFMDCCBBigAwIBAgIQBAkYG1/Vu2Z1U0O1b5VQCDANBgkqhkiG9w0B
# AQsFADBlMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBBc3N1cmVk
# IElEIFJvb3QgQ0EwHhcNMTMxMDIyMTIwMDAwWhcNMjgxMDIyMTIwMDAwWjByMQsw
# CQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cu
# ZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFzc3VyZWQgSUQg
# Q29kZSBTaWduaW5nIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
# +NOzHH8OEa9ndwfTCzFJGc/Q+0WZsTrbRPV/5aid2zLXcep2nQUut4/6kkPApfmJ
# 1DcZ17aq8JyGpdglrA55KDp+6dFn08b7KSfH03sjlOSRI5aQd4L5oYQjZhJUM1B0
# sSgmuyRpwsJS8hRniolF1C2ho+mILCCVrhxKhwjfDPXiTWAYvqrEsq5wMWYzcT6s
# cKKrzn/pfMuSoeU7MRzP6vIK5Fe7SrXpdOYr/mzLfnQ5Ng2Q7+S1TqSp6moKq4Tz
# rGdOtcT3jNEgJSPrCGQ+UpbB8g8S9MWOD8Gi6CxR93O8vYWxYoNzQYIH5DiLanMg
# 0A9kczyen6Yzqf0Z3yWT0QIDAQABo4IBzTCCAckwEgYDVR0TAQH/BAgwBgEB/wIB
# ADAOBgNVHQ8BAf8EBAMCAYYwEwYDVR0lBAwwCgYIKwYBBQUHAwMweQYIKwYBBQUH
# AQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQwYI
# KwYBBQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFz
# c3VyZWRJRFJvb3RDQS5jcnQwgYEGA1UdHwR6MHgwOqA4oDaGNGh0dHA6Ly9jcmw0
# LmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcmwwOqA4oDaG
# NGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RD
# QS5jcmwwTwYDVR0gBEgwRjA4BgpghkgBhv1sAAIEMCowKAYIKwYBBQUHAgEWHGh0
# dHBzOi8vd3d3LmRpZ2ljZXJ0LmNvbS9DUFMwCgYIYIZIAYb9bAMwHQYDVR0OBBYE
# FFrEuXsqCqOl6nEDwGD5LfZldQ5YMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6en
# IZ3zbcgPMA0GCSqGSIb3DQEBCwUAA4IBAQA+7A1aJLPzItEVyCx8JSl2qB1dHC06
# GsTvMGHXfgtg/cM9D8Svi/3vKt8gVTew4fbRknUPUbRupY5a4l4kgU4QpO4/cY5j
# DhNLrddfRHnzNhQGivecRk5c/5CxGwcOkRX7uq+1UcKNJK4kxscnKqEpKBo6cSgC
# PC6Ro8AlEeKcFEehemhor5unXCBc2XGxDI+7qPjFEmifz0DLQESlE/DmZAwlCEIy
# sjaKJAL+L3J+HNdJRZboWR3p+nRka7LrZkPas7CM1ekN3fYBIM6ZMWM9CBoYs4Gb
# T8aTEAb8B4H6i9r5gkn3Ym6hU/oSlBiFLpKR6mhsRDKyZqHnGKSaZFHvMIIFNjCC
# BB6gAwIBAgIQC00BIFzepyXTcMbB+AfaoDANBgkqhkiG9w0BAQsFADByMQswCQYD
# VQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGln
# aWNlcnQuY29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFzc3VyZWQgSUQgQ29k
# ZSBTaWduaW5nIENBMB4XDTE1MDgxMTAwMDAwMFoXDTE4MDgxNTEyMDAwMFowfTEL
# MAkGA1UEBhMCU0UxFzAVBgNVBAgTDlN0b2NraG9sbXMgTGFuMREwDwYDVQQHDAhT
# a8O2bmRhbDEgMB4GA1UEChMXUG93ZXJDb2RlIENvbnN1bHRpbmcgQUIxIDAeBgNV
# BAMTF1Bvd2VyQ29kZSBDb25zdWx0aW5nIEFCMIIBIjANBgkqhkiG9w0BAQEFAAOC
# AQ8AMIIBCgKCAQEA0Yu390VGptjUZIdLxIYQCSG1atPh/tN6qPf/eovS3ohJy+td
# XluaPkUXuE3fWeMp+p3Jsj3c/LdsA1iYiQQQnJ/9afqiW2hnmSkNZfgcLQ9mceXl
# mmd2otcwfkVhfA6ZuFnpceFgKciLLld7AY1sMiSyc1L5RvEsOR/1S6uBg0AWoSSv
# l44vF8EgeArhPCx8GNbUmYfEpeqs1f5LOLlQBwImGCsjv1rmbuPwt0E229XVLerU
# auNXJjb+jtrGBTzD384QiLMGtNHWnE4yBStjrLTHHNz4mE0g6jUIYJbFvGLD04Cl
# 7WovOkODL+9nmsyreUg2UVBKrO98GK/G8XhG8wIDAQABo4IBuzCCAbcwHwYDVR0j
# BBgwFoAUWsS5eyoKo6XqcQPAYPkt9mV1DlgwHQYDVR0OBBYEFAGtca5rM/ejkFdY
# 3OVLhIxGkpIBMA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcDAzB3
# BgNVHR8EcDBuMDWgM6Axhi9odHRwOi8vY3JsMy5kaWdpY2VydC5jb20vc2hhMi1h
# c3N1cmVkLWNzLWcxLmNybDA1oDOgMYYvaHR0cDovL2NybDQuZGlnaWNlcnQuY29t
# L3NoYTItYXNzdXJlZC1jcy1nMS5jcmwwQgYDVR0gBDswOTA3BglghkgBhv1sAwEw
# KjAoBggrBgEFBQcCARYcaHR0cHM6Ly93d3cuZGlnaWNlcnQuY29tL0NQUzCBhAYI
# KwYBBQUHAQEEeDB2MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5j
# b20wTgYIKwYBBQUHMAKGQmh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdp
# Q2VydFNIQTJBc3N1cmVkSURDb2RlU2lnbmluZ0NBLmNydDAMBgNVHRMBAf8EAjAA
# MA0GCSqGSIb3DQEBCwUAA4IBAQC+nkBDDZo+AvHQdEm2IA9ygsJIQccvEE/ijFoq
# RHqje75atqGhfzcVyqjyRdhj7FJ2WGvcWsHahViDq9ZR5W42S6D9OG0c+Wmo6buc
# jn1Y8lfaWIngCloNZ0BF7rBcVmR8JLkfKjVZSsHdbBKVxj3x7NYw9cr7nx/UQjXX
# jghqtWMetHOlw73BKpDEJGs7LFtb8TZcNLVyWU4GuW1HWhncf5lq2b3WUP82xKIa
# Pf7w50P33/xxo+N12nNJJQ82aIhUVhVXcZ+TWlfO2n0yZT7dsa1FFwRf/dGPIpZm
# Kn8tanILjQg5K4NWlli2iLonrmRmqXAlXe8NSPTXWPvaNskAMYICKDCCAiQCAQEw
# gYYwcjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UE
# CxMQd3d3LmRpZ2ljZXJ0LmNvbTExMC8GA1UEAxMoRGlnaUNlcnQgU0hBMiBBc3N1
# cmVkIElEIENvZGUgU2lnbmluZyBDQQIQC00BIFzepyXTcMbB+AfaoDAJBgUrDgMC
# GgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYK
# KwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG
# 9w0BCQQxFgQUutS8UMOY5lPaQmBXbqBW6ExuNMMwDQYJKoZIhvcNAQEBBQAEggEA
# cY/XEa2UVozd9fJicE0BsL6wsBINNMBCLxsStfvUOSOLsRGrB7OnBaGc7xXAL30U
# 7WaC7wIFTFLFIH99aKrHNtfm2hODZw8HDvof2VqSW1mU7fi5eG/Lt98iC40caQi0
# EdsBztvAQIib9lEOumQmPRcUOdj/az2S2Obcluwx91oADvccL5dI3dhxlKYSRF2x
# gyoTXgKB8H/ZaIWS+I+K8yKgfaMZJiuZAIk7wMD460VHLKAje436R88so7jzH+xQ
# uVShdUjDEFNJloBtYBscAft9r2YrypdSRHkULjgSYGWzOJWAZ3TldUYcw7nuu7JM
# RJ6J3auYVIeMvMhgNp9aAQ==
# SIG # End signature block
