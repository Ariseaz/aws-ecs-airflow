module "airflow-vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "2.6.0"

  name = "${var.project_name}-${var.stage}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support = true
  enable_vpn_gateway = false

  tags = {
    Name        = "${var.project_name}-${var.stage}-vpc"
    Environment = var.stage
  }
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.airflow-vpc.vpc_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.airflow-vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.airflow-vpc.public_subnets
}

