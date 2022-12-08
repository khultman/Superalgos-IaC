# Terraform :: Modules :: Platform :: AWS :: Route53 :: record

Creates a Route53 Delegation Set.

## Usage

```hcl
module "nsrecord-xyx" {
  source                  = "modules/platform/aws/route53/record"
  zone_id                 = module.hosted-zone-xyz.zone_id
  force_destroy           = true
}
```


## Inputs

| Name                       | Type    | Default             | Required      | Description
|----------------------------|:-------:|:-------------------:|:-------------:|------------
| zone_id                    | string  | -                   | yes           | The ID of the hosted zone to contain this record.
| name                       | string  | -                   | yes           | The name of the record.
| type                       | string  | A                   | no            | The record type. Valid values are A, AAAA, CAA, CNAME, DS, MX, NAPTR, NS, PTR, SOA, SPF, SRV and TXT.
| ttl                        | number  | -                   | conditionally | (Required for non-alias records) The TTL of the record.
| records                    | string  | -                   | conditionally | (Required for non-alias records) A string list of records. To specify a single record value longer than 255 characters such as a TXT record for DKIM, add \"\" inside the Terraform configuration string (e.g., "first255characters\"\"morecharacters")
| set_identifier             | string  | -                   | conditionally | Unique identifier to differentiate records with routing policies from one another. Required if using failover, geolocation, latency, multivalue_answer, or weighted routing policies.
| health_check_id            | string  | -                   | no            | The health check the record should be associated with.
| alias                      | map     | -                   | no            | An alias block. Conflicts with ttl & records.
| failover_routing_policy    | map     | -                   | no            | A block indicating the routing behavior when associated health check fails. Conflicts with any other routing policy.
| geolocation_routing_policy |         | -                   | no            | A block indicating a routing policy based on the geolocation of the requestor. Conflicts with any other routing policy.
| latency_routing_policy     |         | -                   |               | A block indicating a routing policy based on the latency between the requestor and an AWS region. Conflicts with any other routing policy.
| weighted_routing_policy    |         | -                   |               | A block indicating a weighted routing policy. Conflicts with any other routing policy.
| allow_overwrite            | bool    | true                | no            | Allow creation of this record in Terraform to overwrite an existing record, if any. This does not affect the ability to update the record in Terraform and does not prevent other resources within Terraform or manual Route 53 changes outside Terraform from overwriting this record. false by default. This configuration is not recommended for most environments.


## Outputs

| Name                    | Description
|-------------------------|------------
| arn                     | The Amazon Resource Name (ARN) of the Hosted Zone.
| zone_id                 | The Hosted Zone ID. This can be referenced by zone records.
| name_servers            | A list of name servers in associated (or default) delegation set. Find more about delegation sets in [AWS docs](https://docs.aws.amazon.com/Route53/latest/APIReference/actions-on-reusable-delegation-sets.html).
| primary_name_server     | The Route 53 name server that created the SOA record.
