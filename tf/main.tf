
module "superalgos" {
    source                        = "./modules/superalgos"
    environment                   = var.environment_live
    vpc_cidr                      = var.vpc_cidr
    vpn_subdomain                 = var.vpn_subdomain
    public_subnet_cidr            = var.public_subnet_cidr
    bastion_subnet_cidr           = var.bastion_subnet_cidr
    application_subnet_cidr       = var.application_subnet_cidr
    tags                          = var.tags
    tags_for_resource             = var.tags_for_resource
}

