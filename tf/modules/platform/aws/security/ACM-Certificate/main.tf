
resource "aws_acm_certificate" "cert" {
  domain_name                     = var.domain_name
  validation_method               = "DNS"

  lifecycle {
    create_before_destroy         = true
  }

  tags                            = merge(var.tags, lookup(var.tags_for_resource, "aws_acm_certificate", {}))
}


resource "aws_route53_record" "cert_validation_records" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name                        = dvo.resource_record_name
      record                      = dvo.resource_record_value
      type                        = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name                            = each.value.name
  records                         = [each.value.record]
  ttl                             = 60
  type                            = each.value.type
  zone_id                         = var.zone_id
}


resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn                 = aws_acm_certificate.cert.arn
  validation_record_fqdns         = [for record in aws_route53_record.cert_validation_records : record.fqdn]
}