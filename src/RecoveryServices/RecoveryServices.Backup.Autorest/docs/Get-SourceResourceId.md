---
external help file:
Module Name: Az.RecoveryServices
online version: https://docs.microsoft.com/powershell/module/az.recoveryservices/get-sourceresourceid
schema: 2.0.0
---

# Get-SourceResourceId

## SYNOPSIS
Initializes Restore Request object for triggering restore on a protected backup instance.

## SYNTAX

```
Get-SourceResourceId [-RecoveryPoint <IRecoveryPointResource>] [<CommonParameters>]
```

## DESCRIPTION
Initializes Restore Request object for triggering restore on a protected backup instance.

## EXAMPLES

### Example 1: {{ Add title here }}
```powershell
{{ Add code here }}
```

```output
{{ Add output here }}
```

{{ Add description here }}

### Example 2: {{ Add title here }}
```powershell
{{ Add code here }}
```

```output
{{ Add output here }}
```

{{ Add description here }}

## PARAMETERS

### -RecoveryPoint
Specifies the ContainerId
To construct, see NOTES section for RECOVERYPOINT properties and create a hash table.

```yaml
Type: Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.IRecoveryPointResource
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

## OUTPUTS

### System.String

## NOTES

ALIASES

COMPLEX PARAMETER PROPERTIES

To create the parameters described below, construct a hash table containing the appropriate properties. For information on hash tables, run Get-Help about_Hash_Tables.


`RECOVERYPOINT <IRecoveryPointResource>`: Specifies the ContainerId
  - `[ETag <String>]`: Optional ETag.
  - `[Location <String>]`: Resource location.
  - `[Tag <IResourceTags>]`: Resource tags.
    - `[(Any) <String>]`: This indicates any property can be added to this object.
  - `[ObjectType <String>]`: This property will be used as the discriminator for deciding the specific types in the polymorphic chain of types.

## RELATED LINKS

