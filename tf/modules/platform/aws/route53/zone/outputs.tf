output "arn" {
  description                     = "The Amazon Resource Name (ARN) of the Hosted Zone."
  value                           = aws_route53_zone.zone.arn
}

output "zone_id" {
  description                     = "Zone ID of Route53 zone"
  value                           = aws_route53_zone.zone.zone_id
}

output "name_servers" {
  description                     = "A list of name servers in associated (or default) delegation set."
  value                           = aws_route53_zone.zone.name_servers
}

output "primary_name_server" {
  description                     = "The Route 53 name server that created the SOA record."
  value                           = aws_route53_zone.zone.name_servers
}
