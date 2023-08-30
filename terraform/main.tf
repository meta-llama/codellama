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
  ami           = "ami-04e601abe3e1a910f"
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = var.instance_name
  }
#  credit_specification {
#    cpu_credits = "unlimited"
#  }
  private_dns_name_options {
    enable_resource_name_dns_a_record = true
  }
}

output "instance_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.my_instance.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name of EC2 instance"
  value       = aws_instance.my_instance.public_dns
}
