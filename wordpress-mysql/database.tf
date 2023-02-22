resource "azurerm_mariadb_server" "mariadb-server" {
  name                = "${var.name}-mariadb-svr"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku_name = "B_Gen5_2"

  storage_mb                   = 51200
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  version                      = "10.3"
  ssl_enforcement_enabled      = false

  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_mariadb_database" "mariadb-db" {
  name                = "wordpress"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mariadb_server.mariadb-server.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_520_ci"

  depends_on = [
    azurerm_mariadb_server.mariadb-server
  ]
}

resource "azurerm_mariadb_firewall_rule" "mariadb-firewall" {
  name                = "AllowAccesstoAzureServices"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_mariadb_server.mariadb-server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}