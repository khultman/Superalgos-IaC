

module "vpn" {
  source                          = "../platform/aws/networking/vpn"
  domain_name                     = var.domain_name
  associated_subnet_ids           = concat(
    sort(module.public_subnets.subnet_ids),
    sort(module.bastion_subnets.subnet_ids),
  )
  vpc_id                          = module.vpc.vpc_id
  vpc_cidr                        = var.vpc_cidr
  vpn_client_cidr                 = var.vpn_client_cidr
  vpn_subdomain                   = var.vpn_subdomain
  tags                            = var.tags
  tags_for_resource               = var.tags_for_resource
  depends_on                      = [module.vpc, module.public_subnets, module.bastion_subnets]
}
