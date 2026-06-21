# Definicion de variables para el despliegue en Azure
# En terraform.tfvars declaramos los datos sensible no sube a GtitHub

# ID de suscripcion de Azure
variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

# Ubicacion geografica donde se desplegaran los recursos
variable "location" {
  type        = string
  default     = "swedencentral"
}

# Nombre del grupo de recursos donde se desplegaran los recursos
variable "resource_group_name" {
  type        = string
  default     = "rg-casopractico2"
}
