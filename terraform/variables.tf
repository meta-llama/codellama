variable "instance_name" {
  type    = string
  default = "Terraform Test"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = "frankfurt"
}

variable "availability_zone" {
  type    = string
  default = "eu-central-1"
}

variable "ami_id" {
  type = string
  default = "ami-04e601abe3e1a910f"
}