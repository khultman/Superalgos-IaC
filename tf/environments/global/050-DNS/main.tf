
module "superalgos-delegation-set" {
    source                        = "../../../modules/platform/aws/route53/delegation-set"
    reference_name                = "superalgos"
}

module "superalgos-root-zone" {
    source                        = "../../../modules/platform/aws/route53/zone"
    name                          = var.dns_domain_name
    delegation_set_id             = module.superalgos-delegation-set.id
}

