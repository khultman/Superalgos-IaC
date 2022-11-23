# Terraform :: Modules :: Platform :: AWS :: Networking :: vpc

Creates a VPC, Internet Gateway, and DHCP options.

## Usage

```hcl
module "vpc" {
  source                  = "Darklight-Ventures/terraform//modules/platform/aws/networking/vpc"
  cidr_block              = "10.89.0.0/19"
  enable_dns_support      = true
  enable_dns_hostnames    = true
}
```

## Inputs

| Name                    | Type   | Default             | Required | Description
|-------------------------|:------:|:-------------------:|:--------:|------------
| cidr_block              | string | -                   | yes      | The CIDR block for the VPC 
| domain_name             | string | -                   | no       | The suffix domain to use by default when resolving non Full Qualified Domain Names, if left blank then <region>.compute.internal will be used 
| domain_name_servers     | list   | `AmazonProvidedDNS` | no       | List of name servers to configure in /etc/resolve.conf, defaults to the default AWS nameservers 
| enable_dhcp_options     | string | `true`              | no       | Enable creation of DHCP Options
| enable_dns_hostnames    | string | `false`             | no       | Enable DNS hostnames in the VPC
| enable_dns_support      | string | `true`              | no       | Enable DNS support in the VPC 
| tags                    | map    | -                   | no       | A map of tags to assign to resources 
| tags_for_resource       | map    | -                   | no       | A nested map of tags to assign to specific resource types 


## Outputs

| Name                    | Description
|-------------------------|------------
| internet_gateway_id     | The Internet Gateway ID
| vpc_id                  | The VPC ID
