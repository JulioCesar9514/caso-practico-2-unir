#!/bin/bash

set -e  # Detener el script si ocurre un error

RESOURCE_GROUP="rg-casopractico2"

# Crear carpeta de logs si no existe
mkdir -p logs

# Crear nombre de archivo de log con fecha y hora
LOGFILE="logs/deploy_$(date +%Y%m%d_%H%M%S).log"

# Redirigir toda la salida a pantalla + archivo de log
exec > >(tee -a "$LOGFILE") 2>&1

echo "────────────────────────────────────────────────────"
echo "   DESPLIEGUE COMPLETO - CASO PRaCTICO 2 (UNIR)"
echo "   Fecha: $(date)"
echo "   Log: $LOGFILE"
echo "────────────────────────────────────────────────────"

echo ""
echo "─── Comprobando Azure CLI ───"

if ! command -v az >/dev/null 2>&1; then
    echo "ERROR: Azure CLI no esta instalado."
    echo "Instalalo desde:"
    echo "https://learn.microsoft.com/cli/azure/install-azure-cli"
    exit 1
fi

echo ""
echo "─── Comprobando sesion activa en Azure ───"

SUBSCRIPTION_ID=$(az account show --query id -o tsv 2>/dev/null || true)

if [ -z "$SUBSCRIPTION_ID" ]; then
    echo "No se ha detectado ninguna sesion de Azure."
    echo "Iniciando sesion..."

    echo ""
    echo "───────────────────────────────────────────────────────────────"
    echo "─── Iniciando sesion en Azure ───"
    echo "Se requiere autenticacion para continuar."
    echo "Por favor abre este enlace en tu navegador:"
    echo "Cuando Azure CLI muestre un codigo en pantalla,"
    echo "introduce ese codigo en la web."
    echo ""
    echo "El script continuara automaticamente cuando completes el login."
    echo ""
    echo "───────────────────────────────────────────────────────────────"

    # Azure CLI imprimira su mensaje feo aqui (no se puede evitar)
    az login --use-device-code

    # Esperar a que el login se complete
    while ! az account show >/dev/null 2>&1; do
        sleep 1
    done

    SUBSCRIPTION_ID=$(az account show --query id -o tsv)
fi

echo "Sesion activa detectada."
echo "Suscripcion: $SUBSCRIPTION_ID"

echo ""
echo "─── Generando terraform.tfvars ───"

cat > terraform/terraform.tfvars <<EOF
subscription_id       = "$SUBSCRIPTION_ID"
location              = "swedencentral"
resource_group_name   = "rg-casopractico2"

vm_name               = "cp2-vm"
vm_size               = "Standard_B2ats_v2"
vm_admin_username     = "azureuser"
ssh_public_key_path   = "~/.ssh/id_rsa.pub"
EOF

echo "Archivo terraform.tfvars generado correctamente."

echo ""
echo "─── 1. Destruyendo infraestructura con Terraform ───"
cd terraform
terraform destroy -auto-approve || true

echo ""
echo "─── Esperando a que Azure elimine el Resource Group ───"
while az group exists --name "$RESOURCE_GROUP" | grep -q true; do
    echo "Resource Group aun existe... esperando 5 segundos"
    sleep 5
done
echo "Resource Group eliminado correctamente."

echo ""
echo "─── 2. Creando infraestructura con Terraform ───"
terraform apply -auto-approve

echo ""
echo "─── 3. Obteniendo datos del ACR y la VM ───"
ACR_LOGIN_SERVER=$(terraform output -raw acr_login_server)
VM_IP=$(terraform output -raw vm_public_ip)

cd ..

echo ""
echo "─── 4. Construyendo y subiendo imagen al ACR ───"
./scripts/buildPush.sh

echo ""
echo "─── 5. Ejecutando Ansible ───"
cd ansible
ansible-playbook -i hosts.ini deploy.yml

cd ..

echo ""
echo "────────────────────────────────────────────────────"
echo "   DESPLIEGUE COMPLETADO CORRECTAMENTE"
echo "────────────────────────────────────────────────────"
echo "Accede a la web en:"
echo "https://$VM_IP:8443"
echo ""
echo "Introduce usuario y contraseña para validar."
echo "Usuario: uniradmin"
echo "Contraseña: password123"
echo ""
echo "Log completo guardado en:"
echo "$LOGFILE"
echo "────────────────────────────────────────────────────"