
module "superalgos" {
    source                = "./modules/superalgos"

    environment           = "${var.environment_live}"

    vpc_cidr              = "${var.vpc_cidr}"
    public_subnets        = "${var.public_subnets}"
    private_subnets       = "${var.private_subnets}"
    availability_zones    = "${var.availability_zones}"

    tags                  = "${var.tags}"
}

