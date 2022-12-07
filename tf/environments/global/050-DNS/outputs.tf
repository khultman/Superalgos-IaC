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