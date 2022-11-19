
module "superalgos" {
    source = "./superalgos"
    region               = "${var.region}"
    environment          = "${var.environment_paper}"
    vpc_cidr             = "${var.vpc_cidr}"
    public_subnets_cidr  = "${var.public_subnets_cidr}"
    private_subnets_cidr = "${var.private_subnets_cidr}"
    availability_zones   = "${local.production_availability_zones}"
}

# module "networking" {
#     source = "./modules/networking"
#     region               = "${var.region}"
#     environment          = "${var.environment}"
#     vpc_cidr             = "${var.vpc_cidr}"
#     public_subnets_cidr  = "${var.public_subnets_cidr}"
#     private_subnets_cidr = "${var.private_subnets_cidr}"
#     availability_zones   = "${local.production_availability_zones}"
# }

# module "application-loadbalancer" {
#     source = "./modules/application-loadbalancer"
#     region               = "${var.region}"
#     environment          = "${var.environment}"
#     application_listen_proto = "${var.application_listen_proto}"
# }

# module "bastion" {
#     source = "./modules/bastion"
#     region               = "${var.region}"
#     environment          = "${var.environment}"
# }

# module "vpn" {
#     source = "./modules/vpn"
#     region               = "${var.region}"
#     environment          = "${var.environment}"
# }
