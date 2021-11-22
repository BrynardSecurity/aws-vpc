terraform {
  backend "remote" {
    organization = "BrynardSecurity-test"

    workspaces {
      name = "AWS-VPC_Devops-Test"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

locals {
  name   = var.vpc_name
  region = var.aws_region
  tags = {
    "Account ID"    = var.aws_account
    "Account Alias" = var.aws_account_alias
    Environment     = var.environment
    Name            = var.vpc_name
  }
}

module "vpc_example_complete-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.11.0"

  name = local.name
  cidr = "10.0.0.0/8"

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
  public_subnets  = ["10.20.11.0/24", "10.20.12.0/24", "10.20.13.0/24"]

  manage_default_route_table = true
  default_route_table_tags   = { DefaultRouteTable = true }

  enable_dns_hostname = true
  enable_dns_support  = true

  enable_classiclink             = true
  enable_classiclink_dns_support = true

  enable_nat_gateway = true
  single_nat_gateway = true

  customer_gateways = {
    IP1 = {
      bgp_asn     = 65112
      ip_address  = var.customer_gateway_ip
      device_name = var.device_name
    }
  }
  enable_vpn_gateway = true

  enable_dhcp_options = false

  manage_default_security_group  = true
  default_security_group_ingress = []
  default_security_group_egress  = []

  enable_flow_log = false
}

module "vpc_endpoints_nocreate" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  create = false
}

data "aws_security_group" "default" {
  name   = "sg-${var.vpc_name}-${var.environment}"
  vpc_id = module.vpc.vpc_id
}