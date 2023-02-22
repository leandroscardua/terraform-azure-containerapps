variable "location" {
  type        = string
  description = "Location"
  default     = "westeurope"
}

variable "name" {
  type        = string
  description = "Azure Container App name"
  default     = "octopet"
}

variable "law_sku" {
  type        = string
  description = "Log Analytics Workspace SKU"
  default     = "PerGB2018"
}
