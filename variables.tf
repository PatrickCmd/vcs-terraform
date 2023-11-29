variable "instance_type" {
  type = string
}

variable "server_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
}

variable "vpc_id" {
  description = "value of default vpc id"
  type        = string
}

variable "my_ip_with_cidr" {
  type        = string
  description = "My IP address with Cidr"
}

variable "bucket" {
  type = string
}