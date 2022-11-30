
/*==== ACM VPN Client/Server Certificate ======*/
resource "aws_acm_certificate" "acm_cert_vpn_server" {
  domain_name             = "${var.vpn_subdomain}.${var.environment}.${var.domain_name}"
  validation_method       = "DNS"
  tags                    = merge(var.tags, lookup(var.tags_for_resource, "acm_cert_vpn_server", {}))
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_ec2_client_vpn_endpoint" "vpn_client_endpoint" {
  description             = "Client VPN"
  client_cidr_block       = var.vpn_client_cidr
  split_tunnel            = true
  server_certificate_arn  = aws_acm_certificate_validation.acm_cert_vpn_server.certificate_arn

  authentication_options {
    type                  = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.acm_cert_vpn_server.arn
  }

  connection_log_options {
    enabled               = false
  }

  tags                    = merge(var.tags, lookup(var.tags_for_resource, "client_vpn_endpoint", {}))
}


resource "aws_security_group" "sg_vpn_client" {
  vpc_id                  = aws_vpc.main.id
  name                    = "sg_vpn_client"

  ingress {
    from_port             = 443
    protocol              = "UDP"
    to_port               = 443
    cidr_blocks           = ["0.0.0.0/0"]
    description           = "Incoming VPN connection"
  }

  egress {
    from_port             = 0
    protocol              = "-1"
    to_port               = 0
    cidr_blocks           = ["0.0.0.0/0"]
  }

  tags                    = merge(var.tags, lookup(var.tags_for_resource, "sg_vpn_client", {}))
}


resource "aws_ec2_client_vpn_network_association" "vpn_subnets" {
  count = length(aws_subnet.sn_az)

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  subnet_id = aws_subnet.sn_az[count.index].id
  security_groups = [aws_security_group.vpn_access.id]

  lifecycle {
    // The issue why we are ignoring changes is that on every change
    // terraform screws up most of the vpn assosciations
    // see: https://github.com/hashicorp/terraform-provider-aws/issues/14717
    ignore_changes = [subnet_id]
  }
}


resource "aws_ec2_client_vpn_authorization_rule" "vpn_auth_rule" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  target_network_cidr = aws_vpc.main.cidr_block
  authorize_all_groups = true
}


