
resource "aws_route53_delegation_set" "delegation_set" {
  reference_name                  = var.reference_name
}