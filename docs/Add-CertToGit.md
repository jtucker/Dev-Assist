---
external help file: Dev-Assist-help.xml
Module Name: Dev-Assist
online version:
schema: 2.0.0
---

# Add-CertToGit

## SYNOPSIS
Adds a X509Certificate to git trusted root certs

## SYNTAX

```
Add-CertToGit [-Certificate] <X509Certificate> [[-CrtPath] <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
$cert = Get-SiteRootCert -Url 'https://www.google.com'
```

Add-CertToGit -Certificate $cert

### EXAMPLE 2
```
$cert = Get-SiteRootCert -Url 'https://www.google.com'
```

Add-CertToGit -Certificate $cert -CrtPath 'C:\Certs\MyCerts.crt'

## PARAMETERS

### -Certificate
The certificate to add

```yaml
Type: X509Certificate
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CrtPath
The path to the crt file to update

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
