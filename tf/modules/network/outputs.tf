
output "vpc_id" {
  value                   = module.vpc.vpc_id
}

# output "bastion_subnet_cidr_blocks" {
#   value                   = [for s in module.bastion_subnets : s.cidr_block]
# }

output "bastion_subnet_ids" {
  description             = "List of bastion subnet IDs"
  # value                   = [for s in module.bastion_subnets : s.subnet_id ]
  value                   = module.bastion_subnets.subnet_ids
}

output "bastion_subnet_route_table_ids" {
  description             = "List of bastion subnet route table IDs"
  value                   = module.bastion_subnets.route_table_ids
}



# output "application_subnet_cidr_blocks" {
#   value                   = [for s in module.application_subnets : s.cidr_block]
# }

output "application_subnet_ids" {
  description             = "List of application subnet IDs"
  value                   = module.application_subnets.subnet_ids
}

output "application_subnet_route_table_ids" {
  description             = "List of application subnet route table IDs"
  value                   = module.application_subnets.route_table_ids
}



# output "public_subnet_cidr_blocks" {
#   value                   = [for s in module.public_subnets : s.cidr_block]
# }

output "public_subnet_ids" {
  description             = "List of public subnet IDs"
  value                   = module.public_subnets.subnet_ids
}

output "public_subnet_route_table_ids" {
  description             = "List of public subnet route table IDs"
  value                   = module.public_subnets.route_table_ids
}