resource "aws_route53_record" "nsrecord" {
  zone_id                         = var.zone_id

  name                             = var.name
  type                             = var.type
  ttl                              = var.ttl
  records                          = var.records
  set_identifier                   = var.set_identifier
  health_check_id                  = var.health_check_id
  multivalue_answer_routing_policy = var.multivalue_answer_routing_policy
  allow_overwrite                  = var.allow_overwrite

  dynamic "alias" {
    for_each                      = var.alias
    content {
      name                        = alias.name
      zone_id                     = alias.zone_id
      evaluate_target_health      = alias.evaluate_target_health
    }
  }

  dynamic "failover_routing_policy" {
    for_each                      = var.failover_routing_policy
    content {
      type                        = failover_routing_policy.type
    }
  }

  dynamic "latency_routing_policy" {
    for_each                      = var.latency_routing_policy
    content {
      region                      = latency_routing_policy.region
    }
  }

  dynamic "weighted_routing_policy" {
    for_each                      = var.weighted_routing_policy
    content {
      weight                      = weighted_routing_policy.weight
    }
  }

  dynamic "geolocation_routing_policy" {
    for_each                      = var.geolocation_routing_policy
    content {
      continent                   = geolocation_routing_policy.continent
      country                     = geolocation_routing_policy.country
      subdivision                 = geolocation_routing_policy.subdivision
    }
  }
}