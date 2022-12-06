
module "superalgos-delegation-set" {
    source                        = "../../../modules/platform/aws/route53/delegation-set"
    reference_name                = "superalgos"
}