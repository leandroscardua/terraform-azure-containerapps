variable "location" {
  type        = string
  description = "Location"
  default     = "westeurope"
}

variable "name" {
  type        = string
  description = "Azure Container App name"
  default     = "aca"
}

#variable "aca_sku" {
#  type        = string
#  description = "Azure Container App SKU"
#  default     = "Consumption"
#}

#variable "azapi_version" {
#  type        = string
#  description = "Azure API version"
#  default     = "2022-06-01-preview"
#}

#variable "identity" {
#  type        = string
#  description = "Azure Container App identity"
#  default     = "SystemAssigned"
#

variable "law_sku" {
  type        = string
  description = "Log Analytics Workspace SKU"
  default     = "PerGB2018"
}
