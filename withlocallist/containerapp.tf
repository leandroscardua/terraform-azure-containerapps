resource "azurerm_resource_group" "rg" {
  name     = "${var.name}-rg"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.name}-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  #dns_servers         = ["10.0.0.4", "10.0.0.5"]

  depends_on = [azurerm_resource_group.rg]
}



resource "azurerm_subnet" "subnet" {
  name                 = "${var.name}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/21"]

  depends_on = [azurerm_virtual_network.vnet]
}


resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.name}-law"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = var.law_sku
  retention_in_days   = 30
  depends_on = [
    azurerm_subnet.subnet
  ]
}

resource "azurerm_container_app_environment" "aca_env" {
  name                           = "${var.name}-aca"
  location                       = azurerm_resource_group.rg.location
  resource_group_name            = azurerm_resource_group.rg.name
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.law.id
  infrastructure_subnet_id       = azurerm_subnet.subnet.id
  internal_load_balancer_enabled = true


  depends_on = [
    azurerm_log_analytics_workspace.law
  ]
}


resource "azurerm_container_app" "aca" {
  for_each                     = local.apps
  name                         = each.key
  container_app_environment_id = azurerm_container_app_environment.aca_env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  template {
    max_replicas = each.value.maxReplicas
    min_replicas = each.value.minReplicas
    container {
      name   = each.value.imagename
      image  = each.value.image
      cpu    = each.value.cpu
      memory = each.value.memory
    }
  }

  ingress {
    allow_insecure_connections = false
    target_port                = each.value.targetPort
    external_enabled           = true
    transport                  = "auto"
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
