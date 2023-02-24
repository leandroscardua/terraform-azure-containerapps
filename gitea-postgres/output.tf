output "Resource_Group_Name" {
  value = azurerm_resource_group.rg.name
}

output "Log_Analytics_Workspace_Name" {
  value = azurerm_log_analytics_workspace.law.name
}

output "Container_App_Environment_Name" {
  value = azurerm_container_app_environment.aca_env.name
}

output "Container_App_Name_Wordpress" {
  value = azurerm_container_app.aca_gitea.name
}

output "Container_App_Name_url_wordpress" {
  value = azurerm_container_app.aca_gitea.ingress.*.fqdn
}

output "outbound_ip_addresses" {
  value = azurerm_container_app.aca_gitea.outbound_ip_addresses[0]
}
