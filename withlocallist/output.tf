output "Resource_Group_Name" {
  value = azurerm_resource_group.rg.name
}

output "Log_Analytics_Workspace_Name" {
  value = azurerm_log_analytics_workspace.law.name
}

output "Container_App_Name" {
  value = azurerm_container_app.aca.name
}

output "Container_App_Environment_Name" {
  value = azurerm_container_app_environment.aca_env.name
}

output "Container_App_Name1" {
  value = azurerm_container_app.aca.ingress.*.fqdn
}