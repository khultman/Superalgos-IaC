
module "network" {
  source                          = "../network"
  environment                     = var.environment
  vpc_cidr                        = var.vpc_cidr
  vpn_subdomain                   = var.vpn_subdomain
  public_subnet_cidr              = var.public_subnet_cidr
  bastion_subnet_cidr             = var.bastion_subnet_cidr
  application_subnet_cidr         = var.application_subnet_cidr
  tags                            = var.tags
  tags_for_resource               = var.tags_for_resource
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

