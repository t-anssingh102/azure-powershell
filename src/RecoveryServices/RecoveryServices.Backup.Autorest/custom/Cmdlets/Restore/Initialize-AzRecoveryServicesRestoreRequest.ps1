function Get-SourceResourceId {
    [OutputType('string')]
    [CmdletBinding(PositionalBinding=$false)]
    [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Description('Initializes Restore Request object for triggering restore on a protected backup instance.')]

    param (
        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the ContainerId')]
        [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.IRecoveryPointResource]
        ${RecoveryPoint}
    )

    process {
		$RecoveryPointId = $RecoveryPoint.Id
        
        $pattern = '/subscriptions/(?<subscriptionId>[^/]+)/resourceGroups/(?<resourceGroupName>[^/]+)/providers/Microsoft\.RecoveryServices/vaults/(?<vaultName>[^/]+)'
        $matches = [regex]::Match($RecoveryPointId, $pattern)
        $SourceSubscriptionId = $matches.Groups["subscriptionId"].Value
        $SourceResourceGroupName = $matches.Groups["resourceGroupName"].Value
        $SourceVaultName = $matches.Groups["vaultName"].Value
        
        $pattern = "/protectedItems/(?<ProtectedItemName>[^/]+)/recoveryPoints"
        $matches = [regex]::Match($RecoveryPointId, $pattern)
        $ProtectedItemName = $matches.Groups["ProtectedItemName"].Value

        $ProtectedItems = Get-AzRecoveryServicesBackupProtectedItem -ResourceGroupName $SourceResourceGroupName -VaultName $SourceVaultName -SubscriptionId $SourceSubscriptionId
        
        $SelectedProtectedItem = $ProtectedItems | Where-Object {$_.Name -eq $ProtectedItemName}

        $SelectedProtectedItem.SourceResourceId
	}
}


