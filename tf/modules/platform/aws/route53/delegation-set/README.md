# Terraform :: Modules :: Platform :: AWS :: Route53 :: delegation-set

Creates a Route53 Delegation Set.

## Usage

```hcl
module "delegation_set" {
  source                  = "modules/platform/aws/route53/delegation-set"
  reference_name          = "superalgos"
}
```

## Inputs

| Name                    | Type   | Default             | Required | Description
|-------------------------|:------:|:-------------------:|:--------:|------------
| reference_name          | string | -                   | no       | The reference name of the delegation set



## Outputs

| Name                    | Description
|-------------------------|------------
| id                      | ID of Route53 delegation set
| name_servers            | Name servers in the Route53 delegation set
| reference_name          | Reference name used when the Route53 delegation set has been created
