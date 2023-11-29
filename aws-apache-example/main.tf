provider "aws" {
  region = "us-east-1"
}

locals {
  project_name = "Terraform"
  owner        = "PatrickCmd"
}

# Terraform aws data sources vpc: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc
data "aws_vpc" "main" {
  id = var.vpc_id
}

/*https://www.hashicorp.com/blog/hashicorp-terraform-supports-amazon-linux-2*/
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

# Provision server with cloud init
# Cloud init examples: https://cloudinit.readthedocs.io/en/latest/reference/examples.html
data "template_file" "user_data" {
  template = file("${path.module}/userdata.yaml")
}


resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCYcaMQZh5bl38UBsO9Tbhxde+Tyd4WDm4pGI+LjvpHofP44R0LiDq6tuBbOQB6vkWO7knRyhpJE8mr6V21gfrXeU99NrP0u8VG1Jp9PqE7hCuwk7ttqtbtiuOMjfvQHTTMjz5xkaCxiC1DHPb/Kqe8DkWEyGq7XYznh0bs4Req0zFmOrGiJ6Dg+NNLoIQiz6f7eAB3e9z6D67+XkOB5HjmDpinja48Rcz5wPk30qbyKu4KcfXopSLZRjZoJbsbNGiKZjbsWTWiIcOskGy6S8G/phbU8Hc2o5RDDyUt/I0WiD4raBdj9Je2sdmGs9hrlp+/E3HRIVqXn453ndhZvqQJs++UHDlx73GzcQkKTlONCMjptwlQPCZFNjG3QRQafvLN7m9pcvNLnwKDzItSaMvgZEBgsnq4B/RKWuPQCfwW4BKRATMHxDgBT/cZZxDim06apMHhn3i3Yaw8r4PGFwGGD5Sq8Qvw4f7Lfbo5C3kceUMfSdWNv4Gfkl0hfOJ/Axk= gitpod@patrickcmd-awsdeveloper-jwqnowf1m87"
}

resource "aws_security_group" "demo_apache_server_sg" {
  name        = "demo_apache_server_sg"
  description = "Demo Apache server SG"
  vpc_id      = data.aws_vpc.main.id

  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = [var.my_ip_with_cidr] # ["34.140.91.218/32"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    description      = "outgoing traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }
}

resource "aws_subnet" "terraform_public_subnet1" {
  vpc_id                  = data.aws_vpc.main.id
  cidr_block              = "10.0.200.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_instance" "terraform_apache_demo_server" {
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  subnet_id              = aws_subnet.terraform_public_subnet1.id
  vpc_security_group_ids = [aws_security_group.demo_apache_server_sg.id]
  user_data              = data.template_file.user_data.rendered

  tags = {
    Name  = "${var.server_name}-${local.project_name}"
    Owner = local.owner
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket
}

resource "terraform_data" "status" {
  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --instance-ids ${aws_instance.terraform_apache_demo_server.id} --region us-east-1"
  }
  depends_on = [
    aws_instance.terraform_apache_demo_server
  ]
}
