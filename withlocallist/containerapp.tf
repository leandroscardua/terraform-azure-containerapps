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


 resource "azurerm_container_app" "aca" {
   count                      = local.apps
   name                         = "${each.key}"
   container_app_environment_id = azurerm_container_app_environment.aca_env.id
   resource_group_name          = azurerm_resource_group.rg.name
   revision_mode                = "Single"

   template {
     #max_replicas = 10
     #min_replicas = 0
     container {
       name   = each.value.imagename
       image  = each.value.image
       cpu    = each.value.cpu
       memory = each.value.memory
     }
   }

  ingress {
    allow_insecure_connections = false
    target_port      = "3001"
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


# resource "azapi_resource" "aca_env" {
#   type      = "Microsoft.App/managedEnvironments@${var.azapi_version}"
#   name      = "${var.name}-acae"
#   parent_id = azurerm_resource_group.rg.id
#   location  = azurerm_resource_group.rg.location

#   body = jsonencode({
#     properties = {
#       appLogsConfiguration = {
#         destination = "log-analytics"
#         logAnalyticsConfiguration = {
#           customerId = azurerm_log_analytics_workspace.law.workspace_id
#           sharedKey  = azurerm_log_analytics_workspace.law.primary_shared_key
#         }
#       }
#       zoneRedundant = false
#     }
#     sku = {
#       name = var.aca_sku
#     }
#   })
#   depends_on = [
#     azurerm_log_analytics_workspace.law
#   ]
# }

# resource "azapi_resource" "aca" {
#   type      = "Microsoft.App/containerApps@${var.azapi_version}"
#   name      = "${var.name}-001"
#   parent_id = azurerm_resource_group.rg.id
#   location  = azurerm_resource_group.rg.location
#   identity {
#     type         = var.identity
#     identity_ids = []
#   }


#   body = jsonencode({
#     properties = {
#       managedEnvironmentId = azapi_resource.aca_env.id
#       configuration = {
#         ingress = {
#           external : true
#           targetPort : 3001
#         },

#       }
#       template = {
#         containers = [
#           {
#             image = "docker.io/louislam/uptime-kuma:latest"
#             name  = "uptime-kuma"
#             resources = {
#               cpu    = 0.25
#               memory = "0.5Gi"
#             }
#           }
#         ]
#         scale = {
#           minReplicas = 1
#           maxReplicas = 1
#         }
#       }
#     }

#   })
#   depends_on = [
#     azapi_resource.aca_env
#   ]
# }
