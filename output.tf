output "resource_group_name" {
  value = azurerm_resource_group.postgres-group.name
}

output "azurerm_postgresql_flexible_server" {
  value = azurerm_postgresql_flexible_server.postgres-group.name
}

output "postgresql_flexible_server_database_name" {
  value = azurerm_postgresql_flexible_server_database.postgres-group.name
}