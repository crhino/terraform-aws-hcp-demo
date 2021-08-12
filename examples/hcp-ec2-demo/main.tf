terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.43.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.7.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.78.0"

  name                 = "${var.cluster_id}-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
}

# The HVN created in HCP
resource "hcp_hvn" "main" {
  hvn_id         = var.hvn_id
  cloud_provider = "aws"
  region         = var.region
  cidr_block     = var.hvn_cidr_block
}

resource "hcp_consul_cluster" "main_consul_cluster" {
  cluster_id      = var.cluster_id
  hvn_id          = hcp_hvn.main.hvn_id
  public_endpoint = var.enable_public_url
  size            = var.size
  tier            = var.tier
}

resource "hcp_consul_cluster_root_token" "token" {
  cluster_id = hcp_consul_cluster.main_consul_cluster.cluster_id
}

module "aws_hcp_route" {
  source                    = "../../modules/aws_hcp_route"
  hvn                       = hcp_hvn.main
  vpc_region                = var.region
  vpc_cidr_block            = module.vpc.vpc_cidr_block
  vpc_id                    = module.vpc.vpc_id
  owner_id                  = module.vpc.vpc_owner_id
  route_table_ids           = module.vpc.public_route_table_ids
  number_of_route_table_ids = length(module.vpc.public_route_table_ids)
}

module "aws_ec2_consul_client" {
  depends_on              = [hcp_consul_cluster.main_consul_cluster]
  source                  = "../../modules/aws_ec2_consul_client"
  subnet_id               = module.vpc.public_subnets[0]
  security_group_id       = module.vpc.default_security_group_id
  hvn_cidr_block          = hcp_hvn.main.cidr_block
  allowed_ssh_cidr_blocks = ["0.0.0.0/0"]
  client_config_file      = hcp_consul_cluster.main_consul_cluster.consul_config_file
  client_ca_file          = hcp_consul_cluster.main_consul_cluster.consul_ca_file
  root_token              = hcp_consul_cluster_root_token.token.secret_id
}
