resource "azurerm_resource_group" "rg-db" {
  name     = "${var.name}-rg-db"
  location = var.location
}


resource "azurerm_postgresql_server" "postgresql_server" {
  name                = "${var.name}-postgresql-svr"
  location            = azurerm_resource_group.rg-db.location
  resource_group_name = azurerm_resource_group.rg-db.name

  sku_name = "B_Gen5_2"

  storage_mb                   = 51200
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  version                      = "11"
  ssl_enforcement_enabled      = false
  ssl_minimal_tls_version_enforced = "TLSEnforcementDisabled"


  depends_on = [
    azurerm_resource_group.rg-db
  ]
}

resource "azurerm_postgresql_database" "postgresql_database" {
  name                = "gitea"
  resource_group_name = azurerm_resource_group.rg-db.name
  server_name         = azurerm_postgresql_server.postgresql_server.name
  charset             = "UTF8"
  collation           = "English_United States.1252"

  depends_on = [
    azurerm_postgresql_server.postgresql_server
  ]
}

resource "azurerm_postgresql_firewall_rule" "postgresql_firewall_rule" {
  name                = "AllowAccesstoAzureServices"
  resource_group_name = azurerm_resource_group.rg-db.name
  server_name         = azurerm_postgresql_server.postgresql_server.name
  start_ip_address    = azurerm_container_app.aca_gitea.outbound_ip_addresses[0]
  end_ip_address      = azurerm_container_app.aca_gitea.outbound_ip_addresses[0]

  depends_on = [
    azurerm_postgresql_database.postgresql_database,
    azurerm_container_app.aca_gitea
  ]
}