function Initialize-AzRecoveryServicesRestoreRequest {
	[OutputType('Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.RestoreRequest')]
    [CmdletBinding(PositionalBinding=$false)]
    [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Description('Initializes Restore Request object for triggering restore on a protected backup instance.')]

	param (
        # Recovery point and type specific parameters

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the ContainerId')]
        [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Support.DatasourceTypes]
        ${DatasourceType},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the ContainerId')]
        [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.IRecoveryPointResource]
        ${RecoveryPoint},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the RecoveryType')]
        [string]
        ${RecoveryType},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the RecoveryMode')]
        [string]
        ${RecoveryMode},

        # Target specific parameters

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the ContainerId')]
        [string]
        ${TargetSubscriptionId},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the ContainerId')]
        [string]
        ${TargetResourceGroupName},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the ContainerId')]
        [string]
        ${TargetVMName},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the ContainerId')]
        [string]
        ${TargetContainerId},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target directory')]
        [string]
        ${TargetDirectory},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the DatabaseName')]
        [string]
        ${TargetDatabaseName},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target directory')]
        [string]
        ${TargetVNetName},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target directory')]
        [string]
        ${TargetVNetResourceGroup},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target directory')]
        [string]
        ${TargetSubnetName},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target directory')]
        [int]
        ${TargetZoneNumber},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the OverwriteOption')]
        #[Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Support.OverwriteOptions]
        [string]
        ${OverwriteOption},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the SourceResourceId')]
        [string]
        ${SourceResourceId},

        # AzureVM specific parameters

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target directory')]
        [string]
        ${StorageAccountId},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target directory')]
        [string]
        ${Region},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target directory')]
        [string]
        ${DiskEncryptionSetId},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target directory')]
        [string[]]
        ${RestoreDiskList},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target directory')]
        [switch]
        ${RestoreOnlyOSDisk},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target directory')]
        [switch]
        ${UseSystemAssignedIdentity},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target directory')]
        [string]
        ${UserAssignedIdentityId},

        # SQL specific parameters
        
        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target directory')]
        [bool]
        ${NonRecoverable},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target directory')]
        [string]
        ${DataSourceLogicalName},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target directory')]
        [string]
        ${DataSourcePath},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target directory')]
        [string]
        ${DataTargetPath},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target directory')]
        [string]
        ${LogSourceLogicalName},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target directory')]
        [string]
        ${LogSourcePath},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target directory')]
        [string]
        ${LogTargetPath},

        # Rehydrate specific parameters

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target directory')]
        [string]
        ${RehydrateDuration},

        [Parameter(ParameterSetName='InitializeRestoreRequest', HelpMessage='Specifies the target directory')]
        [string]
        ${RehydratePriority}
    )

    begin {  

    }

    process { 
        
        # SAPHANA cases
        if ($DataSourceType -eq "SAPHANA") {
            $restoreRequest = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.AzureWorkloadSapHanaRestoreRequest]::new()

            if (($RecoveryType -eq "AlternateLocation") -and (-not $RecoveryMode)) {
                Write-Debug "AlternateLocation"
            
                $restoreRequest.ObjectType = "AzureWorkloadSAPHanaRestoreRequest"
                $restoreRequest.TargetInfo.ContainerId = $TargetContainerId
                $restoreRequest.TargetInfo.DatabaseName = $TargetDatabaseName
                $restoreRequest.TargetInfo.OverwriteOption = $OverwriteOption

                $restoreRequest.SourceResourceId = Get-SourceResourceId -RecoveryPoint $RecoveryPoint
                
                $TargetVirtualMachineId = "/subscriptions/$TargetSubscriptionId/resourceGroups/$TargetResourceGroupName/providers/Microsoft.Compute/virtualMachines/$TargetVMName"
                $restoreRequest.TargetVirtualMachineId = $TargetVirtualMachineId
                
                $restoreRequest.RecoveryType = $RecoveryType
            }
            elseif ($RecoveryType -eq "OriginalLocation") {

                Write-Debug "OriginalLocation"

                $restoreRequest.ObjectType = "AzureWorkloadSAPHanaRestoreRequest"
                $restoreRequest.RecoveryType = $RecoveryType

		    }
            elseif (($RecoveryType -eq "AlternateLocation") -and ($RecoveryMode -eq "FileRecovery")) {
                
                Write-Debug "As File"

			    $restoreRequest.ObjectType = "AzureWorkloadSAPHanaRestoreRequest"
			    $restoreRequest.TargetInfo.ContainerId = $TargetContainerId
                $restoreRequest.TargetInfo.TargetDirectoryForFileRestore = $TargetDirectory

                $restoreRequest.SourceResourceId = Get-SourceResourceId -RecoveryPoint $RecoveryPoint

			    $TargetVirtualMachineId = "/subscriptions/$TargetSubscriptionId/resourceGroups/$TargetResourceGroupName/providers/Microsoft.Compute/virtualMachines/$TargetVMName"
                $restoreRequest.TargetVirtualMachineId = $TargetVirtualMachineId

                $restoreRequest.RecoveryType = $RecoveryType
                $restoreRequest.RecoveryMode = $RecoveryMode

            }
        }

        # AzureVM cases

        elseif ($DataSourceType -eq "AzureVM") {
            $restoreRequest = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.IaaSVMRestoreRequest]::new()

            if ($RecoveryType -eq "AlternateLocation") {
                Write-Debug "AzureVM new vm"

                $restoreRequest.ObjectType = "IaasVMRestoreRequest"
                $restoreRequest.RecoveryPointId = $RecoveryPoint.Id
                $restoreRequest.RecoveryType = $RecoveryType

                $restoreRequest.SourceResourceId = Get-SourceResourceId -RecoveryPoint $RecoveryPoint
				
                $TargetVirtualMachineId = "/subscriptions/$TargetSubscriptionId/resourceGroups/$TargetResourceGroupName/providers/Microsoft.Compute/virtualMachines/$TargetVMName"
                $restoreRequest.TargetVirtualMachineId = $TargetVirtualMachineId

                $TargetResourceGroupId = "/subscriptions/$TargetSubscriptionId/resourceGroups/$TargetResourceGroupName"
                $restoreRequest.TargetResourceGroupId = $TargetResourceGroupId

                $restoreRequest.StorageAccountId = $StorageAccountId

                $TargetVNetId = "/subscriptions/$TargetSubscriptionId/resourceGroups/$TargetVNetResourceGroup/providers/Microsoft.Network/virtualNetworks/$TargetVNetName" 
                $restoreRequest.VirtualNetworkId = $TargetVNetId

                $TargetSubnetId = "/subscriptions/$TargetSubscriptionId/resourceGroups/$TargetVNetResourceGroup/providers/Microsoft.Network/virtualNetworks/$TargetVNetName/subnets/$TargetSubnetName"
                $restoreRequest.SubnetId = $TargetSubnetId

                $restoreRequest.Region = $Region
                #$restoreRequest.DiskEncryptionSetId = $DiskEncryptionSetId
                #$restoreRequest.RestoreDiskLunList = $RestoreDiskList
                # OS disk?

                $restoreRequest.CreateNewCloudService = $false
                $restoreRequest.OriginalStorageAccountOption = $false
                $restoreRequest.RestoreWithManagedDisk = $false
            }
            elseif ($RecoveryType -eq "RestoreDisks") {
                Write-Debug "AzureVM restore disks"

				$restoreRequest.ObjectType = "IaasVMRestoreRequest"
				$restoreRequest.RecoveryPointId = $RecoveryPoint.Id
				$restoreRequest.RecoveryType = $RecoveryType

				$restoreRequest.SourceResourceId = Get-SourceResourceId -RecoveryPoint $RecoveryPoint

                $TargetResourceGroupId = "/subscriptions/$TargetSubscriptionId/resourceGroups/$TargetResourceGroupName"
                $restoreRequest.TargetResourceGroupId = $TargetResourceGroupId
                
                $restoreRequest.StorageAccountId = $StorageAccountId
                $restoreRequest.Region = $Region

                $restoreRequest.CreateNewCloudService = $false
                $restoreRequest.OriginalStorageAccountOption = $false
                $restoreRequest.RestoreWithManagedDisk = $false
            }
            elseif ($RecoveryType -eq "OriginalLocation") {
                Write-Debug "AzureVM original location"

                $restoreRequest.ObjectType = "IaasVMRestoreRequest"
                $restoreRequest.RecoveryPointId = $RecoveryPoint.Id
                $restoreRequest.RecoveryType = $RecoveryType
                
                $restoreRequest.SourceResourceId = Get-SourceResourceId -RecoveryPoint $RecoveryPoint

                $restoreRequest.StorageAccountId = $StorageAccountId
                $restoreRequest.Region = $Region

                $restoreRequest.CreateNewCloudService = $false
                $restoreRequest.OriginalStorageAccountOption = $false
            }
        }

        # SQL cases

        elseif ($ObjectType -eq "AzureWorkloadSQLRestoreRequest") {
			$restoreRequest = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.AzureWorkloadSqlRestoreRequest]::new()
			
            if (($RecoveryType -eq "AlternateLocation") -and (-not $RecoveryMode)) {
				Write-Debug "SQL alternate"
            
				$restoreRequest.ObjectType = $ObjectType
				$restoreRequest.RecoveryType = $RecoveryType
                $restoreRequest.ShouldUseAlternateTargetLocation = $true
                
                $restoreRequest.TargetInfo.ContainerId = $TargetContainerId
                $restoreRequest.TargetInfo.DatabaseName = $DatabaseName
                $restoreRequest.TargetInfo.OverwriteOption = $OverwriteOption
                $restoreRequest.TargetVirtualMachineId = $TargetVirtualMachineId
				
                $restoreRequest.IsNonRecoverable = $NonRecoverable
				$restoreRequest.SourceResourceId = $SourceResourceId

                $restoreRequest.AlternateDirectoryPath = @()
                
                $DataDirectoryMapping = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.SqlDataDirectoryMapping]::new()
                $DataDirectoryMapping.MappingType = "Data"
                $DataDirectoryMapping.SourceLogicalName = $DataSourceLogicalName
                $DataDirectoryMapping.SourcePath = $DataSourcePath
                $DataDirectoryMapping.TargetPath = $DataTargetPath
                $restoreRequest.AlternateDirectoryPath += $DataDirectoryMapping

                $LogDirectoryMapping = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.SqlDataDirectoryMapping]::new()
                $LogDirectoryMapping.MappingType = "Log"
				$LogDirectoryMapping.SourceLogicalName = $LogSourceLogicalName
				$LogDirectoryMapping.SourcePath = $LogSourcePath
				$LogDirectoryMapping.TargetPath = $LogTargetPath
				$restoreRequest.AlternateDirectoryPath += $LogDirectoryMapping
            }
            elseif ($RecoveryType -eq "OriginalLocation") {
                Write-Debug "SQL original"

                $restoreRequest.ObjectType = $ObjectType
                $restoreRequest.RecoveryType = $RecoveryType
                $restoreRequest.ShouldUseAlternateTargetLocation = $true
                $restoreRequest.IsNonRecoverable = $NonRecoverable
            }
            elseif (($RecoveryType -eq "AlternateLocation") -and ($RecoveryMode -eq "FileRecovery")) {
				Write-Debug "SQL restore as files"
				
                $restoreRequest.ObjectType = $ObjectType
				$restoreRequest.RecoveryType = $RecoveryType
                $restoreRequest.RecoveryMode = $RecoveryMode

                $restoreRequest.TargetInfo.ContainerId = $TargetContainerId
                $restoreRequest.TargetInfo.TargetDirectoryForFileRestore = $TargetDirectory
                $restoreRequest.TargetVirtualMachineId = $TargetVirtualMachineId
				$restoreRequest.SourceResourceId = $SourceResourceId
			}
        }

        # PointInTime cases

        if ($ObjectType -eq "AzureWorkloadSAPHanaPointInTimeRestoreRequest") {
			$restoreRequest = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20210210.AzureWorkloadSapHanaPointInTimeRestoreRequest]::new()
		}
        elseif ($ObjectType -eq "AzureWorkloadSQLPointInTimeRestoreRequest") {
            $restoreRequest = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20210210.AzureWorkloadSqlPointInTimeRestoreRequest]::new()
        }

        # Rehydrate cases

        if ($ObjectType -eq "AzureWorkloadSAPHanaRestoreWithRehydrateRequest") {
            $restoreRequest = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20230201.AzureWorkloadSapHanaRestoreWithRehydrateRequest]::new()
        }
        elseif ($ObjectType -eq "IaasVMRestoreWithRehydrationRequest") {
            $restoreRequest = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20210210.IaasVMRestoreWithRehydrationRequest]::new()
        }
        elseif ($ObjectType -eq "AzureWorkloadSQLRestoreWithRehydrateRequest") {
			$restoreRequest = [Microsoft.Azure.PowerShell.Cmdlets.RecoveryServices.Models.Api20210210.AzureWorkloadSqlRestoreWithRehydrateRequest]::new()
		}

        $restoreRequest
    }
}