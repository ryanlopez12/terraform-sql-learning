resource "random_pet" "flex-postgres-server" {
  prefix = var.name_prefix
}

resource "azurerm_resource_group" "postgres-group" {
  name     = random_pet.flex-postgres-server.id
  location = var.location
}

resource "azurerm_virtual_network" "postgres-group" {
  name                = "${var.name_prefix}-vnet"
  location            = azurerm_resource_group.postgres-group.location
  resource_group_name = azurerm_resource_group.postgres-group.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_network_security_group" "postgres-group" {
  name                = "${var.name_prefix}-nsg"
  location            = azurerm_resource_group.postgres-group.location
  resource_group_name = azurerm_resource_group.postgres-group.name

  security_rule {
    name                       = "demo123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet" "postgres-group" {
  name                 = "${var.name_prefix}-subnet"
  virtual_network_name = azurerm_virtual_network.postgres-group.name
  resource_group_name  = azurerm_resource_group.postgres-group.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Storage"]

  delegation {
    name = "fs"

    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"

      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "postgres-group" {
  subnet_id                 = azurerm_subnet.postgres-group.id
  network_security_group_id = azurerm_network_security_group.postgres-group.id
}

resource "azurerm_private_dns_zone" "postgres-group" {
  name                = "${var.name_prefix}-pdz.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.postgres-group.name

  depends_on = [azurerm_subnet_network_security_group_association.postgres-group]
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres-group" {
  name                  = "${var.name_prefix}-pdzvnetlink.com"
  private_dns_zone_name = azurerm_private_dns_zone.postgres-group.name
  virtual_network_id    = azurerm_virtual_network.postgres-group.id
  resource_group_name   = azurerm_resource_group.postgres-group.name
}

resource "azurerm_postgresql_flexible_server" "postgres-group" {
  name                   = "${var.name_prefix}-server"
  resource_group_name    = azurerm_resource_group.postgres-group.name
  location               = azurerm_resource_group.postgres-group.location
  version                = "13"
  delegated_subnet_id    = azurerm_subnet.postgres-group.id
  private_dns_zone_id    = azurerm_private_dns_zone.postgres-group.id
  administrator_login    = "adminTerraform"
  administrator_password = "QAZwsx123"
  zone                   = "1"
  storage_mb             = 32768
  sku_name               = "GP_Standard_D2s_v3"
  backup_retention_days  = 7

  depends_on = [azurerm_private_dns_zone_virtual_network_link.postgres-group]
}
