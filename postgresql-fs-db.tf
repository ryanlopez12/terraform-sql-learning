resource "azurerm_postgresql_flexible_server_database" "postgres-group" {
  name      = "${var.name_prefix}-db"
  server_id = azurerm_postgresql_flexible_server.postgres-group.id
  collation = "en_US.UTF8"
  charset   = "UTF8"
}