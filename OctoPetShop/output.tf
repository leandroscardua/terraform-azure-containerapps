output "Resource_Group_Name" {
  value = azurerm_resource_group.rg.name
}

output "Log_Analytics_Workspace_Name" {
  value = azurerm_log_analytics_workspace.law.name
}

output "Container_App_Environment_Name" {
  value = azurerm_container_app_environment.aca_env.name
}

output "Container_App_Name_Web" {
  value = azurerm_container_app.aca_web.name
}

output "Container_App_Name_SCS" {
  value = azurerm_container_app.aca_scs.name
}

output "Container_App_Name_PS" {
  value = azurerm_container_app.aca_ps.name
}

output "Container_App_Name_DB" {
  value = azurerm_container_app.aca_db.name
}


output "Container_App_Name_url_WEB" {
  value = azurerm_container_app.aca_web.ingress.*.fqdn
}