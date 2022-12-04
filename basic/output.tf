output "Resource_Group_Name" {
    value = azurerm_resource_group.rg.name
}

output "Log_Analytics_Workspace_Name" {
    value = azurerm_log_analytics_workspace.law.name
}

output "Container_App_Name" {
    value = azapi_resource.aca.name
}

output "Container_App_Environment_Name" {
    value = azapi_resource.aca_env.name
}
