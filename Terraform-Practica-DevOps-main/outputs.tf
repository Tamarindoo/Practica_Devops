output "resource_group" {
  description = "Resource group creado"
  value       = azurerm_resource_group.rg.name
}

output "function_app_name" {
  description = "Nombre de la Function App"
  value       = azurerm_linux_function_app.func.name
}

output "function_app_url" {
  description = "URL pública de la Function App"
  value       = "https://${azurerm_linux_function_app.func.default_hostname}"
}
