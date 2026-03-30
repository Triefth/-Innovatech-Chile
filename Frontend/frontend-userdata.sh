#!/bin/bash

#1. Actualizaciones de seguridad obligatorias
dnf update -y

#2. Instalar Git y Docker
dnf install git -y
dnf install docker -y

#3. Iniciar Docker
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

#4. Crear los archivos localmente en la EC" (simulando lo que bajaria de git)
cat << 'EOF' > /home/ec2-user/index.html
<!DOCTYPE html>
<html lang = "es">
<head><meta charset="UTF-8"><title>Innovatech Chile - Frontend</title></head>
<body><h1>Bienvenido a Innovatech Chile</h1><p>Esta es la capa Frontend (Pública).</p></body>
</html>
EOF

cat << 'EOF' > /home/ec2-user/Dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
EXPOSE 80
EOF

# 5. Construir y correr el contenedor web
cd /home/ec2-user
docker build -t frontend-innovatech .
docker run -d -p 80:80 --name mi_frontend frontend-innovatech