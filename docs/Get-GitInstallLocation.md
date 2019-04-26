---
external help file: Dev-Assist-help.xml
Module Name: Dev-Assist
online version:
schema: 2.0.0
---

# Get-GitInstallLocation

## SYNOPSIS
Returns the location of the Git executable. Can optionally look for the embeded Visual Studio git command.

## SYNTAX

```
Get-GitInstallLocation [-TempLocation] <Object> [-UseVisualStudioGit] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-GitInstallLocation -TempLocation c:\temp -UseVisualStudioGit
```

This example will try and find the location of git by first, downloading `vswhere` and using that utility to get the current installed location of Visual Studio (2017+). 

## PARAMETERS

### -TempLocation
The temporary location to download `vswhere.exe` to. 

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseVisualStudioGit
Use the Visual Studio git install instead of a global installed one.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
