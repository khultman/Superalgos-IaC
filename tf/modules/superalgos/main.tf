
module "vpc" {
  source                  = "git@github.com:terraform-aws-modules/terraform-aws-vpc.git"

  name                    = "${var.environment}-${var.appname}"
  
  cidr                    = "${var.vpc_cidr}"
  azs                     = "${var.availability_zones}"
  private_subnets         = "${var.private_subnets}"
  public_subnets          = "${var.public_subnets}"

  enable_dns_hostnames    = true

  enable_ipv6             = false

  enable_nat_gateway      = true
  one_nat_gateway_per_az  = false
  
  enable_vpn_gateway      = true

  tags                    = merge(var.tags, lookup(var.tags_for_resource, "aws_vpc", {}))
}



# module "application-loadbalancer" {
#     source = "DarkLight-Ventures/Superalgos-IaC/tf/modules/application-loadbalancer"
#     region               = "${var.region}"
#     environment          = "${var.environment}"
#     application_listen_proto = "${var.application_listen_proto}"
# }

# module "bastion" {
#     source = "DarkLight-Ventures/Superalgos-IaC/tf/modules/bastion"
#     region               = "${var.region}"
#     environment          = "${var.environment}"
# }

# module "vpn" {
#     source = "DarkLight-Ventures/Superalgos-IaC/tf/modules/vpn"
#     region               = "${var.region}"
#     environment          = "${var.environment}"
# }

