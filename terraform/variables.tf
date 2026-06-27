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

######################## Maquina virtual ########################
# Variables para la VM
variable "vm_name" {
  type        = string
  default     = "cp2-vm"
  description = "Nombre de la maquina virtual"
}

variable "vm_size" {
  type        = string
  default     = "Standard_B2ats_v2"
  description = "Tamaño de la VM free tier, AMD64"
}

variable "vm_admin_username" {
  type        = string
  default     = "azureuser"
  description = "Usuario administrador de la VM"
}

variable "ssh_public_key_path" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  description = "Ruta a la clave publica SSH"
}
