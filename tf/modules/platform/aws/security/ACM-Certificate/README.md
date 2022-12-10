# Terraform :: Modules :: Provider :: AWS :: Security :: ACM-Certificate

This module provides a DNS Validated ACM Certificate for the Superalgos Platform.

## Usage

```hcl
module "acm-certificate" {
  source                  = "modules/platform/aws/security/acm-certificate"
  domain_name             = module.hosted-zone.name
  tags                    = var.tags
  tags_for_resources      = var.tags_for_resources
  zone_id                 = module.hosted-zone.zone_id
}
```

## Inputs

| Name                       | Type    | Default             | Required      | Description
|----------------------------|:-------:|:-------------------:|:-------------:|------------
| domain_name                | string  | -                   | yes           | The domain name for which the certificate should be issued
| tags                       | map     | -                   | no            | A map of tags to assign to resources 
| tags_for_resource          | map     | -                   | no            | A nested map of tags to assign to specific resource types
| zone_id                    | string  | -                   | yes           | The Route53 Zone ID
