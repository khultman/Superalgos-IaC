
output "public_zone_arn" {
  description                     = "ARN of Route53 root zone"
  value                           = module.superalgos-environment-zone-public.arn
}

output "public_zone_id" {
  description                     = "ID of Route53 root zone"
  value                           = module.superalgos-environment-zone-public.zone_id
}

output "public_zone_name_servers" {
  description                     = "Name servers in the Route53 root zone"
  value                           = module.superalgos-environment-zone-public.name_servers
}

output "public_zone_primary_name_server" {
  description                     = "The Route 53 name server that created the SOA record."
  value                           = module.superalgos-environment-zone-public.primary_name_server
}


output "private_zone_arn" {
  description                     = "ARN of Route53 root zone"
  value                           = module.superalgos-environment-zone-private.arn
}

output "private_zone_id" {
  description                     = "ID of Route53 root zone"
  value                           = module.superalgos-environment-zone-private.zone_id
}

output "private_zone_name_servers" {
  description                     = "Name servers in the Route53 root zone"
  value                           = module.superalgos-environment-zone-private.name_servers
}

output "private_zone_primary_name_server" {
  description                     = "The Route 53 name server that created the SOA record."
  value                           = module.superalgos-environment-zone-private.primary_name_server
}