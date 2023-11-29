module "apache" {
  source          = ".//aws-apache-example"
  vpc_id          = var.vpc_id
  my_ip_with_cidr = var.my_ip_with_cidr
  instance_type   = var.instance_type
  server_name     = var.server_name
  bucket          = var.bucket
}

output "public_ip" {
  value = module.apache.public_ip
}