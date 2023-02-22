resource "azurerm_resource_group" "rg" {
  name     = "${var.name}-rg"
  location = var.location
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.name}-law"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = var.law_sku
  retention_in_days   = 30
  depends_on = [
    azurerm_resource_group.rg
  ]
}

resource "azurerm_container_app_environment" "aca_env" {
  name                       = "${var.name}-env"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  depends_on = [
    azurerm_log_analytics_workspace.law
  ]
}

resource "azurerm_container_app" "aca_gitea" {
  name                         = "${var.name}-gitea"
  container_app_environment_id = azurerm_container_app_environment.aca_env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  template {
    #max_replicas = 10
    #min_replicas = 0
    container {
      name   = "gitea"
      image  = "docker.io/gitea/gitea:latest"
      cpu    = 1.0
      memory = "2Gi"
      env {
        name  = "DB_HOST"
        value = azurerm_postgresql_server.postgresql_server.fqdn
      }
      env {
        name  = "DB_USER"
        value = "${azurerm_postgresql_server.postgresql_server.administrator_login}@${azurerm_postgresql_server.postgresql_server.name}"
      }
      env {
        name        = "DB_PASSWD"
        value       = azurerm_postgresql_server.postgresql_server.administrator_login_password
        secret_name = "dbpassword"
      }
      env {
        name  = "DB_NAME"
        value = azurerm_postgresql_database.postgresql_database.name
      }
      env {
        name  = "DB_TYPE"
        value = "postgres"
      }
    }
  }
  secret {
    name  = "dbpassword"
    value = azurerm_postgresql_server.postgresql_server.administrator_login_password
  }

  ingress {
    allow_insecure_connections = false
    target_port                = "3000"
    external_enabled           = true
    transport                  = "auto"
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  depends_on = [
    azurerm_container_app_environment.aca_env,
    azurerm_postgresql_database.postgresql_database
  ]
}
