# Terrform :: Modules :: Platform :: AWS :: Networking :: subnets

Creates subnets in a VPC.

This module takes a single CIDR block and calculates the CIDR blocks to use for the subnets being created.

## Usage

This is a lower level module. Consider using the [private-subnets](../private-subnets) or [public-subnets](../public-subnets) modules instead.

```hcl
module "subnets" {
  source                  = "Darklight-Ventures/terraform//modules/platform/aws/networking/subnets"
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  subnet_count            = var.subnet_count
  availability_zones      = var.availability_zones
  propagating_vgws        = var.propagating_vgws
  tags                    = var.tags
  tags_for_resource       = var.tags_for_resource
  map_public_ip_on_launch = var.map_public_ip_on_launch
}
```

## Inputs

| Name                    | Type   | Default             | Required | Description
|-------------------------|:------:|:-------------------:|:--------:|------------
| availability_zones      | list   | -                   | yes      | A list of availability zones to create the subnets in 
| cidr_block              | string | -                   | yes      | The larger CIDR block to use for calculating individual subnet CIDR blocks
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
