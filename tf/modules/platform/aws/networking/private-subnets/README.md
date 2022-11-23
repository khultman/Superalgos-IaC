# Terraform :: Modules :: Platform :: AWS :: Networking :: private-subnets

Creates private subnets and route tables in a VPC, optionally using NAT Gateways for internet access.

This module takes a single CIDR block and calculates the CIDR blocks to use for the subnets being created.

## Usage

```hcl
module "vpc" {
  source                  = "Darklight-Ventures/terraform//modules/platform/aws/networking/vpc"
  cidr_block              = "10.42.0.0/19"
  enable_dns_support      = true
  enable_dns_hostnames    = true
}

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
|-------------------------|:------:|:-------------------:|:--------:|-------------
| availability_zones      | list   | -                   | yes      | A list of availability zones to create the subnets in 
| cidr_block              | string | -                   | yes      | The larger CIDR block to use for calculating individual subnet CIDR blocks 
| nat_gateway_count       | string | `0`                 | no       | The number of NAT gateways to use for routing, must match subnet_count and nat_gateway_ids 
| nat_gateway_ids         | string | -                   | no       | A list of NAT Gateway IDs to use for routing 
| propagating_vgws        | list   | -                   | no       | A list of virtual gateways for route propagation 
| subnet_count            | string | -                   | yes      | The number of subnets to create 
| tags                    | map    | -                   | no       | A map of tags to assign to resources 
| tags_for_resource       | map    | -                   | no       | A nested map of tags to assign to specific resource types 
| vpc_id                  | string | -                   | yes      | The ID of the VPC to create the subnets in 

## Outputs

| Name                    | Description
|-------------------------|------------
| route_table_ids         | List of route table IDs
| subnet_count            | The number of subnets
| subnet_ids              | List of subnet IDs
