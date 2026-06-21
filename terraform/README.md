# Documentacion despliegue de infraestructura en Azure

El despliegue de la infraestructura inicial del Caso Práctico 2 del curso de DevOps & Cloud Computing (UNIR).
Aquí se define, mediante Terraform, la creación de:

Un Resource Group  
Un Azure Container Registry (ACR)  
Variables y outputs necesarios  
.gitignore para proteger datos sensibles  

## Recursos desplegados

### Resource Group
***main.tf***

Crea el grupo de recursos donde se desplegará toda la infraestructura del proyecto.

### Azure Container Registry (ACR)
***acr.tf***

Registro de contenedores donde se subirán las imágenes generadas con Podman.

### Variables
***variables.tf***

Define las variables necesarias para parametrizar la infraestructura:

`subscription_id`  
`location`  
`resource_group_name`  

Los valores propios se almacenan en terraform.tfvars -> no se sube a GitHub.

### Archivo terraform.tfvars -> no se sube a GitHub.
Ejemplo de contenido:

`subscription_id      = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"`  
`location             = "swedencentral"`  
`resource_group_name  = "rg-casopractico2"`  

Este archivo contiene datos sensibles y debe estar excluido del repositorio.

### Outputs
***outputs.tf***

Terraform mostrará estos valores tras el apply:

`acr_login_server`  
`acr_admin_username (sensible)`  
`acr_admin_password (sensible)`  

Se usarán para, Login en ACR

## Construccion y subida de imagenes

### Comandos básicos
Inicializar Terraform  
terraform init

Ver el plan de ejecución  
terraform plan

Crear la infraestructura  
terraform apply

Destruir la infraestructura  
terraform destroy

## Seguridad y .gitignore
El .gitignore evita subir archivos sensibles:

***terraform.tfvars***  

*.tfstate  
*.tfstate.backup  
.terraform/  
.terraform.lock.hcl  
.terraform.tfstate.lock.info  