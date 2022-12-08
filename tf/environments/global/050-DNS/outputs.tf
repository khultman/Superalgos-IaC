output "delegation_set_id" {
  description                     = "ID of Route53 delegation set"
  value                           = module.superalgos-delegation-set.delegation_set_id
}

output "delegation_set_name_servers" {
  description                     = "Name servers in the Route53 delegation set"
  value                           = module.superalgos-delegation-set.delegation_set_name_servers
}

output "delegation_set_reference_name" {
  description                     = "Reference name used when the Route53 delegation set has been created"
  value                           = module.superalgos-delegation-set.reference_name
}


output "root_zone_arn" {
  description                     = "ARN of Route53 root zone"
  value                           = module.superalgos-root-zone.arn
}

output "root_zone_id" {
  description                     = "ID of Route53 root zone"
  value                           = module.superalgos-root-zone.zone_id
}

output "root_zone_name_servers" {
  description                     = "Name servers in the Route53 root zone"
  value                           = module.superalgos-root-zone.name_servers
}

output "root_zone_primary_name_server" {
  description                     = "The Route 53 name server that created the SOA record."
  value                           = module.superalgos-root-zone.primary_name_server
}
