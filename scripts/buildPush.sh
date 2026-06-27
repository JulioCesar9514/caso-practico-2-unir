#!/bin/bash

# Cargar variables del ACR desde group_vars
ACR_LOGIN_SERVER=$(grep acr_login_server ansible/group_vars/all.yml | awk '{print $2}' | tr -d '"')
ACR_USERNAME=$(grep acr_username ansible/group_vars/all.yml | awk '{print $2}' | tr -d '"')
ACR_PASSWORD=$(grep acr_password ansible/group_vars/all.yml | awk '{print $2}' | tr -d '"')

IMAGE_NAME="web-nginx"
IMAGE_TAG="casopractico2"

echo "Construyendo imagen local..."
podman build -t localhost/$IMAGE_NAME:$IMAGE_TAG ./web

echo "Login en ACR..."
podman login $ACR_LOGIN_SERVER -u $ACR_USERNAME -p $ACR_PASSWORD

echo "Etiquetando imagen..."
podman tag localhost/$IMAGE_NAME:$IMAGE_TAG $ACR_LOGIN_SERVER/$IMAGE_NAME:$IMAGE_TAG

echo "Subiendo imagen al ACR..."
podman push $ACR_LOGIN_SERVER/$IMAGE_NAME:$IMAGE_TAG

echo "Verificando repositorios..."
az acr repository list --name $(echo $ACR_LOGIN_SERVER | cut -d'.' -f1) -o table
