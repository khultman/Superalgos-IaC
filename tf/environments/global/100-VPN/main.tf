data "remote_state" "superalgos-global-dns" {
    backend                       = "s3"
    config = {
        bucket                    = "CHANGE-THE-BUCKET-NAME"
        key                       = "global/100-VPN/terraform.tfstate"
        region                    = "CHANGE-THE-REGION"
    }
}


module "superalgos-cognito" {
    source                        = "../../../modules/platform/aws/Identity/Cognito"
    dns_domain_name               = var.dns_domain_name
    pool_client_name              = var.pool_client_name
    user_pool_name                = var.user_pool_name
}


module "superalgos-cognito-A-record" {
  source                          = "../../../modules/platform/aws/route53/record"
  name                            = module.superalgos-cognito.domain
  type                            = "A"
  zone_id                         = data.remote_state.superalgos-global-dns.zone_id
  alias {
    evaluate_target_health        = false
    name                          = module.superalgos-cognito.cloudfront_distribution_arn
    zone_id                       = data.remote_state.superalgos-global-dns.zone_id
  }
}
