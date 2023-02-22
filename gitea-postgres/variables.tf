variable "location" {
  type        = string
  description = "Location"
  default     = "westeurope"
}

variable "name" {
  type        = string
  description = "Azure Container App name"
  default     = "aca8"
}

variable "law_sku" {
  type        = string
  description = "Log Analytics Workspace SKU"
  default     = "PerGB2018"
}

variable "administrator_login" {
  type        = string
  description = "postgresql username"
  default     = ""
}

variable "administrator_login_password" {
  type        = string
  description = "postgresql username"
  default     = ""
  sensitive   = true
}