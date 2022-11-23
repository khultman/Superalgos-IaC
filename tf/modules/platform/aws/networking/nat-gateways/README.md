# Terraform :: Modules :: Cloud :: AWS :: Networking :: nat-gateways

Creates an AWS NAT Gateway in each provided subnet.

## Usage

```hcl
# Create VPC

module "vpc" {
  source                  = "Darklight-Ventures/terraform//modules/platform/aws/networking/vpc"
  cidr_block              = "10.42.0.0/19"
  enable_dns_support      = true
  enable_dns_hostnames    = true
}

# Create public subnets with internet access

module "public_subnets" {
  source                  = "Darklight-Ventures/terraform//modules/platform/aws/networking/public-subnets"
  vpc_id                  = module.vpc.vpc_id
  gateway_id              = module.vpc.internet_gateway_id
  map_public_ip_on_launch = true
  cidr_block              = "10.42.0.0/23"
  subnet_count            = 3
  availability_zones      = ["us-east1-1a", "us-east1-1b", "us-east1-1c"]
}

# Create NAT Gateways in public subnets

module "nat_gateways" {
  source                  = "Darklight-Ventures/terraform//modules/platform/aws/networking/nat-gateways"
  subnet_count            = module.public_subnets.subnet_count
  subnet_ids              = module.public_subnets.subnet_ids
}

# Use NAT Gateways in private subnets to provide internet access

module "private_subnets" {
  source                  = "Darklight-Ventures/terraform//modules/platform/aws/networking/private-subnets"
  vpc_id                  = module.vpc.vpc_id
  vpc_id                  = module.vpc.vpc_id
  gateway_id              = module.vpc.internet_gateway_id
  map_public_ip_on_launch = true
  cidr_block              = "10.42.128.0/23"
  subnet_count            = 3
  availability_zones      = ["us-east1-1a", "us-east1-1b", "us-east1-1c"]
}
```

## Inputs

| Name                    | Type   | Default             | Required | Description
|-------------------------|:------:|:-------------------:|:--------:|------------
| subnet_count            | string | -                   | yes      | The number of subnets to create gateways in, must match length of subnet_ids 
| subnet_ids              | list   | -                   | yes      | A list of subnets to create gateways in 
| tags                    | map    | -                   | no       | A map of tags to assign to resources 
| tags_for_resource       | map    | -                   | no       | A nested map of tags to assign to specific resource types 

## Outputs

| Name                    | Description
|-------------------------|------------
| nat_gateway_count       | The number of gateways
| nat_gateway_public_ips  | The public EIPs of the Nat Gateways
| nat_gateway_ids         | List of gateway IDs
