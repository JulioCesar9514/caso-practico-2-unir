# Caso Práctico 2 – Despliegue Automatizado (UNIR)

Este proyecto implementa un **despliegue completo y automatizado** de una aplicación en Azure utilizando:

- Terraform (infraestructura)
- ACR + Podman (contenedorización)
- Ansible (configuración y despliegue)
- Bash (automatización total)

El objetivo es que **cualquier usuario pueda desplegar toda la solución con un único comando**, sin editar archivos ni configurar nada manualmente.

---

## ¿Qué hace el script `deployCompleto.sh`?

`deployCompleto.sh` es un script de automatización **end‑to‑end** que:

1. **Comprueba Azure CLI**  
   Verifica que Azure CLI está instalado.

2. **Comprueba si hay sesión activa en Azure**  
   Si no la hay, muestra un mensaje claro y lanza `az login --use-device-code`.

3. **Genera automáticamente `terraform.tfvars`**  
   Usa la suscripción del usuario que ejecuta el script.  
   No requiere editar nada.

4. **Destruye la infraestructura existente**  
   Ejecuta `terraform destroy` y espera a que Azure elimine el Resource Group.

5. **Crea toda la infraestructura desde cero**  
   Ejecuta `terraform apply` para desplegar:
   - Resource Group  
   - VNet  
   - NSG  
   - VM  
   - ACR  
   - IP pública  

6. **Construye y sube la imagen al ACR**  
   Llama al script `buildPush.sh`.

7. **Ejecuta Ansible**  
   Configura Podman, hace login en ACR y despliega el contenedor como servicio systemd.

8. **Muestra la URL final de acceso**  
   Incluye la IP pública y el puerto HTTPS.

9. **Genera un archivo de log completo**  
   Todo el proceso queda registrado en `logs/`.

---

## Requisitos

- Azure CLI instalado  
- Terraform instalado  
- Ansible instalado  
- Claves SSH generadas en `~/.ssh/id_rsa.pub`  
- Permisos en la suscripción de Azure

---

## Ejecución

Clonar el repositorio:

```text
git clone <URL_DEL_REPO>
cd caso-practico-2-unir
./deployCompleto.sh
```

Si no hay sesión activa en Azure, el script mostrará:  
- Un enlace para abrir en el navegador  
- Un código para introducir  
- Un mensaje claro indicando que el script continuará automáticamente  

## Validación

Al finalizar, el script mostrará:

- La URL de acceso HTTPS
- La IP pública de la VM
- La ruta del archivo de log generado

Abrir en el navegador:

```text
https://<IP_PUBLICA>:8443
Introducir usuario y contraseña de la aplicación.
```

## Estructura del proyecto
```text
.
├── ansible/  
│   ├── deploy.yml  
│   ├── hosts.ini  
│   └── templates/  
│       └── web.service.j2
├── scripts/
│   └── buildPush.sh
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── terraform.tfvars (generado automáticamente)
├── logs/
│   └── deploy_YYYYMMDD_HHMMSS.log
└── deployCompleto.sh
```

## Notas
```text
El script está diseñado para ser 100% reproducible.
No requiere editar archivos.
Funciona en WSL, Linux, Windows y macOS.
Se puede desplegar todo con un único comando.
```

## Autor
Julio Cesar
UNIR – DevOps & Cloud