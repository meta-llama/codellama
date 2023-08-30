terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "my_instance" {
#  ami           = data.aws_ami.ubuntu.id
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = var.instance_name
  }
  private_dns_name_options {
    enable_resource_name_dns_a_record = true
  }
  user_data = file("mount_ebs_volume.sh")
}

resource "aws_instance" "spot_instance" {
  ami = var.ami_id
  instance_market_options {
    spot_options {
      max_price = 0.004
    }
    market_type = "spot"
  }
  instance_type = var.instance_type
  key_name      = var.key_name
  tags = {
    Name = "test-spot"
  }
  private_dns_name_options {
    enable_resource_name_dns_a_record = true
  }
  user_data = file("mount_ebs_volume.sh")
}

resource "aws_volume_attachment" "llama-data-vol" {
  device_name = "/dev/sdf"
  volume_id   = "vol-05be9c5993ebcf10e"
  instance_id = aws_instance.spot_instance.id
}

output "instance_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.my_instance.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of EC2 instance"
  value       = aws_instance.my_instance.public_dns
}

output "spot_instance_public_ip" {
  description = "Public IP of EC2 spot instance"
  value       = aws_instance.spot_instance.public_ip
}

output "spot_instance_public_dns" {
  description = "Public DNS name of EC2 spot instance"
  value       = aws_instance.spot_instance.public_dns
}
