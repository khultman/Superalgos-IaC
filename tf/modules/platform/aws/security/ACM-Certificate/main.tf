
resource "aws_acm_certificate" "cert" {
  domain_name                     = var.domain_name
  validation_method               = "DNS"

  lifecycle {
    create_before_destroy         = true
  }

  tags                            = merge(var.tags, lookup(var.tags_for_resource, "aws_acm_certificate", {}))
}