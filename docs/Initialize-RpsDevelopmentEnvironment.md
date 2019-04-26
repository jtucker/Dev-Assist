---
external help file: Dev-Assist-help.xml
Module Name: Dev-Assist
online version:
schema: 2.0.0
---

# Initialize-RpsDevelopmentEnvironment

## SYNOPSIS
Full process for configuring an environment for RPS Development.

## SYNTAX

```
Initialize-RpsDevelopmentEnvironment [-TempLocation] <Object> [-TfsServerName] <Object> [-UseVisualStudioGit]
 [<CommonParameters>]
```

## DESCRIPTION
Full process for configuring an environment for RPS Development. This will install the DOD Root Certs as well as configure git to connect to the TFS server.

## EXAMPLES

### Example 1
```powershell
PS C:\> Initialize-RpsDevelopmentEnvironment -TemplateLocation c:\temp -TfsServerName hello.tfs.io
```

This example will execute the RPS Development configuration using the folder `c:\temp` for processing, using a globally installed git instance and then configure the users git for the server located at hello.tfs.io.

## PARAMETERS

### -TempLocation
The location where assets and processing will happen on disk.

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

### -TfsServerName
The domain URL for the TFS Git server.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseVisualStudioGit
Use Visual Studio's already built in git client. 

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
