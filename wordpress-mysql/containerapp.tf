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

resource "azurerm_container_app" "aca_wordpress" {
  name                         = "${var.name}-wordpress"
  container_app_environment_id = azurerm_container_app_environment.aca_env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  template {
    #max_replicas = 10
    #min_replicas = 0
    container {
      name   = "wordpress"
      image  = "docker.io/wordpress:latest"
      cpu    = 1.0
      memory = "2Gi"
      env {
        name  = "WORDPRESS_DB_HOST"
        value = azurerm_mariadb_server.mariadb-server.fqdn
      }
      env {
        name  = "WORDPRESS_DB_USER"
        value = azurerm_mariadb_server.mariadb-server.administrator_login
      }
      env {
        name  = "WORDPRESS_DB_PASSWORD"
        value = azurerm_mariadb_server.mariadb-server.administrator_login_password
        secret_name = "wordpressdbpassword"
      }
      env {
        name  = "WORDPRESS_DB_NAME"
        value = azurerm_mariadb_database.mariadb-db.name
      }
    }
  }
  secret {
    name = "wordpressdbpassword"
    value = azurerm_mariadb_server.mariadb-server.administrator_login_password
  }

  ingress {
    allow_insecure_connections = false
    target_port                = "80"
    external_enabled           = true
    transport                  = "auto"
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  depends_on = [
    azurerm_container_app_environment.aca_env,
    azurerm_mariadb_database.mariadb-db
  ]
}
