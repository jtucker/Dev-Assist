---
external help file: Dev-Assist-help.xml
Module Name: Dev-Assist
online version:
schema: 2.0.0
---

# Install-DodCertificates

## SYNOPSIS
Download and install the InstallRoot application. 

## SYNTAX

```
Install-DodCertificates [-TempLocation] <Object> [<CommonParameters>]
```

## DESCRIPTION

## EXAMPLES

### Example 1
```powershell
PS C:\> Install-DodCertificates -TempLocation C:\temp
```

This example will download the InstallRoot installer into the directory `c:\temp\` and then install it. 

## PARAMETERS

### -TempLocation
Temporary location to download assets and any processing. 

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
