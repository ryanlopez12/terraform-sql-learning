# terraform-sql-learning

Testing deploying a flexible postgres server for purpose of being a center point of multiple resources.

receiving error:

Error: Provider produced inconsistent result after apply

When applying changes to azurerm_network_security_group.postgres-group, provider
│ "provider[\"registry.terraform.io/hashicorp/azurerm\"]" produced an unexpected new value: Root resource was present, but  
│ now absent.

 This is a bug in the provider, which should be reported in the provider's own issue tracker.
╵
Error: waiting for provisioning state of Virtual Network: (Name "postgresqlfs-vnet" / Resource Group "postgresqlfs-amused-tuna"): polling for Virtual Network: (Name "postgresqlfs-vnet" / Resource Group "postgresqlfs-amused-tuna"): network.VirtualNetworksClient#Get: Failure responding to request: StatusCode=404 -- Original Error: autorest/azure: Service returned an error. Status=404 Code="ResourceNotFound" Message="The Resource 'Microsoft.Network/virtualNetworks/postgresqlfs-vnet' under resource group 'postgresqlfs-amused-tuna' was not found. For more details please go to https://aka.ms/ARMResourceNotFoundFix"

 with azurerm_virtual_network.postgres-group,
│   on main.tf line 10, in resource "azurerm_virtual_network" "postgres-group":
│   10: resource "azurerm_virtual_network" "postgres-group" {

## tried updating to most recent version of Terraform and error still persists, documentation read that bug was fixed from previous versions
