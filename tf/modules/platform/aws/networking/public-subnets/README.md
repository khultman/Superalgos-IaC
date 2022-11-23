# Terrform :: Modules :: AWS :: Networking :: public-subnets

Creates public subnets and route tables in a VPC with internet access.

This module takes a single CIDR block and calculates the CIDR blocks to use for the subnets being created.

## Usage

```hcl
module "vpc" {
  source                  = "Darklight-Ventures/terraform//modules/platform/aws/networking/vpc"
  cidr_block              = "10.42.0.0/19"
  enable_dns_support      = true
  enable_dns_hostnames    = true
}

module "public_subnets" {
  source                  = "Darklight-Ventures/terraform//modules/platform/aws/networking/public-subnets"
  vpc_id                  = module.vpc.vpc_id
  gateway_id              = module.vpc.internet_gateway_id
  map_public_ip_on_launch = true
  cidr_block              = "10.42.0.0/23"
  subnet_count            = 3
  availability_zones      = ["us-east1-1a", "us-east1-1b", "us-east1-1c"]
}
```

## Inputs

| Name                    | Type   | Default             | Required | Description
|-------------------------|:------:|:-------------------:|:--------:|------------
| availability_zones      | list   | -                   | yes      | A list of availability zones to create the subnets in
| cidr_block              | string | -                   | yes      | The larger CIDR block to use for calculating individual subnet CIDR blocks
| gateway_id              | string | -                   | yes      | The ID of the Internet Gateway to use for routing
| map_public_ip_on_launch | string | `false`             | no       | Assign a public IP address to instances launched into these subnets
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
