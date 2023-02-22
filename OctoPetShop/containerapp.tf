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
  name                       = "${var.name}-aca"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  depends_on = [
    azurerm_log_analytics_workspace.law
  ]
}


 resource "azurerm_container_app" "aca_web" {
   name                         = "${var.name}-web"
   container_app_environment_id = azurerm_container_app_environment.aca_env.id
   resource_group_name          = azurerm_resource_group.rg.name
   revision_mode                = "Single"

   template {
     #max_replicas = 10
     #min_replicas = 0
     container {
       name   = "octopetshopweb"
       image  = "docker.io/leandroscar/octopetshopweb:latest"
       cpu    = 0.25
       memory = "0.5Gi"
     }
   }

  ingress {
    allow_insecure_connections = false
    target_port      = "5000"
    external_enabled = true
    transport        = "auto"
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  depends_on = [
    azurerm_container_app_environment.aca_env
  ]
  

  timeouts {
   create = "5m"
  }

}

 resource "azurerm_container_app" "aca_scs" {
   name                         = "${var.name}-shoppingcartservice"
   container_app_environment_id = azurerm_container_app_environment.aca_env.id
   resource_group_name          = azurerm_resource_group.rg.name
   revision_mode                = "Single"

   template {
     #max_replicas = 10
     #min_replicas = 0
     container {
       name   = "octopetshopshoppingcartservice"
       image  = "docker.io/leandroscar/octopetshopshoppingcartservice:latest"
       cpu    = 0.25
       memory = "0.5Gi"
     }
   }

  #ingress {
  #  allow_insecure_connections = false
  #  target_port      = "3001"
  #  external_enabled = true
  #  transport        = "auto"
  #  traffic_weight {
  #    latest_revision = true
  #    percentage      = 100
  #  }
  #}

  depends_on = [
    azurerm_container_app_environment.aca_env
  ]
  

  timeouts {
   create = "5m"
  }

}


 resource "azurerm_container_app" "aca_ps" {
   name                         = "${var.name}-productservice"
   container_app_environment_id = azurerm_container_app_environment.aca_env.id
   resource_group_name          = azurerm_resource_group.rg.name
   revision_mode                = "Single"

   template {
     #max_replicas = 10
     #min_replicas = 0
     container {
       name   = "octopetshopproductservice"
       image  = "docker.io/leandroscar/octopetshopproductservice:latest"
       cpu    = 0.25
       memory = "0.5Gi"
     }
   }

  #ingress {
    #allow_insecure_connections = false
    #target_port      = "5011"
    #external_enabled = true
    #transport        = "auto"
    #traffic_weight {
    #  latest_revision = true
    #  percentage      = 100
    #}
  #}

  depends_on = [
    azurerm_container_app_environment.aca_env
  ]
  

  timeouts {
   create = "5m"
  }

}

 resource "azurerm_container_app" "aca_db" {
   name                         = "${var.name}-octopetshopdatabase"
   container_app_environment_id = azurerm_container_app_environment.aca_env.id
   resource_group_name          = azurerm_resource_group.rg.name
   revision_mode                = "Single"

   template {
     #max_replicas = 10
     #min_replicas = 0
     container {
       name   = "octopetshopdatabase"
       image  = "docker.io/leandroscar/octopetshopdatabase:latest"
       cpu    = 0.25
       memory = "0.5Gi"
     }
   }

  #ingress {
  #  allow_insecure_connections = false
  #  target_port      = "3001"
  #  external_enabled = true
  #  transport        = "auto"
  #  traffic_weight {
  #    latest_revision = true
  #    percentage      = 100
  #  }
  #}

  depends_on = [
    azurerm_container_app_environment.aca_env
  ]
  

  timeouts {
   create = "5m"
  }

}

