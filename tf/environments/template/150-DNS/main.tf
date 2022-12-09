data "remote_state" "superalgos-global-dns" {
    backend = "s3"
    config = {
        bucket = "CHANGE-THE-BUCKET-NAME"
        key    = "global/050-DNS/terraform.tfstate"
        region = "CHANGE-THE-REGION"
    }
}

data "remote_state" "environment-network" {
    backend = "s3"
    config = {
        bucket = "CHANGE-THE-BUCKET-NAME"
        key    = "CHANGE-THE-ENVIRONMENT-NAME/100-Network/terraform.tfstate"
        region = "CHANGE-THE-REGION"
    }
}


module "superalgos-environment-zone-public" {
    source                        = "../../../modules/platform/aws/route53/zone"
    name                          = var.dns_domain_name
    delegation_set_id             = data.remote_state.superalgos-global-dns.outputs.delegation_set_id
}


module "superalgos-environment-zone-private" {
    source                        = "../../../modules/platform/aws/route53/zone"
    name                          = var.dns_domain_name
    vpc                           = {
        vpc_id                    = data.remote_state.environment-network.outputs.vpc_id
    }
}
