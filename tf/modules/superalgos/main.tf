
module "network" {
  source                  = "../network"
  name                    = "${var.environment}-${var.appname}"
  vpc_cidr                = "${var.vpc_cidr}"
  private_subnets         = "${var.private_subnets}"
  public_subnets          = "${var.public_subnets}"
  tags                    = "${var.tags}"
  tags_for_resource       = "${var.tags_for_resource}"
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

