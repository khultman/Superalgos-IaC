
module "vpc" {
  source                          = "../platform/aws/networking/vpc"
  cidr_block                      = var.vpc_cidr
  enable_dns_support              = true
  enable_dns_hostnames            = true
  tags                            = var.tags
  tags_for_resource               = var.tags_for_resource
}

module "public_subnets" {
  source                          = "../platform/aws/networking/public-subnets"
  vpc_id                          = module.vpc.vpc_id
  cidr_block                      = var.public_subnet_cidr
  gateway_id                      = module.vpc.internet_gateway_id
  availability_zones              = local.availability_zones
  subnet_count                    = length(local.availability_zones)
  map_public_ip_on_launch         = true
  depends_on                      = [module.vpc]
}

module "application_subnets" {
  source                          = "../platform/aws/networking/private-subnets"
  vpc_id                          = module.vpc.vpc_id
  cidr_block                      = var.application_subnet_cidr
  availability_zones              = local.availability_zones
  subnet_count                    = length(local.availability_zones)
  depends_on                      = [module.vpc]
}

module "bastion_subnets" {
  source                          = "../platform/aws/networking/private-subnets"
  vpc_id                          = module.vpc.vpc_id
  cidr_block                      = var.bastion_subnet_cidr
  availability_zones              = local.availability_zones
  subnet_count                    = length(local.availability_zones)
  depends_on                      = [module.vpc]
}

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
