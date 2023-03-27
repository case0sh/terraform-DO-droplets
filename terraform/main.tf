# Security Group
resource "aws_security_group" "webserver_sg" {
  name = "${var.environment_slug}-webserver-sg"
  description = "WebServer DMZ"
  tags = {
    Name = "${var.environment_slug}-webserver-sg"
  }

  ingress {
    description = "HTTP (80)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH (22)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance
resource "aws_instance" "webserver" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  user_data                   = file("aws-user-data.sh")
  key_name                    = aws_key_pair.ansible_keypair.key_name
  monitoring                  = true
  encrypted                   = true
  associate_public_ip_address = true

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 30
      tags = {
        Name = "my-root-block"
      }
    },
  ]

  vpc_security_group_ids = [ aws_security_group.webserver_sg.id ]
  tags = {
    Name = "${var.environment_slug}-webserver"
  }
}

resource "aws_key_pair" "ansible_keypair" {
  key_name   = "${var.environment_slug}-ansible-key"
  public_key = file(var.ssh_pub_key_file)
}

# Get latest Ubuntu Linux Bionic Beaver
data "aws_ami" "ubuntu-linux-2004" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["ubuntu-minimal/images/hvm-ssd/ubuntu-focal-20.04-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}