# Terraform :: Modules :: Platform :: AWS :: Route53 :: zone

Creates a Route53 Delegation Set.

## Usage

```hcl
module "hosted-zone-xyz" {
  source                  = "modules/platform/aws/route53/zone"
  delegation_set_id       = module.superalgos-delegation-set.id
  force_destroy           = true
}
```

```hcl
data "terraform_remote_state" "network" {
  backend                 = "s3"

  config = {
    bucket                = "CHANGE-THE-BUCKET-NAME"
    key                   = "ENVIRONMENT-NAME/100-Network/terraform.tfstate"
    region                = "CHANGE-THE-REGION"
  }
}

module "hosted-zone-xyz" {
  source                  = "modules/platform/aws/route53/zone"
  force_destroy           = true
  vpc                     = [
    {
        vpc_id            = data.terraform_remote_state.network.outputs.vpc_id
    }
  ]
}
```

## Inputs

| Name                    | Type   | Default             | Required | Description
|-------------------------|:------:|:-------------------:|:--------:|------------
| name                    | string | -                   | yes      | This is the name of the hosted zone.
| comment                 | string | Used by Superalgos  | no       | A comment for the hosted zone.
| delegation_set_id       | int    | null                | no       | The ID of the reusable delegation set whose NS records you want to assign to the hosted zone. Conflicts with vpc as delegation sets can only be used for public zones.
| force_destroy           | bool   | false               | no       | Whether to destroy all records (possibly managed outside of Terraform) in the zone when destroying the zone.
| vpc                     | map    | null                | no       | Configuration block(s) specifying VPC(s) to associate with a private hosted zone. Conflicts with the delegation_set_id argument in this resource and any aws_route53_zone_association resource specifying the same zone ID. Detailed below.

### vpc Argument Reference
vpc_id - (Required) ID of the VPC to associate.
vpc_region - (Optional) Region of the VPC to associate. Defaults to AWS provider region.


## Outputs

| Name                    | Description
|-------------------------|------------
| arn                     | The Amazon Resource Name (ARN) of the Hosted Zone.
| zone_id                 | The Hosted Zone ID. This can be referenced by zone records.
| name_servers            | A list of name servers in associated (or default) delegation set. Find more about delegation sets in [AWS docs](https://docs.aws.amazon.com/Route53/latest/APIReference/actions-on-reusable-delegation-sets.html).
| primary_name_server     | The Route 53 name server that created the SOA record.
