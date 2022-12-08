resource "aws_route53_zone" "zone" {
  name                            = var.name
  comment                         = var.comment
  force_destroy                   = var.force_destroy
  delegation_set_id               = var.delegation_set_id

  dynamic "vpc" {
    for_each = try(var.vpc != null ? tolist(var.vpc) : [])

    content {
      vpc_id                      = vpc.value.vpc_id
      vpc_region                  = lookup(vpc.value, "vpc_region", null)
    }
  }

  tags                            = merge(var.tags, lookup(var.tags_for_resource, "route53_zone", {}))
}