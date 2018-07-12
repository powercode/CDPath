---
external help file: cdpath-help.xml
Module Name: cdpath
online version:
schema: 2.0.0
---

# Set-CDPathLocation

## SYNOPSIS
Changing location using by resolving a pattern agains a set of paths

## SYNTAX

```
Set-CDPathLocation [[-Path] <String>] [-Remaining <String[]>] [-Exact] [<CommonParameters>]
```

## DESCRIPTION
CDPath replaces the 'cd' alias with Set-CDPathLocation

Parts of paths can be specified with a space.

PS\> cd win mo

will change directory to ~/documents/windowspowershell/modules

## EXAMPLES

### EXAMPLE 1
```
Set-CDPathLocation ....
```

The example changes the current location to the parent three levels up.
..
(first parent)
...
(second parent)
....
(third parent)

### EXAMPLE 2
```
Set-CDLocation 'C:\Program Files (X86)\Microsoft Visual Studio 12'
```

### EXAMPLE 3
```
Set-CDLocation ~
```

Go back to 'C:\Program Files (X86)\Microsoft Visual Studio 12'

Set-CDPathLocation \-

### EXAMPLE 4
```
Get-CDPath
```

~/Documents/GitHub
~/Documents
~/corpsrc

go to ~/documents/WindowsPowerShell/Modules/CDPath
Set-CDLocation win mod cdp

## PARAMETERS

### -Exact
{{Fill Exact Description}}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
{{Fill Path Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Remaining
{{Fill Remaining Description}}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
