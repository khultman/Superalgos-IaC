
output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "subnet_private_cidr_blocks" {
  value = [for s in aws_subnet.subnet_private : s.cidr_block]
}

output "subnet_public_cidr_blocks" {
  value = [for s in aws_subnet.subnet_public : s.cidr_block]
}


output "subnet_count" {
  description = "The number of subnets"
  value       = var.subnet_count
}

output "subnet_ids" {
  description = "List of subnet IDs"
  value       = module.subnets.subnet_ids
}

output "route_table_ids" {
  description = "List of route table IDs"
  value       = module.subnets.route_table_ids
}