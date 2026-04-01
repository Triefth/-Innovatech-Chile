# 1. Configuración del Proveedor (AWS)
provider "aws" {
  region = "us-east-1" # Región típica de AWS Academy, cámbiala si usas otra
}

# 2. Creación de la VPC Base (10.0.0.0/16)
resource "aws_vpc" "innovatech_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "VPC-Innovatech"
  }
}

# 3. Subred Pública para tu Frontend
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.innovatech_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true # Esto le da la IP pública automáticamente

  tags = {
    Name = "Subred-Publica-Front"
  }
}

# 4. Internet Gateway y Tabla de Rutas (Para que el Front salga a Internet)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.innovatech_vpc.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.innovatech_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# 5. Security Group del Frontend
resource "aws_security_group" "sg_front" {
  name        = "SG_Frontend"
  description = "Permite HTTP y SSH"
  vpc_id      = aws_vpc.innovatech_vpc.id

  # Regla de entrada: HTTP desde cualquier lugar
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regla de entrada: SSH (Lo ideal es tu IP, pero para la prueba dejamos abierto)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regla de salida: Permitir todo
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# 6. Buscar la última imagen de Amazon Linux 2023
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# 7. ¡La Instancia EC2 del Frontend!
resource "aws_instance" "frontend" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  
  # CAMBIO 1: Usar vpc_security_group_ids (es lo correcto para VPC)
  vpc_security_group_ids = [aws_security_group.sg_front.id]
  
  # CAMBIO 2: La llave obligatoria de AWS Academy
  key_name      = "vockey"

  # CAMBIO 3: El perfil de IAM para Session Manager
  iam_instance_profile = "LabInstanceProfile"

  user_data = file("frontend-userdata.sh")

  tags = {
    Name = "Frontend-Innovatech"
  }
}

# 8. Outputs (Para que te de los datos al terminar)
output "ip_publica_frontend" {
  value = aws_instance.frontend.public_ip
}
output "vpc_id_para_el_backend" {
  value = aws_vpc.innovatech_vpc.id
}
output "sg_frontend_id_para_el_backend" {
  value = aws_security_group.sg_front.id
}