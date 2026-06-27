# Caso Practico 2 – Despliegue Automatizado (UNIR)

Este proyecto implementa un **despliegue completo y automatizado** de una aplicacion en Azure utilizando:

- Terraform (infraestructura)
- ACR + Podman (contenedorizacion)
- Ansible (configuracion y despliegue)
- Bash (automatizacion total)

El objetivo es que **cualquier usuario pueda desplegar toda la solucion con un unico comando**, sin editar archivos ni configurar nada manualmente.

---

## ¿Que hace el script `deployCompleto.sh`?

`deployCompleto.sh` es un script de automatizacion **end‑to‑end** que:

1. **Comprueba Azure CLI**  
   Verifica que Azure CLI esta instalado.

2. **Comprueba si hay sesion activa en Azure**  
   Si no la hay, muestra un mensaje claro y lanza `az login --use-device-code`.

3. **Genera automaticamente `terraform.tfvars`**  
   Usa la suscripcion del usuario que ejecuta el script.  
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
   - IP publica  

6. **Construye y sube la imagen al ACR**  
   Llama al script `buildPush.sh`.

7. **Ejecuta Ansible**  
   Configura Podman, hace login en ACR y despliega el contenedor como servicio systemd.

8. **Muestra la URL final de acceso**  
   Incluye la IP publica y el puerto HTTPS.

9. **Genera un archivo de log completo**  
   Todo el proceso queda registrado en `logs/`.

---

## Requisitos

- Azure CLI instalado  
- Terraform instalado  
- Ansible instalado  
- Claves SSH generadas en `~/.ssh/id_rsa.pub`  
- Permisos en la suscripcion de Azure

---

## Ejecucion

Clonar el repositorio:

```text
git clone <URL_DEL_REPO>
cd caso-practico-2-unir
./deployCompleto.sh
```

Si no hay sesion activa en Azure, el script mostrara:  
- Un enlace para abrir en el navegador  
- Un codigo para introducir  
- Un mensaje claro indicando que el script continuara automaticamente  

## Validacion

Al finalizar, el script mostrara:

- La URL de acceso HTTPS
- La IP publica de la VM
- La ruta del archivo de log generado

Abrir en el navegador:

```text
https://<IP_PUBLICA>:8443
Introducir usuario y contraseña de la aplicacion.
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
│   └── terraform.tfvars (generado automaticamente)
├── logs/
│   └── deploy_YYYYMMDD_HHMMSS.log
└── deployCompleto.sh
```

## Notas
```text
El script esta diseñado para ser 100% reproducible.
No requiere editar archivos.
Funciona en WSL, Linux, Windows y macOS.
Se puede desplegar todo con un unico comando.
```

## Autor
Julio Cesar
UNIR – DevOps & Cloud