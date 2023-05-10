module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name                  = "${var.environment}-${var.base_name}-vpc"
  cidr                  = "10.128.0.0/16"
  secondary_cidr_blocks = ["100.64.0.0/16"]


  azs              = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets  = ["100.64.0.0/20", "100.64.16.0/20", "100.64.32.0/20"]
  public_subnets   = ["10.128.4.0/23", "10.128.6.0/23", "10.128.8.0/23"]
  database_subnets = ["10.128.10.0/23", "10.128.12.0/23", "10.128.14.0/23"]
  intra_subnets    = ["100.64.48.0/20", "100.64.64.0/20", "100.64.80.0/20"]

  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = true

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.eks.name}" = "shared"
    "kubernetes.io/role/elb"                  = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.eks.name}" = "shared"
    "kubernetes.io/role/internal-elb"         = 1
  }

}
