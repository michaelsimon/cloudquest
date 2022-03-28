###########VPC###########
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name = "quest-vpc"
  cidr = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.8.0/24"]
  enable_nat_gateway = false
  enable_vpn_gateway = false
  enable_dns_hostnames = true
}