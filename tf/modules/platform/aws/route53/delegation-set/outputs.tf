output "delegation_set_id" {
  description                     = "ID of Route53 delegation set"
  value                           = aws_route53_delegation_set.delegation_set.id
}

output "delegation_set_name_servers" {
  description                     = "Name servers in the Route53 delegation set"
  value                           = aws_route53_delegation_set.delegation_set.name_servers
}

output "reference_name" {
  description                     = "Reference name used when the Route53 delegation set has been created"
  value                           = aws_route53_delegation_set.delegation_set.reference_name
}